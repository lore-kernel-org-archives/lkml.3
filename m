Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbaF3MT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:19:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51955 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lidong Zhong <lzhong@suse.com>,
        David Teigland <teigland@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 030/181] dlm: keep listening connection alive with sctp mode
Date: Mon, 30 Jun 2014 13:50:51 +0200
Message-Id: <34b6c0490bfa372876e6907eee779c5cd0e89963.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lidong Zhong <lzhong@suse.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 883854c5457a97190f7b0ee20f03bcd9664fc0c2 upstream.

The connection struct with nodeid 0 is the listening socket,
not a connection to another node.  The sctp resend function
was not checking that the nodeid was valid (non-zero), so it
would mistakenly get and resend on the listening connection
when nodeid was zero.

Signed-off-by: Lidong Zhong <lzhong@suse.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/dlm/lowcomms.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index a5e34dd6a32c..1381d3fb3738 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -617,6 +617,11 @@ static void retry_failed_sctp_send(struct connection *recv_con,
 	int nodeid = sn_send_failed->ssf_info.sinfo_ppid;
 
 	log_print("Retry sending %d bytes to node id %d", len, nodeid);
+	
+	if (!nodeid) {
+		log_print("Shouldn't resend data via listening connection.");
+		return;
+	}
 
 	con = nodeid2con(nodeid, 0);
 	if (!con) {
-- 
2.0.0

