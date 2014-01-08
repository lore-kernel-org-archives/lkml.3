Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaAHQLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:11:06 -0500
Received: from mx0.aculab.com ([213.249.233.131]:34857 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757149AbaAHQLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:11:02 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, walt <w41ter@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Thread-Topic: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Thread-Index: AQHPDAsx5d97FnYUxUSD3GhphkgfRJp67eMA
Date: Wed, 8 Jan 2014 16:09:14 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D455431@AcuExch.aculab.com>
References: <52CC944C.50702@gmail.com> <20140107212101.GA4199@xanatos>
 <20140108004724.GA14082@xanatos>
In-Reply-To: <20140108004724.GA14082@xanatos>
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

> From: Sarah Sharp
> On Tue, Jan 07, 2014 at 03:57:00PM -0800, walt wrote:
> > On 01/07/2014 01:21 PM, Sarah Sharp wrote:
> >
> > > Can you please try the attached patch, on top of the previous three
> > > patches, and send me dmesg?
> >
> > Hi Sarah, I just now finished running 0001-More-debugging.patch for the
> > first time.  The previous dmesg didn't include that patch, but this one
> > does.
> >
> > I read through this dmesg but I nodded off somewhere around line 500.
> > I hope you can stay awake :)
> 
> Well, it has all the info I need, but the results don't make me too
> happy.  Everything I've checked seems consistent, and I don't know why
> the host stopped.  The link TRBs are intact, the dequeue pointer for the
> endpoint was pointing to the transfer that timed out and it had the
> cycle bit set correctly, etc.  Perhaps the no-op TRBs are really the
> issue.
> 
> I'll have to take a look at the log again tomorrow.  I posted the dmesg
> on pastebin if David wants to check it out as well:
> http://pastebin.com/a4AUpsL1

I can't see anything obvious either.
However there is no response to the 'stop endpoint' command.
Section 4.6.9 (page 107 of rev1.0) states that the controller will complete
any USB IN or OUT transaction before raising the command completion event.
Possibly it is too 'stuck' to complete the transaction?

The endpoint status is also still '1' (running).
This also means that the 'TR dequeue pointer' is undefined - so the
controller could easily be processing a later TRB.
This field might even still contain the ring base address written by
the driver much earlier.

This might mean that something 'catastrophic' has happened earlier.
Maybe the controller isn't actually seeing any doorbell writes at all.
Maybe the base addresses it has for the rings have all got corrupted.
At least this looks like amd64 - so there aren't memory coherency issues.

Some hacks that might help isolate the problem:
1) Request an interrupt from the last nop data TRB.
2) Put a command nop (decimal 23) TRB into the command ring before
   the 'stop endpoint'.
3) Comment out the code that adds the nop data TRBs.
The first two might need code adding to handle the responses.

Do we know the actual xhci device?
I think it reports version 0x96.
(Sarah - it might be useful if that version were in one of the trace
messages that is output by default.)

	David


