Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaBCVMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:12:01 -0500
Received: from toast.topped-with-meat.com ([204.197.218.159]:59332 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaBCVL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:11:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/lkml
Cc: Andy Lutomirski <luto@amacapital.net>,
        Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH 3/4] Add 32 bit VDSO time support for 32 bit kernel
In-Reply-To: H. Peter Anvin's message of  Saturday, 1 February 2014 16:56:56 -0800 <52ED97D8.50809@zytor.com>
References: <1391268756-10766-1-git-send-email-stefani@seibold.net>
	<1391268756-10766-4-git-send-email-stefani@seibold.net>
	<CALCETrVp+aTm_mT4bg6kcaX3QOnqyjVdfM9vdhHZPsKG276X0A@mail.gmail.com>
	<52ED90A3.9080802@zytor.com>
	<CALCETrV-odpkNyFFSDRcrOdT1m11FTXgZJ+oASKKWa_wn8hUWw@mail.gmail.com>
	<384f3ba9-ce01-4779-8988-556cea724f07@email.android.com>
	<52ED97D8.50809@zytor.com>
Emacs: a learning curve that you can use as a plumb line.
Message-Id: <20140203211155.77EF674413@topped-with-meat.com>
Date: Mon,  3 Feb 2014 13:11:55 -0800 (PST)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.1 cv=Rt9WckWK c=1 sm=1 tr=0
		a=WkljmVdYkabdwxfqvArNOQ==:117 a=14OXPxybAAAA:8 a=CBeSZioxfMsA:10
		a=Z6MIti7PxpgA:10 a=kj9zAlcOel0A:10 a=hOe2yjtxAAAA:8 a=1d1W4jXkn7cA:10
		a=scXZTnEgpzbLjRVXPycA:9 a=NGdl49OUiY2cOXI5:21 a=Qp322rv0uAumGzzd:21
		a=CjuIK1q_8ugA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > config COMPAT_VDSO
> >         def_bool y
> >         prompt "Compat VDSO support"
> >         depends on X86_32 || IA32_EMULATION
> >         ---help---
> >           Map the 32-bit VDSO to the predictable old-style address too.
> > 
> >           Say N here if you are running a sufficiently recent glibc
> >           version (2.3.3 or later), to remove the high-mapped
> >           VDSO mapping and to exclusively use the randomized VDSO.
> > 
> >           If unsure, say Y.
> 
> So we need this for 32-bit glibc < 2.3.3, and we effecively have the
> same problem as on 64 bits.  Next question is if those old glibcs rely
> on the entry point alone or if they also expect the vdso header at that
> address.
> 
> I looked at the glibc diffs from 2.3.2 to 2.3.3, but it isn't really
> obvious to me what assumptions the 2.3.2 glibc made.  Perhaps Roland has
> any idea?

Jakub often has more reliable memories of these things than I do.

>From looking at the old states of the code, AFAICT 2.3.3 was the first
version that actually looked at AT_SYSINFO_EHDR or cared about the vDSO per
se; 2.3.2 just uses AT_SYSINFO.

I have a vague recollection that there was a period wherein ld.so would
crash (trying to modify part of the read-only vDSO image in place) if the
vDSO was loaded somewhere other than its prelinked location.  But I don't
see any evidence in the code that there was actually a release made of code
with that issue.

I'm fairly sure there are some relevant issues that I've forgotten and am
overlooking now.

> The safest thing for that might be to have the compat vdso be a
> completely separate object from the real vdso, and let the former be an
> object as similar to the current one as possible.

I'm not at all clear on what particular dangers that avoids.


Thanks,
Roland
