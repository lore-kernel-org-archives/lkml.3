Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301AbaH0N1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:27:47 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48320 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaH0N1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:27:45 -0400
Date: Wed, 27 Aug 2014 16:27:30 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: chunkeey@googlemail.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] carl9170: tx: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140827132730.GA31650@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to RCU_INIT_POINTER()'s block comment 3.a, it can be used if
"3.   The referenced data structure has already been exposed to readers either
at compile time or via rcu_assign_pointer() -and-
 a.   You have not made -any- reader-visible changes to this structure since
then".

This case fulfills the conditions above because between the rcu_dereference()
call (cvif = rcu_dereference(ar->beacon_iter);) and the rcu_assign_pointer()
call there is no update of the "cvif" variable.
Therefore, this patch makes the replacement.

The following Coccinelle semantic patch was used:
@@
identifier v;
@@

v = rcu_dereference(...);
... when != rcu_dereference(...);
    when != v = ...;
    when != (<+...v...+>)++;
    when != \(memcpy\|memset\)(...);
(
- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., v);
|
 if(...) {
... when != v = ...;
- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., v);
... when any
 }
)

Because there are cases where between a “rcu_dereference()” call and a
“rcu_assign_pointer()” call might be updates of the value that interests us,
the Coccinelle semantic patch ignores them and replaces with
"RCU_INIT_POINTER()" only when the update is not happening.

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/net/wireless/ath/carl9170/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 4cadfd4..ae86a600 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1557,7 +1557,7 @@ static struct carl9170_vif_info *carl9170_pick_beaconing_vif(struct ar9170 *ar)
 	}
 
 out:
-	rcu_assign_pointer(ar->beacon_iter, cvif);
+	RCU_INIT_POINTER(ar->beacon_iter, cvif);
 	return cvif;
 }
 
-- 
1.9.1

