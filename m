Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3LSUk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:40:56 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39214 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab3LSUkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:40:55 -0500
Date: Thu, 19 Dec 2013 21:40:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        len.brown@intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/idle] x86, idle: Use static_cpu_has() for CLFLUSH
 workaround, add barriers
Message-ID: <20131219204051.GA2253@gmail.com>
References: <CA+55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com>
 <tip-7e98b71920464b8d15fa95c74366416cd3c88861@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-7e98b71920464b8d15fa95c74366416cd3c88861@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for H. Peter Anvin <tipbot@zytor.com> wrote:

> Commit-ID:  7e98b71920464b8d15fa95c74366416cd3c88861
> Gitweb:     http://git.kernel.org/tip/7e98b71920464b8d15fa95c74366416cd3c88861
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Thu, 19 Dec 2013 11:58:16 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 19 Dec 2013 11:58:16 -0800
> 
> x86, idle: Use static_cpu_has() for CLFLUSH workaround, add barriers
> 
> Use static_cpu_has() to conditionalize the CLFLUSH workaround, and add
> memory barriers around it since the documentation is explicit that
> CLFLUSH is only ordered with respect to MFENCE.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Len Brown <len.brown@intel.com>
> Link: http://lkml.kernel.org/r/CA%2B55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com
> ---
>  arch/x86/include/asm/mwait.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
> index 361b02e..19b71c4 100644
> --- a/arch/x86/include/asm/mwait.h
> +++ b/arch/x86/include/asm/mwait.h
> @@ -43,8 +43,11 @@ static inline void __mwait(unsigned long eax, unsigned long ecx)
>  static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
>  {
>  	if (!current_set_polling_and_test()) {
> -		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
> +		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
> +			mb();
>  			clflush((void *)&current_thread_info()->flags);
> +			mb();
> +		}

So since this is a v3.14 commit, lets get it right, ok?

The first mb() looks superfluous, because see 
current_set_polling_and_test():

static inline bool __must_check current_set_polling_and_test(void)
{
        __current_set_polling();

        /*
         * Polling state must be visible before we test NEED_RESCHED,
         * paired by resched_task()
         */
        smp_mb();

        return unlikely(tif_need_resched());
}

So it already has a (MFENCE) barrier after ->flags is modified.

So using a comment - something like the patch below, should be enough 
as well, agreed?

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 19b71c4..d4f5c9a 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -44,7 +44,10 @@ static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
 {
 	if (!current_set_polling_and_test()) {
 		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
-			mb();
+			/*
+			 * There's no need for an extra barrier here: current_set_polling_and_test()
+			 * already has an smp_mb() after ->flags gets modified, see sched.h.
+			 */
 			clflush((void *)&current_thread_info()->flags);
 			mb();
 		}
