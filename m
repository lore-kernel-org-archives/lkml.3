Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab3BSEOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:14:48 -0500
Received: from mout.gmx.net ([212.227.15.18]:54453 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab3BSEOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:14:21 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18Tz3dJ9joTT3F20uxoL+Wertc9Uf4TtPsqrZ2fHR
	1BvHcOA5MRNxXO
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>, Peter Huewe <peterhuewe@gmx.de>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Cruz Julian Bishop <cruzjbishop@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] staging/slicoss: Fix buffer possible overflow in slic_card_locate
Date: Tue, 19 Feb 2013 05:18:51 +0100
Message-Id: <1361247532-1874-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1361247234-1754-1-git-send-email-peterhuewe@gmx.de>
References: <1361247234-1754-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smatch complains about a possible buffer overflow
slicoss.c:3651 slic_card_locate() error: buffer overflow
'physcard->adapter' 4 <= 4

If the for loop is not exited prematurely i++ is executed after the last
iteration and thus i can be 4, which is out of bounds for
physcard->adapter.

-> Add check for this condition and simplify the if statement by
inverting the condition.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/slicoss/slicoss.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index fc08585..48056bf 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3643,11 +3643,12 @@ static u32 slic_card_locate(struct adapter *adapter)
 
 	while (physcard) {
 		for (i = 0; i < SLIC_MAX_PORTS; i++) {
-			if (!physcard->adapter[i])
-				continue;
-			else
+			if (physcard->adapter[i])
 				break;
 		}
+		if (i == SLIC_MAX_PORTS)
+			break;
+
 		if (physcard->adapter[i]->slotnumber == adapter->slotnumber)
 			break;
 		physcard = physcard->next;
-- 
1.7.8.6

