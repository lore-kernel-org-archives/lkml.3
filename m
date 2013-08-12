Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab3HLQq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:46:58 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:62861 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab3HLQq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:46:56 -0400
Date: Mon, 12 Aug 2013 12:46:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <imtangchen@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl,
        lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: Re: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
Message-ID: <20130812164650.GN15892@htj.dyndns.org>
References: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com>
 <20130812145016.GI15892@htj.dyndns.org>
 <5208FBBC.2080304@zytor.com>
 <20130812152343.GK15892@htj.dyndns.org>
 <52090D7F.6060600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52090D7F.6060600@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tang.

On Tue, Aug 13, 2013 at 12:29:51AM +0800, Tang Chen wrote:
> As you said, we can ensure at least one node to be unhotplug. Then the
> kernel will boot anyway. Just like CPU0. But we have the chance to lose
> one movable node.
> 
> The best way is firmware and software corporate together. SRAT provides
> several movable node and enough non-movable memory for the kernel to
> boot. The hotplug users only use movable node.

I'm really lost on this conversation and have no idea what you're
arguing.  My point was simple - let the kernel do its best during boot
and report the result to userland on what nodes are hotpluggable or
not.  Can you please elaborate what your point is from the ground up?
Unfortunately, I currently have no idea what you're saying.

> But, different users have different ways to use memory hotplug.
> 
> Hotswaping any particular chunk of memory is the goal we will reach
> finally. But it is on specific hardware. In most current machines, we
> can use movable node to manage resource in node unit.
> 
> And also, without this movablenode boot option, the MOVABLE_NODE
> functionality, which is already in the kernel, will not be able to
> work. All nodes has kernel memory means no movable node.
> 
> So, how about this: Just like MOVABLE_NODE functionality, introduce
> a new config option. When we have better solutions for memory hotplug,
> we shutoff or remove the config and related code.
> 
> For now, at least make movable node work.

We are talking completely past each other.  I'll just try to clarify
what I was saying.  Can you please do the same?  Let's re-sync on the
discussion.

* Adding an option to tell the kernel to try to stay away from
  hotpluggable nodes is fine.  I have no problem with that at all.

* The patchsets upto this point have been somehow trying to reorder
  operations shomehow such that *no* memory allocation happens before
  memblock is populated with hotplug information.

* However, we already *know* that the memory the kernel image is
  occupying won't be removeable.  It's highly likely that the amount
  of memory allocation before NUMA / hotplug information is fully
  populated is pretty small.  Also, it's highly likely that small
  amount of memory right after the kernel image is contained in the
  same NUMA node, so if we allocate memory close to the kernel image,
  it's likely that we don't contaminate hotpluggable node.  We're
  talking about few megs at most right after the kernel image.  I
  can't see how that would make any noticeable difference.

* Once hotplug information is available, allocation can happen as
  usual and the kernel can report the nodes which are actually
  hotpluggable - marked as hotpluggable by the firmware && didn't get
  contaminated during early alloc && didn't get overflow allocations
  afterwards.  Note that we need such mechanism no matter what as the
  kernel image can be loaded into hotpluggable nodes and reporting
  that to userland is the only thing the kernel can do for cases like
  that short of denying memory unplug on such nodes.

The whole thing would be a lot simpler and generic.  It doesn't even
have to care about which mechanism is being used to acquire all those
information.  What am I missing here?

Thanks.

-- 
tejun
