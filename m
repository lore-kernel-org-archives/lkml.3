Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaAPNjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:39:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38352 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaAPNj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:39:27 -0500
Date: Thu, 16 Jan 2014 05:39:03 -0800
From: tip-bot for Mark Rutland <tipbot@zytor.com>
Message-ID: <tip-0e9e79a13ab9d56b86db6538305babc23b1445cc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, mingo@kernel.org, will.deacon@arm.com,
        mark.rutland@arm.com, jolsa@redhat.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, will.deacon@arm.com,
        mark.rutland@arm.com, jolsa@redhat.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1389782648-4417-3-git-send-email-mark.rutland@arm.com>
References: <1389782648-4417-3-git-send-email-mark.rutland@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  fix pointer-integer size mismatch
Git-Commit-ID: 0e9e79a13ab9d56b86db6538305babc23b1445cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:39:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e9e79a13ab9d56b86db6538305babc23b1445cc
Gitweb:     http://git.kernel.org/tip/0e9e79a13ab9d56b86db6538305babc23b1445cc
Author:     Mark Rutland <mark.rutland@arm.com>
AuthorDate: Wed, 15 Jan 2014 10:44:07 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Jan 2014 17:04:38 -0300

tools lib traceevent: fix pointer-integer size mismatch

The scsi and cfg80211 plugins cast between unsigned long long and
pointers, which is problematic for architectures where unsigned long
long is wider than the native pointer size:

  linux/tools/lib/traceevent/plugin_scsi.c: In function ‘process_scsi_trace_parse_cdb’:
  linux/tools/lib/traceevent/plugin_scsi.c:408:26: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    scsi_trace_parse_cdb(s, (unsigned char *) args[1], args[2]);

  linux/tools/lib/traceevent/plugin_cfg80211.c: In function ‘process___le16_to_cpup’:
  linux/tools/lib/traceevent/plugin_cfg80211.c:11:18: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    uint16_t *val = (uint16_t *) args[0];

This patch adds an intermediate cast to unsigned long, silencing the
warning.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Link: http://lkml.kernel.org/r/1389782648-4417-3-git-send-email-mark.rutland@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/plugin_cfg80211.c | 2 +-
 tools/lib/traceevent/plugin_scsi.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/plugin_cfg80211.c b/tools/lib/traceevent/plugin_cfg80211.c
index dcab8e8..57e9822 100644
--- a/tools/lib/traceevent/plugin_cfg80211.c
+++ b/tools/lib/traceevent/plugin_cfg80211.c
@@ -8,7 +8,7 @@ static unsigned long long
 process___le16_to_cpup(struct trace_seq *s,
 		       unsigned long long *args)
 {
-	uint16_t *val = (uint16_t *) args[0];
+	uint16_t *val = (uint16_t *) (unsigned long) args[0];
 	return val ? (long long) le16toh(*val) : 0;
 }
 
diff --git a/tools/lib/traceevent/plugin_scsi.c b/tools/lib/traceevent/plugin_scsi.c
index 6fb8e3e..7ef16cc 100644
--- a/tools/lib/traceevent/plugin_scsi.c
+++ b/tools/lib/traceevent/plugin_scsi.c
@@ -405,7 +405,7 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 unsigned long long process_scsi_trace_parse_cdb(struct trace_seq *s,
 						unsigned long long *args)
 {
-	scsi_trace_parse_cdb(s, (unsigned char *) args[1], args[2]);
+	scsi_trace_parse_cdb(s, (unsigned char *) (unsigned long) args[1], args[2]);
 	return 0;
 }
 
