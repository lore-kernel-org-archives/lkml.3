Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbaC0ILG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:11:06 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:28449 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaC0ILE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:11:04 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <linux@arm.linux.org.uk>, <horms@verge.net.au>
CC: <linux-arm-kernel@lists.infradead.org>, <kexec@lists.infradead.org>,
        "Liu Hua" <sdu.liu@huawei.com>, Vivek Goyal <vgoyal@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] kexec : ARM : add LPAE support
Date: Thu, 27 Mar 2014 16:00:40 +0800
Message-ID: <1395907240-13308-4-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395907240-13308-1-git-send-email-sdu.liu@huawei.com>
References: <1395907240-13308-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 32-bit ARM systems with CONFIG_ARM_LPAE=y, when kexec utility
loads the crash kernel. 32-bit elf header is not enough if the
physical address exceeds 4G.

This patch check whether the largest physical address of the system
exceeds 4G. If so, kexec creates 64-bit elf header.Otherwise it
creates 32-bit elf header.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
To: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <kexec@lists.infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>
---
 kexec/arch/arm/crashdump-arm.c | 23 ++++++++++++++++++++---
 kexec/kexec-iomem.c            |  8 ++++----
 kexec/kexec.h                  |  4 ++--
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/kexec/arch/arm/crashdump-arm.c b/kexec/arch/arm/crashdump-arm.c
index 0cd6935..d1133cd 100644
--- a/kexec/arch/arm/crashdump-arm.c
+++ b/kexec/arch/arm/crashdump-arm.c
@@ -20,6 +20,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
+#include <limits.h>
 #include <elf.h>
 #include <errno.h>
 #include <stdio.h>
@@ -75,8 +76,8 @@ unsigned long phys_offset;
  * regions is placed in @crash_memory_nr_ranges.
  */
 static int crash_range_callback(void *UNUSED(data), int UNUSED(nr),
-				char *str, unsigned long base,
-				unsigned long length)
+				char *str, unsigned long long base,
+				unsigned long long length)
 {
 	struct memory_range *range;
 
@@ -276,6 +277,7 @@ int load_crashdump_segments(struct kexec_info *info, char *mod_cmdline)
 	unsigned long bufsz;
 	void *buf;
 	int err;
+	int last_ranges;
 
 	/*
 	 * First fetch all the memory (RAM) ranges that we are going to pass to
@@ -292,10 +294,25 @@ int load_crashdump_segments(struct kexec_info *info, char *mod_cmdline)
 	phys_offset = usablemem_rgns.ranges->start;
 	dbgprintf("phys_offset: %#lx\n", phys_offset);
 
-	err = crash_create_elf32_headers(info, &elf_info,
+	last_ranges = usablemem_rgns.size - 1;
+	if (last_ranges < 0)
+		last_ranges = 0;
+
+	if (crash_memory_ranges[last_ranges].end > ULONG_MAX) {
+
+		/* for support arm LPAE and arm64 */
+		elf_info.class = ELFCLASS64;
+
+		err = crash_create_elf64_headers(info, &elf_info,
 					 usablemem_rgns.ranges,
 					 usablemem_rgns.size, &buf, &bufsz,
 					 ELF_CORE_HEADER_ALIGN);
+	} else {
+		err = crash_create_elf32_headers(info, &elf_info,
+					 usablemem_rgns.ranges,
+					 usablemem_rgns.size, &buf, &bufsz,
+					 ELF_CORE_HEADER_ALIGN);
+	}
 	if (err)
 		return err;
 
diff --git a/kexec/kexec-iomem.c b/kexec/kexec-iomem.c
index 0396713..485a2e8 100644
--- a/kexec/kexec-iomem.c
+++ b/kexec/kexec-iomem.c
@@ -26,8 +26,8 @@ int kexec_iomem_for_each_line(char *match,
 			      int (*callback)(void *data,
 					      int nr,
 					      char *str,
-					      unsigned long base,
-					      unsigned long length),
+					      unsigned long long base,
+					      unsigned long long length),
 			      void *data)
 {
 	const char *iomem = proc_iomem();
@@ -65,8 +65,8 @@ int kexec_iomem_for_each_line(char *match,
 
 static int kexec_iomem_single_callback(void *data, int nr,
 				       char *UNUSED(str),
-				       unsigned long base,
-				       unsigned long length)
+				       unsigned long long base,
+				       unsigned long long length)
 {
 	struct memory_range *range = data;
 
diff --git a/kexec/kexec.h b/kexec/kexec.h
index 2bd6e96..ecc4681 100644
--- a/kexec/kexec.h
+++ b/kexec/kexec.h
@@ -279,8 +279,8 @@ int kexec_iomem_for_each_line(char *match,
 			      int (*callback)(void *data,
 					      int nr,
 					      char *str,
-					      unsigned long base,
-					      unsigned long length),
+					      unsigned long long base,
+					      unsigned long long length),
 			      void *data);
 int parse_iomem_single(char *str, uint64_t *start, uint64_t *end);
 const char * proc_iomem(void);
-- 
1.9.0

