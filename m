Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3HUPA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:00:59 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42464 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3HUPA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:00:56 -0400
Message-ID: <5214D60A.2090309@gmail.com>
Date: Wed, 21 Aug 2013 23:00:26 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, konrad.wilk@oracle.com,
        robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl,
        lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Subject: Re: [PATCH 0/8] x86, acpi: Move acpi_initrd_override() earlier.
References: <1377080143-28455-1-git-send-email-tangchen@cn.fujitsu.com> <20130821130647.GB19286@mtj.dyndns.org>
In-Reply-To: <20130821130647.GB19286@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi tejun,

On 08/21/2013 09:06 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 21, 2013 at 06:15:35PM +0800, Tang Chen wrote:
>> [What are we doing]
>>
>> We are trying to initialize acip tables as early as possible. But Linux kernel
>> allows users to override acpi tables by specifying their own tables in initrd.
>> So we have to do acpi_initrd_override() earlier first.
> 
> So, are we now back to making SRAT info as early as possible?  What
> happened to just co-locating early allocations close to kernel image?
> What'd be the benefit of doing this over that?

We know you are trying to give the direction to make the change more natural and
robust and very thankful for your comments. We have taken your comments and suggestions
about co-locating early allocations close to kernel image into consideration, but
still we found that not that easy.

In current boot order, before we get the SRAT, we have a big consumer of early
allocations: we are setting up the page table in top-down (The idea was proposed by HPA,
Link: https://lkml.org/lkml/2012/10/4/701). That said, this kind of page table
setup will make the page tables as high as possible in memory, since memory at low 
addresses is precious (for stupid DMA devices, for things like  kexec/kdump, and so on.)

So if we are trying to make early allocations close to kernel image, we should
rewrite the way we are setting up page table totally. That is not a easy thing
to do.

As for the benefits of the patchset, just as Tang said in this patch,

* For memory hotplug, we need ACPI SRAT at early time to be aware of which memory
  ranges are hotpluggable, and tell the kernel to try to stay away from hotpluggable
  nodes.

This one is the current requirement of us but may be very helpful for future change:

* As suggested by Yinghai, we should allocate page tables in local node. This also
  needs SRAT before direct mapping page tables are setup.

* As mentioned by Toshi Kani <toshi.kani@hp.com>, ACPI SCPR/DBGP/DBG2 tables
  allow the OS to initialize serial console/debug ports at early boot time. The
  earlier it can be initialized, the better this feature will be.  These tables
  are not currently used by Linux due to a licensing issue, but it could be
  addressed some time soon.

So we decided to firstly make ACPI override earlier and use BRK (this is obviously
near the kernel image range) to store the found ACPI tables.

-- 
Thanks.
Zhang Yanfei
