Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaAOKok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:44:40 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58724 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbaAOKoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:44:37 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 2/3] tools lib traceevent: fix pointer-integer size mismatch
Date: Wed, 15 Jan 2014 10:44:07 +0000
Message-Id: <1389782648-4417-3-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1389782648-4417-1-git-send-email-mark.rutland@arm.com>
References: <1389782648-4417-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>
---
 tools/lib/traceevent/plugin_cfg80211.c | 2 +-
 tools/lib/traceevent/plugin_scsi.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

I'm not sure about this one as I'm not certain I read all the sites
input values for args could be generated. I'd appreciate if someone more
familiar with traceevent plugins could verify this makes sense.

Mark.

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
 
-- 
1.8.1.1

