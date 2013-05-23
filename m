Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab3EWEet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 00:34:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13072 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab3EWEer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 00:34:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,725,1363104000"; 
   d="scan'208";a="7341235"
Message-ID: <519D9D04.9090403@cn.fujitsu.com>
Date: Thu, 23 May 2013 12:37:24 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH] Driver core / memory: Simplify __memory_block_change_state()
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <1824290.fKsAJTo9gA@vostro.rjw.lan> <519C4D6E.6080902@cn.fujitsu.com> <1594596.DcsjzgnrZI@vostro.rjw.lan>
In-Reply-To: <1594596.DcsjzgnrZI@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/23 12:33:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/23 12:33:22,
	Serialize complete at 2013/05/23 12:33:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>

Thanks. :)

On 05/23/2013 06:06 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki<rafael.j.wysocki@intel.com>
>
> As noted by Tang Chen, the last_online field in struct memory_block
> introduced by commit 4960e05 (Driver core: Introduce offline/online
> callbacks for memory blocks) is not really necessary, because
> online_pages() restores the previous state if passed ONLINE_KEEP as
> the last argument.  Therefore, remove that field along with the code
> referring to it.
>
> References: http://marc.info/?l=linux-kernel&m=136919777305599&w=2
> Signed-off-by: Rafael J. Wysocki<rafael.j.wysocki@intel.com>
> ---
>
> Hi,
>
> The patch is on top (and the commit mentioned in the changelog is present in)
> the acpi-hotplug branch of the linux-pm.git tree.
>
> Thanks,
> Rafael
>
> ---
>   drivers/base/memory.c  |   11 ++---------
>   include/linux/memory.h |    1 -
>   2 files changed, 2 insertions(+), 10 deletions(-)
>
> Index: linux-pm/drivers/base/memory.c
> ===================================================================
> --- linux-pm.orig/drivers/base/memory.c
> +++ linux-pm/drivers/base/memory.c
> @@ -291,13 +291,7 @@ static int __memory_block_change_state(s
>   		mem->state = MEM_GOING_OFFLINE;
>
>   	ret = memory_block_action(mem->start_section_nr, to_state, online_type);
> -	if (ret) {
> -		mem->state = from_state_req;
> -	} else {
> -		mem->state = to_state;
> -		if (to_state == MEM_ONLINE)
> -			mem->last_online = online_type;
> -	}
> +	mem->state = ret ? from_state_req : to_state;
>   	return ret;
>   }
>
> @@ -310,7 +304,7 @@ static int memory_subsys_online(struct d
>
>   	ret = mem->state == MEM_ONLINE ? 0 :
>   		__memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE,
> -					    mem->last_online);
> +					    ONLINE_KEEP);
>
>   	mutex_unlock(&mem->state_mutex);
>   	return ret;
> @@ -618,7 +612,6 @@ static int init_memory_block(struct memo
>   			base_memory_block_id(scn_nr) * sections_per_block;
>   	mem->end_section_nr = mem->start_section_nr + sections_per_block - 1;
>   	mem->state = state;
> -	mem->last_online = ONLINE_KEEP;
>   	mem->section_count++;
>   	mutex_init(&mem->state_mutex);
>   	start_pfn = section_nr_to_pfn(mem->start_section_nr);
> Index: linux-pm/include/linux/memory.h
> ===================================================================
> --- linux-pm.orig/include/linux/memory.h
> +++ linux-pm/include/linux/memory.h
> @@ -26,7 +26,6 @@ struct memory_block {
>   	unsigned long start_section_nr;
>   	unsigned long end_section_nr;
>   	unsigned long state;
> -	int last_online;
>   	int section_count;
>
>   	/*
>
>
