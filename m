Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab3HLM2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:28:36 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56626 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3HLM2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:28:32 -0400
Message-ID: <5208D4E5.6030808@gmail.com>
Date: Mon, 12 Aug 2013 20:28:21 +0800
From: Tang Chen <imtangchen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Jiang Liu <jiang.liu@huawei.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH part4 2/4] x86, acpica, acpi: Try to find if SRAT is overrided
 earlier.
References: <1375954883-30225-1-git-send-email-tangchen@cn.fujitsu.com> <1375954883-30225-3-git-send-email-tangchen@cn.fujitsu.com> <CAE9FiQXUS9+heHagD45WAyO22NiGDMo3j2JumzvscypVhnjn9A@mail.gmail.com> <5204B93A.6030409@cn.fujitsu.com> <CAE9FiQWSjkrFHBr3UrTYSpaCa8ThVrtPPVcaCyJrD0sGHcei3w@mail.gmail.com>
In-Reply-To: <CAE9FiQWSjkrFHBr3UrTYSpaCa8ThVrtPPVcaCyJrD0sGHcei3w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2013 07:34 AM, Yinghai Lu wrote:
> On Fri, Aug 9, 2013 at 2:41 AM, Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>> On 08/09/2013 12:29 AM, Yinghai Lu wrote:
>> ......
>>
>>>
>>> Please check if you can reuse first half of my patchset, so find and copy
>>> override table earlier. the copied acpi tables could be near kernel code
>>> range.
>>>
>>
>> I don't think we need to do the finding step at that early time, in
>> head64.c stage.
>>
>> Before pagetables are setup, we can use early_ioremap() to map the
>> memory we want to access. We don't need to use phys addr. We can do
>> it in setup_arch(), which has nothing to do with 32bit or 64bit.
>
> if override the acpi tables early, you don't need to check firmware srat and
> then override srat.
> just check last one will be used by kernel.
>
> So you don't need to dig initrd to find srat anymore.

The current logic is find tables in firmware, and override them. I
don't think it is a big deal.

Even if we want to override first, and then skip the table in
firmware (install one time), we still don't need to do it in head64.c,
right ?

>
>>
>>
>>> Move finding in head64.c stage could help xen/dom0 a bit.
>>> as Konrad is working on patchset with acpi override in xen hypervisor.
>>> We can avoid override acpi table two times. Esp xen like to change
>>> DMAR to XMAR.
>>
>>
>> Would you please give some more info about this, and explain why finding
>> override tables in head64.c stage is helpful for xen ?
>
> xen usually can change acpi tables and pass to dom0 kernel. like change DMAR
> to hide it to dom0 kernel.
>
> also distribution could have same kernel to support bare metal and dom0.
>
> so if we find the override kernel early in head64.c, dom0 path will not copy
> actually as no one try to find that for them.
>

I don't know the detail, but seeing from your description, doing
override in head64.c may avoid a copy. If doing such a copy in xen
is not that difficult, I think we can do it for now. Modifying
acpi_initrd_override() logic will need to modify a lot of things.

Just like the local node pagetable, I think it is better to do
xen things after memory hotplug is done.

Thanks.

