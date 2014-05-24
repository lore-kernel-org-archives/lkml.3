Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbaEXITx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 04:19:53 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57895 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaEXITs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 04:19:48 -0400
Date: Sat, 24 May 2014 18:19:27 +1000
From: Vitaly Osipov <vitaly.osipov@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: remove _malloc()
Message-ID: <20140524081927.GA15839@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all usage of _malloc() and the function itself. Most
uses are straightforward replacements by kmalloc(..., GFP_ATOMIC),
because this was the definition of _malloc(). In a few places it
was possible to use kzalloc() or memdup_user.

A further improvement would be to replace GFP_ATOMIC with GFP_KERNEL
where possible.

Verified by compilation only.

Initial replacement done by running a Coccinelle script along the lines
of:

@@
type T;
expression E;
identifier V;
@@
- V = (T) _malloc(E);
+ V = kmalloc(E, GFP_ATOMIC);

@@
expression E, E1;
@@
- E1 = _malloc(E);
+ E1 = kmalloc(E, GFP_ATOMIC);

Signed-off-by: Vitaly Osipov <vitaly.osipov@gmail.com>
---
 drivers/staging/rtl8712/hal_init.c            |   2 +-
 drivers/staging/rtl8712/mlme_linux.c          |   3 +-
 drivers/staging/rtl8712/osdep_service.h       |   5 --
 drivers/staging/rtl8712/rtl8712_recv.c        |   6 +-
 drivers/staging/rtl8712/rtl871x_cmd.c         | 123 +++++++++++---------------
 drivers/staging/rtl8712/rtl871x_io.c          |  11 +--
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |  35 +++-----
 drivers/staging/rtl8712/rtl871x_mlme.c        |  17 ++--
 drivers/staging/rtl8712/rtl871x_mp.c          |  10 +--
 drivers/staging/rtl8712/rtl871x_recv.c        |   6 +-
 drivers/staging/rtl8712/rtl871x_sta_mgt.c     |   4 +-
 drivers/staging/rtl8712/rtl871x_xmit.c        |  16 ++--
 drivers/staging/rtl8712/usb_ops_linux.c       |   2 +-
 13 files changed, 102 insertions(+), 138 deletions(-)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index d801c5a..36de7e4 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -183,7 +183,7 @@ static u8 rtl8712_dl_fw(struct _adapter *padapter)
 		maxlen = (fwhdr.img_IMEM_size > fwhdr.img_SRAM_size) ?
 			  fwhdr.img_IMEM_size : fwhdr.img_SRAM_size;
 		maxlen += txdscp_sz;
-		ptmpchar = _malloc(maxlen + FWBUFF_ALIGN_SZ);
+		ptmpchar = kmalloc(maxlen + FWBUFF_ALIGN_SZ, GFP_ATOMIC);
 		if (ptmpchar == NULL)
 			return ret;
 
diff --git a/drivers/staging/rtl8712/mlme_linux.c b/drivers/staging/rtl8712/mlme_linux.c
index f569a70..377efb8 100644
--- a/drivers/staging/rtl8712/mlme_linux.c
+++ b/drivers/staging/rtl8712/mlme_linux.c
@@ -147,10 +147,9 @@ void r8712_report_sec_ie(struct _adapter *adapter, u8 authmode, u8 *sec_ie)
 
 	buff = NULL;
 	if (authmode == _WPA_IE_ID_) {
-		buff = _malloc(IW_CUSTOM_MAX);
+		buff = kzalloc(IW_CUSTOM_MAX, GFP_ATOMIC);
 		if (buff == NULL)
 			return;
-		memset(buff, 0, IW_CUSTOM_MAX);
 		p = buff;
 		p += sprintf(p, "ASSOCINFO(ReqIEs=");
 		len = sec_ie[1] + 2;
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 566235a..09e1561 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -168,11 +168,6 @@ static inline void sleep_schedulable(int ms)
 		return;
 }
 
-static inline u8 *_malloc(u32 sz)
-{
-	return	kmalloc(sz, GFP_ATOMIC);
-}
-
 static inline unsigned char _cancel_timer_ex(struct timer_list *ptimer)
 {
 	return del_timer(ptimer);
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index 667398a..1f70017 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -58,12 +58,10 @@ int r8712_init_recv_priv(struct recv_priv *precvpriv, struct _adapter *padapter)
 
 	/*init recv_buf*/
 	_init_queue(&precvpriv->free_recv_buf_queue);
-	precvpriv->pallocated_recv_buf = _malloc(NR_RECVBUFF *
-					 sizeof(struct recv_buf) + 4);
+	precvpriv->pallocated_recv_buf = kzalloc(NR_RECVBUFF * sizeof(struct recv_buf) + 4,
+						 GFP_ATOMIC);
 	if (precvpriv->pallocated_recv_buf == NULL)
 		return _FAIL;
-	memset(precvpriv->pallocated_recv_buf, 0, NR_RECVBUFF *
-		sizeof(struct recv_buf) + 4);
 	precvpriv->precv_buf = precvpriv->pallocated_recv_buf + 4 -
 			      ((addr_t) (precvpriv->pallocated_recv_buf) & 3);
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index a67185d..6a3cecc 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -64,13 +64,14 @@ static sint _init_cmd_priv(struct cmd_priv *pcmdpriv)
 
 	/* allocate DMA-able/Non-Page memory for cmd_buf and rsp_buf */
 	pcmdpriv->cmd_seq = 1;
-	pcmdpriv->cmd_allocated_buf = _malloc(MAX_CMDSZ + CMDBUFF_ALIGN_SZ);
+	pcmdpriv->cmd_allocated_buf = kmalloc(MAX_CMDSZ + CMDBUFF_ALIGN_SZ,
+					      GFP_ATOMIC);
 	if (pcmdpriv->cmd_allocated_buf == NULL)
 		return _FAIL;
 	pcmdpriv->cmd_buf = pcmdpriv->cmd_allocated_buf  +  CMDBUFF_ALIGN_SZ -
 			    ((addr_t)(pcmdpriv->cmd_allocated_buf) &
 			    (CMDBUFF_ALIGN_SZ-1));
-	pcmdpriv->rsp_allocated_buf = _malloc(MAX_RSPSZ + 4);
+	pcmdpriv->rsp_allocated_buf = kmalloc(MAX_RSPSZ + 4, GFP_ATOMIC);
 	if (pcmdpriv->rsp_allocated_buf == NULL)
 		return _FAIL;
 	pcmdpriv->rsp_buf = pcmdpriv->rsp_allocated_buf  +  4 -
@@ -85,7 +86,7 @@ static sint _init_evt_priv(struct evt_priv *pevtpriv)
 {
 	/* allocate DMA-able/Non-Page memory for cmd_buf and rsp_buf */
 	pevtpriv->event_seq = 0;
-	pevtpriv->evt_allocated_buf = _malloc(MAX_EVTSZ + 4);
+	pevtpriv->evt_allocated_buf = kmalloc(MAX_EVTSZ + 4, GFP_ATOMIC);
 
 	if (pevtpriv->evt_allocated_buf == NULL)
 		return _FAIL;
@@ -226,11 +227,10 @@ u8 r8712_sitesurvey_cmd(struct _adapter *padapter,
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psurveyPara = (struct sitesurvey_parm *)_malloc(
-		       sizeof(struct sitesurvey_parm));
+	psurveyPara = kmalloc(sizeof(struct sitesurvey_parm), GFP_ATOMIC);
 	if (psurveyPara == NULL) {
 		kfree((unsigned char *) ph2c);
 		return _FAIL;
@@ -259,11 +259,11 @@ u8 r8712_setdatarate_cmd(struct _adapter *padapter, u8 *rateset)
 	struct setdatarate_parm	*pbsetdataratepara;
 	struct cmd_priv		*pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pbsetdataratepara = (struct setdatarate_parm *)_malloc(
-			     sizeof(struct setdatarate_parm));
+	pbsetdataratepara = kmalloc(sizeof(struct setdatarate_parm),
+				    GFP_ATOMIC);
 	if (pbsetdataratepara == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -282,11 +282,11 @@ u8 r8712_set_chplan_cmd(struct _adapter *padapter, int chplan)
 	struct SetChannelPlan_param *psetchplanpara;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetchplanpara = (struct SetChannelPlan_param *)
-		_malloc(sizeof(struct SetChannelPlan_param));
+	psetchplanpara = kmalloc(sizeof(struct SetChannelPlan_param),
+				 GFP_ATOMIC);
 	if (psetchplanpara == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -304,11 +304,11 @@ u8 r8712_setbasicrate_cmd(struct _adapter *padapter, u8 *rateset)
 	struct setbasicrate_parm *pssetbasicratepara;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pssetbasicratepara = (struct setbasicrate_parm *)_malloc(
-			      sizeof(struct setbasicrate_parm));
+	pssetbasicratepara = kmalloc(sizeof(struct setbasicrate_parm),
+				     GFP_ATOMIC);
 	if (pssetbasicratepara == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -327,11 +327,10 @@ u8 r8712_setptm_cmd(struct _adapter *padapter, u8 type)
 	struct writePTM_parm	*pwriteptmparm;
 	struct cmd_priv		*pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pwriteptmparm = (struct writePTM_parm *)
-		_malloc(sizeof(struct writePTM_parm));
+	pwriteptmparm = kmalloc(sizeof(struct writePTM_parm), GFP_ATOMIC);
 	if (pwriteptmparm == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -348,11 +347,10 @@ u8 r8712_setfwdig_cmd(struct _adapter *padapter, u8 type)
 	struct writePTM_parm *pwriteptmparm;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pwriteptmparm = (struct writePTM_parm *)
-		_malloc(sizeof(struct setdig_parm));
+	pwriteptmparm = kmalloc(sizeof(struct setdig_parm), GFP_ATOMIC);
 	if (pwriteptmparm == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -369,11 +367,10 @@ u8 r8712_setfwra_cmd(struct _adapter *padapter, u8 type)
 	struct writePTM_parm *pwriteptmparm;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pwriteptmparm = (struct writePTM_parm *)
-		_malloc(sizeof(struct setra_parm));
+	pwriteptmparm = kmalloc(sizeof(struct setra_parm), GFP_ATOMIC);
 	if (pwriteptmparm == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -390,11 +387,10 @@ u8 r8712_setrfreg_cmd(struct _adapter  *padapter, u8 offset, u32 val)
 	struct writeRF_parm *pwriterfparm;
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pwriterfparm = (struct writeRF_parm *)_malloc(
-			sizeof(struct writeRF_parm));
+	pwriterfparm = kmalloc(sizeof(struct writeRF_parm), GFP_ATOMIC);
 	if (pwriterfparm == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -412,10 +408,10 @@ u8 r8712_getrfreg_cmd(struct _adapter *padapter, u8 offset, u8 *pval)
 	struct readRF_parm *prdrfparm;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	prdrfparm = (struct readRF_parm *)_malloc(sizeof(struct readRF_parm));
+	prdrfparm = kmalloc(sizeof(struct readRF_parm), GFP_ATOMIC);
 	if (prdrfparm == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -456,7 +452,7 @@ u8 r8712_createbss_cmd(struct _adapter *padapter)
 				 &padapter->registrypriv.dev_network;
 
 	padapter->ledpriv.LedControlHandler(padapter, LED_CTL_START_TO_LINK);
-	pcmd = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	pcmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (pcmd == NULL)
 		return _FAIL;
 	_init_listhead(&pcmd->list);
@@ -490,7 +486,7 @@ u8 r8712_joinbss_cmd(struct _adapter  *padapter, struct wlan_network *pnetwork)
 						network.InfrastructureMode;
 
 	padapter->ledpriv.LedControlHandler(padapter, LED_CTL_START_TO_LINK);
-	pcmd = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	pcmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (pcmd == NULL)
 		return _FAIL;
 	t_len = sizeof(u32) + 6 * sizeof(unsigned char) + 2 +
@@ -628,11 +624,10 @@ u8 r8712_disassoc_cmd(struct _adapter *padapter) /* for sta_mode */
 	struct disconnect_parm *pdisconnect;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	pdisconnect_cmd = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	pdisconnect_cmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (pdisconnect_cmd == NULL)
 		return _FAIL;
-	pdisconnect = (struct disconnect_parm *)_malloc(
-		      sizeof(struct disconnect_parm));
+	pdisconnect = kmalloc(sizeof(struct disconnect_parm), GFP_ATOMIC);
 	if (pdisconnect == NULL) {
 		kfree((u8 *)pdisconnect_cmd);
 		return _FAIL;
@@ -651,11 +646,10 @@ u8 r8712_setopmode_cmd(struct _adapter *padapter,
 
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetop = (struct setopmode_parm *)_malloc(
-		  sizeof(struct setopmode_parm));
+	psetop = kmalloc(sizeof(struct setopmode_parm), GFP_ATOMIC);
 	if (psetop == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -676,17 +670,15 @@ u8 r8712_setstakey_cmd(struct _adapter *padapter, u8 *psta, u8 unicast_key)
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 	struct sta_info *sta = (struct sta_info *)psta;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetstakey_para = (struct set_stakey_parm *)_malloc(
-			  sizeof(struct set_stakey_parm));
+	psetstakey_para = kmalloc(sizeof(struct set_stakey_parm), GFP_ATOMIC);
 	if (psetstakey_para == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
 	}
-	psetstakey_rsp = (struct set_stakey_rsp *)_malloc(
-			  sizeof(struct set_stakey_rsp));
+	psetstakey_rsp = kmalloc(sizeof(struct set_stakey_rsp), GFP_ATOMIC);
 	if (psetstakey_rsp == NULL) {
 		kfree((u8 *) ph2c);
 		kfree((u8 *) psetstakey_para);
@@ -718,11 +710,10 @@ u8 r8712_setrfintfs_cmd(struct _adapter *padapter, u8 mode)
 	struct setrfintfs_parm *psetrfintfsparm;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetrfintfsparm = (struct setrfintfs_parm *)_malloc(
-			   sizeof(struct setrfintfs_parm));
+	psetrfintfsparm = kmalloc(sizeof(struct setrfintfs_parm), GFP_ATOMIC);
 	if (psetrfintfsparm == NULL) {
 		kfree((unsigned char *) ph2c);
 		return _FAIL;
@@ -741,11 +732,10 @@ u8 r8712_setrttbl_cmd(struct _adapter *padapter,
 	struct setratable_parm *psetrttblparm;
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetrttblparm = (struct setratable_parm *)_malloc(
-			sizeof(struct setratable_parm));
+	psetrttblparm = kmalloc(sizeof(struct setratable_parm), GFP_ATOMIC);
 	if (psetrttblparm == NULL) {
 		kfree((unsigned char *)ph2c);
 		return _FAIL;
@@ -763,11 +753,10 @@ u8 r8712_gettssi_cmd(struct _adapter *padapter, u8 offset, u8 *pval)
 	struct cmd_obj *ph2c;
 	struct readTSSI_parm *prdtssiparm;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	prdtssiparm = (struct readTSSI_parm *)
-		_malloc(sizeof(struct readTSSI_parm));
+	prdtssiparm = kmalloc(sizeof(struct readTSSI_parm), GFP_ATOMIC);
 	if (prdtssiparm == NULL) {
 		kfree((unsigned char *) ph2c);
 		return _FAIL;
@@ -790,11 +779,11 @@ u8 r8712_setMacAddr_cmd(struct _adapter *padapter, u8 *mac_addr)
 	struct cmd_obj *ph2c;
 	struct SetMacAddr_param	*psetMacAddr_para;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetMacAddr_para = (struct SetMacAddr_param *)_malloc(
-			   sizeof(struct SetMacAddr_param));
+	psetMacAddr_para = kmalloc(sizeof(struct SetMacAddr_param),
+				   GFP_ATOMIC);
 	if (psetMacAddr_para == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -813,17 +802,17 @@ u8 r8712_setassocsta_cmd(struct _adapter *padapter, u8 *mac_addr)
 	struct set_assocsta_parm	*psetassocsta_para;
 	struct set_assocsta_rsp		*psetassocsta_rsp = NULL;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetassocsta_para = (struct set_assocsta_parm *)
-			    _malloc(sizeof(struct set_assocsta_parm));
+	psetassocsta_para = kmalloc(sizeof(struct set_assocsta_parm),
+				    GFP_ATOMIC);
 	if (psetassocsta_para == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
 	}
-	psetassocsta_rsp = (struct set_assocsta_rsp *)_malloc(
-			    sizeof(struct set_assocsta_rsp));
+	psetassocsta_rsp = kmalloc(sizeof(struct set_assocsta_rsp),
+				   GFP_ATOMIC);
 	if (psetassocsta_rsp == NULL) {
 		kfree((u8 *)ph2c);
 		kfree((u8 *)psetassocsta_para);
@@ -843,11 +832,10 @@ u8 r8712_addbareq_cmd(struct _adapter *padapter, u8 tid)
 	struct cmd_obj		*ph2c;
 	struct addBaReq_parm	*paddbareq_parm;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	paddbareq_parm = (struct addBaReq_parm *)_malloc(
-			  sizeof(struct addBaReq_parm));
+	paddbareq_parm = kmalloc(sizeof(struct addBaReq_parm), GFP_ATOMIC);
 	if (paddbareq_parm == NULL) {
 		kfree((unsigned char *)ph2c);
 		return _FAIL;
@@ -865,11 +853,10 @@ u8 r8712_wdg_wk_cmd(struct _adapter *padapter)
 	struct drvint_cmd_parm  *pdrvintcmd_param;
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pdrvintcmd_param = (struct drvint_cmd_parm *)_malloc(
-			   sizeof(struct drvint_cmd_parm));
+	pdrvintcmd_param = kmalloc(sizeof(struct drvint_cmd_parm), GFP_ATOMIC);
 	if (pdrvintcmd_param == NULL) {
 		kfree((unsigned char *)ph2c);
 		return _FAIL;
@@ -1040,16 +1027,14 @@ u8 r8712_disconnectCtrlEx_cmd(struct _adapter *adapter, u32 enableDrvCtrl,
 	struct DisconnectCtrlEx_param *param;
 	struct cmd_priv *pcmdpriv = &adapter->cmdpriv;
 
-	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	param = (struct DisconnectCtrlEx_param *)
-		_malloc(sizeof(struct DisconnectCtrlEx_param));
+	param = kzalloc(sizeof(struct DisconnectCtrlEx_param), GFP_ATOMIC);
 	if (param == NULL) {
 		kfree((unsigned char *) ph2c);
 		return _FAIL;
 	}
-	memset(param, 0, sizeof(struct DisconnectCtrlEx_param));
 
 	param->EnableDrvCtrl = (unsigned char)enableDrvCtrl;
 	param->TryPktCnt = (unsigned char)tryPktCnt;
diff --git a/drivers/staging/rtl8712/rtl871x_io.c b/drivers/staging/rtl8712/rtl871x_io.c
index abc1c97..37a841a 100644
--- a/drivers/staging/rtl8712/rtl871x_io.c
+++ b/drivers/staging/rtl8712/rtl871x_io.c
@@ -60,8 +60,8 @@ static uint _init_intf_hdl(struct _adapter *padapter,
 	set_intf_funs = &(r8712_usb_set_intf_funs);
 	set_intf_ops = &r8712_usb_set_intf_ops;
 	init_intf_priv = &r8712_usb_init_intf_priv;
-	pintf_priv = pintf_hdl->pintfpriv = (struct intf_priv *)
-		     _malloc(sizeof(struct intf_priv));
+	pintf_priv = pintf_hdl->pintfpriv = kmalloc(sizeof(struct intf_priv),
+						    GFP_ATOMIC);
 	if (pintf_priv == NULL)
 		goto _init_intf_hdl_fail;
 	pintf_hdl->adapter = (u8 *)padapter;
@@ -112,15 +112,16 @@ uint r8712_alloc_io_queue(struct _adapter *adapter)
 	struct io_queue *pio_queue;
 	struct io_req *pio_req;
 
-	pio_queue = (struct io_queue *)_malloc(sizeof(struct io_queue));
+	pio_queue = kmalloc(sizeof(struct io_queue), GFP_ATOMIC);
 	if (pio_queue == NULL)
 		goto alloc_io_queue_fail;
 	_init_listhead(&pio_queue->free_ioreqs);
 	_init_listhead(&pio_queue->processing);
 	_init_listhead(&pio_queue->pending);
 	spin_lock_init(&pio_queue->lock);
-	pio_queue->pallocated_free_ioreqs_buf = (u8 *)_malloc(NUM_IOREQ *
-						(sizeof(struct io_req)) + 4);
+	pio_queue->pallocated_free_ioreqs_buf = kmalloc(NUM_IOREQ *
+							(sizeof(struct io_req)) + 4,
+							GFP_ATOMIC);
 	if ((pio_queue->pallocated_free_ioreqs_buf) == NULL)
 		goto alloc_io_queue_fail;
 	memset(pio_queue->pallocated_free_ioreqs_buf, 0,
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 1eca992..e147c4b 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -424,10 +424,9 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 			wep_key_idx = 0;
 		if (wep_key_len > 0) {
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
-			pwep = (struct NDIS_802_11_WEP *)_malloc((u32)
-			       (wep_key_len +
-			       FIELD_OFFSET(struct NDIS_802_11_WEP,
-			       KeyMaterial)));
+			pwep = kmalloc((u32)(wep_key_len +
+				       FIELD_OFFSET(struct NDIS_802_11_WEP, KeyMaterial)),
+				       GFP_ATOMIC);
 			if (pwep == NULL)
 				return -ENOMEM;
 			memset(pwep, 0, sizeof(struct NDIS_802_11_WEP));
@@ -518,10 +517,9 @@ static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
 	if ((ielen > MAX_WPA_IE_LEN) || (pie == NULL))
 		return -EINVAL;
 	if (ielen) {
-		buf = _malloc(ielen);
+		buf = kmemdup(pie, ielen, GFP_ATOMIC);
 		if (buf == NULL)
 			return -ENOMEM;
-		memcpy(buf, pie , ielen);
 		pos = buf;
 		if (ielen < RSN_HEADER_LEN) {
 			ret  = -EINVAL;
@@ -959,13 +957,9 @@ static int r871x_wx_set_priv(struct net_device *dev,
 	struct iw_point *dwrq = (struct iw_point *)awrq;
 
 	len = dwrq->length;
-	ext = _malloc(len);
-	if (!ext)
-		return -ENOMEM;
-	if (copy_from_user(ext, dwrq->pointer, len)) {
-		kfree(ext);
-		return -EFAULT;
-	}
+	ext = memdup_user(dwrq->pointer, len);
+	if (IS_ERR(ext))
+		return PTR_ERR(ext);
 
 	if (0 == strcasecmp(ext, "RSSI")) {
 		/*Return received signal strength indicator in -db for */
@@ -1819,10 +1813,9 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
 	}
 
 	param_len = sizeof(struct ieee_param) + pext->key_len;
-	param = (struct ieee_param *)_malloc(param_len);
+	param = kzalloc(param_len, GFP_ATOMIC);
 	if (param == NULL)
 		return -ENOMEM;
-	memset(param, 0, param_len);
 	param->cmd = IEEE_CMD_SET_ENCRYPTION;
 	memset(param->sta_addr, 0xff, ETH_ALEN);
 
@@ -1922,7 +1915,7 @@ static int r871x_mp_ioctl_hdl(struct net_device *dev,
 	bset = (u8)(p->flags & 0xFFFF);
 	len = p->length;
 	pparmbuf = NULL;
-	pparmbuf = (u8 *)_malloc(len);
+	pparmbuf = kmalloc(len, GFP_ATOMIC);
 	if (pparmbuf == NULL) {
 		ret = -ENOMEM;
 		goto _r871x_mp_ioctl_hdl_exit;
@@ -2195,13 +2188,9 @@ static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
 
 	if (p->length < sizeof(struct ieee_param) || !p->pointer)
 		return -EINVAL;
-	param = (struct ieee_param *)_malloc(p->length);
-	if (param == NULL)
-		return -ENOMEM;
-	if (copy_from_user(param, p->pointer, p->length)) {
-		kfree((u8 *)param);
-		return -EFAULT;
-	}
+	param = memdup_user(p->pointer, p->length);
+	if (IS_ERR(param))
+		return PTR_ERR(param);
 	switch (param->cmd) {
 	case IEEE_CMD_SET_WPA_PARAM:
 		ret = wpa_set_param(dev, param->u.wpa_param.name,
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index f8f651a..02339e1 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -62,7 +62,8 @@ static sint _init_mlme_priv(struct _adapter *padapter)
 	_init_queue(&(pmlmepriv->scanned_queue));
 	set_scanned_network_val(pmlmepriv, 0);
 	memset(&pmlmepriv->assoc_ssid, 0, sizeof(struct ndis_802_11_ssid));
-	pbuf = _malloc(MAX_BSS_CNT * (sizeof(struct wlan_network)));
+	pbuf = kmalloc(MAX_BSS_CNT * (sizeof(struct wlan_network)),
+		       GFP_ATOMIC);
 	if (pbuf == NULL)
 		return _FAIL;
 	pmlmepriv->free_bss_buf = pbuf;
@@ -725,8 +726,7 @@ void r8712_joinbss_event_callback(struct _adapter *adapter, u8 *pbuf)
 	struct wlan_network *pnetwork;
 
 	if (sizeof(struct list_head) == 4 * sizeof(u32)) {
-		pnetwork = (struct wlan_network *)
-			_malloc(sizeof(struct wlan_network));
+		pnetwork = kmalloc(sizeof(struct wlan_network), GFP_ATOMIC);
 		memcpy((u8 *)pnetwork+16, (u8 *)pbuf + 8,
 			sizeof(struct wlan_network) - 16);
 	} else
@@ -1212,17 +1212,15 @@ sint r8712_set_auth(struct _adapter *adapter,
 	struct cmd_obj *pcmd;
 	struct setauth_parm *psetauthparm;
 
-	pcmd = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	pcmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (pcmd == NULL)
 		return _FAIL;
 
-	psetauthparm = (struct setauth_parm *)_malloc(
-			sizeof(struct setauth_parm));
+	psetauthparm = kzalloc(sizeof(struct setauth_parm), GFP_ATOMIC);
 	if (psetauthparm == NULL) {
 		kfree((unsigned char *)pcmd);
 		return _FAIL;
 	}
-	memset(psetauthparm, 0, sizeof(struct setauth_parm));
 	psetauthparm->mode = (u8)psecuritypriv->AuthAlgrthm;
 	pcmd->cmdcode = _SetAuth_CMD_;
 	pcmd->parmbuf = (unsigned char *)psetauthparm;
@@ -1244,15 +1242,14 @@ sint r8712_set_key(struct _adapter *adapter,
 	u8 keylen;
 	sint ret = _SUCCESS;
 
-	pcmd = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	pcmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (pcmd == NULL)
 		return _FAIL;
-	psetkeyparm = (struct setkey_parm *)_malloc(sizeof(struct setkey_parm));
+	psetkeyparm = kzalloc(sizeof(struct setkey_parm), GFP_ATOMIC);
 	if (psetkeyparm == NULL) {
 		ret = _FAIL;
 		goto err_free_cmd;
 	}
-	memset(psetkeyparm, 0, sizeof(struct setkey_parm));
 	if (psecuritypriv->AuthAlgrthm == 2) { /* 802.1X */
 		psetkeyparm->algorithm =
 			 (u8)psecuritypriv->XGrpPrivacy;
diff --git a/drivers/staging/rtl8712/rtl871x_mp.c b/drivers/staging/rtl8712/rtl871x_mp.c
index 5fd60cd..389062f 100644
--- a/drivers/staging/rtl8712/rtl871x_mp.c
+++ b/drivers/staging/rtl8712/rtl871x_mp.c
@@ -53,8 +53,9 @@ static int init_mp_priv(struct mp_priv *pmp_priv)
 	_init_mp_priv_(pmp_priv);
 	_init_queue(&pmp_priv->free_mp_xmitqueue);
 	pmp_priv->pallocated_mp_xmitframe_buf = NULL;
-	pmp_priv->pallocated_mp_xmitframe_buf = _malloc(NR_MP_XMITFRAME *
-					 sizeof(struct mp_xmit_frame) + 4);
+	pmp_priv->pallocated_mp_xmitframe_buf = kmalloc(NR_MP_XMITFRAME *
+							sizeof(struct mp_xmit_frame) + 4,
+							GFP_ATOMIC);
 	if (pmp_priv->pallocated_mp_xmitframe_buf == NULL) {
 		res = _FAIL;
 		goto _exit_init_mp_priv;
@@ -280,11 +281,10 @@ void r8712_SetChannel(struct _adapter *pAdapter)
 	struct SetChannel_parm *pparm = NULL;
 	u16 code = GEN_CMD_CODE(_SetChannel);
 
-	pcmd = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	pcmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
 	if (pcmd == NULL)
 		return;
-	pparm = (struct SetChannel_parm *)_malloc(sizeof(struct
-					 SetChannel_parm));
+	pparm = kmalloc(sizeof(struct SetChannel_parm), GFP_ATOMIC);
 	if (pparm == NULL) {
 		kfree(pcmd);
 		return;
diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index 4ac4a1b..eb77587 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -72,9 +72,9 @@ sint _r8712_init_recv_priv(struct recv_priv *precvpriv,
 	_init_queue(&precvpriv->recv_pending_queue);
 	precvpriv->adapter = padapter;
 	precvpriv->free_recvframe_cnt = NR_RECVFRAME;
-	precvpriv->pallocated_frame_buf = _malloc(NR_RECVFRAME *
-					   sizeof(union recv_frame) +
-					   RXFRAME_ALIGN_SZ);
+	precvpriv->pallocated_frame_buf = kmalloc(NR_RECVFRAME *
+						  sizeof(union recv_frame) + RXFRAME_ALIGN_SZ,
+						  GFP_ATOMIC);
 	if (precvpriv->pallocated_frame_buf == NULL)
 		return _FAIL;
 	kmemleak_not_leak(precvpriv->pallocated_frame_buf);
diff --git a/drivers/staging/rtl8712/rtl871x_sta_mgt.c b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
index 8db6849..6c64984 100644
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -51,8 +51,8 @@ u32 _r8712_init_sta_priv(struct	sta_priv *pstapriv)
 	struct sta_info *psta;
 	s32 i;
 
-	pstapriv->pallocated_stainfo_buf = _malloc(sizeof(struct sta_info) *
-						   NUM_STA + 4);
+	pstapriv->pallocated_stainfo_buf = kmalloc(sizeof(struct sta_info) *
+						   NUM_STA + 4, GFP_ATOMIC);
 	if (pstapriv->pallocated_stainfo_buf == NULL)
 		return _FAIL;
 	pstapriv->pstainfo_buf = pstapriv->pallocated_stainfo_buf + 4 -
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index 78f570b..230681a 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -87,8 +87,8 @@ sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 	and initialize free_xmit_frame below.
 	Please also apply  free_txobj to link_up all the xmit_frames...
 	*/
-	pxmitpriv->pallocated_frame_buf = _malloc(NR_XMITFRAME *
-					  sizeof(struct xmit_frame) + 4);
+	pxmitpriv->pallocated_frame_buf = kmalloc(NR_XMITFRAME * sizeof(struct xmit_frame) + 4,
+						  GFP_ATOMIC);
 	if (pxmitpriv->pallocated_frame_buf == NULL) {
 		pxmitpriv->pxmit_frame_buf = NULL;
 		return _FAIL;
@@ -126,8 +126,8 @@ sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 	/*init xmit_buf*/
 	_init_queue(&pxmitpriv->free_xmitbuf_queue);
 	_init_queue(&pxmitpriv->pending_xmitbuf_queue);
-	pxmitpriv->pallocated_xmitbuf = _malloc(NR_XMITBUFF *
-					sizeof(struct xmit_buf) + 4);
+	pxmitpriv->pallocated_xmitbuf = kmalloc(NR_XMITBUFF * sizeof(struct xmit_buf) + 4,
+						GFP_ATOMIC);
 	if (pxmitpriv->pallocated_xmitbuf  == NULL)
 		return _FAIL;
 	pxmitpriv->pxmitbuf = pxmitpriv->pallocated_xmitbuf + 4 -
@@ -135,8 +135,8 @@ sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 	pxmitbuf = (struct xmit_buf *)pxmitpriv->pxmitbuf;
 	for (i = 0; i < NR_XMITBUFF; i++) {
 		_init_listhead(&pxmitbuf->list);
-		pxmitbuf->pallocated_buf = _malloc(MAX_XMITBUF_SZ +
-					   XMITBUF_ALIGN_SZ);
+		pxmitbuf->pallocated_buf = kmalloc(MAX_XMITBUF_SZ + XMITBUF_ALIGN_SZ,
+						   GFP_ATOMIC);
 		if (pxmitbuf->pallocated_buf == NULL)
 			return _FAIL;
 		pxmitbuf->pbuf = pxmitbuf->pallocated_buf + XMITBUF_ALIGN_SZ -
@@ -955,8 +955,8 @@ static void alloc_hwxmits(struct _adapter *padapter)
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
 	pxmitpriv->hwxmit_entry = HWXMIT_ENTRY;
-	pxmitpriv->hwxmits = (struct hw_xmit *)_malloc(sizeof(struct hw_xmit) *
-			     pxmitpriv->hwxmit_entry);
+	pxmitpriv->hwxmits = kmalloc(sizeof(struct hw_xmit) * pxmitpriv->hwxmit_entry,
+				     GFP_ATOMIC);
 	if (pxmitpriv->hwxmits == NULL)
 		return;
 	hwxmits = pxmitpriv->hwxmits;
diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index dca398a..064dc10 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -495,7 +495,7 @@ int r8712_usbctrl_vendorreq(struct intf_priv *pintfpriv, u8 request, u16 value,
 	 */
 	u8 *palloc_buf, *pIo_buf;
 
-	palloc_buf = _malloc((u32) len + 16);
+	palloc_buf = kmalloc((u32)len + 16, GFP_ATOMIC);
 	if (palloc_buf == NULL) {
 		dev_err(&udev->dev, "%s: Can't alloc memory for vendor request\n",
 			__func__);
-- 
1.9.1

