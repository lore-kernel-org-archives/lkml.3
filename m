Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbaEMHEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:04:11 -0400
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:37223 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaEMHEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:04:09 -0400
X-Greylist: delayed 2321 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2014 03:04:09 EDT
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: "sdu.liu@huawei.com" <sdu.liu@huawei.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "will.deacon@arm.com" <will.deacon@arm.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        "liusdu@126.com" <liusdu@126.com>
Subject: RE: [RFC PATCH 2/2] makedumpfile: get additional information from
 vmcore
Thread-Topic: [RFC PATCH 2/2] makedumpfile: get additional information from
 vmcore
Thread-Index: AQHPafj9zWy25+zH3Ei/KNRE53umlZs+B23w
Date: Tue, 13 May 2014 06:21:12 +0000
Message-ID: <0910DD04CBD6DE4193FCF86B9C00BE97210369@BPXM01GP.gisp.nec.co.jp>
References: <1399469234-54925-1-git-send-email-sdu.liu@huawei.com>
 <1399469234-54925-3-git-send-email-sdu.liu@huawei.com>
In-Reply-To: <1399469234-54925-3-git-send-email-sdu.liu@huawei.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.40.240]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Liu,

>Now we define MAX_PHYSMEM_BITS and SECTION_SIZE_BITS as
>macros. So if we deal with vmcores with different values
>of these two macros. We have to recompile makedumpfile.

There are other macros which have architecture-specific values
(e.g. __PAGE_OFFSET), and some functions are specific to each
architecture (e.g. vaddr_to_paddr()), so we need recompilation
eventually.

OTOH, we already don't need recompilation for the same architecture
since the values of such macros are defined for each kernel version
like below:

#ifdef __x86_64__
...
#define _MAX_PHYSMEM_BITS_ORIG          (40)
#define _MAX_PHYSMEM_BITS_2_6_26        (44)
#define _MAX_PHYSMEM_BITS_2_6_31        (46)

So I don't think this patch is valuable.


Thanks
Atsushi Kumagai

>This patch makes makedumpfile get these two values from
>vmcore info, if existing. It makes the makedumpfile more
>compatible to vmcores with different section size.
>
>Signed-off-by: Liu Hua <sdu.liu@huawei.com>
>---
> makedumpfile.c | 17 +++++++++++++++++
> makedumpfile.h |  2 ++
> 2 files changed, 19 insertions(+)
>
>diff --git a/makedumpfile.c b/makedumpfile.c
>index 6cf6e24..3cdf323 100644
>--- a/makedumpfile.c
>+++ b/makedumpfile.c
>@@ -2111,6 +2111,8 @@ read_vmcoreinfo(void)
> 	READ_NUMBER("PG_slab", PG_slab);
> 	READ_NUMBER("PG_buddy", PG_buddy);
> 	READ_NUMBER("PG_hwpoison", PG_hwpoison);
>+	READ_NUMBER("SECTION_SIZE_BITS", SECTION_SIZE_BITS);
>+	READ_NUMBER("MAX_PHYSMEM_BITS", MAX_PHYSMEM_BITS);
>
> 	READ_SRCFILE("pud_t", pud_t);
>
>@@ -2998,6 +3000,18 @@ initialize_bitmap_memory(void)
> }
>
> int
>+calibrate_machdep_info(void)
>+{
>+	if (NUMBER(MAX_PHYSMEM_BITS) > 0)
>+		info->max_physmem_bits = NUMBER(MAX_PHYSMEM_BITS);
>+
>+	if (NUMBER(SECTION_SIZE_BITS) > 0)
>+		info->section_size_bits = NUMBER(SECTION_SIZE_BITS);
>+
>+	return TRUE;
>+}
>+
>+int
> initial(void)
> {
> 	off_t offset;
>@@ -3214,6 +3228,9 @@ out:
> 	if (debug_info && !get_machdep_info())
> 		return FALSE;
>
>+	if (debug_info && !calibrate_machdep_info())
>+		return FALSE;
>+
> 	if (is_xen_memory() && !get_dom0_mapnr())
> 		return FALSE;
>
>diff --git a/makedumpfile.h b/makedumpfile.h
>index eb03688..7acb23a 100644
>--- a/makedumpfile.h
>+++ b/makedumpfile.h
>@@ -1434,6 +1434,8 @@ struct number_table {
> 	long    PG_hwpoison;
>
> 	long	PAGE_BUDDY_MAPCOUNT_VALUE;
>+	long	SECTION_SIZE_BITS;
>+	long	MAX_PHYSMEM_BITS;
> };
>
> struct srcfile_table {
>--
>1.9.0
