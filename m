Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140AbaEGNfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:35:44 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:61774 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934128AbaEGNfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:35:39 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <linux@arm.linux.org.uk>, <kumagai-atsushi@mxc.nes.nec.co.jp>
CC: <will.deacon@arm.com>, <kexec@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <wangnan0@huawei.com>,
        <peifeiyue@huawei.com>, <sdu.liu@huawei.com>, <liusdu@126.com>
Subject: [RFC PATCH 2/2] makedumpfile: get additional information from vmcore
Date: Wed, 7 May 2014 21:27:14 +0800
Message-ID: <1399469234-54925-3-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399469234-54925-1-git-send-email-sdu.liu@huawei.com>
References: <1399469234-54925-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we define MAX_PHYSMEM_BITS and SECTION_SIZE_BITS as
macros. So if we deal with vmcores with different values
of these two macros. We have to recompile makedumpfile.

This patch makes makedumpfile get these two values from
vmcore info, if existing. It makes the makedumpfile more
compatible to vmcores with different section size.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 makedumpfile.c | 17 +++++++++++++++++
 makedumpfile.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/makedumpfile.c b/makedumpfile.c
index 6cf6e24..3cdf323 100644
--- a/makedumpfile.c
+++ b/makedumpfile.c
@@ -2111,6 +2111,8 @@ read_vmcoreinfo(void)
 	READ_NUMBER("PG_slab", PG_slab);
 	READ_NUMBER("PG_buddy", PG_buddy);
 	READ_NUMBER("PG_hwpoison", PG_hwpoison);
+	READ_NUMBER("SECTION_SIZE_BITS", SECTION_SIZE_BITS);
+	READ_NUMBER("MAX_PHYSMEM_BITS", MAX_PHYSMEM_BITS);
 
 	READ_SRCFILE("pud_t", pud_t);
 
@@ -2998,6 +3000,18 @@ initialize_bitmap_memory(void)
 }
 
 int
+calibrate_machdep_info(void)
+{
+	if (NUMBER(MAX_PHYSMEM_BITS) > 0)
+		info->max_physmem_bits = NUMBER(MAX_PHYSMEM_BITS);
+
+	if (NUMBER(SECTION_SIZE_BITS) > 0)
+		info->section_size_bits = NUMBER(SECTION_SIZE_BITS);
+
+	return TRUE;
+}
+
+int
 initial(void)
 {
 	off_t offset;
@@ -3214,6 +3228,9 @@ out:
 	if (debug_info && !get_machdep_info())
 		return FALSE;
 
+	if (debug_info && !calibrate_machdep_info())
+		return FALSE;
+
 	if (is_xen_memory() && !get_dom0_mapnr())
 		return FALSE;
 
diff --git a/makedumpfile.h b/makedumpfile.h
index eb03688..7acb23a 100644
--- a/makedumpfile.h
+++ b/makedumpfile.h
@@ -1434,6 +1434,8 @@ struct number_table {
 	long    PG_hwpoison;
 
 	long	PAGE_BUDDY_MAPCOUNT_VALUE;
+	long	SECTION_SIZE_BITS;
+	long	MAX_PHYSMEM_BITS;
 };
 
 struct srcfile_table {
-- 
1.9.0

