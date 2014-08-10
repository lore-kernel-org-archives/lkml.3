Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaHJOpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:45:06 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40132 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHJOpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:45:04 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/22] staging: rtl8188eu: Cleanup firmware initialization code
Date: Sun, 10 Aug 2014 20:14:14 +0530
Message-Id: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using rtl8188ee's (drivers/net/wireless/rtlwifi/rtl8188ee/fw.c) neat and clean
firmware initialization code to replace rtl8188eu's messy firmware
initialization code.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile                |    1 +
 drivers/staging/rtl8188eu/hal/fw.c                |  236 ++++++++++++++++
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |  298 ---------------------
 drivers/staging/rtl8188eu/hal/usb_halinit.c       |    6 +-
 drivers/staging/rtl8188eu/include/drv_types.h     |    7 -
 drivers/staging/rtl8188eu/include/fw.h            |   59 ++++
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h  |   47 +---
 drivers/staging/rtl8188eu/os_dep/os_intfs.c       |    7 +-
 8 files changed, 309 insertions(+), 352 deletions(-)
 create mode 100644 drivers/staging/rtl8188eu/hal/fw.c
 create mode 100644 drivers/staging/rtl8188eu/include/fw.h

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index aeebf93..32d64a7 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -17,6 +17,7 @@ r8188eu-y :=				\
 		core/rtw_sta_mgt.o	\
 		core/rtw_wlan_util.o	\
 		core/rtw_xmit.o		\
+		hal/fw.o	\
 		hal/HalHWImg8188E_MAC.o	\
 		hal/HalHWImg8188E_BB.o	\
 		hal/HalHWImg8188E_RF.o	\
diff --git a/drivers/staging/rtl8188eu/hal/fw.c b/drivers/staging/rtl8188eu/hal/fw.c
new file mode 100644
index 0000000..09324ae
--- /dev/null
+++ b/drivers/staging/rtl8188eu/hal/fw.c
@@ -0,0 +1,236 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2013  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "fw.h"
+#include "drv_types.h"
+#include "usb_ops_linux.h"
+#include "rtl8188e_spec.h"
+#include "rtl8188e_hal.h"
+
+#include <linux/firmware.h>
+#include <linux/kmemleak.h>
+
+static void _rtl88e_enable_fw_download(struct adapter *adapt, bool enable)
+{
+	u8 tmp;
+
+	if (enable) {
+		tmp = usb_read8(adapt, REG_MCUFWDL);
+		usb_write8(adapt, REG_MCUFWDL, tmp | 0x01);
+
+		tmp = usb_read8(adapt, REG_MCUFWDL + 2);
+		usb_write8(adapt, REG_MCUFWDL + 2, tmp & 0xf7);
+	} else {
+		tmp = usb_read8(adapt, REG_MCUFWDL);
+		usb_write8(adapt, REG_MCUFWDL, tmp & 0xfe);
+
+		usb_write8(adapt, REG_MCUFWDL + 1, 0x00);
+	}
+}
+
+static void _rtl88e_fw_block_write(struct adapter *adapt,
+				   const u8 *buffer, u32 size)
+{
+	u32 blk_sz = sizeof(u32);
+	u8 *buf_ptr = (u8 *)buffer;
+	u32 *pu4BytePtr = (u32 *)buffer;
+	u32 i, offset, blk_cnt, remain;
+
+	blk_cnt = size / blk_sz;
+	remain = size % blk_sz;
+
+	for (i = 0; i < blk_cnt; i++) {
+		offset = i * blk_sz;
+		usb_write32(adapt, (FW_8192C_START_ADDRESS + offset),
+				*(pu4BytePtr + i));
+	}
+
+	if (remain) {
+		offset = blk_cnt * blk_sz;
+		buf_ptr += offset;
+		for (i = 0; i < remain; i++) {
+			usb_write8(adapt, (FW_8192C_START_ADDRESS +
+						 offset + i), *(buf_ptr + i));
+		}
+	}
+}
+
+static void _rtl88e_fill_dummy(u8 *pfwbuf, u32 *pfwlen)
+{
+	u32 fwlen = *pfwlen;
+	u8 remain = (u8) (fwlen % 4);
+
+	remain = (remain == 0) ? 0 : (4 - remain);
+
+	while (remain > 0) {
+		pfwbuf[fwlen] = 0;
+		fwlen++;
+		remain--;
+	}
+
+	*pfwlen = fwlen;
+}
+
+static void _rtl88e_fw_page_write(struct adapter *adapt,
+				  u32 page, const u8 *buffer, u32 size)
+{
+	u8 value8;
+	u8 u8page = (u8) (page & 0x07);
+
+	value8 = (usb_read8(adapt, REG_MCUFWDL + 2) & 0xF8) | u8page;
+
+	usb_write8(adapt, (REG_MCUFWDL + 2), value8);
+	_rtl88e_fw_block_write(adapt, buffer, size);
+}
+
+static void _rtl88e_write_fw(struct adapter *adapt, u8 *buffer, u32 size)
+{
+	u8 *buf_ptr = buffer;
+	u32 page_no, remain;
+	u32 page, offset;
+
+	_rtl88e_fill_dummy(buf_ptr, &size);
+
+	page_no = size / FW_8192C_PAGE_SIZE;
+	remain = size % FW_8192C_PAGE_SIZE;
+
+	for (page = 0; page < page_no; page++) {
+		offset = page * FW_8192C_PAGE_SIZE;
+		_rtl88e_fw_page_write(adapt, page, (buf_ptr + offset),
+				      FW_8192C_PAGE_SIZE);
+	}
+
+	if (remain) {
+		offset = page_no * FW_8192C_PAGE_SIZE;
+		page = page_no;
+		_rtl88e_fw_page_write(adapt, page, (buf_ptr + offset), remain);
+	}
+}
+
+static void rtl88e_firmware_selfreset(struct adapter *adapt)
+{
+	u8 u1b_tmp;
+
+	u1b_tmp = usb_read8(adapt, REG_SYS_FUNC_EN+1);
+	usb_write8(adapt, REG_SYS_FUNC_EN+1, (u1b_tmp & (~BIT(2))));
+	usb_write8(adapt, REG_SYS_FUNC_EN+1, (u1b_tmp | BIT(2)));
+}
+
+static int _rtl88e_fw_free_to_go(struct adapter *adapt)
+{
+	int err = -EIO;
+	u32 counter = 0;
+	u32 value32;
+
+	do {
+		value32 = usb_read32(adapt, REG_MCUFWDL);
+		if (value32 & FWDL_ChkSum_rpt)
+			break;
+	} while (counter++ < POLLING_READY_TIMEOUT_COUNT);
+
+	if (counter >= POLLING_READY_TIMEOUT_COUNT) {
+		goto exit;
+	}
+
+	value32 = usb_read32(adapt, REG_MCUFWDL);
+	value32 |= MCUFWDL_RDY;
+	value32 &= ~WINTINI_RDY;
+	usb_write32(adapt, REG_MCUFWDL, value32);
+
+	rtl88e_firmware_selfreset(adapt);
+	counter = 0;
+
+	do {
+		value32 = usb_read32(adapt, REG_MCUFWDL);
+		if (value32 & WINTINI_RDY) {
+			err = 0;
+			goto exit;
+		}
+
+		udelay(FW_8192C_POLLING_DELAY);
+
+	} while (counter++ < POLLING_READY_TIMEOUT_COUNT);
+
+exit:
+	return err;
+}
+
+int rtl88e_download_fw(struct adapter *adapt)
+{
+	struct hal_data_8188e *rtlhal = GET_HAL_DATA(adapt);
+	struct dvobj_priv *dvobj = adapter_to_dvobj(adapt);
+	struct device *device = dvobj_to_dev(dvobj);
+	const struct firmware *fw;
+	const char fw_name[] = "rtlwifi/rtl8188eufw.bin";
+	struct rtl92c_firmware_header *pfwheader = NULL;
+	u8 *pfwdata;
+	u32 fwsize;
+	int err;
+
+	if (request_firmware(&fw, fw_name, device)){
+		dev_err(device, "Firmware %s not available\n", fw_name);
+		return -ENOENT;
+	}
+
+	if (fw->size > FW_8188E_SIZE) {
+		dev_err(device,"Firmware size exceed 0x%X. Check it.\n",
+			 FW_8188E_SIZE);
+		return -1;
+	}
+
+	pfwdata = kzalloc(FW_8188E_SIZE, GFP_KERNEL);
+	if (!pfwdata)
+		return -ENOMEM;
+
+	rtlhal->pfirmware = pfwdata;
+	memcpy(rtlhal->pfirmware, fw->data, fw->size);
+	rtlhal->fwsize = fw->size;
+	release_firmware(fw);
+
+	fwsize = rtlhal->fwsize;
+	pfwheader = (struct rtl92c_firmware_header *)pfwdata;
+
+	if (IS_FW_HEADER_EXIST(pfwheader)) {
+		pfwdata = pfwdata + 32;
+		fwsize = fwsize - 32;
+	}
+
+	if (usb_read8(adapt, REG_MCUFWDL) & RAM_DL_SEL) {
+		usb_write8(adapt, REG_MCUFWDL, 0);
+		rtl88e_firmware_selfreset(adapt);
+	}
+	_rtl88e_enable_fw_download(adapt, true);
+	usb_write8(adapt, REG_MCUFWDL, usb_read8(adapt, REG_MCUFWDL) | FWDL_ChkSum_rpt);
+	_rtl88e_write_fw(adapt, pfwdata, fwsize);
+	_rtl88e_enable_fw_download(adapt, false);
+
+	err = _rtl88e_fw_free_to_go(adapt);
+
+	return err;
+}
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index fbf70f6..ac4bede 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -170,145 +170,8 @@ void rtw_IOL_cmd_tx_pkt_buf_dump(struct adapter *Adapter, int data_len)
 	DBG_88E("###### %s ######\n", __func__);
 }
 
-static void _FWDownloadEnable(struct adapter *padapter, bool enable)
-{
-	u8 tmp;
-
-	if (enable) {
-		/*  MCU firmware download enable. */
-		tmp = usb_read8(padapter, REG_MCUFWDL);
-		usb_write8(padapter, REG_MCUFWDL, tmp | 0x01);
-
-		/*  8051 reset */
-		tmp = usb_read8(padapter, REG_MCUFWDL+2);
-		usb_write8(padapter, REG_MCUFWDL+2, tmp&0xf7);
-	} else {
-		/*  MCU firmware download disable. */
-		tmp = usb_read8(padapter, REG_MCUFWDL);
-		usb_write8(padapter, REG_MCUFWDL, tmp&0xfe);
-
-		/*  Reserved for fw extension. */
-		usb_write8(padapter, REG_MCUFWDL+1, 0x00);
-	}
-}
-
 #define MAX_REG_BOLCK_SIZE	196
 
-static int _BlockWrite(struct adapter *padapter, void *buffer, u32 buffSize)
-{
-	int ret = _SUCCESS;
-	u32	blockSize_p1 = 4;	/*  (Default) Phase #1 : PCI muse use 4-byte write to download FW */
-	u32	blockSize_p2 = 8;	/*  Phase #2 : Use 8-byte, if Phase#1 use big size to write FW. */
-	u32	blockSize_p3 = 1;	/*  Phase #3 : Use 1-byte, the remnant of FW image. */
-	u32	blockCount_p1 = 0, blockCount_p2 = 0, blockCount_p3 = 0;
-	u32	remainSize_p1 = 0, remainSize_p2 = 0;
-	u8 *bufferPtr	= (u8 *)buffer;
-	u32	i = 0, offset = 0;
-
-	blockSize_p1 = MAX_REG_BOLCK_SIZE;
-
-	/* 3 Phase #1 */
-	blockCount_p1 = buffSize / blockSize_p1;
-	remainSize_p1 = buffSize % blockSize_p1;
-
-	if (blockCount_p1) {
-		RT_TRACE(_module_hal_init_c_, _drv_notice_,
-			 ("_BlockWrite: [P1] buffSize(%d) blockSize_p1(%d) blockCount_p1(%d) remainSize_p1(%d)\n",
-			 buffSize, blockSize_p1, blockCount_p1, remainSize_p1));
-	}
-
-	for (i = 0; i < blockCount_p1; i++) {
-		ret = usb_writeN(padapter, (FW_8188E_START_ADDRESS + i * blockSize_p1), blockSize_p1, (bufferPtr + i * blockSize_p1));
-		if (ret == _FAIL)
-			goto exit;
-	}
-
-	/* 3 Phase #2 */
-	if (remainSize_p1) {
-		offset = blockCount_p1 * blockSize_p1;
-
-		blockCount_p2 = remainSize_p1/blockSize_p2;
-		remainSize_p2 = remainSize_p1%blockSize_p2;
-
-		if (blockCount_p2) {
-				RT_TRACE(_module_hal_init_c_, _drv_notice_,
-					 ("_BlockWrite: [P2] buffSize_p2(%d) blockSize_p2(%d) blockCount_p2(%d) remainSize_p2(%d)\n",
-					 (buffSize-offset), blockSize_p2 , blockCount_p2, remainSize_p2));
-		}
-
-		for (i = 0; i < blockCount_p2; i++) {
-			ret = usb_writeN(padapter, (FW_8188E_START_ADDRESS + offset + i*blockSize_p2), blockSize_p2, (bufferPtr + offset + i*blockSize_p2));
-
-			if (ret == _FAIL)
-				goto exit;
-		}
-	}
-
-	/* 3 Phase #3 */
-	if (remainSize_p2) {
-		offset = (blockCount_p1 * blockSize_p1) + (blockCount_p2 * blockSize_p2);
-
-		blockCount_p3 = remainSize_p2 / blockSize_p3;
-
-		RT_TRACE(_module_hal_init_c_, _drv_notice_,
-			 ("_BlockWrite: [P3] buffSize_p3(%d) blockSize_p3(%d) blockCount_p3(%d)\n",
-			 (buffSize-offset), blockSize_p3, blockCount_p3));
-
-		for (i = 0; i < blockCount_p3; i++) {
-			ret = usb_write8(padapter, (FW_8188E_START_ADDRESS + offset + i), *(bufferPtr + offset + i));
-
-			if (ret == _FAIL)
-				goto exit;
-		}
-	}
-
-exit:
-	return ret;
-}
-
-static int _PageWrite(struct adapter *padapter, u32 page, void *buffer, u32 size)
-{
-	u8 value8;
-	u8 u8Page = (u8)(page & 0x07);
-
-	value8 = (usb_read8(padapter, REG_MCUFWDL+2) & 0xF8) | u8Page;
-	usb_write8(padapter, REG_MCUFWDL+2, value8);
-
-	return _BlockWrite(padapter, buffer, size);
-}
-
-static int _WriteFW(struct adapter *padapter, void *buffer, u32 size)
-{
-	/*  Since we need dynamic decide method of dwonload fw, so we call this function to get chip version. */
-	/*  We can remove _ReadChipVersion from ReadpadapterInfo8192C later. */
-	int ret = _SUCCESS;
-	u32	pageNums, remainSize;
-	u32	page, offset;
-	u8 *bufferPtr = (u8 *)buffer;
-
-	pageNums = size / MAX_PAGE_SIZE;
-	remainSize = size % MAX_PAGE_SIZE;
-
-	for (page = 0; page < pageNums; page++) {
-		offset = page * MAX_PAGE_SIZE;
-		ret = _PageWrite(padapter, page, bufferPtr+offset, MAX_PAGE_SIZE);
-
-		if (ret == _FAIL)
-			goto exit;
-	}
-	if (remainSize) {
-		offset = pageNums * MAX_PAGE_SIZE;
-		page = pageNums;
-		ret = _PageWrite(padapter, page, bufferPtr+offset, remainSize);
-
-		if (ret == _FAIL)
-			goto exit;
-	}
-	RT_TRACE(_module_hal_init_c_, _drv_info_, ("_WriteFW Done- for Normal chip.\n"));
-exit:
-	return ret;
-}
-
 void _8051Reset88E(struct adapter *padapter)
 {
 	u8 u1bTmp;
@@ -319,167 +182,6 @@ void _8051Reset88E(struct adapter *padapter)
 	DBG_88E("=====> _8051Reset88E(): 8051 reset success .\n");
 }
 
-static s32 _FWFreeToGo(struct adapter *padapter)
-{
-	u32	counter = 0;
-	u32	value32;
-
-	/*  polling CheckSum report */
-	do {
-		value32 = usb_read32(padapter, REG_MCUFWDL);
-		if (value32 & FWDL_ChkSum_rpt)
-			break;
-	} while (counter++ < POLLING_READY_TIMEOUT_COUNT);
-
-	if (counter >= POLLING_READY_TIMEOUT_COUNT) {
-		DBG_88E("%s: chksum report fail! REG_MCUFWDL:0x%08x\n", __func__, value32);
-		return _FAIL;
-	}
-	DBG_88E("%s: Checksum report OK! REG_MCUFWDL:0x%08x\n", __func__, value32);
-
-	value32 = usb_read32(padapter, REG_MCUFWDL);
-	value32 |= MCUFWDL_RDY;
-	value32 &= ~WINTINI_RDY;
-	usb_write32(padapter, REG_MCUFWDL, value32);
-
-	_8051Reset88E(padapter);
-
-	/*  polling for FW ready */
-	counter = 0;
-	do {
-		value32 = usb_read32(padapter, REG_MCUFWDL);
-		if (value32 & WINTINI_RDY) {
-			DBG_88E("%s: Polling FW ready success!! REG_MCUFWDL:0x%08x\n", __func__, value32);
-			return _SUCCESS;
-		}
-		udelay(5);
-	} while (counter++ < POLLING_READY_TIMEOUT_COUNT);
-
-	DBG_88E("%s: Polling FW ready fail!! REG_MCUFWDL:0x%08x\n", __func__, value32);
-	return _FAIL;
-}
-
-#define IS_FW_81xxC(padapter)	(((GET_HAL_DATA(padapter))->FirmwareSignature & 0xFFF0) == 0x88C0)
-
-static int load_firmware(struct rt_firmware *pFirmware, struct device *device)
-{
-	int rtstatus = _SUCCESS;
-	const struct firmware *fw;
-	const char fw_name[] = "rtlwifi/rtl8188eufw.bin";
-
-	if (request_firmware(&fw, fw_name, device)) {
-		rtstatus = _FAIL;
-		goto exit;
-	}
-	if (!fw) {
-		pr_err("Firmware %s not available\n", fw_name);
-		rtstatus = _FAIL;
-		goto exit;
-	}
-	if (fw->size > FW_8188E_SIZE) {
-		rtstatus = _FAIL;
-		RT_TRACE(_module_hal_init_c_, _drv_err_,
-			 ("Firmware size exceed 0x%X. Check it.\n",
-			 FW_8188E_SIZE));
-		goto exit;
-	}
-
-	pFirmware->szFwBuffer = kzalloc(FW_8188E_SIZE, GFP_KERNEL);
-	if (!pFirmware->szFwBuffer) {
-		rtstatus = _FAIL;
-		goto exit;
-	}
-	memcpy(pFirmware->szFwBuffer, fw->data, fw->size);
-	pFirmware->ulFwLength = fw->size;
-	release_firmware(fw);
-
-	DBG_88E_LEVEL(_drv_info_,
-		      "+%s: !bUsedWoWLANFw, FmrmwareLen:%d+\n", __func__,
-		      pFirmware->ulFwLength);
-exit:
-	return rtstatus;
-}
-
-s32 rtl8188e_FirmwareDownload(struct adapter *padapter)
-{
-	s32	rtStatus = _SUCCESS;
-	u8 writeFW_retry = 0;
-	u32 fwdl_start_time;
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(padapter);
-	struct dvobj_priv *dvobj = adapter_to_dvobj(padapter);
-	struct device *device = dvobj_to_dev(dvobj);
-	struct rt_firmware_hdr *pFwHdr = NULL;
-	u8 *pFirmwareBuf;
-	u32 FirmwareLen;
-	static int log_version;
-
-	RT_TRACE(_module_hal_init_c_, _drv_info_, ("+%s\n", __func__));
-	if (!dvobj->firmware.szFwBuffer)
-		rtStatus = load_firmware(&dvobj->firmware, device);
-	if (rtStatus == _FAIL) {
-		dvobj->firmware.szFwBuffer = NULL;
-		goto Exit;
-	}
-	pFirmwareBuf = dvobj->firmware.szFwBuffer;
-	FirmwareLen = dvobj->firmware.ulFwLength;
-
-	/*  To Check Fw header. Added by tynli. 2009.12.04. */
-	pFwHdr = (struct rt_firmware_hdr *)dvobj->firmware.szFwBuffer;
-
-	pHalData->FirmwareVersion =  le16_to_cpu(pFwHdr->Version);
-	pHalData->FirmwareSubVersion = pFwHdr->Subversion;
-	pHalData->FirmwareSignature = le16_to_cpu(pFwHdr->Signature);
-
-	if (!log_version++)
-		pr_info("%sFirmware Version %d, SubVersion %d, Signature 0x%x\n",
-			DRIVER_PREFIX, pHalData->FirmwareVersion,
-			pHalData->FirmwareSubVersion, pHalData->FirmwareSignature);
-
-	if (IS_FW_HEADER_EXIST(pFwHdr)) {
-		/*  Shift 32 bytes for FW header */
-		pFirmwareBuf = pFirmwareBuf + 32;
-		FirmwareLen = FirmwareLen - 32;
-	}
-
-	/*  Suggested by Filen. If 8051 is running in RAM code, driver should inform Fw to reset by itself, */
-	/*  or it will cause download Fw fail. 2010.02.01. by tynli. */
-	if (usb_read8(padapter, REG_MCUFWDL) & RAM_DL_SEL) { /* 8051 RAM code */
-		usb_write8(padapter, REG_MCUFWDL, 0x00);
-		_8051Reset88E(padapter);
-	}
-
-	_FWDownloadEnable(padapter, true);
-	fwdl_start_time = jiffies;
-	while (1) {
-		/* reset the FWDL chksum */
-		usb_write8(padapter, REG_MCUFWDL, usb_read8(padapter, REG_MCUFWDL) | FWDL_ChkSum_rpt);
-
-		rtStatus = _WriteFW(padapter, pFirmwareBuf, FirmwareLen);
-
-		if (rtStatus == _SUCCESS ||
-		    (rtw_get_passing_time_ms(fwdl_start_time) > 500 && writeFW_retry++ >= 3))
-			break;
-
-		DBG_88E("%s writeFW_retry:%u, time after fwdl_start_time:%ums\n",
-			__func__, writeFW_retry, rtw_get_passing_time_ms(fwdl_start_time)
-		);
-	}
-	_FWDownloadEnable(padapter, false);
-	if (_SUCCESS != rtStatus) {
-		DBG_88E("DL Firmware failed!\n");
-		goto Exit;
-	}
-
-	rtStatus = _FWFreeToGo(padapter);
-	if (_SUCCESS != rtStatus) {
-		DBG_88E("DL Firmware failed!\n");
-		goto Exit;
-	}
-	RT_TRACE(_module_hal_init_c_, _drv_info_, ("Firmware is ready to run!\n"));
-Exit:
-	return rtStatus;
-}
-
 void rtl8188e_InitializeFirmwareVars(struct adapter *padapter)
 {
 	struct hal_data_8188e *pHalData = GET_HAL_DATA(padapter);
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index e1839331..42541c5 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -22,7 +22,7 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 #include <rtw_efuse.h>
-
+#include <fw.h>
 #include <rtl8188e_hal.h>
 #include <rtl8188e_led.h>
 #include <rtw_iol.h>
@@ -744,9 +744,9 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 		Adapter->bFWReady = false;
 		haldata->fw_ractrl = false;
 	} else {
-		status = rtl8188e_FirmwareDownload(Adapter);
+		status = rtl88e_download_fw(Adapter);
 
-		if (status != _SUCCESS) {
+		if (status) {
 			DBG_88E("%s: Download Firmware failed!!\n", __func__);
 			Adapter->bFWReady = false;
 			haldata->fw_ractrl = false;
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 8f42d48..c813179 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -141,15 +141,8 @@ struct registry_priv {
 
 #define MAX_CONTINUAL_URB_ERR		4
 
-struct rt_firmware {
-	u8			*szFwBuffer;
-	u32			ulFwLength;
-};
-
 struct dvobj_priv {
 	struct adapter *if1;
-	struct rt_firmware firmware;
-
 	/* For 92D, DMDP have 2 interface. */
 	u8	InterfaceNumber;
 	u8	NumInterfaces;
diff --git a/drivers/staging/rtl8188eu/include/fw.h b/drivers/staging/rtl8188eu/include/fw.h
new file mode 100644
index 0000000..c7c7e7e
--- /dev/null
+++ b/drivers/staging/rtl8188eu/include/fw.h
@@ -0,0 +1,59 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2013  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+#include "drv_types.h"
+#include <linux/types.h>
+
+#ifndef __RTL92C__FW__H__
+#define __RTL92C__FW__H__
+
+#define FW_8192C_START_ADDRESS		0x1000
+#define FW_8192C_PAGE_SIZE			4096
+#define FW_8192C_POLLING_DELAY		5
+
+struct rtl92c_firmware_header {
+	u16 signature;
+	u8 category;
+	u8 function;
+	u16 version;
+	u8 subversion;
+	u8 rsvd1;
+	u8 month;
+	u8 date;
+	u8 hour;
+	u8 minute;
+	u16 ramcodesize;
+	u16 rsvd2;
+	u32 svnindex;
+	u32 rsvd3;
+	u32 rsvd4;
+	u32 rsvd5;
+};
+
+int rtl88e_download_fw(struct adapter *adapt);
+
+#endif
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index fb20653..8b73c03 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -70,45 +70,10 @@
 #define MAX_PAGE_SIZE			4096	/*  @ page : 4k bytes */
 
 #define IS_FW_HEADER_EXIST(_pFwHdr)				\
-	((le16_to_cpu(_pFwHdr->Signature)&0xFFF0) == 0x92C0 ||	\
-	(le16_to_cpu(_pFwHdr->Signature)&0xFFF0) == 0x88C0 ||	\
-	(le16_to_cpu(_pFwHdr->Signature)&0xFFF0) == 0x2300 ||	\
-	(le16_to_cpu(_pFwHdr->Signature)&0xFFF0) == 0x88E0)
-
-/*  This structure must be careful with byte-ordering */
-
-struct rt_firmware_hdr {
-	/*  8-byte alinment required */
-	/*  LONG WORD 0 ---- */
-	__le16		Signature;	/* 92C0: test chip; 92C,
-					 * 88C0: test chip; 88C1: MP A-cut;
-					 * 92C1: MP A-cut */
-	u8		Category;	/*  AP/NIC and USB/PCI */
-	u8		Function;	/*  Reserved for different FW function
-					 *  indcation, for further use when
-					 *  driver needs to download different
-					 *  FW for different conditions */
-	__le16		Version;	/*  FW Version */
-	u8		Subversion;	/*  FW Subversion, default 0x00 */
-	u16		Rsvd1;
-
-	/*  LONG WORD 1 ---- */
-	u8		Month;	/*  Release time Month field */
-	u8		Date;	/*  Release time Date field */
-	u8		Hour;	/*  Release time Hour field */
-	u8		Minute;	/*  Release time Minute field */
-	__le16		RamCodeSize;	/*  The size of RAM code */
-	u8		Foundry;
-	u8		Rsvd2;
-
-	/*  LONG WORD 2 ---- */
-	__le32		SvnIdx;	/*  The SVN entry index */
-	u32		Rsvd3;
-
-	/*  LONG WORD 3 ---- */
-	u32		Rsvd4;
-	u32		Rsvd5;
-};
+	((le16_to_cpu(_pFwHdr->signature)&0xFFF0) == 0x92C0 ||	\
+	(le16_to_cpu(_pFwHdr->signature)&0xFFF0) == 0x88C0 ||	\
+	(le16_to_cpu(_pFwHdr->signature)&0xFFF0) == 0x2300 ||	\
+	(le16_to_cpu(_pFwHdr->signature)&0xFFF0) == 0x88E0)
 
 #define DRIVER_EARLY_INT_TIME		0x05
 #define BCN_DMA_ATIME_INT_TIME		0x02
@@ -242,7 +207,8 @@ struct hal_data_8188e {
 	struct HAL_VERSION	VersionID;
 	enum rt_regulator_mode RegulatorMode; /*  switching regulator or LDO */
 	u16	CustomerID;
-
+	u8 *pfirmware;
+	u32 fwsize;
 	u16	FirmwareVersion;
 	u16	FirmwareVersionRev;
 	u16	FirmwareSubVersion;
@@ -419,7 +385,6 @@ struct hal_data_8188e {
 	(GET_HAL_DATA(_Adapter)->MultiFunc & RT_MULTI_FUNC_GPS)
 
 /*  rtl8188e_hal_init.c */
-s32 rtl8188e_FirmwareDownload(struct adapter *padapter);
 void _8051Reset88E(struct adapter *padapter);
 void rtl8188e_InitializeFirmwareVars(struct adapter *padapter);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index c7a44ab..08a80f7 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -26,6 +26,7 @@
 #include <recv_osdep.h>
 #include <hal_intf.h>
 #include <rtw_ioctl.h>
+#include <rtl8188e_hal.h>
 
 #include <usb_hal.h>
 
@@ -1121,7 +1122,7 @@ int pm_netdev_open(struct net_device *pnetdev, u8 bnormal)
 int netdev_close(struct net_device *pnetdev)
 {
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(pnetdev);
-	struct dvobj_priv *dvobj = adapter_to_dvobj(padapter);
+	struct hal_data_8188e *rtlhal = GET_HAL_DATA(padapter);
 
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("+88eu_drv - drv_close\n"));
 
@@ -1154,8 +1155,8 @@ int netdev_close(struct net_device *pnetdev)
 		rtw_led_control(padapter, LED_CTL_POWER_OFF);
 	}
 
-	kfree(dvobj->firmware.szFwBuffer);
-	dvobj->firmware.szFwBuffer = NULL;
+	kfree(rtlhal->pfirmware);
+	rtlhal->pfirmware = NULL;
 
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("-88eu_drv - drv_close\n"));
 	DBG_88E("-88eu_drv - drv_close, bup =%d\n", padapter->bup);
-- 
1.7.10.4

