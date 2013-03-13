Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab3CMMFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 08:05:52 -0400
Received: from service88.mimecast.com ([195.130.217.12]:55872 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3CMMFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 08:05:49 -0400
Message-ID: <51406BA7.8010306@arm.com>
Date: Wed, 13 Mar 2013 12:05:59 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lokesh Vutla <lokeshvutla@ti.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] ARM: hw_breakpoint: Enable debug powerdown only if system
 supports 'has_ossr'
References: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com>
In-Reply-To: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com>
X-MC-Unique: 113031312054700202
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/13 06:52, Lokesh Vutla wrote:
> Commit {9a6eb31 ARM: hw_breakpoint: Debug powerdown support for self-hosted
> debug} introduces debug powerdown support for self-hosted debug.
> While merging the patch 'has_ossr' check was removed which
> was needed for hardwares which doesn't support self-hosted debug.
> Pandaboard (A9) is one such hardware and Dietmar's orginial
> patch did mention this issue.
> Without that check on Panda with CPUIDLE enabled, a flood of
> below messages thrown.
>
> [ 3.597930] hw-breakpoint: CPU 0 failed to disable vector catch
> [ 3.597991] hw-breakpoint: CPU 1 failed to disable vector catch
>

Hi Lokesh,

I confirm that this has_ossr condition has to go back into the
pm_init(void) call. I just verified it again on my Panda board and I get
the same issue like you without it.

I guess what was happening is that Will asked me if this check is really
necessary and I said No without re-testing on my Panda board as an V7
debug architecture example where OSSR is not implemented. Since then I
only tested in on V7.1 debug architectures where OSSR is mandatory.
Sorry about this and thanks for catching this.

You can add my Acked-by: if you wish.

-- Dietmar

> So restore that check back to avoid the mentioned issue.
>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Reported-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>   arch/arm/kernel/hw_breakpoint.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
> index 96093b7..0ba062d 100644
> --- a/arch/arm/kernel/hw_breakpoint.c
> +++ b/arch/arm/kernel/hw_breakpoint.c
> @@ -1049,7 +1049,8 @@ static struct notifier_block __cpuinitdata dbg_cpu_pm_nb = {
>
>   static void __init pm_init(void)
>   {
> -     cpu_pm_register_notifier(&dbg_cpu_pm_nb);
> +     if (has_ossr)
> +             cpu_pm_register_notifier(&dbg_cpu_pm_nb);
>   }
>   #else
>   static inline void pm_init(void)
>

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

