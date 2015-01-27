Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbbA0SLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:11:23 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44415 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbbA0SLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:11:21 -0500
Date: Tue, 27 Jan 2015 23:41:13 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] Staging: rtl8192u: Use put_unaligned_le16 in rtl819x_BAProc.c
Message-ID: <20150127181113.GA10077@vaishali-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of function put_unaligned_le16.

This is done using Coccinelle and semantic patch used is as follows:

@a@
typedef u16, __le16, uint16_t;
{u16,__le16,uint16_t} e16;
identifier tmp;
expression ptr;
expression y,e;
type T;
type T;
@@

- tmp = cpu_to_le16(y);

<+... when != tmp
(
- memcpy(ptr, (T)&tmp, \(2\|sizeof(u16)\|sizeof(__le16)\|sizeof(uint16_t)\|sizeof(e16)\));
+ put_unaligned_le16(y,ptr);
|
- memcpy(ptr, (T)&tmp, ...);
+ put_unaligned_le16(y,ptr);
)
...+>
? tmp = e

@@ type T; identifier a.tmp; @@

- T tmp;
...when != tmp

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
index a9fd2cb..1b4623c 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
@@ -4,6 +4,8 @@
  * ADDBAREQ ADDBARSP and DELBA packet is still on consideration. Temporarily use MANAGE QUEUE instead of Normal Queue.
  * WB 2008-05-27
  * *****************************************************************************************************************************/
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include "ieee80211.h"
 #include "rtl819x_BA.h"
 
@@ -110,7 +112,6 @@ static struct sk_buff *ieee80211_ADDBA(struct ieee80211_device *ieee, u8 *Dst, P
 	struct sk_buff *skb = NULL;
 	 struct ieee80211_hdr_3addr *BAReq = NULL;
 	u8 *tag = NULL;
-	__le16 tmp = 0;
 	u16 len = ieee->tx_headroom + 9;
 	//category(1) + action field(1) + Dialog Token(1) + BA Parameter Set(2) +  BA Timeout Value(2) +  BA Start SeqCtrl(2)(or StatusCode(2))
 	IEEE80211_DEBUG(IEEE80211_DL_TRACE | IEEE80211_DL_BA, "========>%s(), frame(%d) sentd to:%pM, ieee->dev:%p\n", __func__, type, Dst, ieee->dev);
@@ -149,17 +150,17 @@ static struct sk_buff *ieee80211_ADDBA(struct ieee80211_device *ieee, u8 *Dst, P
 	{
 		// Status Code
 		printk("=====>to send ADDBARSP\n");
-		tmp = cpu_to_le16(StatusCode);
-		memcpy(tag, (u8 *)&tmp, 2);
+
+		put_unaligned_le16(StatusCode, tag);
 		tag += 2;
 	}
 	// BA Parameter Set
-	tmp = cpu_to_le16(pBA->BaParamSet.shortData);
-	memcpy(tag, (u8 *)&tmp, 2);
+
+	put_unaligned_le16(pBA->BaParamSet.shortData, tag);
 	tag += 2;
 	// BA Timeout Value
-	tmp = cpu_to_le16(pBA->BaTimeoutValue);
-	memcpy(tag, (u8 *)&tmp, 2);
+
+	put_unaligned_le16(pBA->BaTimeoutValue, tag);
 	tag += 2;
 
 	if (ACT_ADDBAREQ == type)
@@ -196,7 +197,6 @@ static struct sk_buff *ieee80211_DELBA(
 	struct sk_buff *skb = NULL;
 	 struct ieee80211_hdr_3addr *Delba = NULL;
 	u8 *tag = NULL;
-	__le16 tmp = 0;
 	//len = head len + DELBA Parameter Set(2) + Reason Code(2)
 	u16 len = 6 + ieee->tx_headroom;
 
@@ -230,12 +230,12 @@ static struct sk_buff *ieee80211_DELBA(
 	*tag ++= ACT_DELBA;
 
 	// DELBA Parameter Set
-	tmp = cpu_to_le16(DelbaParamSet.shortData);
-	memcpy(tag, (u8 *)&tmp, 2);
+
+	put_unaligned_le16(DelbaParamSet.shortData, tag);
 	tag += 2;
 	// Reason Code
-	tmp = cpu_to_le16(ReasonCode);
-	memcpy(tag, (u8 *)&tmp, 2);
+
+	put_unaligned_le16(ReasonCode, tag);
 	tag += 2;
 
 	IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA|IEEE80211_DL_BA, skb->data, skb->len);
-- 
1.9.1

