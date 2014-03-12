Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaCLRIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:08:48 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:52390 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbaCLRIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:08:47 -0400
Date: Wed, 12 Mar 2014 13:08:42 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Liu hua <sdu.liu@huawei.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, msalter@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wang Nan <wangnan0@huawei.com>, peifeiyue@huawei.com,
        wangkefeng.wang@huawei.com, Li Zefan <lizefan@huawei.com>
Subject: Re: [ARM]Fixmap mapping region is not enough for system of 14+
 CPUs.
In-Reply-To: <53204956.30703@huawei.com>
Message-ID: <alpine.LFD.2.11.1403121306280.1217@knanqh.ubzr>
References: <53203F9C.8040500@huawei.com> <53204956.30703@huawei.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, Liu hua wrote:

> Hi Russell, Will or Nicolas,
> 
> (In this mail, we only discuss ARM 32-bit linux.)
> 
> As we know, the region (0xfff00000-0xfffdffff) is reserved as fixmap
> mapping region.
> 
> The function "kmap_atomic" maps highmem pages to this region referring
> to CPUID and per-cpu variable "__kmap_atomic_idx" via
> 
>   idx = type + KM_TYPE_NR * smp_processor_id();
>   vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
> 
> Size of region used by one cpu is 0x10000 (KM_TYPE_NR << PAGE_SHIFT).
> And the total size of the fixmap mapping region is 0xe0000.
> (only support 14 CPUs).
> 
> So in a system of more than 14 CPUs, this region is not large enough.
> should we change the memory layout on ARM Linux to support 14+ cpu system ?
> Or can we do anything else to support that ?

How many CPUs do you have?

What about the following patch?  If this doesn't work for you then more 
intrusive changes will be needed.

diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index 68ea615c2a..254f2df08d 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -14,7 +14,17 @@
  */
 
 #define FIXADDR_START		0xfff00000UL
+
+#if !defined(CONFIG_HAVE_TCM) && !defined(CONFIG_CPU_XSCALE)
+/*
+ * If no TCM nor on on a XScale then enlarge the fixmap area to
+ * accommodate up to 30 CPUs.
+ */
+#define FIXADDR_END		0xffff0000UL
+#else
 #define FIXADDR_END		0xfffe0000UL
+#endif
+
 #define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
 
 enum fixed_addresses {


Nicolas
