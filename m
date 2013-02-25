Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815Ab3BYCzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:55:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49304 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759581Ab3BYCzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:55:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,731,1355068800"; 
   d="scan'208";a="6760801"
Message-ID: <512AD269.2010900@cn.fujitsu.com>
Date: Mon, 25 Feb 2013 10:54:33 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        minchan.kim@gmail.com, mgorman@suse.de, rientjes@google.com,
        guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au, lliubbo@gmail.com,
        jaegeuk.hanse@gmail.com, tony.luck@intel.com, glommer@parallels.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [Bug fix PATCH 2/2] acpi, movablemem_map: Make whatever nodes
 the kernel resides in un-hotpluggable.
References: <1361358056-1793-1-git-send-email-tangchen@cn.fujitsu.com> <1361358056-1793-3-git-send-email-tangchen@cn.fujitsu.com> <1361647596.11282.7@driftwood>
In-Reply-To: <1361647596.11282.7@driftwood>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/25 10:54:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/25 10:54:19,
	Serialize complete at 2013/02/25 10:54:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2013 03:26 AM, Rob Landley wrote:
> On 02/20/2013 05:00:56 AM, Tang Chen wrote:
>> There could be several memory ranges in the node in which the kernel
>> resides.
>> When using movablemem_map=acpi, we may skip one range that have memory
>> reserved
>> by memblock. But if it is too small, then the kernel will fail to
>> boot. So, make
>> the whole node which the kernel resides in un-hotpluggable. Then the
>> kernel has
>> enough memory to use.
>>
>> Reported-by: H Peter Anvin <hpa@zytor.com>
>> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
>
> Docs part Acked-by: Rob Landley <rob@landley.net> (with minor
> non-blocking snark).

Hi Rob,

Thanks for ack. :)

>
>> @@ -1673,6 +1675,10 @@ bytes respectively. Such letter suffixes can
>> also be entirely omitted.
>> satisfied. So the administrator should be careful that
>> the amount of movablemem_map areas are not too large.
>> Otherwise kernel won't have enough memory to start.
>> + NOTE: We don't stop users specifying the node the
>> + kernel resides in as hotpluggable so that this
>> + option can be used as a workaround of firmware
>> + bugs.
>
> I usually see workaround "for", not "of". And your whitespace is
> inconsistent on that last line.
>
> And I'm now kind of curious what such a workaround would accomplish, but
> I'm suspect it's obvious to people who wind up needing it.

SFAIK, this is more useful when debugging.

>
>> MTD_Partition= [MTD]
>> Format: <name>,<region-number>,<size>,<offset>
>> diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
>> index b8028b2..79836d0 100644
>> --- a/arch/x86/mm/srat.c
>> +++ b/arch/x86/mm/srat.c
>> @@ -166,6 +166,9 @@ handle_movablemem(int node, u64 start, u64 end,
>> u32 hotpluggable)
>> * for other purposes, such as for kernel image. We cannot prevent
>> * kernel from using these memory, so we need to exclude these memory
>> * even if it is hotpluggable.
>> + * Furthermore, to ensure the kernel has enough memory to boot, we make
>> + * all the memory on the node which the kernel resides in
>> + * un-hotpluggable.
>> */
>
> Can you hot-unplug half a node? (Do you have a choice with the
> granularity here?)

No, we cannot hot-plug/hot-unplug half a node. But we can offline some 
of the
memory, not all the memory on one node. :)

Here, hotplug means finally you will physically remove the hardware 
device from
the system while the system is running. So there is no such thing like 
hotplug
half a node, I think. :)

Thanks. :)
