Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbbAOTgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:36:19 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:58323 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbbAOTgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:36:15 -0500
Message-ID: <54B816AC.7070902@gmail.com>
Date: Thu, 15 Jan 2015 11:36:12 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Ralf Baechle <ralf@linux-mips.org>, David Daney <david.daney@cavium.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Hemmo Nieminen <hemmo.nieminen@iki.fi>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] MIPS: OCTEON: fix kernel crash when offlining a CPU
References: <1421347767-21740-1-git-send-email-aaro.koskinen@iki.fi>
In-Reply-To: <1421347767-21740-1-git-send-email-aaro.koskinen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 10:49 AM, Aaro Koskinen wrote:
> octeon_cpu_disable() will unconditionally enable interrupts when called
> with interrupts disabled. Fix that.

interrupts are always disabled here, so...

[...]
>
> Reported-by: Hemmo Nieminen <hemmo.nieminen@iki.fi>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: stable@vger.kernel.org

NACK!

> ---
>   arch/mips/cavium-octeon/smp.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
> index ecd903d..9673c5b 100644
> --- a/arch/mips/cavium-octeon/smp.c
> +++ b/arch/mips/cavium-octeon/smp.c
> @@ -231,6 +231,7 @@ DEFINE_PER_CPU(int, cpu_state);
>   static int octeon_cpu_disable(void)
>   {
>   	unsigned int cpu = smp_processor_id();
> +	unsigned long flags;
>
>   	if (cpu == 0)
>   		return -EBUSY;
> @@ -240,9 +241,9 @@ static int octeon_cpu_disable(void)
>
>   	set_cpu_online(cpu, false);
>   	cpu_clear(cpu, cpu_callin_map);
> -	local_irq_disable();
> +	local_irq_save(flags);

Just remove this...

>   	octeon_fixup_irqs();
> -	local_irq_enable();
> +	local_irq_restore(flags);

... and this.

>
>   	flush_cache_all();
>   	local_flush_tlb_all();
>

You can add an Acked-by me if you do that.

David Daney.
