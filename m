Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaCGFxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:53:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:56736 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaCGFxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:53:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="scan'208";a="487721873"
Subject: [PATCH] [staging][r8188eu]: memory leak in rtw_free_cmd_obj if
 command is (_Set_Drv_Extra)
From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
To: gregkh@linuxfoundation.org, valentina.manea.m@gmail.com,
        dan.carpenter@oracle.com, standby24x7@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dongxing.zhang@intel.com, xiaoming.wang@intel.com,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Mar 2014 15:01:34 -0500
Message-ID: <1394222494.26112.32.camel@wxm-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcmd->parmbuf->pbuf has been allocated if command is GEN_CMD_CODE(_Set_Drv_Extra),
and it enqueued by rtw_enqueue_cmd. rtw_cmd_thread dequeue pcmd by rtw_dequeue_cmd.
The memory leak happened on this branch "if( _FAIL == rtw_cmd_filter(pcmdpriv, pcmd) )"
which goto post_process directly against freeing pcmd->parmbuf->pbuf in
rtw_drvextra_cmd_hdl which is the cmd_hdl if command is (_Set_Drv_Extra).
This patch free pcmd->parmbuf->pbuf on forgotten branch to avoid memory leak.

Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 82fe8c4..cec9db9 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -314,6 +314,7 @@ int rtw_cmd_thread(void *context)
        void (*pcmd_callback)(struct adapter *dev, struct cmd_obj *pcmd);
        struct adapter *padapter = (struct adapter *)context;
        struct cmd_priv *pcmdpriv = &(padapter->cmdpriv);
+       struct drvextra_cmd_parm *extra_parm = NULL;

 _func_enter_;

@@ -350,6 +351,11 @@ _next:

                if (_FAIL == rtw_cmd_filter(pcmdpriv, pcmd)) {
                        pcmd->res = H2C_DROPPED;
+                       if (pcmd->cmdcode == GEN_CMD_CODE(_Set_Drv_Extra)) {
+                               extra_parm = (struct drvextra_cmd_parm *)pcmd->parmbuf;
+                               if (extra_parm && extra_parm->pbuf && extra_parm->size > 0)
+                                       rtw_mfree(extra_parm->pbuf, extra_parm->size);
+                       }
                        goto post_process;
                }


