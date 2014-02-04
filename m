Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaBDRcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:32:17 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50797 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932123AbaBDRcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:32:12 -0500
Date: Tue, 4 Feb 2014 17:31:33 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v3 3/3] arm64: audit: Add audit hook in
 ptrace/syscall_trace
Message-ID: <20140204173133.GG664@mudshark.cambridge.arm.com>
References: <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org>
 <1391410590-4884-1-git-send-email-takahiro.akashi@linaro.org>
 <1391410590-4884-4-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391410590-4884-4-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 06:56:30AM +0000, AKASHI Takahiro wrote:
> This patch adds auditing functions on entry to or exit from
> every system call invocation.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/include/asm/thread_info.h |    1 +
>  arch/arm64/kernel/entry.S            |    3 +++
>  arch/arm64/kernel/ptrace.c           |   10 ++++++++++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 720e70b..7468388 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -101,6 +101,7 @@ static inline struct thread_info *current_thread_info(void)
>  #define TIF_NEED_RESCHED	1
>  #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
>  #define TIF_SYSCALL_TRACE	8
> +#define TIF_SYSCALL_AUDIT	9
>  #define TIF_POLLING_NRFLAG	16
>  #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
>  #define TIF_FREEZE		19
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 827cbad..83c4b29 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -630,6 +630,9 @@ el0_svc_naked:					// compat entry point
>  	get_thread_info tsk
>  	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
>  	tbnz	x16, #TIF_SYSCALL_TRACE, __sys_trace // are we tracing syscalls?
> +#ifdef CONFIG_AUDITSYSCALL
> +	tbnz	x16, #TIF_SYSCALL_AUDIT, __sys_trace // auditing syscalls?
> +#endif

Could we avoid the back-to-back tbnz instructions with a single mask? It's
not obvious that it will end up any better, but it would be good to know.

>  	adr	lr, ret_fast_syscall		// return address
>  	cmp     scno, sc_nr                     // check upper syscall limit
>  	b.hs	ni_sys
> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index 6777a21..75a3f23 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -19,6 +19,7 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  
> +#include <linux/audit.h>
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
>  #include <linux/mm.h>
> @@ -38,6 +39,7 @@
>  #include <asm/compat.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/pgtable.h>
> +#include <asm/syscall.h>
>  #include <asm/traps.h>
>  #include <asm/system_misc.h>
>  
> @@ -1064,6 +1066,14 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>  {
>  	unsigned long saved_reg;
>  
> +	if (dir)
> +		audit_syscall_exit(regs);
> +	else
> +		audit_syscall_entry(syscall_get_arch(current, regs),
> +			(int)regs->syscallno,
> +			regs->orig_x0, regs->regs[1],
> +			regs->regs[2], regs->regs[3]);
> +

Do we really want to perform the audit checks before the tracehook calls?
Remember that the latter can rewrite all of the registers.

Will
