Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934376AbaFTPEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:04:10 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47069 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaFTPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:04:04 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 29/41] staging: rtl8188eu: efuse_ReadEFuse(): Remove parameter bool bPseudoTest
Date: Fri, 20 Jun 2014 20:29:35 +0530
Message-Id: <1403276387-11841-30-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bPseudoTest is always false.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    4 ++--
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   20 ++++++--------------
 drivers/staging/rtl8188eu/include/rtw_efuse.h     |    2 +-
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 9519888..ecfd311 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -232,7 +232,7 @@ u8 rtw_efuse_map_read(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 
 	Efuse_PowerSwitch(padapter, false, true);
 
-	efuse_ReadEFuse(padapter, EFUSE_WIFI, addr, cnts, data, false);
+	efuse_ReadEFuse(padapter, EFUSE_WIFI, addr, cnts, data);
 
 	Efuse_PowerSwitch(padapter, false, false);
 
@@ -415,7 +415,7 @@ static void Efuse_ReadAllMap(struct adapter *pAdapter, u8 efuseType, u8 *Efuse,
 
 	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
 
-	efuse_ReadEFuse(pAdapter, efuseType, 0, mapLen, Efuse, pseudo);
+	efuse_ReadEFuse(pAdapter, efuseType, 0, mapLen, Efuse);
 
 	Efuse_PowerSwitch(pAdapter, false, false);
 }
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index ff5dfff..7ef2313 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -807,23 +807,15 @@ void Efuse_PowerSwitch(
 	}
 }
 
-void efuse_ReadEFuse(struct adapter *Adapter, u8 efuseType, u16 _offset, u16 _size_byte, u8 *pbuf, bool bPseudoTest)
+void efuse_ReadEFuse(struct adapter *Adapter, u8 efuseType, u16 _offset, u16 _size_byte, u8 *pbuf)
 {
-	if (!bPseudoTest) {
-		int ret = _FAIL;
-		if (rtw_IOL_applied(Adapter)) {
-			rtw_hal_power_on(Adapter);
 
-			iol_mode_enable(Adapter, 1);
-			ret = iol_read_efuse(Adapter, 0, _offset, _size_byte, pbuf);
-			iol_mode_enable(Adapter, 0);
-
-			if (_SUCCESS == ret)
-				goto exit;
-		}
+	if (rtw_IOL_applied(Adapter)) {
+		rtw_hal_power_on(Adapter);
+		iol_mode_enable(Adapter, 1);
+		iol_read_efuse(Adapter, 0, _offset, _size_byte, pbuf);
+		iol_mode_enable(Adapter, 0);
 	}
-
-exit:
 	return;
 }
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index cd96366..fc87388 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -131,7 +131,7 @@ u8 efuse_OneByteRead(struct adapter *adapter, u16 addr, u8 *data);
 u8 efuse_OneByteWrite(struct adapter *adapter, u16 addr, u8 data);
 
 void efuse_ReadEFuse(struct adapter *Adapter, u8 efuseType, u16 _offset,
-		u16 _size_byte, u8 *pbuf, bool bPseudoTest);
+		u16 _size_byte, u8 *pbuf);
 void Efuse_PowerSwitch(struct adapter *adapt, u8 bWrite, u8  PwrState);
 int Efuse_PgPacketRead(struct adapter *adapt, u8 offset, u8 *data, bool test);
 bool Efuse_PgPacketWrite(struct adapter *adapter, u8 offset, u8 word, u8 *data,
-- 
1.7.10.4

