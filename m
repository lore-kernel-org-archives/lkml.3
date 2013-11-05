Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3KEKHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 05:07:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:29051 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3KEKHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 05:07:10 -0500
X-IronPort-AV: E=Sophos;i="4.93,638,1378828800"; 
   d="scan'208";a="8951778"
Message-ID: <5278C1DC.9000609@cn.fujitsu.com>
Date: Tue, 05 Nov 2013 18:01:00 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jfrederich@gmail.com, dsd@laptop.org, jon.nettleton@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH 2/2] staging/olpc_docn: reorder the lock sequence to
 avoid potential dead lock
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/05 18:05:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/05 18:05:17,
	Serialize complete at 2013/11/05 18:05:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock sequence of dcon_blank_fb(fb_info->lock ---> console_lock) is against
with the one of console_callback(console_lock ---> fb_info->lock), it'll
lead to a potential dead lock, so reorder the lock sequence of dcon_blank_fb
to avoid the potential dead lock.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 198595e..9db88d9 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -255,17 +255,19 @@ static bool dcon_blank_fb(struct dcon_priv *dcon, bool blank)
 {
 	int err;
 
+	console_lock();
 	if (!lock_fb_info(dcon->fbinfo)) {
+		console_unlock();
 		dev_err(&dcon->client->dev, "unable to lock framebuffer\n");
 		return false;
 	}
-	console_lock();
+
 	dcon->ignore_fb_events = true;
 	err = fb_blank(dcon->fbinfo,
 			blank ? FB_BLANK_POWERDOWN : FB_BLANK_UNBLANK);
 	dcon->ignore_fb_events = false;
-	console_unlock();
 	unlock_fb_info(dcon->fbinfo);
+	console_unlock();
 
 	if (err) {
 		dev_err(&dcon->client->dev, "couldn't %sblank framebuffer\n",
-- 
1.7.7

