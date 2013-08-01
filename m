Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3HAKG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:06:27 -0400
Received: from mail.southpole.se ([37.247.8.11]:44005 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab3HAKGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:06:24 -0400
X-Greylist: delayed 1304 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Aug 2013 06:06:24 EDT
Message-ID: <51FA2E67.2030001@southpole.se>
Date: Thu, 01 Aug 2013 11:46:15 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: linux-kernel@vger.kernel.org, linux@openrisc.net
Subject: Re: [ORLinux] [PATCH] openrisc: add cache way information to cpuinfo
References: <1367085752-4736-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-Reply-To: <1367085752-4736-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13137) on assp.southpole.se
X-Assp-ID: assp.southpole.se 50276-06326
X-Assp-Session: 7F85ADAC34D0 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2013 08:02 PM, Stefan Kristiansson wrote:
> Motivation for this is to be able to print the way information
> properly in print_cpuinfo(), instead of hardcoding it to one.
>
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

Applied.  Thanks.
/Jonas

> ---
>   arch/openrisc/include/asm/cpuinfo.h |  2 ++
>   arch/openrisc/kernel/setup.c        | 20 +++++++++++++-------
>   2 files changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/arch/openrisc/include/asm/cpuinfo.h b/arch/openrisc/include/asm/cpuinfo.h
> index 917318b..ec10679 100644
> --- a/arch/openrisc/include/asm/cpuinfo.h
> +++ b/arch/openrisc/include/asm/cpuinfo.h
> @@ -24,9 +24,11 @@ struct cpuinfo {
>
>   	u32 icache_size;
>   	u32 icache_block_size;
> +	u32 icache_ways;
>
>   	u32 dcache_size;
>   	u32 dcache_block_size;
> +	u32 dcache_ways;
>   };
>
>   extern struct cpuinfo cpuinfo;
> diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
> index f4d5bed..6b0e2c4 100644
> --- a/arch/openrisc/kernel/setup.c
> +++ b/arch/openrisc/kernel/setup.c
> @@ -129,13 +129,15 @@ static void print_cpuinfo(void)
>   	if (upr & SPR_UPR_DCP)
>   		printk(KERN_INFO
>   		       "-- dcache: %4d bytes total, %2d bytes/line, %d way(s)\n",
> -		       cpuinfo.dcache_size, cpuinfo.dcache_block_size, 1);
> +		       cpuinfo.dcache_size, cpuinfo.dcache_block_size,
> +		       cpuinfo.dcache_ways);
>   	else
>   		printk(KERN_INFO "-- dcache disabled\n");
>   	if (upr & SPR_UPR_ICP)
>   		printk(KERN_INFO
>   		       "-- icache: %4d bytes total, %2d bytes/line, %d way(s)\n",
> -		       cpuinfo.icache_size, cpuinfo.icache_block_size, 1);
> +		       cpuinfo.icache_size, cpuinfo.icache_block_size,
> +		       cpuinfo.icache_ways);
>   	else
>   		printk(KERN_INFO "-- icache disabled\n");
>
> @@ -167,25 +169,25 @@ void __init setup_cpuinfo(void)
>   {
>   	struct device_node *cpu;
>   	unsigned long iccfgr, dccfgr;
> -	unsigned long cache_set_size, cache_ways;
> +	unsigned long cache_set_size;
>
>   	cpu = of_find_compatible_node(NULL, NULL, "opencores,or1200-rtlsvn481");
>   	if (!cpu)
>   		panic("No compatible CPU found in device tree...\n");
>
>   	iccfgr = mfspr(SPR_ICCFGR);
> -	cache_ways = 1 << (iccfgr & SPR_ICCFGR_NCW);
> +	cpuinfo.icache_ways = 1 << (iccfgr & SPR_ICCFGR_NCW);
>   	cache_set_size = 1 << ((iccfgr & SPR_ICCFGR_NCS) >> 3);
>   	cpuinfo.icache_block_size = 16 << ((iccfgr & SPR_ICCFGR_CBS) >> 7);
>   	cpuinfo.icache_size =
> -	    cache_set_size * cache_ways * cpuinfo.icache_block_size;
> +	    cache_set_size * cpuinfo.icache_ways * cpuinfo.icache_block_size;
>
>   	dccfgr = mfspr(SPR_DCCFGR);
> -	cache_ways = 1 << (dccfgr & SPR_DCCFGR_NCW);
> +	cpuinfo.dcache_ways = 1 << (dccfgr & SPR_DCCFGR_NCW);
>   	cache_set_size = 1 << ((dccfgr & SPR_DCCFGR_NCS) >> 3);
>   	cpuinfo.dcache_block_size = 16 << ((dccfgr & SPR_DCCFGR_CBS) >> 7);
>   	cpuinfo.dcache_size =
> -	    cache_set_size * cache_ways * cpuinfo.dcache_block_size;
> +	    cache_set_size * cpuinfo.dcache_ways * cpuinfo.dcache_block_size;
>
>   	if (of_property_read_u32(cpu, "clock-frequency",
>   				 &cpuinfo.clock_frequency)) {
> @@ -336,8 +338,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>   			  "frequency\t: %ld\n"
>   			  "dcache size\t: %d bytes\n"
>   			  "dcache block size\t: %d bytes\n"
> +			  "dcache ways\t: %d\n"
>   			  "icache size\t: %d bytes\n"
>   			  "icache block size\t: %d bytes\n"
> +			  "icache ways\t: %d\n"
>   			  "immu\t\t: %d entries, %lu ways\n"
>   			  "dmmu\t\t: %d entries, %lu ways\n"
>   			  "bogomips\t: %lu.%02lu\n",
> @@ -346,8 +350,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>   			  loops_per_jiffy * HZ,
>   			  cpuinfo.dcache_size,
>   			  cpuinfo.dcache_block_size,
> +			  cpuinfo.dcache_ways,
>   			  cpuinfo.icache_size,
>   			  cpuinfo.icache_block_size,
> +			  cpuinfo.icache_ways,
>   			  1 << ((mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTS) >> 2),
>   			  1 + (mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTW),
>   			  1 << ((mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTS) >> 2),
>

