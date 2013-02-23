Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab3BWVeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 16:34:10 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:54769 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3BWVdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 16:33:55 -0500
Date: Sat, 23 Feb 2013 13:26:36 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [Bug fix PATCH 2/2] acpi, movablemem_map: Make whatever nodes
 the kernel resides in un-hotpluggable.
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        minchan.kim@gmail.com, mgorman@suse.de, rientjes@google.com,
        guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au, lliubbo@gmail.com,
        jaegeuk.hanse@gmail.com, tony.luck@intel.com, glommer@parallels.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <1361358056-1793-1-git-send-email-tangchen@cn.fujitsu.com>
	<1361358056-1793-3-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1361358056-1793-3-git-send-email-tangchen@cn.fujitsu.com>
	(from tangchen@cn.fujitsu.com on Wed Feb 20 05:00:56 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1361647596.11282.7@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 05:00:56 AM, Tang Chen wrote:
> There could be several memory ranges in the node in which the kernel  
> resides.
> When using movablemem_map=acpi, we may skip one range that have  
> memory reserved
> by memblock. But if it is too small, then the kernel will fail to  
> boot. So, make
> the whole node which the kernel resides in un-hotpluggable. Then the  
> kernel has
> enough memory to use.
> 
> Reported-by: H Peter Anvin <hpa@zytor.com>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>

Docs part Acked-by: Rob Landley <rob@landley.net> (with minor  
non-blocking snark).

> @@ -1673,6 +1675,10 @@ bytes respectively. Such letter suffixes can  
> also be entirely omitted.
>  			satisfied. So the administrator should be  
> careful that
>  			the amount of movablemem_map areas are not too  
> large.
>  			Otherwise kernel won't have enough memory to  
> start.
> +			NOTE: We don't stop users specifying the node  
> the
> +			      kernel resides in as hotpluggable so that  
> this
> +			      option can be used as a workaround of  
> firmware
> +                              bugs.

I usually see workaround "for", not "of". And your whitespace is  
inconsistent on that last line.

And I'm now kind of curious what such a workaround would accomplish,  
but I'm suspect it's obvious to people who wind up needing it.

>  	MTD_Partition=	[MTD]
>  			Format: <name>,<region-number>,<size>,<offset>
> diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> index b8028b2..79836d0 100644
> --- a/arch/x86/mm/srat.c
> +++ b/arch/x86/mm/srat.c
> @@ -166,6 +166,9 @@ handle_movablemem(int node, u64 start, u64 end,  
> u32 hotpluggable)
>  	 * for other purposes, such as for kernel image. We cannot  
> prevent
>  	 * kernel from using these memory, so we need to exclude these  
> memory
>  	 * even if it is hotpluggable.
> +	 * Furthermore, to ensure the kernel has enough memory to boot,  
> we make
> +	 * all the memory on the node which the kernel resides in
> +	 * un-hotpluggable.
>  	 */

Can you hot-unplug half a node? (Do you have a choice with the  
granularity here?)

Rob
