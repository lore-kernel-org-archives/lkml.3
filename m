Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaLIRfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:35:00 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55141 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaLIRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:34:58 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [RFC PATCH 3/8] perf probe: Improve detection of file/function name in the probe pattern
Date: Tue,  9 Dec 2014 23:04:01 +0530
Message-Id: <de6c0cd8236de1cabc179e456514c2a399cbc7b5.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120917-0029-0000-0000-000000C7B558
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, perf probe considers patterns including a '.' to be a file.
However, this causes problems on powerpc ABIv1 where all functions have
a leading '.':

  $ perf probe -F | grep schedule_timeout_interruptible
  .schedule_timeout_interruptible
  $ perf probe .schedule_timeout_interruptible
  Semantic error :File always requires line number or lazy pattern.
    Error: Command Parse Error.

Fix this by checking the probe pattern in more detail.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 tools/perf/util/probe-event.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index c150ca4..c7e01ef 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -999,6 +999,24 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 		arg = tmp;
 	}
 
+	/*
+	 * Check arg is function or file name and copy it.
+	 *
+	 * We consider arg to be a file spec if and only if it satisfies
+	 * all of the below criteria::
+	 * - it does not include any of "+@%",
+	 * - it includes one of ":;", and
+	 * - it has a period '.' in the name.
+	 *
+	 * Otherwise, we consider arg to be a function specification.
+	 */
+	c = 0;
+	if (!strpbrk(arg, "+@%") && (ptr = strpbrk(arg, ";:")) != NULL) {
+		/* This is a file spec if it includes a '.' before ; or : */
+		if (memchr(arg, '.', ptr-arg))
+			c = 1;
+	}
+
 	ptr = strpbrk(arg, ";:+@%");
 	if (ptr) {
 		nc = *ptr;
@@ -1009,10 +1027,9 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 	if (tmp == NULL)
 		return -ENOMEM;
 
-	/* Check arg is function or file and copy it */
-	if (strchr(tmp, '.'))	/* File */
+	if (c == 1)
 		pp->file = tmp;
-	else			/* Function */
+	else
 		pp->function = tmp;
 
 	/* Parse other options */
-- 
2.1.3

