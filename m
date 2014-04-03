Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161142AbaDCBiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 21:38:19 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:13887 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933675AbaDCBiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 21:38:13 -0400
X-IronPort-AV: E=Sophos;i="4.97,783,1389715200"; 
   d="scan'208";a="28808038"
Message-ID: <533CBB46.4050800@cn.fujitsu.com>
Date: Thu, 3 Apr 2014 09:37:10 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, <nfont@linux.vnet.ibm.com>,
        <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>
In-Reply-To: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ccing

On 04/02/2014 04:56 PM, Li Zhong wrote:
> I noticed the phys_index and end_phys_index under 
> /sys/devices/system/memory/memoryXXX/ have the same value, e.g.
> (for the test machine, one memory block has 8 sections, that is 
>  sections_per_block equals 8)
> 
> # cd /sys/devices/system/memory/memory100/
> # cat phys_index end_phys_index 
> 00000064
> 00000064
> 
> Seems they should reflect the start/end section number respectively, which 
> also matches what is said in Documentation/memory-hotplug.txt

Indeed. I've noticed this before. The value in 'end_phys_index' doesn't
match what it really means. But, the name itself is vague, it looks like
it is the index of some page frame. (we keep this name for compatibility?)

The corresponding member in struct memory_block is:

struct memory_block {
        unsigned long start_section_nr;
        unsigned long end_section_nr;
...

The two members seem to have the right name, and have the right value in kernel.


> 
> This patch tries to modify that so the two files could show the start/end
> section number of the memory block.
> 
> After this change, output of the above example looks like:
> 
> # cat phys_index end_phys_index 
> 00000320
> 00000327
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> ---
>  drivers/base/memory.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index bece691..b10f2fa 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -114,7 +114,7 @@ static ssize_t show_mem_start_phys_index(struct device *dev,
>  	struct memory_block *mem = to_memory_block(dev);
>  	unsigned long phys_index;
>  
> -	phys_index = mem->start_section_nr / sections_per_block;
> +	phys_index = mem->start_section_nr;
>  	return sprintf(buf, "%08lx\n", phys_index);
>  }
>  
> @@ -124,7 +124,7 @@ static ssize_t show_mem_end_phys_index(struct device *dev,
>  	struct memory_block *mem = to_memory_block(dev);
>  	unsigned long phys_index;
>  
> -	phys_index = mem->end_section_nr / sections_per_block;
> +	phys_index = mem->end_section_nr;
>  	return sprintf(buf, "%08lx\n", phys_index);
>  }
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Thanks.
Zhang Yanfei
