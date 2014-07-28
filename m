Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaG1IQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:16:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:31789 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaG1IQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:16:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,747,1400050800"; 
   d="scan'208";a="576410268"
Message-ID: <53D6067C.4000702@intel.com>
Date: Mon, 28 Jul 2014 16:14:52 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, mnipxh <mnipxh@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tty/n_gsm.c: fix a memory leak in gsmld_open
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gsmld_attach_gsm fails, the gsm is not used anymore.
tty core will not call gsmld_close to do the cleanup work.
tty core just restore to the tty old ldisc.
That always causes memory leak.

Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
Reported-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_gsm.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 81e7ccb..6cb1a6d 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2368,6 +2368,7 @@ static void gsmld_close(struct tty_struct *tty)
 static int gsmld_open(struct tty_struct *tty)
 {
 	struct gsm_mux *gsm;
+	int ret;
 
 	if (tty->ops->write == NULL)
 		return -EINVAL;
@@ -2382,7 +2383,13 @@ static int gsmld_open(struct tty_struct *tty)
 
 	/* Attach the initial passive connection */
 	gsm->encoding = 1;
-	return gsmld_attach_gsm(tty, gsm);
+
+	ret = gsmld_attach_gsm(tty, gsm);
+	if (ret != 0) {
+		gsm_cleanup_mux(gsm);
+		mux_put(gsm);
+	}
+	return ret;
 }
 
 /**
-- 
1.7.9.5
