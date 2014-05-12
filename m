Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaELCIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:08:22 -0400
Received: from 1wt.eu ([62.212.114.60]:34535 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbaELBmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:25 -0400
Message-Id: <20140512003201.135463494@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Max Matveev <makc@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 012/143] sctp: deal with multiple COOKIE_ECHO chunks
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Max Matveev <makc@redhat.com>

commit d5ccd496601b8776a516d167a6485754575dc38f upstream

Attempt to reduce the number of IP packets emitted in response to single
SCTP packet (2e3216cd) introduced a complication - if a packet contains
two COOKIE_ECHO chunks and nothing else then SCTP state machine corks the
socket while processing first COOKIE_ECHO and then loses the association
and forgets to uncork the socket. To deal with the issue add new SCTP
command which can be used to set association explictly. Use this new
command when processing second COOKIE_ECHO chunk to restore the context
for SCTP state machine.

Signed-off-by: Max Matveev <makc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/net/sctp/command.h | 1 +
 net/sctp/sm_sideeffect.c   | 5 +++++
 net/sctp/sm_statefuns.c    | 6 ++++++
 3 files changed, 12 insertions(+)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 2c55a7e..0edc14d 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -108,6 +108,7 @@ typedef enum {
 	SCTP_CMD_UPDATE_INITTAG, /* Update peer inittag */
 	SCTP_CMD_SEND_MSG,	 /* Send the whole use message */
 	SCTP_CMD_SEND_NEXT_ASCONF, /* Send the next ASCONF after ACK */
+	SCTP_CMD_SET_ASOC,	 /* Restore association context */
 	SCTP_CMD_LAST
 } sctp_verb_t;
 
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index ed742bf..9005d83 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1676,6 +1676,11 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 		case SCTP_CMD_SEND_NEXT_ASCONF:
 			sctp_cmd_send_asconf(asoc);
 			break;
+
+		case SCTP_CMD_SET_ASOC:
+			asoc = cmd->obj.asoc;
+			break;
+
 		default:
 			printk(KERN_WARNING "Impossible command: %u, %p\n",
 			       cmd->verb, cmd->obj.ptr);
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 2f8e1c8..9e4e846 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2048,6 +2048,12 @@ sctp_disposition_t sctp_sf_do_5_2_4_dupcook(const struct sctp_endpoint *ep,
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_ASOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_DELETE_TCB, SCTP_NULL());
 
+	/* Restore association pointer to provide SCTP command interpeter
+	 * with a valid context in case it needs to manipulate
+	 * the queues */
+	sctp_add_cmd_sf(commands, SCTP_CMD_SET_ASOC,
+			 SCTP_ASOC((struct sctp_association *)asoc));
+
 	return retval;
 
 nomem:
-- 
1.7.12.2.21.g234cd45.dirty



