Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077AbaICWV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:21:59 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:53388 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933916AbaICWV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:21:56 -0400
Date: Wed, 3 Sep 2014 23:20:18 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: Tainting the kernel on raw I/O access
Message-ID: <20140903232018.17bba503@alan.etchedpixels.co.uk>
In-Reply-To: <5407863B.9030608@intel.com>
References: <5407863B.9030608@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2014 14:20:59 -0700
"H. Peter Anvin" <h.peter.anvin@intel.com> wrote:

> In a meeting earlier today, we discussed MSR access and that it could be
> used to do bad things.  The same applies to other forms of raw I/O
> (/dev/mem, /dev/port, ioperm, iopl, etc.)

For MSR I assume writing primarily - but if you block read access you
break a ton of tools, and if you block write access you stop things like
DPTF working (which personally I couldn't care about, but other folks who
are using it to power manage their boxes might be a bit more upset 8)).
Fixing that takes you into the joyful world of whitelists.

> This is basically the same problem with which the secure boot people
> have been struggling.

Not sure that is true

"secure" boot is based upon the premise that you can't fool the machine
into booting a different OS image without the user choosing to do so in a
protected manner that prevents impersonation.

"tainting" on raw I/O is a useful debug tool. There is at best only
minimal overlap in the sense that one is a partial subset of the other
(and only partial because there are safe MSRs, I/O ports and memory
ranges).

> Peter Z. suggested we should taint the kernel on raw I/O access, and I
> tend to concur.
> 
> So what I would like to suggest is that we create a new kernel helper
> function which can return an error in secure boot mode and otherwise
> taints the kernel with a raw I/O taint.

That makes the job instantly about ten times harder. You can add taints
trivially to the kernel but every single taint that might error is a new
error path, and no doubt a new exciting pile of kernel bugs.

> What do people think?

The problem is that it's not just little bits of raw I/O. You've got a
load of kernel command line options that have the same problem and you've
got a load of things like firmware upload in the unsigned firmware case
which may in some cases also need to count but not others. Even things
like the features planned so you can inject missing DTD information int
your ACPI tables (or fix the garbage your vendor provided) raise the same
question.

What is the *actual* goal here, what is the security model, what is the
at least basic proof that it works. We've got 20 years of layered
insecurity by guesswork in the kernel already.

Also how does this work for virtual machines ? Does the hypervisor do the
taint management for ports it doesn't manage and that are not
passthrough. What about passthrough devices on a non signed guest on a
signed master.

If you just want some "detector bits" for bug report filtering them its
quite a different need to fixing "secure" boot mode. Even in the detector
bits case there should be an overall plan and some defined properties
that provide the security and which you can show should always be true.

The failure case for "detector bits" is 'the user did something dumb and
we spent a while looking at a bug that was their fault' and the fix path
is 'get around to adding a new taint'. The 'secure boot' case is a
promise of a security model which implies you can prove its at least
reasonably correct (and can be implemented to be correct).

Alan
