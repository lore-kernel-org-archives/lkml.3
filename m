Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbaDIKpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:45:55 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36950 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340AbaDIKpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:45:53 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, sachin.kamat@linaro.org, grygorii.strashko@ti.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: speakup: fix misuse of kstrtol() in handle_goto()
Date: Wed, 09 Apr 2014 19:45:46 +0900
Message-ID: <2039876.xlVvlD6iFL@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A string of goto_buf has a number followed by x or y.
e.g. "3x" means move 3 lines down.
The kstrtol() returns an error(-EINVAL) with this string so
go_pos has unsigned a value of that error.
And also "*cp" has not expected value.

And fix sparse warnings:
 drivers/staging/speakup/main.c:1901 handle_goto() warn:
unsigned '(speakup_console[vc->vc_num]->go_pos)' is never less than zero.
 drivers/staging/speakup/main.c:1911 handle_goto() warn:
unsigned '(speakup_console[vc->vc_num]->go_pos)' is never less than zero.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/speakup/main.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index ef5933b..3b6e535 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -1855,8 +1855,9 @@ static int handle_goto(struct vc_data *vc, u_char type, u_char ch, u_short key)
 {
 	static u_char goto_buf[8];
 	static int num;
-	int maxlen, go_pos;
+	int maxlen;
 	char *cp;
+
 	if (type == KT_SPKUP && ch == SPEAKUP_GOTO)
 		goto do_goto;
 	if (type == KT_LATIN && ch == '\n')
@@ -1891,25 +1892,24 @@ oops:
 		spk_special_handler = NULL;
 		return 1;
 	}
-	go_pos = kstrtol(goto_buf, 10, (long *)&cp);
-	goto_pos = (u_long) go_pos;
+
+	goto_pos = simple_strtoul(goto_buf, &cp, 10);
+
 	if (*cp == 'x') {
 		if (*goto_buf < '0')
 			goto_pos += spk_x;
-		else
+		else if (goto_pos > 0)
 			goto_pos--;
-		if (goto_pos < 0)
-			goto_pos = 0;
+
 		if (goto_pos >= vc->vc_cols)
 			goto_pos = vc->vc_cols - 1;
 		goto_x = 1;
 	} else {
 		if (*goto_buf < '0')
 			goto_pos += spk_y;
-		else
+		else if (goto_pos > 0)
 			goto_pos--;
-		if (goto_pos < 0)
-			goto_pos = 0;
+
 		if (goto_pos >= vc->vc_rows)
 			goto_pos = vc->vc_rows - 1;
 		goto_x = 0;
-- 
1.7.4.4


