Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaAMRA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:00:59 -0500
Received: from mx0.aculab.com ([213.249.233.131]:57598 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752728AbaAMRAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:00:52 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC 00/10] xhci: re-work command queue management
Thread-Topic: [RFC 00/10] xhci: re-work command queue management
Thread-Index: AQHPEG/FJXCXw8xZgk+WRonRUzZdl5qC22Ug
Date: Mon, 13 Jan 2014 16:58:50 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D45938C@AcuExch.aculab.com>
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
In-Reply-To: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Nyman
> This is an attempt to re-work and solve the issues in xhci command
> queue management that Sarah has descibed earlier:
> 
> Right now, the command management in the xHCI driver is rather ad-hock.
> Different parts of the driver all submit commands, including interrupt
> handling routines, functions called from the USB core (with or without the
> bus bandwidth mutex held).
> Some times they need to wait for the command to complete, and sometimes
> they just issue the command and don't care about the result of the command.
> 
...
> 
> The Implementation:
> -------------------
> 
> First step is to create a list of the commands submitted to the command queue.
> To accomplish this each command is required to be submitted with a properly
> filled command structure containing completion, status variable and a pointer to
> the command TRB that will be used.
> 
> The first 7 patches are all about creating these command structures and
> submitting them when we queue commands.
> The command structures are allocated on the fly, the commands that are submitted
> in interrupt context are allocated with GFP_ATOMIC.
> 
> Next, the global command queue is introduced. Commands are added to the queue
> when trb's are queued, and remove when the commad completes.
> Also switch to use the status variable and completion in the command struct.
...

IMHO the xhci driver is already far too complicated, and this probably just makes
it even worse.

The fact that you are having to allocate memory ion an ISR ought also to be
ringing alarm bells.

Have you considered adding a 'software command ring' (indexed with the
same value as the hardware one) and using it to hold additional parameters?

It might even be worth only putting a single command into the hardware ring!
That might simplify the timer code.

This still has a fixed constraint on the number of queued commands, but
I suspect that is bounded anyway (a few per device?).
If not you can almost certainly arrange to grow the soft-ring before
the isr code can run out of entries.

	David



