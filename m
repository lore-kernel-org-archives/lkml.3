Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbaH0Kjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:39:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50807 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaH0Kje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:39:34 -0400
Message-ID: <53FDB580.8050009@arm.com>
Date: Wed, 27 Aug 2014 11:40:00 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "byungchul.park@lge.com" <byungchul.park@lge.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm64: take onlined cpus into account when setting
 irq affinity in migrate_one_irq
References: <1409131832-11317-1-git-send-email-byungchul.park@lge.com>
In-Reply-To: <1409131832-11317-1-git-send-email-byungchul.park@lge.com>
X-OriginalArrivalTime: 27 Aug 2014 10:39:32.0731 (UTC) FILETIME=[303154B0:01CFC1E3]
X-MC-Unique: 114082711393204101
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 27/08/14 10:30, byungchul.park@lge.com wrote:
> From: Byungchul Park <byungchul.park@lge.com>
>
> This patch ensures that the cpu being offlined is not present in the affinity mask.
>

I agree that this patch fixes the issue reported in [1] without
disabling forced set affinity mask. However Thomas responded yesterday
asking to disable it [2] on the original thread for ARM. I have
responded on the thread and waiting for feedback from rmk and tglx. I
would prefer to wait and align with ARM code if possible.

> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> ---
>   arch/arm64/kernel/irq.c |    9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
> index 473e5db..0c7b79e 100644
> --- a/arch/arm64/kernel/irq.c
> +++ b/arch/arm64/kernel/irq.c
> @@ -87,6 +87,7 @@ static bool migrate_one_irq(struct irq_desc *desc)
>   {
>   	struct irq_data *d = irq_desc_get_irq_data(desc);
>   	const struct cpumask *affinity = d->affinity;
> +	struct cpumask tmp_affinity;
>   	struct irq_chip *c;
>   	bool ret = false;
>
> @@ -100,6 +101,14 @@ static bool migrate_one_irq(struct irq_desc *desc)
>   	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
>   		affinity = cpu_online_mask;
>   		ret = true;
> +	} else {
> +		/*
> +		 * when using forced irq_set_affinity we must ensure that the cpu
> +		 * being offlined is not present in the affinity mask, it may be
> +		 * selected as the target CPU otherwise
> +		 */
> +		cpumask_and(&tmp_affinity, affinity, cpu_online_mask);

In case we decide to retain forced set affinity, you can probably squash 
this cpumask_and with the above cpumask_any_and.

> +		affinity = &tmp_affinity;
>   	}
>
>   	c = irq_data_get_irq_chip(d);
>

Regards,
Sudeep

[1] 
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/266785.html
[2] 
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/281548.html

