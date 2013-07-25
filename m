Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab3GYEGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:06:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23692 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3GYEGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:06:47 -0400
X-IronPort-AV: E=Sophos;i="4.89,740,1367942400"; 
   d="scan'208";a="8015463"
Message-ID: <51F0A4F9.2060802@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 12:09:29 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 18/21] x86, numa: Synchronize nid info in memblock.reserve
 with numa_meminfo.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-19-git-send-email-tangchen@cn.fujitsu.com> <20130723212548.GZ21100@mtj.dyndns.org>
In-Reply-To: <20130723212548.GZ21100@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 12:04:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 12:04:42,
	Serialize complete at 2013/07/25 12:04:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 05:25 AM, Tejun Heo wrote:
> On Fri, Jul 19, 2013 at 03:59:31PM +0800, Tang Chen wrote:
>> Vasilis Liaskovitis found that before we parse SRAT and fulfill numa_meminfo,
>> the nids of all the regions in memblock.reserve[] are MAX_NUMNODES. That is
>> because nids have not been mapped at that time.
>>
>> When we arrange ZONE_MOVABLE in each node later, we need nid in memblock. So
>> after we parse SRAT and fulfill nume_meminfo, synchronize the nid info to
>> memblock.reserve[] immediately.
>
> Having a separate sync is rather nasty.  Why not let
> memblock_set_node() and alloc functions set nid on the reserved
> regions?

Node id and pxm are 1-1 mapped. For the current kernel, before SRAT is 
parsed,
we don't know nid. So all allocated regions are reserved by memblock with
nid = MAX_NUMNODES. So for early allocated memory, we cannot use 
memblock_set_node()
and alloc functions to set the nid.

In this patch-set, we parse SRAT twice, the first one is right after 
memblock is ready.
But we didn't setup nid <-> pxm mapping. So we still have this problem.

And as in [patch 14/21], when reserving hotpluggable memory, we use pxm. 
So my
idea was to do a nid sync in numa_init(). After this, memblock will set 
nid when
it allocates memory.

If we want to let memblock_set_node() and alloc functions set nid on the 
reserved
regions, we should setup nid <-> pxm mapping when we parst SRAT for the 
first time.
If you think this is OK, I can try it.

Thanks.
