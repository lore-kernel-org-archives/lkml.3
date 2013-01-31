Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab3AaLFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:05:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36383 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab3AaLFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:05:16 -0500
Date: Thu, 31 Jan 2013 03:04:58 -0800
From: tip-bot for Thomas Jarosch <thomas.jarosch@intra2net.com>
Message-ID: <tip-5809fde040de2afa477a6c593ce2e8fd2c11d9d3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, thomas.jarosch@intra2net.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, thomas.jarosch@intra2net.com, tglx@linutronix.de
In-Reply-To: <1751778.SZQB4fNdIh@storm>
References: <1751778.SZQB4fNdIh@storm>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Fix double fclose() on do_write(fd,
  xxx) failure
Git-Commit-ID: 5809fde040de2afa477a6c593ce2e8fd2c11d9d3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 03:05:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5809fde040de2afa477a6c593ce2e8fd2c11d9d3
Gitweb:     http://git.kernel.org/tip/5809fde040de2afa477a6c593ce2e8fd2c11d9d3
Author:     Thomas Jarosch <thomas.jarosch@intra2net.com>
AuthorDate: Mon, 28 Jan 2013 10:21:14 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:40:44 -0300

perf header: Fix double fclose() on do_write(fd, xxx) failure

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
 
