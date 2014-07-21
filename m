Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaGUFfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 01:35:50 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11028 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaGUFfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 01:35:48 -0400
From: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "liwanp@linux.vnet.ibm.com" <liwanp@linux.vnet.ibm.com>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        "iamjoonsoo.kim@lge.com" <iamjoonsoo.kim@lge.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "Wulizhen (Pss)" <pss.wulizhen@huawei.com>
Subject: =?utf-8?B?W1BBVENIXSBtbe+8mmJ1Z2ZpeCwgcGZuX3ZhbGlkIHNvbWV0aW1lcyByZXR1?=
 =?utf-8?Q?rn_incorrect_when_memmap_parameter_specified?=
Thread-Topic: =?utf-8?B?W1BBVENIXSBtbe+8mmJ1Z2ZpeCwgcGZuX3ZhbGlkIHNvbWV0aW1lcyByZXR1?=
 =?utf-8?Q?rn_incorrect_when_memmap_parameter_specified?=
Thread-Index: Ac+kpZGxps7obKFKQaieV59FpTtmRg==
Date: Mon, 21 Jul 2014 05:35:31 +0000
Message-ID: <615092B2FD0E7648B6E4B43E029BCFB852D66798@SZXEMA503-MBS.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.19.148]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6L5Zs21027708

In sparse memory mode, I add "memmap = 200M$0x1033800000" into menu.lst,
then I found the information in /proc/iomem is shown as:
.................
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:08
fff00000-ffffffff : reserved
100000000-10337fffff : System RAM
1033800000-103fffffff : reserved
the return value of function pfn_valid, which checks whether pfn 0x1033800 is valid,
is non-zero.Thus, it will thereafter run the function PageReserved(), which returns 0,
I think the return value of 0 is wrong, as that pfn 0x1033800 is actually reserved.
I probed further, and found that: the section [0x1033000000~0x1033AFFFFFF], including
pfn 0x1033800, is initialized during kernel starting up. However, the page sturctures
corresponding to that section are just partially initialzed,
known as [0x1033000000~(max_pfn -1)](max_pfn = 0x1033800). Which means that, pfn 0x1033800
is valid(as function pfn_valid tells), but its related page structures are not initialized,
which results in the problem shown above: pfn 0x1033800 is of type reserved, but the function
PageReserved shows that it's not.

i think in the funtion of pfn_valid should be add a condition: pfn >= max_pfn.

Signed-off-by: Wulizhen <pss.wulizhen@huawei.com>
---
 include/linux/mmzone.h | 2 +-
 mm/nobootmem.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 835aa3d..c54284b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1199,7 +1199,7 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
 static inline int pfn_valid(unsigned long pfn)
 {
- if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
+ if (pfn >= max_pfn || pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
  return 0;
  return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
 }
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 04a9d94..7eb273e 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -31,7 +31,7 @@ EXPORT_SYMBOL(contig_page_data);
 unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
-
+EXPORT_SYMBOL(max_pfn);
 static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
  u64 goal, u64 limit)
 {
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
