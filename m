Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab3AUW0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:26:42 -0500
Received: from gimli.pxnet.com ([89.1.7.7]:45315 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab3AUW0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:26:39 -0500
X-Greylist: delayed 1730 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 17:26:35 EST
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130121-patch-isdn-02.tilman@imap.cc>
In-Reply-To: <20130121-patch-isdn-00.tilman@imap.cc>
References: <20130121-patch-isdn-00.tilman@imap.cc>
Subject: [PATCH 2/6] isdn/gigaset: leave DLE mode before hanging up
Date: Mon, 21 Jan 2013 22:57:20 +0100 (CET)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (mail.pxnet.com [89.1.7.7]); Mon, 21 Jan 2013 22:57:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some firmware releases of Gigaset M105 do not accept AT+VLS=0 command
in DLE mode, so always leave DLE mode before sending the command.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/ev-layer.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/gigaset/ev-layer.c b/drivers/isdn/gigaset/ev-layer.c
index 2e6963d..e2383ec 100644
--- a/drivers/isdn/gigaset/ev-layer.c
+++ b/drivers/isdn/gigaset/ev-layer.c
@@ -1693,6 +1693,11 @@ static void process_command_flags(struct cardstate *cs)
 	for (i = 0; i < cs->channels; ++i) {
 		bcs = cs->bcs + i;
 		if (bcs->at_state.pending_commands & PC_HUP) {
+			if (cs->dle) {
+				cs->curchannel = bcs->channel;
+				schedule_sequence(cs, &cs->at_state, SEQ_DLE0);
+				return;
+			}
 			bcs->at_state.pending_commands &= ~PC_HUP;
 			if (bcs->at_state.pending_commands & PC_CID) {
 				/* not yet dialing: PC_NOCID is sufficient */
-- 
1.7.3.4

