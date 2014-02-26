Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbaBZT3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:29:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:54502 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaBZT3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:29:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,549,1389772800"; 
   d="scan'208";a="462813947"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFCv3 0/4] xhci: re-work command queue management
Date: Wed, 26 Feb 2014 21:38:46 +0200
Message-Id: <1393443530-9216-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes since v2:

    squash first 7 patches together that all just created commands 
    and avoid some nasty mid-patch series memory leaking	  

changes since v1: 

    Fixing smatch warnings and errors.
    Check for null return from alloc_command, release lock in error path and
    don't dereference possible null pointer in error path.

    release lock in xhci_stop_dev() error path.
    
This is the third attempt to re-work and solve the issues in xhci command
queue management that Sarah has described earlier:

Right now, the command management in the xHCI driver is rather ad-hock.  
Different parts of the driver all submit commands, including interrupt 
handling routines, functions called from the USB core (with or without the
bus bandwidth mutex held).
Some times they need to wait for the command to complete, and sometimes 
they just issue the command and don't care about the result of the command.

The places that wait on a command all time the command for five seconds,
and then attempt to cancel the command.  
Unfortunately, that means if several commands are issued at once, and one of
them times out, all the commands timeout, even though the host hasn't gotten
a chance to service them yet.

This is apparent with some devices that take a long time to respond to the 
Set Address command during device enumeration (when the device is plugged in).
If a driver for a different device attempts to change alternate interface
settings at the same time (causing a Configure Endpoint command to be issued),
both commands timeout.

Instead of having each command timeout after five seconds, the driver should
wait indefinitely in an uninterruptible sleep on the command completion.  
A global command queue manager should time whatever command is currently
running, and cancel that command after five seconds.

If the commands were in a list, like TDs currently are, it may be easier to keep
track of where the command ring dequeue pointer is, and avoid racing with events.
We may need to have parts of the driver that issue commands without waiting on
them still put the commands in the command list.

The Implementation:
-------------------

First step is to create a list of the commands submitted to the command queue.
To accomplish this each command is required to be submitted with a properly
filled command structure containing completion, status variable and a pointer to
the command TRB that will be used.

The first patch is all about creating these command structures and
submitting them when we queue commands.
The command structures are allocated on the fly, the commands that are submitted
in interrupt context are allocated with GFP_ATOMIC.

Next, the global command queue is introduced. Commands structures are added to 
the queue when trb's are queued, and removed when the command completes. 
Also switch to use the status variable and completion in the command struct.

A new timer handles command timeout, the timer is kicked every time when a 
command finishes and there's a new command waiting in the queue, or when a new
command is submitted to an _empty_ command queue.
Timer is deleted when the the last command on the queue finishes (empty queue)

The old cancel_cmd_list is removed. 
When the timer expires we simply tag the current command as "ABORTED" and start
the ring abortion process. Functions waiting for an aborted command to finish are
called after the command abortion is completed.

Mathias Nyman (4):
  xhci: Use command structures when queuing commands on the command ring
  xhci: Add a global command queue
  xhci: Use completion and status in global command queue
  xhci: rework command timeout and cancellation,

 drivers/usb/host/xhci-hub.c  |  43 ++--
 drivers/usb/host/xhci-mem.c  |  22 +-
 drivers/usb/host/xhci-ring.c | 529 ++++++++++++++-----------------------------
 drivers/usb/host/xhci.c      | 264 +++++++++++----------
 drivers/usb/host/xhci.h      |  43 ++--
 5 files changed, 373 insertions(+), 528 deletions(-)

-- 
1.8.1.2

