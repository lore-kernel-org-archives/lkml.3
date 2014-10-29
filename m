Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbaJ2Wm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:42:57 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47958 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673AbaJ2Wmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:42:47 -0400
From: Behan Webster <behanw@converseincode.com>
To: andriy.shevchenko@linux.intel.com, aysemelikeyurtoglu@gmail.com,
        matthias.schoepe@studium.uni-erlangen.de, mdcasey@chabloom.com,
        peter.senna@gmail.com, rashika.kheria@gmail.com, standby24x7@gmail.com
Cc: behanw@converseincode.com, akpm@linux-foundation.org,
        andreas.frembs@studium.uni-erlangen.de, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mahati.chamarthy@gmail.com, peter.p.waskiewicz.jr@intel.com,
        quozl@laptop.org, valentina.manea.m@gmail.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/4] staging, rtl8192e, LLVMLinux: Make static local in inline function const
Date: Wed, 29 Oct 2014 15:42:23 -0700
Message-Id: <1414622543-22969-5-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414622543-22969-1-git-send-email-behanw@converseincode.com>
References: <1414622543-22969-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtllib_association_req is a (large) inline function which defines 2 constant
static arrays which aren't labelled as const. As a result clang complains with:

non-constant static local variable in inline function may be different in
different files
[-Wstatic-local-in-inline]
  static u8       AironetIeOui[] = {0x00, 0x01, 0x66};
  ^
The solution is making them "static const".

However doing so requires dropping const when being used with struct
octet_string. However the value is used in a const fashion thereafter, so no
harm done.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/rtl8192e/rtllib_softmac.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 089a058..e970db4 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -1311,7 +1311,7 @@ inline struct sk_buff *rtllib_association_req(struct rtllib_network *beacon,
 	}
 
 	if (beacon->bCkipSupported) {
-		static u8	AironetIeOui[] = {0x00, 0x01, 0x66};
+		static const u8 AironetIeOui[] = {0x00, 0x01, 0x66};
 		u8	CcxAironetBuf[30];
 		struct octet_string osCcxAironetIE;
 
@@ -1331,10 +1331,11 @@ inline struct sk_buff *rtllib_association_req(struct rtllib_network *beacon,
 	}
 
 	if (beacon->bCcxRmEnable) {
-		static u8 CcxRmCapBuf[] = {0x00, 0x40, 0x96, 0x01, 0x01, 0x00};
+		static const u8 CcxRmCapBuf[] = {0x00, 0x40, 0x96, 0x01, 0x01,
+			0x00};
 		struct octet_string osCcxRmCap;
 
-		osCcxRmCap.Octet = CcxRmCapBuf;
+		osCcxRmCap.Octet = (u8 *) CcxRmCapBuf;
 		osCcxRmCap.Length = sizeof(CcxRmCapBuf);
 		tag = skb_put(skb, ccxrm_ie_len);
 		*tag++ = MFIE_TYPE_GENERIC;
-- 
1.9.1

