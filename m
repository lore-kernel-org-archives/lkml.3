Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab3KNBZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:25:07 -0500
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:33937 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087Ab3KNBZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:25:02 -0500
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Nov 2013 20:25:02 EST
From: Josh Hunt <johunt@akamai.com>
To: netdev@vger.kernel.org, venkat.x.venkatsubra@oracle.com
Cc: linux-kernel@vger.kernel.org, jjolly@suse.com, fenlason@redhat.com,
        honli@redhat.com, Josh Hunt <johunt@akamai.com>
Subject: [PATCH] rds: fix local ping DoS
Date: Wed, 13 Nov 2013 17:15:43 -0800
Message-Id: <1384391743-9342-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rds_ib_xmit function in net/rds/ib_send.c in the Reliable Datagram Sockets
(RDS) protocol implementation allows local users to cause a denial of service
(BUG_ON and kernel panic) by establishing an RDS connection with the source
IP address equal to the IPoIB interface's own IP address, as demonstrated by
rds-ping.

A local unprivileged user could use this flaw to crash the system.

CVE-2012-2372

Reported-by: Honggang Li <honli@redhat.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 net/rds/ib_send.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index e590949..7920c85 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -544,7 +544,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 	int flow_controlled = 0;
 	int nr_sig = 0;
 
-	BUG_ON(off % RDS_FRAG_SIZE);
+	BUG_ON(!conn->c_loopback && off % RDS_FRAG_SIZE);
 	BUG_ON(hdr_off != 0 && hdr_off != sizeof(struct rds_header));
 
 	/* Do not send cong updates to IB loopback */
-- 
1.7.0.4

