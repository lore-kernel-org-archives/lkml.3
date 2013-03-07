Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab3CGMMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:12:51 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49725 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/16] TTY: msm_smd_tty, clean up activate/shutdown
Date: Thu,  7 Mar 2013 13:12:28 +0100
Message-Id: <1362658360-26629-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not dig struct smd_tty_info out of tty_struct using
tty_port_tty_get. It is unnecessarily too complicated, use simple
container_of instead.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/msm_smd_tty.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/msm_smd_tty.c b/drivers/tty/serial/msm_smd_tty.c
index e722ff1..1238ac3 100644
--- a/drivers/tty/serial/msm_smd_tty.c
+++ b/drivers/tty/serial/msm_smd_tty.c
@@ -90,13 +90,13 @@ static void smd_tty_notify(void *priv, unsigned event)
 
 static int smd_tty_port_activate(struct tty_port *tport, struct tty_struct *tty)
 {
+	struct smd_tty_info *info = container_of(tport, struct smd_tty_info,
+			port);
 	int i, res = 0;
-	int n = tty->index;
 	const char *name = NULL;
-	struct smd_tty_info *info = smd_tty + n;
 
 	for (i = 0; i < smd_tty_channels_len; i++) {
-		if (smd_tty_channels[i].id == n) {
+		if (smd_tty_channels[i].id == tty->index) {
 			name = smd_tty_channels[i].name;
 			break;
 		}
@@ -117,17 +117,13 @@ static int smd_tty_port_activate(struct tty_port *tport, struct tty_struct *tty)
 
 static void smd_tty_port_shutdown(struct tty_port *tport)
 {
-	struct smd_tty_info *info;
-	struct tty_struct *tty = tty_port_tty_get(tport);
+	struct smd_tty_info *info = container_of(tport, struct smd_tty_info,
+			port);
 
-	info = tty->driver_data;
 	if (info->ch) {
 		smd_close(info->ch);
 		info->ch = 0;
 	}
-
-	tty->driver_data = 0;
-	tty_kref_put(tty);
 }
 
 static int smd_tty_open(struct tty_struct *tty, struct file *f)
-- 
1.8.1.4


