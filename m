Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3JFTNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 15:13:45 -0400
Received: from mout.gmx.net ([212.227.17.22]:64099 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab3JFTNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 15:13:43 -0400
From: Hans-Frieder Vogt <hfvogt@gmx.net>
To: zbr@ioremap.net, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] w1 - call request_module with w1 master mutex unlocked
Date: Sun, 06 Oct 2013 21:13:40 +0200
Message-ID: <2740843.j7PY66riEd@maximilian>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc2-a64; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:DU2G9V3rtW7sextJlSDojv/+4xuGMbf78aZ4DomhDPzFLE+D/m3
 k/YXx04SYI2ewirivW8x70xF/0fk9kl/G65P47eIIqvcPcIoEgdVC1BmOYgaBCxJx71wb1l
 F1JSG88QKtpLw95K/eAxxHv7Mp6YkvsohfLPbr6Yk0btVq6CXKOXovhieEWcO/rAaAWlXK9
 amac2npEEzFAofyXjh1lA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_module for w1 slave modules needs to be called with the w1 master 
mutex
unlocked. Because w1_attach_slave_device gets always(?) called with mutex
locked, we need to temporarily unlock the w1 master mutex for the loading of 
the
w1 slave module.

Signed-off by: Hans-Frieder Vogt <hfvogt@gmx.net>
---
 drivers/w1/w1.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/w1/w1.c	2013-10-06 14:58:45.246528318 +0200
+++ b/drivers/w1/w1.c	2013-10-06 19:13:04.115279322 +0200
@@ -716,7 +716,10 @@ static int w1_attach_slave_device(struct
 	atomic_set(&sl->refcnt, 0);
 	init_completion(&sl->released);
 
+	/* slave modules need to be loaded in a context with unlocked mutex */
+	mutex_unlock(&dev->mutex);
 	request_module("w1-family-0x%0x", rn->family);
+	mutex_lock(&dev->mutex);
 
 	spin_lock(&w1_flock);
 	f = w1_family_registered(rn->family);

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net

