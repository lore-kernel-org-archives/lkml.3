Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3IZQnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:43:19 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:46041 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3IZQnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:43:15 -0400
Message-ID: <52446413.50504@gmail.com>
Date: Fri, 27 Sep 2013 00:42:59 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, prarit@redhat.com,
        "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 6/6] mem-hotplug: Introduce movablenode boot option
References: <5241D897.1090905@gmail.com> <5241DB62.2090300@gmail.com> <20130926145326.GH3482@htj.dyndns.org>
In-Reply-To: <20130926145326.GH3482@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 10:53 PM, Tejun Heo wrote:
> On Wed, Sep 25, 2013 at 02:35:14AM +0800, Zhang Yanfei wrote:
>> From: Tang Chen <tangchen@cn.fujitsu.com>
>>
>> The hot-Pluggable field in SRAT specifies which memory is hotpluggable.
>> As we mentioned before, if hotpluggable memory is used by the kernel,
>> it cannot be hot-removed. So memory hotplug users may want to set all
>> hotpluggable memory in ZONE_MOVABLE so that the kernel won't use it.
>>
>> Memory hotplug users may also set a node as movable node, which has
>> ZONE_MOVABLE only, so that the whole node can be hot-removed.
>>
>> But the kernel cannot use memory in ZONE_MOVABLE. By doing this, the
>> kernel cannot use memory in movable nodes. This will cause NUMA
>> performance down. And other users may be unhappy.
>>
>> So we need a way to allow users to enable and disable this functionality.
>> In this patch, we introduce movablenode boot option to allow users to
>> choose to not to consume hotpluggable memory at early boot time and
>> later we can set it as ZONE_MOVABLE.
>>
>> To achieve this, the movablenode boot option will control the memblock
>> allocation direction. That said, after memblock is ready, before SRAT is
>> parsed, we should allocate memory near the kernel image as we explained
>> in the previous patches. So if movablenode boot option is set, the kernel
>> does the following:
>>
>> 1. After memblock is ready, make memblock allocate memory bottom up.
>> 2. After SRAT is parsed, make memblock behave as default, allocate memory
>>    top down.
>>
>> Users can specify "movablenode" in kernel commandline to enable this
>> functionality. For those who don't use memory hotplug or who don't want
>> to lose their NUMA performance, just don't specify anything. The kernel
>> will work as before.
>>
>> Suggested-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> I hope the param description and comment were better.  Not necessarily
> longer, but clearer, so it'd be great if you can polish them a bit

OK. Trying below:

movablenode	[KNL,X86] This option enables the kernel to arrange
		hotpluggable memory into ZONE_MOVABLE zone. If memory
		in a node is all hotpluggable, the option may make
		the whole node has only one ZONE_MOVABLE zone, so that
		the whole node can be hot-removed after system is up.
		Note that this option may cause NUMA performance down.

As for the comment in cmdline_parse_movablenode():

	/*
	 * ACPI SRAT records all hotpluggable memory ranges. But before
	 * SRAT is parsed, we don't know about it. So by specifying this
	 * option, we will use the bottom-up mode to try allocating memory
	 * near the kernel image before SRAT is parsed.
	 * 
	 * Bottom-up mode prevents memblock allocating hotpluggable memory
	 * for the kernel so that the kernel will arrange hotpluggable
	 * memory into ZONE_MOVABLE zone when possible.
	 */

Thanks.

> more.  Other than that,
> 
>  Acked-by: Tejun Heo <tj@kernel.org>
> 
> Thanks.
> 


-- 
Thanks.
Zhang Yanfei
