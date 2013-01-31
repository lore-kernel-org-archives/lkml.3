Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3AaLC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:02:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36342 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3AaLCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:02:55 -0500
Date: Thu, 31 Jan 2013 03:02:38 -0800
From: tip-bot for Thomas Jarosch <thomas.jarosch@intra2net.com>
Message-ID: <tip-0b9e01a4f0d1c8277da6824fe060ccb0434d2fde@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, thomas.jarosch@intra2net.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, thomas.jarosch@intra2net.com, tglx@linutronix.de
In-Reply-To: <2717013.8dV0naNhAV@storm>
References: <2717013.8dV0naNhAV@storm>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix memory leak on error
Git-Commit-ID: 0b9e01a4f0d1c8277da6824fe060ccb0434d2fde
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 03:02:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b9e01a4f0d1c8277da6824fe060ccb0434d2fde
Gitweb:     http://git.kernel.org/tip/0b9e01a4f0d1c8277da6824fe060ccb0434d2fde
Author:     Thomas Jarosch <thomas.jarosch@intra2net.com>
AuthorDate: Fri, 25 Jan 2013 11:20:47 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:40:05 -0300

perf tools: Fix memory leak on error

cppcheck reported:
[util/event.c:480]: (error) Memory leak: event

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Link: http://lkml.kernel.org/r/2717013.8dV0naNhAV@storm
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3cf2c3e..5cd13d7 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -476,8 +476,10 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 		}
 	}
 
-	if (kallsyms__parse(filename, &args, find_symbol_cb) <= 0)
+	if (kallsyms__parse(filename, &args, find_symbol_cb) <= 0) {
+		free(event);
 		return -ENOENT;
+	}
 
 	map = machine->vmlinux_maps[MAP__FUNCTION];
 	size = snprintf(event->mmap.filename, sizeof(event->mmap.filename),
