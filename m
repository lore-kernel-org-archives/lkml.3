Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaJAVux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:50:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbaJAVuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:50:02 -0400
From: "Herton R. Krzesinski" <herton@redhat.com>
To: Chien Yen <chien.yen@oracle.com>
Cc: rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        rmanes@redhat.com, dledford@redhat.com
Subject: [PATCH 2/3] net/rds: do proper house keeping if connection fails in rds_tcp_conn_connect
Date: Wed,  1 Oct 2014 18:49:53 -0300
Message-Id: <1412200194-28902-3-git-send-email-herton@redhat.com>
In-Reply-To: <1412200194-28902-1-git-send-email-herton@redhat.com>
References: <1412200194-28902-1-git-send-email-herton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see two problems if we consider the sock->ops->connect attempt to fail in
rds_tcp_conn_connect. The first issue is that for example we don't remove the
previously added rds_tcp_connection item to rds_tcp_tc_list at
rds_tcp_set_callbacks, which means that on a next reconnect attempt for the
same rds_connection, when rds_tcp_conn_connect is called we can again call
rds_tcp_set_callbacks, resulting in duplicated items on rds_tcp_tc_list,
leading to list corruption: to avoid this just make sure we call
properly rds_tcp_restore_callbacks before we exit. The second issue
is that we should also release the sock properly, by setting sock = NULL
only if we are returning without error.

Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
---
 net/rds/tcp_connect.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rds/tcp_connect.c b/net/rds/tcp_connect.c
index a65ee78..f9f564a 100644
--- a/net/rds/tcp_connect.c
+++ b/net/rds/tcp_connect.c
@@ -106,11 +106,14 @@ int rds_tcp_conn_connect(struct rds_connection *conn)
 	rds_tcp_set_callbacks(sock, conn);
 	ret = sock->ops->connect(sock, (struct sockaddr *)&dest, sizeof(dest),
 				 O_NONBLOCK);
-	sock = NULL;
 
 	rdsdebug("connect to address %pI4 returned %d\n", &conn->c_faddr, ret);
 	if (ret == -EINPROGRESS)
 		ret = 0;
+	if (ret == 0)
+		sock = NULL;
+	else
+		rds_tcp_restore_callbacks(sock, conn->c_transport_data);
 
 out:
 	if (sock)
-- 
1.9.3

