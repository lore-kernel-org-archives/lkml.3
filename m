Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab3HLOjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:39:18 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:35618 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab3HLOjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:39:16 -0400
Date: Mon, 12 Aug 2013 10:39:10 -0400
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
Subject: Re: [PATCH part5 1/7] x86: get pg_data_t's memory from other node
Message-ID: <20130812143910.GH15892@htj.dyndns.org>
References: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com>
 <1375956979-31877-2-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375956979-31877-2-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The subject is a bit misleading.  Maybe it should say "allow getting
..." rather than "get ..."?

On Thu, Aug 08, 2013 at 06:16:13PM +0800, Tang Chen wrote:
....
> A node could have several memory devices. And the device who holds node
> data should be hot-removed in the last place. But in NUMA level, we don't
> know which memory_block (/sys/devices/system/node/nodeX/memoryXXX) belongs
> to which memory device. We only have node. So we can only do node hotplug.
> 
> But in virtualization, developers are now developing memory hotplug in qemu,
> which support a single memory device hotplug. So a whole node hotplug will
> not satisfy virtualization users.
> 
> So at last, we concluded that we'd better do memory hotplug and local node
> things (local node node data, pagetable, vmemmap, ...) in two steps.
> Please refer to https://lkml.org/lkml/2013/6/19/73

I suppose the above three paragraphs are trying to say

* A hotpluggable NUMA node may be composed of multiple memory devices
  which individually are hot-pluggable.

* pg_data_t and page tables the serving a NUMA node may be located in
  the same node they're serving; however, if the node is composed of
  multiple hotpluggable memory devices, the device containing them
  should be the last one to be removed.

* For physical memory hotplug, whole NUMA node hotunplugging is fine;
  however, in virtualizied environments, finer grained hotunplugging
  is desirable; unfortunately, there currently is no way to which
  specific memory device pg_data_t and page tables are allocated
  inside making it impossible to order unpluggings of memory devices
  of a NUMA node.  To avoid the ordering problem while allowing
  removal of subset fo a NUMA node, it has been decided that pg_data_t
  and page tables should be allocated on a different non-hotpluggable
  NUMA node.

Am I following it correctly?  If so, can you please update the
description?  It's quite confusing.  Also, the decision seems rather
poorly made.  It should be trivial to allocate memory for pg_data_t
and page tables in one end of the NUMA node and just record the
boundary to distinguish between the area which can be removed any time
and the other which can only be removed as a unit as the last step.

Thanks.

-- 
tejun
