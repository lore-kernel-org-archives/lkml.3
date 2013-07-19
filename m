Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030333Ab3GSHzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:55:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35992 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030254Ab3GSHzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:55:03 -0400
Date: Fri, 19 Jul 2013 00:54:41 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-8d541e974f4b3ed5db7e278b4d64481af34910a9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1374083403-14591-5-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header:
  Introduce feat_offset into perf_header
Git-Commit-ID: 8d541e974f4b3ed5db7e278b4d64481af34910a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:54:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d541e974f4b3ed5db7e278b4d64481af34910a9
Gitweb:     http://git.kernel.org/tip/8d541e974f4b3ed5db7e278b4d64481af34910a9
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 17 Jul 2013 19:49:44 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Jul 2013 16:46:32 -0300

perf header: Introduce feat_offset into perf_header

Introducing feat_offset into perf_header to make the location of the
features section clear.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374083403-14591-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 6 ++++--
 tools/perf/util/header.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index dcba56a..eefb052 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2225,7 +2225,7 @@ static int perf_header__adds_write(struct perf_header *header,
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
-	sec_start = header->data_offset + header->data_size;
+	sec_start = header->feat_offset;
 	lseek(fd, sec_start + sec_size, SEEK_SET);
 
 	for_each_set_bit(feat, header->adds_features, HEADER_FEAT_BITS) {
@@ -2304,6 +2304,7 @@ int perf_session__write_header(struct perf_session *session,
 	}
 
 	header->data_offset = lseek(fd, 0, SEEK_CUR);
+	header->feat_offset = header->data_offset + header->data_size;
 
 	if (at_exit) {
 		err = perf_header__adds_write(header, evlist, fd);
@@ -2373,7 +2374,7 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
-	lseek(fd, header->data_offset + header->data_size, SEEK_SET);
+	lseek(fd, header->feat_offset, SEEK_SET);
 
 	err = perf_header__getbuffer64(header, fd, feat_sec, sec_size);
 	if (err < 0)
@@ -2572,6 +2573,7 @@ int perf_file_header__read(struct perf_file_header *header,
 
 	ph->data_offset  = header->data.offset;
 	ph->data_size	 = header->data.size;
+	ph->feat_offset  = header->data.offset + header->data.size;
 	return 0;
 }
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 6fa80f9..e6387dc 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -88,6 +88,7 @@ struct perf_header {
 	bool			needs_swap;
 	u64			data_offset;
 	u64			data_size;
+	u64			feat_offset;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 	struct perf_session_env env;
 };
