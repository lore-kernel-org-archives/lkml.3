Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3G2RKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:10:38 -0400
Received: from mail-gh0-f175.google.com ([209.85.160.175]:53639 "EHLO
	mail-gh0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab3G2RKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:10:36 -0400
Date: Mon, 29 Jul 2013 13:10:25 -0400
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
Message-ID: <20130729171025.GH22605@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-15-git-send-email-tangchen@cn.fujitsu.com>
 <20130723205557.GS21100@mtj.dyndns.org>
 <20130723213212.GA21100@mtj.dyndns.org>
 <51F089C1.4010402@cn.fujitsu.com>
 <20130725151719.GE26107@mtj.dyndns.org>
 <51F1F0E0.7040800@cn.fujitsu.com>
 <20130726102609.GB30786@mtj.dyndns.org>
 <51F5CF98.1080101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F5CF98.1080101@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tang.

On Mon, Jul 29, 2013 at 10:12:40AM +0800, Tang Chen wrote:
> So the point is, how to mark the hotpluggable regions and at the
> same time, make
> ACPI and memblock parts independent, right ?

No, not at all.  My point is that the roles need to be divided
clearly.  The firmware (be that ACPI or whatever) knows memory areas
are hotpluggable but it shouldn't be making policy decisions like not
dispending hotpluggable memory through memblock allocator because that
part of logic has *nothing* to do with ACPI.  That is the generic
kernel memory management policy which will apply regardless of what
type of firmware the machine happens to be running on top of.

So, please make ACPI inform memblock of the hotpluggable regions and
implement the allocation policies inside memblock proper.

> So are you saying mark the hotpluggable regions in memblock.memory, but not
> reserve them in memblock.reserved, and make the default allocate
> function avoid
> the hotpluggable regions in memblock.memory ?
>
> This way will be convenient when we put the node_data on local node
> (don't need
> to free regions from memblock.reserved, as you mentioned before), right?

I don't care too much about the specifics and it's likely that you'll
find out which way (flag in memblock.memory, separate region array or
whatever) is better as implementation progresses, but let's please put
things where they belong; otherwise, we end up with weird mess, and,
later on, have to do things like freeing part of reserved hotpluggable
memory for node data from firmware side as you said above, which
basically moves part of memory allocation logic into ACPI, which is
just horrible.

Thanks.

-- 
tejun
