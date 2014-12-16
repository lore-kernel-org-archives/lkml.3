Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbaLPCQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:16:20 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56897 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaLPCQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:16:19 -0500
Date: Tue, 16 Dec 2014 12:16:12 +1000
From: Mitchell Krome <mitchellkrome@gmail.com>
To: acme@kernel.org
Cc: mingo@redhat.com, paulus@samba.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] perf tool: Fix use after free in filename__read_build_id
Message-ID: <20141216021612.GA7199@mitchell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In filename__read_build_id, phdr points to memory in buf, which gets realloced
before a call to fseek that uses phdr->p_offset. This change stores the value
of p_offset before buf is realloced, so the fseek can use the value safely.

Signed-off-by: Mitchell Krome <mitchellkrome@gmail.com>
---
 tools/perf/util/symbol-minimal.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index fa585c6..d7efb03 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -129,6 +129,7 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 
 		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
 			void *tmp;
+			long offset;
 
 			if (need_swap) {
 				phdr->p_type = bswap_32(phdr->p_type);
@@ -140,12 +141,13 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 				continue;
 
 			buf_size = phdr->p_filesz;
+			offset = phdr->p_offset;
 			tmp = realloc(buf, buf_size);
 			if (tmp == NULL)
 				goto out_free;
 
 			buf = tmp;
-			fseek(fp, phdr->p_offset, SEEK_SET);
+			fseek(fp, offset, SEEK_SET);
 			if (fread(buf, buf_size, 1, fp) != 1)
 				goto out_free;
 
@@ -178,6 +180,7 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 
 		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
 			void *tmp;
+			long offset;
 
 			if (need_swap) {
 				phdr->p_type = bswap_32(phdr->p_type);
@@ -189,12 +192,13 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 				continue;
 
 			buf_size = phdr->p_filesz;
+			offset = phdr->p_offset;
 			tmp = realloc(buf, buf_size);
 			if (tmp == NULL)
 				goto out_free;
 
 			buf = tmp;
-			fseek(fp, phdr->p_offset, SEEK_SET);
+			fseek(fp, offset, SEEK_SET);
 			if (fread(buf, buf_size, 1, fp) != 1)
 				goto out_free;
 
-- 
1.9.1

