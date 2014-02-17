Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaBQRnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:43:46 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36854 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbaBQRnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:43:45 -0500
Date: Mon, 17 Feb 2014 17:42:57 +0000
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
Subject: Re: [PATCH v4 3/3] arm64: audit: Add audit hook in
 ptrace/syscall_trace
Message-ID: <20140217174257.GE26590@mudshark.cambridge.arm.com>
References: <1391410590-4884-1-git-send-email-takahiro.akashi@linaro.org>
 <1391767803-5350-1-git-send-email-takahiro.akashi@linaro.org>
 <1391767803-5350-4-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391767803-5350-4-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:10:03AM +0000, AKASHI Takahiro wrote:
> This patch adds auditing functions on entry to or exit from
> every system call invocation.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/kernel/ptrace.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index 64ce39f..8cdba09 100644
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
> @@ -1076,10 +1078,15 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>  	}
>  
>  	if (dir) {
> +		audit_syscall_exit(regs);
>  		tracehook_report_syscall_exit(regs, 0);
>  	} else {
>  		if (tracehook_report_syscall_entry(regs))
>  			regs->syscallno = ~0UL;
> +		audit_syscall_entry(syscall_get_arch(current, regs),
> +			(int)regs->syscallno,
> +			regs->orig_x0, regs->regs[1],
> +			regs->regs[2], regs->regs[3]);

Again, I don't think we should just lump tracehook and audit together like
this without checking the flags (see my reply to the previous patch series).

Will
