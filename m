Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaHRIW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:22:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51494 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaHRIWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:22:25 -0400
Date: Mon, 18 Aug 2014 01:21:51 -0700
From: tip-bot for Alex Converse <tipbot@zytor.com>
Message-ID: <tip-1e2bb043f171084e5f34816a4268304512d35a46@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        aconverse@google.com, adrian.hunter@intel.com, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, aconverse@google.com, jolsa@redhat.com,
        ak@linux.intel.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1408050180-14088-1-git-send-email-aconverse@google.com>
References: <1408050180-14088-1-git-send-email-aconverse@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Don'
 t truncate Intel style addresses
Git-Commit-ID: 1e2bb043f171084e5f34816a4268304512d35a46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e2bb043f171084e5f34816a4268304512d35a46
Gitweb:     http://git.kernel.org/tip/1e2bb043f171084e5f34816a4268304512d35a46
Author:     Alex Converse <aconverse@google.com>
AuthorDate: Thu, 14 Aug 2014 14:03:00 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 10:39:26 -0300

perf annotate: Don't truncate Intel style addresses

Instructions like "mov r9,QWORD PTR [rdx+0x8]" were being truncated to
"mov r9,QWORD" by code that assuemd operands cannot have spaces.

Signed-off-by: Alex Converse <aconverse@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1408050180-14088-1-git-send-email-aconverse@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7745fec..3643752 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -232,9 +232,16 @@ static int mov__parse(struct ins_operands *ops)
 		return -1;
 
 	target = ++s;
+	comment = strchr(s, '#');
 
-	while (s[0] != '\0' && !isspace(s[0]))
-		++s;
+	if (comment != NULL)
+		s = comment - 1;
+	else
+		s = strchr(s, '\0') - 1;
+
+	while (s > target && isspace(s[0]))
+		--s;
+	s++;
 	prev = *s;
 	*s = '\0';
 
@@ -244,7 +251,6 @@ static int mov__parse(struct ins_operands *ops)
 	if (ops->target.raw == NULL)
 		goto out_free_source;
 
-	comment = strchr(s, '#');
 	if (comment == NULL)
 		return 0;
 
