Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbaIEOIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:08:14 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34065 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaIEOIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:08:11 -0400
Message-ID: <5409C3C6.90204@linux.vnet.ibm.com>
Date: Fri, 05 Sep 2014 09:08:06 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: bharata.rao@gmail.com, linux-kernel@vger.kernel.org
CC: linuxppc-dev@lists.ozlabs.org, Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [PATCH] pseries: Make CPU hotplug path endian safe
References: <1409908577-10648-1-git-send-email-bharata.rao@gmail.com>
In-Reply-To: <1409908577-10648-1-git-send-email-bharata.rao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090514-9332-0000-0000-000001EA63D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 04:16 AM, bharata.rao@gmail.com wrote:
> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> - ibm,rtas-configure-connector should treat the RTAS data as big endian.
> - Treat ibm,ppc-interrupt-server#s as big-endian when setting
>   smp_processor_id during hotplug.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/dlpar.c       | 10 +++++-----
>  arch/powerpc/platforms/pseries/hotplug-cpu.c |  4 ++--
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
> index 2d0b4d6..dc55f9c 100644
> --- a/arch/powerpc/platforms/pseries/dlpar.c
> +++ b/arch/powerpc/platforms/pseries/dlpar.c
> @@ -48,11 +48,11 @@ static struct property *dlpar_parse_cc_property(struct cc_workarea *ccwa)
>  	if (!prop)
>  		return NULL;
>  
> -	name = (char *)ccwa + ccwa->name_offset;
> +	name = (char *)ccwa + be32_to_cpu(ccwa->name_offset);
>  	prop->name = kstrdup(name, GFP_KERNEL);
>  
> -	prop->length = ccwa->prop_length;
> -	value = (char *)ccwa + ccwa->prop_offset;
> +	prop->length = be32_to_cpu(ccwa->prop_length);
> +	value = (char *)ccwa + be32_to_cpu(ccwa->prop_offset);
>  	prop->value = kmemdup(value, prop->length, GFP_KERNEL);
>  	if (!prop->value) {
>  		dlpar_free_cc_property(prop);
> @@ -78,7 +78,7 @@ static struct device_node *dlpar_parse_cc_node(struct cc_workarea *ccwa,
>  	if (!dn)
>  		return NULL;
>  
> -	name = (char *)ccwa + ccwa->name_offset;
> +	name = (char *)ccwa + be32_to_cpu(ccwa->name_offset);
>  	dn->full_name = kasprintf(GFP_KERNEL, "%s/%s", path, name);
>  	if (!dn->full_name) {
>  		kfree(dn);
> @@ -148,7 +148,7 @@ struct device_node *dlpar_configure_connector(u32 drc_index,
>  		return NULL;
>  
>  	ccwa = (struct cc_workarea *)&data_buf[0];
> -	ccwa->drc_index = drc_index;
> +	ccwa->drc_index = cpu_to_be32(drc_index);

I need to look at this some more but I think this may cause an issue for
partition migration. If I am following the code correctly, starting in
pseries_devicetree_update(), the drc_index value passed to 
dlpar_configure_connector is pulled directly out of a buffer we get from
firmware. This would mean the drc_index value is already in BE format.

Whereas for cpu hotplug the drc_index value is passed in from userspace
via the cpu probe interface in sysfs. I assume that you are seeing the
drc_index value getting passed in in LE format.

-Nathan

>  	ccwa->zero = 0;
>  
>  	do {
> diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
> index 20d6297..447f8c6 100644
> --- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
> +++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
> @@ -247,7 +247,7 @@ static int pseries_add_processor(struct device_node *np)
>  	unsigned int cpu;
>  	cpumask_var_t candidate_mask, tmp;
>  	int err = -ENOSPC, len, nthreads, i;
> -	const u32 *intserv;
> +	const __be32 *intserv;
>  
>  	intserv = of_get_property(np, "ibm,ppc-interrupt-server#s", &len);
>  	if (!intserv)
> @@ -293,7 +293,7 @@ static int pseries_add_processor(struct device_node *np)
>  	for_each_cpu(cpu, tmp) {
>  		BUG_ON(cpu_present(cpu));
>  		set_cpu_present(cpu, true);
> -		set_hard_smp_processor_id(cpu, *intserv++);
> +		set_hard_smp_processor_id(cpu, be32_to_cpu(*intserv++));
>  	}
>  	err = 0;
>  out_unlock:
> 

