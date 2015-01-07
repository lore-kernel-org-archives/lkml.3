Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbbAGRPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:15:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39336 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbbAGRPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:15:45 -0500
Message-ID: <54AD69BE.6050007@codeaurora.org>
Date: Wed, 07 Jan 2015 12:15:42 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:33.0) Gecko/20100101 Thunderbird/33.0
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>, linux@arm.linux.org.uk, mingo@redhat.com,
        x86@kernel.org, masami.hiramatsu.pt@hitachi.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net, ananth@in.ibm.com,
        dave.long@linaro.org, tixy@linaro.org
CC: lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 01/11] ARM: kprobes: directly modify code if
 kprobe is not initialized.
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com> <1420616124-42765-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1420616124-42765-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 02:35 AM, Wang Nan wrote:
> If kprobe is optimized before kprobe is initialized, there should
> be only one core, the probed instruction is not armed with breakpoint,
> so simply patch text is okay.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  arch/arm/probes/kprobes/opt-arm.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/probes/kprobes/opt-arm.c b/arch/arm/probes/kprobes/opt-arm.c
> index 15b37c0..a021474 100644
> --- a/arch/arm/probes/kprobes/opt-arm.c
> +++ b/arch/arm/probes/kprobes/opt-arm.c
> @@ -325,8 +325,17 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
>  		 * Similar to __arch_disarm_kprobe, operations which
>  		 * removing breakpoints must be wrapped by stop_machine
>  		 * to avoid racing.
> +		 *
> +		 * If this function is called before kprobes initialized,
> +		 * the kprobe should be an early kprobe, the instruction
> +		 * is not armed with breakpoint. There should be only
> +		 * one core now, so directly __patch_text is enough.
>  		 */
> -		kprobes_remove_breakpoint(op->kp.addr, insn);
> +		if (unlikely(!kprobes_initialized)) {
> +			BUG_ON(!(op->kp.flags & KPROBE_FLAG_EARLY));
> +			__patch_text(op->kp.addr, insn);
> +		} else
> +			kprobes_remove_breakpoint(op->kp.addr, insn);

"...if only one branch of a conditional statement is a single statement ...
use braces in both branches".

https://www.kernel.org/doc/Documentation/CodingStyle

>  
>  		list_del_init(&op->list);
>  	}
> 

Regards,
Chris

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
