Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaCJBpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 21:45:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:60286 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbaCJBpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 21:45:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,621,1389772800"; 
   d="scan'208";a="495175511"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "valentina.manea.m@gmail.com" <valentina.manea.m@gmail.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "standby24x7@gmail.com" <standby24x7@gmail.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Dongxing" <dongxing.zhang@intel.com>
Subject: RE: [PATCH] [staging][r8188eu]: memory leak in rtw_free_cmd_obj if
 command is (_Set_Drv_Extra)
Thread-Topic: [PATCH] [staging][r8188eu]: memory leak in rtw_free_cmd_obj if
 command is (_Set_Drv_Extra)
Thread-Index: AQHPPAA/O+9x7gYAX0mpMnq3wMVi/JrZjGIA
Date: Mon, 10 Mar 2014 01:44:59 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01C4D7AE@SHSMSX101.ccr.corp.intel.com>
References: <1394465864.27962.2.camel@wxm-ubuntu>
In-Reply-To: <1394465864.27962.2.camel@wxm-ubuntu>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2A1jEQE013748

Hi,

> -----Original Message-----
> From: Wang, Xiaoming
> Sent: Monday, March 10, 2014 11:38 PM
> To: gregkh@linuxfoundation.org; valentina.manea.m@gmail.com;
> dan.carpenter@oracle.com; standby24x7@gmail.com
> Cc: devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; Zhang,
> Dongxing; Wang, Xiaoming; Liu, Chuansheng
> Subject: [PATCH] [staging][r8188eu]: memory leak in rtw_free_cmd_obj if
> command is (_Set_Drv_Extra)
> 
> pcmd->parmbuf->pbuf has been allocated if command is
> GEN_CMD_CODE(_Set_Drv_Extra),
> and it enqueued by rtw_enqueue_cmd. rtw_cmd_thread dequeue pcmd by
> rtw_dequeue_cmd.
> The memory leak happened on this branch "if( _FAIL ==
> rtw_cmd_filter(pcmdpriv, pcmd) )"
> which goto post_process directly against freeing pcmd->parmbuf->pbuf in
> rtw_drvextra_cmd_hdl which is the cmd_hdl if command is (_Set_Drv_Extra).
> This patch free pcmd->parmbuf->pbuf on the forgotten branch to avoid memory
> leak.
> 
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> 
> diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c
> b/drivers/staging/rtl8188eu/core/rtw_cmd.c
> index c0a0a52..1c7f505 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
> @@ -288,7 +288,7 @@ int rtw_cmd_thread(void *context)
>         void (*pcmd_callback)(struct adapter *dev, struct cmd_obj *pcmd);
>         struct adapter *padapter = (struct adapter *)context;
>         struct cmd_priv *pcmdpriv = &(padapter->cmdpriv);
> -
> +       struct drvextra_cmd_parm *extra_parm = NULL;
> 
>         thread_enter("RTW_CMD_THREAD");
> 
> @@ -323,6 +323,11 @@ _next:
> 
>                 if (_FAIL == rtw_cmd_filter(pcmdpriv, pcmd)) {
>                         pcmd->res = H2C_DROPPED;
> +                       if (pcmd->cmdcode ==
> GEN_CMD_CODE(_Set_Drv_Extra)) {
> +                               extra_parm = (struct
> drvextra_cmd_parm *)pcmd->parmbuf;
> +                               if (extra_parm && extra_parm->pbuf
> && extra_parm->size > 0)
> +                                       rtw_mfree(extra_parm->pbuf,
> extra_parm->size);
> +                       }
>                         goto post_process;
>                 }
> 

Reviewed-by: Chuansheng Liu <chuansheng.liu@intel.com>

Thanks.

Best Regards
Chuansheng

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
