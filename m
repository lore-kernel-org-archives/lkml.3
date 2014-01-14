Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaANMjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:39:36 -0500
Received: from mx0.aculab.com ([213.249.233.131]:42944 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751287AbaANMje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:39:34 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC 00/10] xhci: re-work command queue management
Thread-Topic: [RFC 00/10] xhci: re-work command queue management
Thread-Index: AQHPEG/FJXCXw8xZgk+WRonRUzZdl5qC22UggAFFqoCAAAOdQA==
Date: Tue, 14 Jan 2014 12:37:27 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D45B31F@AcuExch.aculab.com>
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
 <063D6719AE5E284EB5DD2968C1650D6D45938C@AcuExch.aculab.com>
 <52D5281F.4080108@linux.intel.com>
In-Reply-To: <52D5281F.4080108@linux.intel.com>
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
...
> > The fact that you are having to allocate memory ion an ISR ought also to be
> > ringing alarm bells.
> 
> It did.
> Other options are as you said to use a 'software command ring'. Either
> just pre-allocate a full command ring (64 trbs * sizeof(struct
> xhci_command)), roughly 2300 bytes when driver loads,
> or then a smaller pool of commands just used for ISR submitted commands.
> (We then need to either either expand pool, or start allocating in isr
> if pool is empty)

If you pre-allocate mapping 1-1 with the command ring entries
you don't need many of the fields of xhci_command at all.
So the allocated size will be much smaller.

Also not that all the rings have been increased to 256 entries,
not that there is any requirement for them to match.

> These solutions require some ring management and possibly expansion
> code, and increases the complexity again. I selected this simpler
> approach as I understood that the frequency of commands allocated in ISR
> is quite low.

The frequency isn't the problem - the fact that it is allowed is a problem.

> This also feels like trying to optimize before we get the main
> changes working.

I would call it 'not realising the full scope of the problem' and thus
leaving the 'difficult bits' for last.
Sorting out how to solve the difficult bits up front can lead to a
nicer solution.

> 
> >
> > Have you considered adding a 'software command ring' (indexed with the
> > same value as the hardware one) and using it to hold additional parameters?
> >
> > It might even be worth only putting a single command into the hardware ring!
> > That might simplify the timer code.
> 
> This is something I haven't thought about. Could be one possibility, but
> feels like artificially restricting something the HW is designed to care
> of.

It might resolve any issues about the fixed finite size of the hardware
command ring.
OTOH you probably don't need that many entries in the hardware command
ring for 'normal' processing - provided you have a software ring/queue
that can buffer all the requests.

Looking at the number of fields in xci_command, why do you need the
caller to pass a structure at all?
Just make the fields parameters to the 'send a command' function
along with a parameter that says whether it can sleep (in kmalloc()
or if the ring is full depending on the implementation).

...
> > This still has a fixed constraint on the number of queued commands, but
> > I suspect that is bounded anyway (a few per device?).
> 
> 64 commands fit on the command ring segment, I'm not aware of any
> per-device limits?

I was wondering about how many commands the software might try to queue,
not the number that the hardware allowed to be queued.

	David



