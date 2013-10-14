Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab3JNUzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:55:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53772 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663Ab3JNUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:55:44 -0400
Date: Mon, 14 Oct 2013 16:55:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
Message-ID: <20131014205540.GM4722@htj.dyndns.org>
References: <525BFCF3.5010908@gmail.com>
 <20131014142719.GI4722@htj.dyndns.org>
 <525C02DC.4050706@gmail.com>
 <20131014145131.GJ4722@htj.dyndns.org>
 <525C0866.2010808@gmail.com>
 <20131014151902.GL4722@htj.dyndns.org>
 <525C0EFE.2010409@gmail.com>
 <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>
 <20131014200437.GA5720@htj.dyndns.org>
 <CAE9FiQXCG6gR-XL9fVudpNVEdS-3MHPObfWQ=Uf=q7pv33QBOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXCG6gR-XL9fVudpNVEdS-3MHPObfWQ=Uf=q7pv33QBOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 14, 2013 at 01:37:20PM -0700, Yinghai Lu wrote:
> The problem is how to define "amount necessary". If we can parse srat early,
> then we could just map RAM for all boot nodes one time, instead of try some
> small and then after SRAT table, expand it cover non-boot nodes.

Wouldn't that amount be fairly static and restricted?  If you wanna
chunk memory init anyway, there's no reason to init more than
necessary until smp stage is reached.  The more you do early, the more
serialized you're, so wouldn't the goal naturally be initing the
minimum possible?

> To keep non-boot numa node hot-removable. we need to page table (and other
> that we allocate during boot stage) on ram of non boot nodes, or their
> local node ram.  (share page table always should be on boot nodes).

The above assumes the followings,

* 4k page mappings.  It'd be nice to keep everything working for 4k
  but just following SRAT isn't enough.  What if the non-hotpluggable
  boot node doesn't stretch high enough and page table reaches down
  too far?  This won't be an optional behavior, so it is actually
  *likely* to happen on certain setups.

* Memory hotplug is at NUMA node granularity instead of device.

> > Optimizing NUMA boot just requires moving the heavy lifting to
> > appropriate NUMA nodes.  It doesn't require that early boot phase
> > should strictly follow NUMA node boundaries.
> 
> At end of day, I like to see all numa system (ram/cpu/pci) could have
> non boot nodes to be hot-removed logically. with any boot command
> line.

I suppose you mean "without any boot command line"?  Sure, but, first
of all, there is a clear performance trade-off, and, secondly, don't
we want something finer grained?  Why would we want to that per-NUMA
node, which is extremely coarse?

Thanks.

-- 
tejun
