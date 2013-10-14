Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab3JNUhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:37:25 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:40213 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab3JNUhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:37:21 -0400
MIME-Version: 1.0
In-Reply-To: <20131014200437.GA5720@htj.dyndns.org>
References: <525B19C3.9040907@gmail.com>
	<20131014133835.GG4722@htj.dyndns.org>
	<525BFCF3.5010908@gmail.com>
	<20131014142719.GI4722@htj.dyndns.org>
	<525C02DC.4050706@gmail.com>
	<20131014145131.GJ4722@htj.dyndns.org>
	<525C0866.2010808@gmail.com>
	<20131014151902.GL4722@htj.dyndns.org>
	<525C0EFE.2010409@gmail.com>
	<CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>
	<20131014200437.GA5720@htj.dyndns.org>
Date: Mon, 14 Oct 2013 13:37:20 -0700
X-Google-Sender-Auth: QO4uJQon_CmFHcrqrGiT0wBT9Hg
Message-ID: <CAE9FiQXCG6gR-XL9fVudpNVEdS-3MHPObfWQ=Uf=q7pv33QBOA@mail.gmail.com>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 1:04 PM, Tejun Heo <tj@kernel.org> wrote:
>> 6. in the long run, We should rework our NUMA booting:
>> a. boot system with boot numa nodes early only.
>> b. in later init stage or user space, init other nodes
>> RAM/CPU/PCI...in parallel.
>> that will reduce boot time for 8 sockets/32 sockets dramatically.
>>
>> We will need to parse srat table early so could avoid init memory for
>> non-boot nodes.
>
> Among the six you listed, this one sounds somewhat valid but still
> assuming huge page, what difference does it make?  We're just talking
> about page table alloc / init and ACPI init.  If you wanna speed up
> huge NUMA machine booting and chop down memory init per-NUMA, sure,
> move those pieces to later stages.  You can init the amount necessary
> during early boot and then bring up the rest later on.  I don't see
> why that'd require parsing SRAT.

The problem is how to define "amount necessary". If we can parse srat early,
then we could just map RAM for all boot nodes one time, instead of try some
small and then after SRAT table, expand it cover non-boot nodes.

To keep non-boot numa node hot-removable. we need to page table (and other
that we allocate during boot stage) on ram of non boot nodes, or their
local node ram.  (share page table always should be on boot nodes).

> In fact, I think there'll be more
> cases where you want to actively ignore NUMA mapping during early
> boot.  What if the system maps low memory to a non-boot numa node?

Then we treat that non-boot numa node as one of boot nodes, and it
could not be hot removed.

Actually that is BIOS or Firmware bug, they should set memory address
decoder correctly.

>
> Optimizing NUMA boot just requires moving the heavy lifting to
> appropriate NUMA nodes.  It doesn't require that early boot phase
> should strictly follow NUMA node boundaries.

At end of day, I like to see all numa system (ram/cpu/pci) could have
non boot nodes to be hot-removed logically. with any boot command
line.

Thanks

Yinghai
