Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3A1JVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:21:30 -0500
Received: from re04.intra2net.com ([82.165.46.26]:35425 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3A1JVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:21:18 -0500
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: [perf PATCH v2] Fix double fclose() on do_write(fd, xxx) failure
Date: Mon, 28 Jan 2013 10:21:14 +0100
Message-ID: <1751778.SZQB4fNdIh@storm>
User-Agent: KMail/4.9.5 (Linux/3.6.11-5.fc17.x86_64; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck reported:
[util/header.c:983]: (error) Used file that is not opened.

Thanks to Arnaldo Carvalho de Melo for pointing out that
fclose(NULL) is undefined behavior -> protect against it.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 tools/perf/util/header.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7b24cf3..f6081cb 100644
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
1.7.11.7

