Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbaDBUWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:22:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42836 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758896AbaDBUN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dongmao Zhang <dmzhang@suse.com>,
        David Teigland <teigland@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 21/40] dlm: set zero linger time on sctp socket
Date: Wed,  2 Apr 2014 22:13:07 +0200
Message-Id: <bcce5be089d8a67721eda2f0e668d6e43b9a399d.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongmao Zhang <dmzhang@suse.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ece35848c1847cdf3dd07954578d3e99238ebbae upstream.

The recovery time for a failed node was taking a long
time because the failed node could not perform the full
shutdown process.  Removing the linger time speeds this
up.  The dlm does not care what happens to messages to
or from the failed node.

Signed-off-by: Dongmao Zhang <dmzhang@suse.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/dlm/lowcomms.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index d90909ec6aa6..a5e34dd6a32c 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -649,6 +649,7 @@ static void process_sctp_notification(struct connection *con,
 				      struct msghdr *msg, char *buf)
 {
 	union sctp_notification *sn = (union sctp_notification *)buf;
+	struct linger linger;
 
 	switch (sn->sn_header.sn_type) {
 	case SCTP_SEND_FAILED:
@@ -727,6 +728,13 @@ static void process_sctp_notification(struct connection *con,
 			}
 			add_sock(new_con->sock, new_con);
 
+			linger.l_onoff = 1;
+			linger.l_linger = 0;
+			ret = kernel_setsockopt(new_con->sock, SOL_SOCKET, SO_LINGER,
+						(char *)&linger, sizeof(linger));
+			if (ret < 0)
+				log_print("set socket option SO_LINGER failed");
+
 			log_print("connecting to %d sctp association %d",
 				 nodeid, (int)sn->sn_assoc_change.sac_assoc_id);
 
-- 
1.9.1

