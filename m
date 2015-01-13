Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbbAMPeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:34:23 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52249 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbbAMPeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:34:21 -0500
Message-ID: <54B53AF5.2010303@hitachi.com>
Date: Wed, 14 Jan 2015 00:34:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: linux@arm.linux.org.uk, mingo@redhat.com, x86@kernel.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net, ananth@in.ibm.com,
        dave.long@linaro.org, tixy@linaro.org, lizefan@huawei.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/11] ARM: kprobes: directly modify code if kprobe
 is not initialized.
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com> <1420616124-42765-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1420616124-42765-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/07 16:35), Wang Nan wrote:
> If kprobe is optimized before kprobe is initialized, there should
> be only one core, the probed instruction is not armed with breakpoint,
> so simply patch text is okay.

This patch looks very hacky. If kprobes is not initialized, why anyone
can optimize kprobes? I think you must introduce early kprobes init
routine and set init flag at that point.

Thank you,

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
>  
>  		list_del_init(&op->list);
>  	}
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


