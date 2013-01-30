Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3A3Ov5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:51:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57835 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab3A3OrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/21] perf header: Fix double fclose() on do_write(fd, xxx) failure
Date: Wed, 30 Jan 2013 11:47:02 -0300
Message-Id: <1359557222-17547-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

cppcheck reported:
[util/header.c:983]: (error) Used file that is not opened.

Thanks to Arnaldo Carvalho de Melo for pointing out that
fclose(NULL) is undefined behavior -> protect against it.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Link: http://lkml.kernel.org/r/1751778.SZQB4fNdIh@storm
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7b24cf3..f6081cb3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -955,6 +955,7 @@ static int write_topo_node(int fd, int node)
 	}
 
 	fclose(fp);
+	fp = NULL;
 
 	ret = do_write(fd, &mem_total, sizeof(u64));
 	if (ret)
@@ -981,7 +982,8 @@ static int write_topo_node(int fd, int node)
 	ret = do_write_string(fd, buf);
 done:
 	free(buf);
-	fclose(fp);
+	if (fp)
+		fclose(fp);
 	return ret;
 }
 
-- 
1.8.1.1.361.gec3ae6e

