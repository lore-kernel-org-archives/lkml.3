Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaLPQ7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:59:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:47194 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbaLPQ7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:59:07 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mitchell Krome <mitchellkrome@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/18] perf symbols: Fix use after free in filename__read_build_id
Date: Tue, 16 Dec 2014 13:57:20 -0300
Message-Id: <1418749040-31807-19-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mitchell Krome <mitchellkrome@gmail.com>

In filename__read_build_id, phdr points to memory in buf, which gets realloced
before a call to fseek that uses phdr->p_offset. This change stores the value
of p_offset before buf is realloced, so the fseek can use the value safely.

Signed-off-by: Mitchell Krome <mitchellkrome@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20141216021612.GA7199@mitchell
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-minimal.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index fa585c63f56a..d7efb03b3f9a 100644
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
1.9.3

