Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3FXBWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 21:22:30 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48327 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3FXBW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 21:22:28 -0400
Date: Mon, 24 Jun 2013 09:22:19 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Sage Weil" <sage@inktank.com>, davem <davem@davemloft.net>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        davem <davem@davemloft.net>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] libceph: Call con->ops->put(con) if cancel_delayed_work(&con->work) worked.
X-Priority: 3
X-GUID: 87C14C1D-6EC1-4AF6-AAD4-91965063FD35
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201306240921544358210@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5O1MePF017848

Because in func queue_con_delay, it will call con->ops->get(con).
So if we cancel the work successfully,we must call con->ops->put(con).
Otherwise some resource can't free like 'struct ceph_mds_session'.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 net/ceph/messenger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index eb0a46a..8207b37 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -661,7 +661,8 @@ void ceph_con_close(struct ceph_connection *con)
 
 	reset_connection(con);
 	con->peer_global_seq = 0;
-	cancel_delayed_work(&con->work);
+	if (cancel_delayed_work(&con->work))
+		con->ops->put(con);
 	con_close_socket(con);
 	mutex_unlock(&con->mutex);
 }
-- 
1.8.1.2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
