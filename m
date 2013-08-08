Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab3HHQ3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:29:14 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:63997 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956Ab3HHQ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:29:11 -0400
MIME-Version: 1.0
In-Reply-To: <1375954883-30225-3-git-send-email-tangchen@cn.fujitsu.com>
References: <1375954883-30225-1-git-send-email-tangchen@cn.fujitsu.com>
	<1375954883-30225-3-git-send-email-tangchen@cn.fujitsu.com>
Date: Thu, 8 Aug 2013 09:29:08 -0700
X-Google-Sender-Auth: FIcwHZL3RiqAYjEjkY3HpUuQAiA
Message-ID: <CAE9FiQXUS9+heHagD45WAyO22NiGDMo3j2JumzvscypVhnjn9A@mail.gmail.com>
Subject: Re: [PATCH part4 2/4] x86, acpica, acpi: Try to find if SRAT is
 overrided earlier.
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Jiang Liu <jiang.liu@huawei.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trimmed CC list a bit.

On Thu, Aug 8, 2013 at 2:41 AM, Tang Chen <tangchen@cn.fujitsu.com> wrote:

> Linux cannot migrate pages used by the kernel due to the direct mapping
> (va = pa + PAGE_OFFSET), any memory used by the kernel cannot be hot-removed.
> So when using memory hotplug, we have to prevent the kernel from using
> hotpluggable memory.
>
> The ACPI table SRAT (System Resource Affinity Table) contains info to specify
> which memory is hotpluggble. After SRAT is parsed, we are aware of which
> memory is hotpluggable.
>
> At the early time when system is booting, SRAT has not been parsed. The boot
> memory allocator memblock will allocate any memory to the kernel. So we need
> SRAT parsed before memblock starts to work.
>
> In this patch, we are going to parse SRAT earlier, right after memblock is ready.
>
> Generally speaking, tables such as SRAT are provided by firmware. But
> ACPI_INITRD_TABLE_OVERRIDE functionality allows users to customize their own
> tables in initrd, and override the ones from firmware. So if we want to parse
> SRAT earlier, we also need to do SRAT override earlier.
>
> First, we introduce early_acpi_override_srat() to check if SRAT will be overridden
> from initrd.
>
> Second, we introduce find_hotpluggable_memory() to reserve hotpluggable memory,
> which will firstly call early_acpi_override_srat() to find out which memory is
> hotpluggable in the override SRAT.

acpi_override_srat handling is pretty ugly.

Please check if you can reuse first half of my patchset, so find and copy
override table earlier. the copied acpi tables could be near kernel code range.

Move finding in head64.c stage could help xen/dom0 a bit.
as Konrad is working on patchset with acpi override in xen hypervisor.
We can avoid override acpi table two times. Esp xen like to change
DMAR to XMAR.

Yinghai
