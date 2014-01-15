Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaAOUdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:33:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48488 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaAOUdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:33:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/13] tools lib traceevent: fix pointer-integer size mismatch
Date: Wed, 15 Jan 2014 17:33:11 -0300
Message-Id: <1389817991-8145-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389817991-8145-1-git-send-email-acme@infradead.org>
References: <1389817991-8145-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

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
index dcab8e873c21..57e98221db20 100644
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
index 6fb8e3e3fcad..7ef16cc96562 100644
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
 
-- 
1.8.1.4

