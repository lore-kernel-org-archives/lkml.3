Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbaEFMlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:41:53 -0400
Received: from mx02.posteo.de ([89.146.194.165]:56860 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756361AbaEFMlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:41:51 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: dgnc: fix compile warning frame size is larger than 1024 bytes
Date: Tue,  6 May 2014 14:41:37 +0200
Message-Id: <1399380097-11908-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix following warning by dynamically allocating memory:
dgnc_tty.c:583:1: warning: the frame size of 1060 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
This is more of a question. Is this a desired solution to fixing such a
frame size warning?

thanks,
                martin

 drivers/staging/dgnc/dgnc_tty.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index f0b17c3..1c78cc2 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -481,8 +481,8 @@ void dgnc_sniff_nowait_nolock(struct channel_t *ch, uchar *text, uchar *buf, int
 	int nbuf;
 	int i;
 	int tmpbuflen;
-	char tmpbuf[TMPBUFLEN];
-	char *p = tmpbuf;
+	char *tmpbuf;
+	char *p;
 	int too_much_data;
 
 	/* Leave if sniff not open */
@@ -492,6 +492,13 @@ void dgnc_sniff_nowait_nolock(struct channel_t *ch, uchar *text, uchar *buf, int
 	do_gettimeofday(&tv);
 
 	/* Create our header for data dump */
+	tmpbuf = kmalloc(TMPBUFLEN, GFP_KERNEL);
+	if (!tmpbuf) {
+		pr_err("dgnc: memory allocation error\n");
+		return;
+	}
+	p = tmpbuf;
+
 	p += sprintf(p, "<%ld %ld><%s><", tv.tv_sec, tv.tv_usec, text);
 	tmpbuflen = p - tmpbuf;
 
-- 
1.7.10.4

