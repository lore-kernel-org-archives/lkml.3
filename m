Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaIDRP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:15:59 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:37549 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbaIDRP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:15:58 -0400
Date: Thu, 4 Sep 2014 20:15:48 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        navin.patidar@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] rtl8188eu: rtw_xmit: Replace rcu_dereference() with
 rcu_access_pointer()
Message-ID: <20140904171548.GA3265@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "br_port" local variables obtained through the rcu_dereference() calls are
not dereferenced in the rest of their function.
Therefore, it is recommended to use rcu_access_pointer() instead of
rcu_dereference().
This patch makes the replacements.

The first step to detect this was made with the following Coccinelle semantic
patch:
@@
identifier p;
@@

* p = rcu_dereference(...)
... when any
    when != p
(
* if( (<+...p...+>) ) { ... }
|
* while( (<+...p...+>) ) { ... }
)
... when != p

After the analysis of the output, the change was made manually.

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_xmit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 1413ec8..93228dc 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -1684,7 +1684,7 @@ static int rtw_br_client_tx(struct adapter *padapter, struct sk_buff **pskb)
 	void *br_port = NULL;
 
 	rcu_read_lock();
-	br_port = rcu_dereference(padapter->pnetdev->rx_handler_data);
+	br_port = rcu_access_pointer(padapter->pnetdev->rx_handler_data);
 	rcu_read_unlock();
 	spin_lock_bh(&padapter->br_ext_lock);
 	if (!(skb->data[0] & 1) && br_port &&
@@ -1868,7 +1868,7 @@ s32 rtw_xmit(struct adapter *padapter, struct sk_buff **ppkt)
 	}
 
 	rcu_read_lock();
-	br_port = rcu_dereference(padapter->pnetdev->rx_handler_data);
+	br_port = rcu_access_pointer(padapter->pnetdev->rx_handler_data);
 	rcu_read_unlock();
 
 	if (br_port && check_fwstate(pmlmepriv, WIFI_STATION_STATE|WIFI_ADHOC_STATE)) {
-- 
1.9.1

