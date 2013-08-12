Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3HLOuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:50:25 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:38849 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3HLOuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:50:21 -0400
Date: Mon, 12 Aug 2013 10:50:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Subject: Re: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
Message-ID: <20130812145016.GI15892@htj.dyndns.org>
References: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 08, 2013 at 06:16:12PM +0800, Tang Chen wrote:
> [How we do this]
> 
> In ACPI, SRAT(System Resource Affinity Table) contains NUMA info. The memory
> affinities in SRAT record every memory range in the system, and also, flags
> specifying if the memory range is hotpluggable.
> (Please refer to ACPI spec 5.0 5.2.16)
> 
> With the help of SRAT, we have to do the following two things to achieve our
> goal:
> 
> 1. When doing memory hot-add, allow the users arranging hotpluggable as
>    ZONE_MOVABLE.
>    (This has been done by the MOVABLE_NODE functionality in Linux.)
> 
> 2. when the system is booting, prevent bootmem allocator from allocating
>    hotpluggable memory for the kernel before the memory initialization
>    finishes.
>    (This is what we are going to do. See below.)

I think it's in a much better shape than before but there still are a
couple things bothering me.

* Why can't it be opportunistic?  It's silly, for example, to fail
  boot because ACPI tells the kernel that all memory is hotpluggable
  especially as there'd be plenty of memory sitting around doing
  nothing and failing to boot is one of the most grave failure mode.
  The HOTPLUG flag can be advisory, right?  Try to allocate
  !hotpluggable memory first, but if that fails, ignore it and
  allocate from anywhere, much like the try_nid allocations.

* Similar to the point hpa raised.  If this can be made opportunistic,
  do we need the strict reordering to discover things earlier?
  Shouldn't it be possible to configure memblock to allocate close to
  the kernel image until hotplug and numa information is available?
  For most sane cases, the memory allocated will be contained in
  non-hotpluggable node anyway and in case they aren't hotplug
  wouldn't work but the system will boot and function perfectly fine.

Thanks.

-- 
tejun
