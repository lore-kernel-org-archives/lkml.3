Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaBERG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:06:27 -0500
Received: from mx0.aculab.com ([213.249.233.131]:48155 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753069AbaBERGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:06:24 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Dan Williams'" <dan.j.williams@intel.com>
CC: Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFCv2 00/10] xhci: re-work command queue management
Thread-Topic: [RFCv2 00/10] xhci: re-work command queue management
Thread-Index: AQHPHcSK9atdaSRCp0qab+MyU9T1kJqdUXswgAiotwCAAG6swIAAf8WAgAAAoaA=
Date: Wed, 5 Feb 2014 17:05:33 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6B9214@AcuExch.aculab.com>
References: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F6B532A@AcuExch.aculab.com>
	<CAPcyv4gWnaK+s5zSu58Kue2ZiTTr4YC6pJG0n_Tu2Cm4RXOR=A@mail.gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F6B8B7E@AcuExch.aculab.com>
 <CAPcyv4gerLT1uuUre9L4minu6u4HYRFSYD2s-bo_7H9UH64QYQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gerLT1uuUre9L4minu6u4HYRFSYD2s-bo_7H9UH64QYQ@mail.gmail.com>
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

From: Dan Williams
> Yes, but I think we need to centralize the context under which
> commands are submitted.  The complicating factor is the mix of
> synchronous command submission and interrupt driven asynchronous
> command queuing.  I think we can simplify it by making it all
> submitted from a single event queue context.  I'm investigating if
> that is a workable solution...

Given that the entire network stack runs from (I believe) 'process level'
contexts (NAPI functions), it is rather surprising that the USB stack
runs everything from the actual interrupt context (or in the callers
context with interrupts disabled).

For large SMP systems disabling interrupts and acquiring global locks
like that just doesn't scale.

Even for 'normal' URB it ought to be possible to queue them for later
submission - rather than having to immediately put them on the transfer
ring.

Ideally the 'event' ring ought to be large enough for all the events
that the controller can add. This is approximately 1 per TD (2 for
short RX) and one per command. So much like the 'reserved command'
slots (which aren't implemented correctly) there should probably be
'reserved event' slots - otherwise the event ring might become full
(if the host stops servicing interrupts for any length of time.)
Avoiding the need for large numbers of events really means restricting
the number of TD (that request interrupts).

isoc and disk might limit this anyway, but network traffic can queue
a much larger number of TD. I've seen 20 tx TD (all nearly 60kB)
queued. Every time one completes another is immediately added.
usbnet needs to be taught how to do BQL, and something (somehow)
reduce the number of interrupts.

(end of ramble)

	David



