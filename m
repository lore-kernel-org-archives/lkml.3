Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbbACLOh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 06:14:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbbACLOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 06:14:35 -0500
From: Daniel Borkmann <dborkman@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joe Mario <jmario@redhat.com>
Subject: [PATCH akpm/next v2] lib: crc32: constify crc32 lookup table
Date: Sat,  3 Jan 2015 12:14:32 +0100
Message-Id: <1420283672-17902-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8f243af42ade ("sections: fix const sections for crc32 table")
removed the compile-time generated crc32 tables from the RO sections,
because it conflicts with the definition of __cacheline_aligned
which puts all such aligned data into .data..cacheline_aligned section
optimized for wasting less space, and can cause alignment issues when
used in combination with const with some gcc versions like 4.7.0 due
to a gcc bug [1].

Given that most gcc versions should have the fix by now, we can just
use ____cacheline_aligned, which only aligns the data but doesn't move
it into specific sections as opposed to __cacheline_aligned. In case
of gcc versions having the mentioned bug, the alignment attribute will
have no effect, but the data will still be made RO.

After patch tables are in RO:

$ nm -v lib/crc32.o | grep -1 -E "crc32c?table"
0000000000000000 t arch_local_irq_enable
0000000000000000 r crc32ctable_le
0000000000000000 t crc32_exit
--
0000000000000960 t test_buf
0000000000002000 r crc32table_be
0000000000004000 r crc32table_le
000000001d1056e5 A __crc_crc32_be

  [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=52181

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
---
 v1 -> v2:
  - Removed gcc test case.

 lib/gen_crc32table.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
index 71fcfcd..d83a372 100644
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -109,7 +109,7 @@ int main(int argc, char** argv)
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static u32 __cacheline_aligned "
+		printf("static const u32 ____cacheline_aligned "
 		       "crc32table_le[%d][%d] = {",
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32table_le, LE_TABLE_ROWS,
@@ -119,7 +119,7 @@ int main(int argc, char** argv)
 
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static u32 __cacheline_aligned "
+		printf("static const u32 ____cacheline_aligned "
 		       "crc32table_be[%d][%d] = {",
 		       BE_TABLE_ROWS, BE_TABLE_SIZE);
 		output_table(crc32table_be, LE_TABLE_ROWS,
@@ -128,7 +128,7 @@ int main(int argc, char** argv)
 	}
 	if (CRC_LE_BITS > 1) {
 		crc32cinit_le();
-		printf("static u32 __cacheline_aligned "
+		printf("static const u32 ____cacheline_aligned "
 		       "crc32ctable_le[%d][%d] = {",
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32ctable_le, LE_TABLE_ROWS,
-- 
1.7.11.7

