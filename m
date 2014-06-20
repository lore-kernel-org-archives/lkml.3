Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbaFTPCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:02:36 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38894 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbaFTPCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:02:33 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 16/41] staging: rtl8188eu: Remove function Hal_EfuseReadEFuse88E()
Date: Fri, 20 Jun 2014 20:29:22 +0530
Message-Id: <1403276387-11841-17-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hal_EfuseReadEFuse88E() is called in ReadEFuseByIC(), when bPseudoTest is true
but it's always false.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |  136 ---------------------
 1 file changed, 136 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 8e93d48..abf66e7 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -807,141 +807,6 @@ void Efuse_PowerSwitch(
 	}
 }
 
-static void Hal_EfuseReadEFuse88E(struct adapter *Adapter,
-	u16			_offset,
-	u16			_size_byte,
-	u8 *pbuf,
-		bool bPseudoTest
-	)
-{
-	u8 *efuseTbl = NULL;
-	u8 rtemp8[1];
-	u16	eFuse_Addr = 0;
-	u8 offset, wren;
-	u16	i, j;
-	u16	**eFuseWord = NULL;
-	u16	efuse_utilized = 0;
-	u8 u1temp = 0;
-
-	/*  */
-	/*  Do NOT excess total size of EFuse table. Added by Roger, 2008.11.10. */
-	/*  */
-	if ((_offset + _size_byte) > EFUSE_MAP_LEN_88E) {/*  total E-Fuse table is 512bytes */
-		DBG_88E("Hal_EfuseReadEFuse88E(): Invalid offset(%#x) with read bytes(%#x)!!\n", _offset, _size_byte);
-		goto exit;
-	}
-
-	efuseTbl = (u8 *)rtw_zmalloc(EFUSE_MAP_LEN_88E);
-	if (efuseTbl == NULL) {
-		DBG_88E("%s: alloc efuseTbl fail!\n", __func__);
-		goto exit;
-	}
-
-	eFuseWord = (u16 **)rtw_malloc2d(EFUSE_MAX_SECTION_88E, EFUSE_MAX_WORD_UNIT, sizeof(u16));
-	if (eFuseWord == NULL) {
-		DBG_88E("%s: alloc eFuseWord fail!\n", __func__);
-		goto exit;
-	}
-
-	/*  0. Refresh efuse init map as all oxFF. */
-	for (i = 0; i < EFUSE_MAX_SECTION_88E; i++)
-		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++)
-			eFuseWord[i][j] = 0xFFFF;
-
-	/*  */
-	/*  1. Read the first byte to check if efuse is empty!!! */
-	/*  */
-	/*  */
-	ReadEFuseByte(Adapter, eFuse_Addr, rtemp8, bPseudoTest);
-	if (*rtemp8 != 0xFF) {
-		efuse_utilized++;
-		eFuse_Addr++;
-	} else {
-		DBG_88E("EFUSE is empty efuse_Addr-%d efuse_data =%x\n", eFuse_Addr, *rtemp8);
-		goto exit;
-	}
-
-	/*  */
-	/*  2. Read real efuse content. Filter PG header and every section data. */
-	/*  */
-	while ((*rtemp8 != 0xFF) && (eFuse_Addr < EFUSE_REAL_CONTENT_LEN_88E)) {
-		/*  Check PG header for section num. */
-		if ((*rtemp8 & 0x1F) == 0x0F) {		/* extended header */
-			u1temp = ((*rtemp8 & 0xE0) >> 5);
-
-			ReadEFuseByte(Adapter, eFuse_Addr, rtemp8, bPseudoTest);
-
-			if ((*rtemp8 & 0x0F) == 0x0F) {
-				eFuse_Addr++;
-				ReadEFuseByte(Adapter, eFuse_Addr, rtemp8, bPseudoTest);
-
-				if (*rtemp8 != 0xFF && (eFuse_Addr < EFUSE_REAL_CONTENT_LEN_88E))
-					eFuse_Addr++;
-				continue;
-			} else {
-				offset = ((*rtemp8 & 0xF0) >> 1) | u1temp;
-				wren = (*rtemp8 & 0x0F);
-				eFuse_Addr++;
-			}
-		} else {
-			offset = ((*rtemp8 >> 4) & 0x0f);
-			wren = (*rtemp8 & 0x0f);
-		}
-
-		if (offset < EFUSE_MAX_SECTION_88E) {
-			/*  Get word enable value from PG header */
-
-			for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
-				/*  Check word enable condition in the section */
-				if (!(wren & 0x01)) {
-					ReadEFuseByte(Adapter, eFuse_Addr, rtemp8, bPseudoTest);
-					eFuse_Addr++;
-					efuse_utilized++;
-					eFuseWord[offset][i] = (*rtemp8 & 0xff);
-					if (eFuse_Addr >= EFUSE_REAL_CONTENT_LEN_88E)
-						break;
-					ReadEFuseByte(Adapter, eFuse_Addr, rtemp8, bPseudoTest);
-					eFuse_Addr++;
-					efuse_utilized++;
-					eFuseWord[offset][i] |= (((u16)*rtemp8 << 8) & 0xff00);
-					if (eFuse_Addr >= EFUSE_REAL_CONTENT_LEN_88E)
-						break;
-				}
-				wren >>= 1;
-			}
-		}
-
-		/*  Read next PG header */
-		ReadEFuseByte(Adapter, eFuse_Addr, rtemp8, bPseudoTest);
-
-		if (*rtemp8 != 0xFF && (eFuse_Addr < EFUSE_REAL_CONTENT_LEN_88E)) {
-			efuse_utilized++;
-			eFuse_Addr++;
-		}
-	}
-
-	/*  3. Collect 16 sections and 4 word unit into Efuse map. */
-	for (i = 0; i < EFUSE_MAX_SECTION_88E; i++) {
-		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++) {
-			efuseTbl[(i*8)+(j*2)] = (eFuseWord[i][j] & 0xff);
-			efuseTbl[(i*8)+((j*2)+1)] = ((eFuseWord[i][j] >> 8) & 0xff);
-		}
-	}
-
-	/*  4. Copy from Efuse map to output pointer memory!!! */
-	for (i = 0; i < _size_byte; i++)
-		pbuf[i] = efuseTbl[_offset+i];
-
-	/*  5. Calculate Efuse utilization. */
-	rtw_hal_set_hwreg(Adapter, HW_VAR_EFUSE_BYTES, (u8 *)&eFuse_Addr);
-
-exit:
-	kfree(efuseTbl);
-
-	if (eFuseWord)
-		rtw_mfree2d((void *)eFuseWord, EFUSE_MAX_SECTION_88E, EFUSE_MAX_WORD_UNIT, sizeof(u16));
-}
-
 static void ReadEFuseByIC(struct adapter *Adapter, u8 efuseType, u16 _offset, u16 _size_byte, u8 *pbuf, bool bPseudoTest)
 {
 	if (!bPseudoTest) {
@@ -957,7 +822,6 @@ static void ReadEFuseByIC(struct adapter *Adapter, u8 efuseType, u16 _offset, u1
 				goto exit;
 		}
 	}
-	Hal_EfuseReadEFuse88E(Adapter, _offset, _size_byte, pbuf, bPseudoTest);
 
 exit:
 	return;
-- 
1.7.10.4

