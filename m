Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaABMMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:12:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaABMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: [PATCH, RFC 20/30] isdn: hisax/elsa: fix sleep_on race in elsa FSM
Date: Thu,  2 Jan 2014 13:07:44 +0100
Message-Id: <1388664474-1710039-21-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:TgQwn8cDdXbKIKC6X3O3ud+SwNAA+NE84r+V9FH6dho
 NxFrVXNldYTiFAZ6Nk8aWLnJRyZfAOFPkevhLQThdXo9/NNpdD
 f+QFIPi+T/AhotbZ5CZJSAjUiLhkPWzP8e8C+wK0GF/xux6Gis
 NMTcpNB0HOVNqLBUJG55dcQfOi/KzRQSFcpqr3CsBKH48bv1gP
 19+58XFabz6EY7D6Q3deRiCcOpW81v+XQKcJprLJnWEf+eZ/sL
 8YDQX1zaTTfakQ04TWNTBG3WsBT1S9ec68qg+CWFHfhYfZIxt+
 arUWQ3WizcCVhixB6cXVAAroKzSLmujKxueY+LidVlN47wUqHF
 AR6l+S/Q1BXF8A7SH9WP6/JU3Z/urw45G4kSTod+3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The state machine code in the elsa driver uses interruptible_sleep_on
to wait for state changes, which is racy. A closer look at the possible
states reveals that it is always used to wait for getting back into
ARCOFI_NOP, so we can use wait_event_interruptible instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/hisax/elsa.c     | 9 ++++++---
 drivers/isdn/hisax/elsa_ser.c | 3 ++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index 2be1c8a..d8ef64d 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -509,7 +509,8 @@ static void
 set_arcofi(struct IsdnCardState *cs, int bc) {
 	cs->dc.isac.arcofi_bc = bc;
 	arcofi_fsm(cs, ARCOFI_START, &ARCOFI_COP_5);
-	interruptible_sleep_on(&cs->dc.isac.arcofi_wait);
+	wait_event_interruptible(cs->dc.isac.arcofi_wait,
+				 cs->dc.isac.arcofi_state == ARCOFI_NOP);
 }
 
 static int
@@ -528,7 +529,8 @@ check_arcofi(struct IsdnCardState *cs)
 		}
 	cs->dc.isac.arcofi_bc = 0;
 	arcofi_fsm(cs, ARCOFI_START, &ARCOFI_VERSION);
-	interruptible_sleep_on(&cs->dc.isac.arcofi_wait);
+	wait_event_interruptible(cs->dc.isac.arcofi_wait,
+				 cs->dc.isac.arcofi_state == ARCOFI_NOP);
 	if (!test_and_clear_bit(FLG_ARCOFI_ERROR, &cs->HW_Flags)) {
 		debugl1(cs, "Arcofi response received %d bytes", cs->dc.isac.mon_rxp);
 		p = cs->dc.isac.mon_rx;
@@ -595,7 +597,8 @@ check_arcofi(struct IsdnCardState *cs)
 			       Elsa_Types[cs->subtyp],
 			       cs->hw.elsa.base + 8);
 		arcofi_fsm(cs, ARCOFI_START, &ARCOFI_XOP_0);
-		interruptible_sleep_on(&cs->dc.isac.arcofi_wait);
+		wait_event_interruptible(cs->dc.isac.arcofi_wait,
+				 cs->dc.isac.arcofi_state == ARCOFI_NOP);
 		return (1);
 	}
 	return (0);
diff --git a/drivers/isdn/hisax/elsa_ser.c b/drivers/isdn/hisax/elsa_ser.c
index 3f84dd8..a2a358c 100644
--- a/drivers/isdn/hisax/elsa_ser.c
+++ b/drivers/isdn/hisax/elsa_ser.c
@@ -573,7 +573,8 @@ modem_l2l1(struct PStack *st, int pr, void *arg)
 		test_and_clear_bit(BC_FLG_ACTIV, &bcs->Flag);
 		bcs->cs->dc.isac.arcofi_bc = st->l1.bc;
 		arcofi_fsm(bcs->cs, ARCOFI_START, &ARCOFI_XOP_0);
-		interruptible_sleep_on(&bcs->cs->dc.isac.arcofi_wait);
+		wait_event_interruptible(bcs->cs->dc.isac.arcofi_wait,
+				 bcs->cs->dc.isac.arcofi_state == ARCOFI_NOP);
 		bcs->cs->hw.elsa.MFlag = 1;
 	} else {
 		printk(KERN_WARNING "ElsaSer: unknown pr %x\n", pr);
-- 
1.8.3.2

