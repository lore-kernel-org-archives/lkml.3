Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbaKUMv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:51:26 -0500
Received: from mout.web.de ([212.227.17.12]:53159 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbaKUMvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:51:24 -0500
Message-ID: <546F353A.9060301@users.sourceforge.net>
Date: Fri, 21 Nov 2014 13:51:06 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] tty: Deletion of unnecessary checks before two function
 calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:9lfZnGGw6TxtSQ6P/pNDKnajsPUGintRdkjOILHEnAiYT4wOUBb
 vbqr4LzltqxGF5gTp9rMFqrP2xI5PZo5ax0smY4qtxALSuJdjDXeU0wFmvlWynUBKmcWhBF
 DWTmHcBo2rerhe6fhK950dQjorDPthm3m9r/AnbWd/vipHk41UDyJppu0jrLQFpwscGRpjk
 pN7Bq/dHpbGey2cTud0pA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Nov 2014 13:42:29 +0100

The functions put_device() and tty_kref_put() test whether their argument
is NULL and then return immediately.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/tty/tty_io.c   | 6 ++----
 drivers/tty/tty_port.c | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 848c17a..3302789 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -169,8 +169,7 @@ void free_tty_struct(struct tty_struct *tty)
 {
 	if (!tty)
 		return;
-	if (tty->dev)
-		put_device(tty->dev);
+	put_device(tty->dev);
 	kfree(tty->write_buf);
 	tty->magic = 0xDEADDEAD;
 	kfree(tty);
@@ -1612,8 +1611,7 @@ static void release_tty(struct tty_struct *tty, int idx)
 		tty->link->port->itty = NULL;
 	cancel_work_sync(&tty->port->buf.work);
 
-	if (tty->link)
-		tty_kref_put(tty->link);
+	tty_kref_put(tty->link);
 	tty_kref_put(tty);
 }
 
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 1b93357..856c064 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -193,8 +193,7 @@ void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty)
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	if (port->tty)
-		tty_kref_put(port->tty);
+	tty_kref_put(port->tty);
 	port->tty = tty_kref_get(tty);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
-- 
2.1.3

