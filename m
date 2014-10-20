Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaJTRoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:44:37 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:61175 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaJTRoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1411494540.git.luto@amacapital.net>
References: <cover.1411494540.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Oct 2014 10:44:13 -0700
Message-ID: <CALCETrWxeNGZCgh5ZTh5552eDQ_Bwf8TXxnuh7R1k9PTM3HbLA@mail.gmail.com>
Subject: Re: [PATCH 0/8] x86: Disentangle the vdso and clean it up
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:50 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> Hi Ingo and Thomas,

Now that the merge window is closed, can you take a look at these?
There are a few more that follow (tidying up vsyscall emulation and
adding a config flag for the tiny folks), too, but I'd rather not keep
resending these in an ever-growing form.

Thanks,
Andy

>
> This should all be straightforward.  It's primarily a cleanup, but it
> fixes what is arguably a bug in the PER_CPU mechanism.
>
> The first two patches just rearrange code to disentangle the vdso from
> the vsyscall emulation code.
>
> The next three patches are tiny.  Patch 3 rewrites the PER_CPU setup
> code to make it comprehensible; it has no effect other than clarify.
> Patches 4 and 5 fix two problems with the PER_CPU segment that are
> apparent after the code has been cleaned up.  (Patch 5 fixes a glitch
> that that is almost, but not quote, a security bug.)
>
> Patches 6 and 7 are just cleanups.  Patch 6 removes the "jiffies" vvar,
> which has been unused for years.  Patch 7 cleans up some initialization
> code.
>
> Patch 8 removes the vvar that selects the getcpu mode.  That vvar
> has been unnecessary for a couple of years, ever since alternative
> patching has worked in the vdso.
>
> There is a small but non quote zero chance that I will want to revert
> patch 8 at some point.  Reverting it will be needed to be able to
> disable the TSC (in the CR4.TSC sense) without breaking the vdso, unless
> we patch the vdso text.  That being said, I think it'll be a lot less
> messy to just patch the vdso text if we do that.
>
> Please consider applying these, or at least applying patches 1-7,
> to tip/x86/vdso for 3.18.
>
> Thanks,
> Andy
>
>
> Changes from way back when: This has been floating around since June in
> some form. See:
> http://lkml.kernel.org/g/cover.1404164803.git.luto@amacapital.net
>
> This version just disentangles the vdso and vsyscall code and does the
> vdso cleanups/fixes.  It does *not* contain the PER_CPU removal on
> RDTSCP systems, since hpa mentioned that this is potentially
> problematic, and, if we were to try it, it should soak in -next for a
> *long* time.  It is also heavily cleaned up since last time.
>
>
> Andy Lutomirski (8):
>   x86_64,vsyscall: Move all of the gate_area code to vsyscall_64.c
>   x86_64: Move getcpu code from vsyscall_64.c to vdso/vma.c
>   x86,vdso: Change the PER_CPU segment to use struct desc_struct
>   x86,vdso: Make the PER_CPU segment start out accessed
>   x86,vdso: Make the PER_CPU segment 32 bits
>   x86_64,vdso: Remove jiffies from the vvar page
>   x86_64,vdso: Clean up vgetcpu init and merge the vdso initcalls
>   x86,vdso: Replace vgetcpu_mode with static_cpu_has
>
>  arch/x86/include/asm/vgtod.h    | 21 ++++++++++
>  arch/x86/include/asm/vsyscall.h | 29 --------------
>  arch/x86/include/asm/vvar.h     |  2 -
>  arch/x86/kernel/cpu/common.c    | 10 -----
>  arch/x86/kernel/time.c          |  2 +-
>  arch/x86/kernel/vsyscall_64.c   | 84 ++++++++++++++++++----------------------
>  arch/x86/mm/init_64.c           | 49 ------------------------
>  arch/x86/vdso/vclock_gettime.c  |  3 ++
>  arch/x86/vdso/vgetcpu.c         |  5 ++-
>  arch/x86/vdso/vma.c             | 85 ++++++++++++++++++++++++++++++++---------
>  10 files changed, 132 insertions(+), 158 deletions(-)
>
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
