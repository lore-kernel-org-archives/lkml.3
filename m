Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab3GYPRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:17:30 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:43025 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab3GYPR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:17:27 -0400
Date: Thu, 25 Jul 2013 11:17:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Subject: Re: [PATCH 14/21] x86, acpi, numa: Reserve hotpluggable memory at
 early time.
Message-ID: <20130725151719.GE26107@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-15-git-send-email-tangchen@cn.fujitsu.com>
 <20130723205557.GS21100@mtj.dyndns.org>
 <20130723213212.GA21100@mtj.dyndns.org>
 <51F089C1.4010402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F089C1.4010402@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 25, 2013 at 10:13:21AM +0800, Tang Chen wrote:
> >>This is rather hacky.  Why not just introduce MEMBLOCK_NO_MERGE flag?
> 
> The original thinking is to merge regions with the same nid. So I used pxm.
> And then refresh the nid field when nids are mapped.
> 
> I will try to introduce MEMBLOCK_NO_MERGE and make it less hacky.

I kinda don't follow why it's necessary to disallow merging BTW.  Can
you plesae elaborate?  Shouldn't it be enough to mark the regions
hotpluggable?  Why does it matter whether they get merged or not?  If
they belong to different nodes, they'll be separated during the
isolation phase while setting nids, which is the modus operandi of
memblock anyway.

> In order to let memblock control the allocation, we have to store the
> hotpluggable ranges somewhere, and keep the allocated range out of the
> hotpluggable regions. I just think reserving the hotpluggable regions
> and then memblock won't allocate them. No need to do any other limitation.

It isn't different from what you're doing right now.  Just tell
memblock that the areas are hotpluggable and the default memblock
allocation functions stay away from the areas.  That way you can later
add functions which may allocate from hotpluggable areas for
node-local data without resorting to tricks like unreserving part of
it and trying allocation or what not.  As it currently stands, you're
scattering hotpluggable memory handling across memblock and acpi which
is kinda nasty.  Please make acpi feed information into memblock and
make memblock handle hotpluggable regions appropriately.

> And also, the acpi side modification in this patch-set is to get SRAT
> and parse it. I think most of the logic in
> acpi_reserve_hotpluggable_memory()
> is necessary. I don't think letting memblock control the allocation will
> make the acpi side easier.

It's about proper layering.  The code change involved in either case
aren't big but splitting it right would give us less headache when we
later try to support a different firmware or add more features, and
more importantly, it makes things logical and lowers the all important
WTH factor and makes things easier to follow.

Thanks.

-- 
tejun
