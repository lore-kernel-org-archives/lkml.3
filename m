Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaAMO6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:58:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:40377 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaAMO6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:58:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="457939176"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC 00/10] xhci: re-work command queue management
Date: Mon, 13 Jan 2014 17:05:49 +0200
Message-Id: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt to re-work and solve the issues in xhci command
queue management that Sarah has descibed earlier: 

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

The first 7 patches are all about creating these command structures and
submitting them when we queue commands.
The command structures are allocated on the fly, the commands that are submitted
in interrupt context are allocated with GFP_ATOMIC.

Next, the global command queue is introduced. Commands are added to the queue
when trb's are queued, and remove when the commad completes. 
Also switch to use the status variable and completion in the command struct.

A new timer handles command timeout, the timer is kicked every time when a 
command finishes and there's a new command waiting in the queue, or when a new
command is submitted to an _empty_ command queue.
Timer is deleted when the the last command on the queue finishes (empty queue)

The old cancel_cmd_list is removed. 
When the timer expires we simply tag the current command as "ABORTED" and start
the ring abortion process. Functions waiting for an aborted command to finish are
called after the command abortion is completed.

Mathias Nyman (10):
  xhci: Use command structures when calling xhci_configure_endpoint
  xhci: use a command structure internally in xhci_address_device()
  xhci: use command structures for xhci_queue_slot_control()
  xhci: use command structures for xhci_queue_stop_endpoint()
  xhci: use command structure for xhci_queue_new_dequeue_state()
  xhci: use command structures for xhci_queue_reset_ep()
  xhci: Use command structured when queuing commands
  xhci: Add a global command queue
  xhci: Use completion and status in global command queue
  xhci: rework command timeout and cancellation,

 drivers/usb/host/xhci-hub.c  |  42 ++--
 drivers/usb/host/xhci-mem.c  |  22 +-
 drivers/usb/host/xhci-ring.c | 532 ++++++++++++++-----------------------------
 drivers/usb/host/xhci.c      | 264 +++++++++++----------
 drivers/usb/host/xhci.h      |  43 ++--
 5 files changed, 373 insertions(+), 530 deletions(-)

-- 
1.8.1.2

