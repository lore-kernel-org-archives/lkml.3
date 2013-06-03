Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3FCHkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:40:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:62609 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FCHki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:40:38 -0400
From: Xufeng Zhang <xufeng.zhang@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <nhorman@tuxdriver.com>, <xufeng.zhang@windriver.com>,
        <vyasevich@gmail.com>, <davem@davemloft.net>
Subject: [PATCH] sctp: set association state to established in dupcook_a handler
Date: Mon, 3 Jun 2013 15:52:58 +0800
Message-ID: <1370245978-12884-1-git-send-email-xufeng.zhang@windriver.com>
X-Mailer: git-send-email 1.7.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Xufeng Zhang <xufeng.zhang@windriver.com>

[ Upstream commit 9839ff0dead906e85e4d17490aeff87a5859a157 ]

While sctp handling a duplicate COOKIE-ECHO and the action is
'Association restart', sctp_sf_do_dupcook_a() will processing
the unexpected COOKIE-ECHO for peer restart, but it does not set
the association state to SCTP_STATE_ESTABLISHED, so the association
could stuck in SCTP_STATE_SHUTDOWN_PENDING state forever.
This violates the sctp specification:
  RFC 4960 5.2.4. Handle a COOKIE ECHO when a TCB Exists
  Action
  A) In this case, the peer may have restarted. .....
     After this, the endpoint shall enter the ESTABLISHED state.

To resolve this problem, adding a SCTP_CMD_NEW_STATE cmd to the
command list before SCTP_CMD_REPLY cmd, this will set the restart
association to SCTP_STATE_ESTABLISHED state properly and also avoid
I-bit being set in the DATA chunk header when COOKIE_ACK is bundled
with DATA chunks.

Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sctp/sm_statefuns.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index cb1c430..ab08f65 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1747,8 +1747,10 @@ static sctp_disposition_t sctp_sf_do_dupcook_a(const struct sctp_endpoint *ep,
 
 	/* Update the content of current association. */
 	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
-	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
 	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
+	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
+			SCTP_STATE(SCTP_STATE_ESTABLISHED));
+	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
 	return SCTP_DISPOSITION_CONSUME;
 
 nomem_ev:
-- 
1.7.0.2

