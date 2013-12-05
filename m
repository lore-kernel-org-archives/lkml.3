Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3LEK0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:26:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55950 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab3LEK0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:26:48 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52A054A0.6060108@jp.fujitsu.com>
Date: Thu, 5 Dec 2013 19:25:36 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <mingo@kernel.org>, <hpa@zytor.com>,
        <tglx@linutronix.de>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH] mm, x86: Skip NUMA_NO_NODE while parsing SLIT
References: <1386191348-4696-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1386191348-4696-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/05 6:09), Toshi Kani wrote:
> When ACPI SLIT table has an I/O locality (i.e. a locality unique
> to an I/O device), numa_set_distance() emits the warning message
> below.
> 
>   NUMA: Warning: node ids are out of bound, from=-1 to=-1 distance=10
> 
> acpi_numa_slit_init() calls numa_set_distance() with pxm_to_node(),
> which assumes that all localities have been parsed with SRAT previously.
> SRAT does not list I/O localities, where as SLIT lists all localities

> including I/Os.  Hence, pxm_to_node() returns NUMA_NO_NODE (-1) for
> an I/O locality.  I/O localities are not supported and are ignored
> today, but emitting such warning message leads unnecessary confusion.

In this case, the warning message should not be shown. But if SLIT table
is really broken, the message should be shown. Your patch seems to not care
for second case.

Thanks,
Yasuaki Ishimatsu


> 
> Change acpi_numa_slit_init() to avoid calling numa_set_distance()
> with NUMA_NO_NODE.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>   arch/x86/mm/srat.c |   10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> index 266ca91..29a2ced 100644
> --- a/arch/x86/mm/srat.c
> +++ b/arch/x86/mm/srat.c
> @@ -47,10 +47,16 @@ void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
>   {
>   	int i, j;
>   
> -	for (i = 0; i < slit->locality_count; i++)
> -		for (j = 0; j < slit->locality_count; j++)
> +	for (i = 0; i < slit->locality_count; i++) {
> +		if (pxm_to_node(i) == NUMA_NO_NODE)
> +			continue;
> +		for (j = 0; j < slit->locality_count; j++) {
> +			if (pxm_to_node(j) == NUMA_NO_NODE)
> +				continue;
>   			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
>   				slit->entry[slit->locality_count * i + j]);
> +		}
> +	}
>   }
>   
>   /* Callback for Proximity Domain -> x2APIC mapping */
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 


