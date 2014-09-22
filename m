Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaIVQzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:55:13 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:44280 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaIVQzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:55:11 -0400
Message-ID: <5420546D.6050102@gmail.com>
Date: Mon, 22 Sep 2014 09:55:09 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Markos Chandras <markos.chandras@imgtec.com>
CC: linux-mips@linux-mips.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MIPS: ftrace.h: Fix the MCOUNT_INSN_SIZE definition
References: <1411392779-9554-1-git-send-email-markos.chandras@imgtec.com> <1411392779-9554-2-git-send-email-markos.chandras@imgtec.com>
In-Reply-To: <1411392779-9554-2-git-send-email-markos.chandras@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 06:32 AM, Markos Chandras wrote:
> The MCOUNT_INSN_SIZE is meant to be used to denote the overall
> size of the mcount() call. Since a jal instruction is used to
> call mcount() the delay slot should be taken into consideration
> as well.
> This also replaces the MCOUNT_INSN_SIZE usage with the real size
> of a single MIPS instruction since, as described above, the
> MCOUNT_INSN_SIZE is used to denote the total overhead of the
> mcount() call.

Are you seeing errors with the existing code?  If so please state what 
they are.

By changing this, we can no longer atomically replace the instruction. 
So I think shouldn't be changing this stuff unless there is a real bug 
we are fixing.

In conclusion: NAK unless the patch fixes a bug, in which case the 
change log *must* state what the bug is, and how the patch addresses the 
problem.

David Daney


>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
> ---
>   arch/mips/include/asm/ftrace.h | 2 +-
>   arch/mips/kernel/ftrace.c      | 4 +++-
>   2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
> index 992aaba603b5..70d4a35fb560 100644
> --- a/arch/mips/include/asm/ftrace.h
> +++ b/arch/mips/include/asm/ftrace.h
> @@ -13,7 +13,7 @@
>   #ifdef CONFIG_FUNCTION_TRACER
>
>   #define MCOUNT_ADDR ((unsigned long)(_mcount))
> -#define MCOUNT_INSN_SIZE 4		/* sizeof mcount call */
> +#define MCOUNT_INSN_SIZE 8		/* sizeof mcount call + delay slot */
>
>   #ifndef __ASSEMBLY__
>   extern void _mcount(void);
> diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
> index 937c54bc8ccc..211460d4617d 100644
> --- a/arch/mips/kernel/ftrace.c
> +++ b/arch/mips/kernel/ftrace.c
> @@ -28,6 +28,8 @@
>   #define MCOUNT_OFFSET_INSNS 4
>   #endif
>
> +#define FTRACE_MIPS_INSN_SIZE 4 /* Size of single MIPS instruction */
> +
>   #ifdef CONFIG_DYNAMIC_FTRACE
>
>   /* Arch override because MIPS doesn't need to run this from stop_machine() */
> @@ -395,7 +397,7 @@ void prepare_ftrace_return(unsigned long *parent_ra_addr, unsigned long self_ra,
>   	 */
>
>   	insns = in_kernel_space(self_ra) ? 2 : MCOUNT_OFFSET_INSNS + 1;
> -	trace.func = self_ra - (MCOUNT_INSN_SIZE * insns);
> +	trace.func = self_ra - (FTRACE_MIPS_INSN_SIZE * insns);
>
>   	/* Only trace if the calling function expects to */
>   	if (!ftrace_graph_entry(&trace)) {
>

