Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbbAMINn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:13:43 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:37527 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbbAMINl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:13:41 -0500
Message-ID: <54B4D36D.8030204@hp.com>
Date: Tue, 13 Jan 2015 16:12:29 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        vgoyal@redhat.com, dyoung@redhat.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, alex.williamson@redhat.com,
        ddutile@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        doug.hatch@hp.com, jerry.hoemann@hp.com, tom.vaden@hp.com,
        li.zhang6@hp.com, lisa.mitchell@hp.com, billsumnerlinux@gmail.com,
        rwright@hp.com, "Li, ZhenHua" <zhen-hual@hp.com>
Subject: Re: [PATCH v8 02/10] iommu/vt-d: Items required for kdump
References: <1421046388-27925-1-git-send-email-zhen-hual@hp.com> <1421046388-27925-3-git-send-email-zhen-hual@hp.com> <20150112152207.GC6343@8bytes.org>
In-Reply-To: <20150112152207.GC6343@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 11:22 PM, Joerg Roedel wrote:
> On Mon, Jan 12, 2015 at 03:06:20PM +0800, Li, Zhen-Hua wrote:
>> +
>> +#ifdef CONFIG_CRASH_DUMP
>> +
>> +/*
>> + * Fix Crashdump failure caused by leftover DMA through a hardware IOMMU
>> + *
>> + * Fixes the crashdump kernel to deal with an active iommu and legacy
>> + * DMA from the (old) panicked kernel in a manner similar to how legacy
>> + * DMA is handled when no hardware iommu was in use by the old kernel --
>> + * allow the legacy DMA to continue into its current buffers.
>> + *
>> + * In the crashdump kernel, this code:
>> + * 1. skips disabling the IOMMU's translating of IO Virtual Addresses (IOVA).
>> + * 2. Do not re-enable IOMMU's translating.
>> + * 3. In kdump kernel, use the old root entry table.
>> + * 4. Leaves the current translations in-place so that legacy DMA will
>> + *    continue to use its current buffers.
>> + * 5. Allocates to the device drivers in the crashdump kernel
>> + *    portions of the iova address ranges that are different
>> + *    from the iova address ranges that were being used by the old kernel
>> + *    at the time of the panic.
>> + *
>> + */
>
> It looks like you are still copying the io-page-tables from the old
> kernel into the kdump kernel, is that right? With the approach that was
> proposed you only need to copy over the context entries 1-1. They are
> still pointing to the page-tables in the old kernels memory (which is
> just fine).
>
> The root-entry of the old kernel is also re-used, and when the kdump
> kernel starts to use a device, its context entry is updated to point to
> a newly allocated page-table.
>

Current status:
1. Use old root entry table,
2. Copy old context entry tables.
3. Copy old page tables.
4. Allocate new page table when device driver is loading.

I remember the progress we discussed was this. Checking the old mails,
founding we did not clearly discuss about the old page tables, only
agrred with allocating new page tables when device driver is loading.

To me, both of these two options are fine, copying old page tables, or
re-use the old ones. My debugging shows both of them works fine.

If we use the old page tables, the patchset will use less code.
Functions copy_page_addr, copy_page_table are no longer needed, and
functions copy_context_entry and copy_context_entry_table will be
reduced to several lines. The patchset will be much simpler.

Zhenhua


