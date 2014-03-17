Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaCQVgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:36:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaCQVgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:36:51 -0400
Date: Mon, 17 Mar 2014 14:38:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: valentina.manea.m@gmail.com, dan.carpenter@oracle.com,
        standby24x7@gmail.com, devel@driverdev.osuosl.org,
        chuansheng.liu@intel.com, dongxing.zhang@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [staging][r8188eu]: memory leak in rtw_free_cmd_obj if
 command is (_Set_Drv_Extra)
Message-ID: <20140317213852.GA29071@kroah.com>
References: <1394465864.27962.2.camel@wxm-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394465864.27962.2.camel@wxm-ubuntu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 11:37:44AM -0400, Wang, Xiaoming wrote:
> pcmd->parmbuf->pbuf has been allocated if command is GEN_CMD_CODE(_Set_Drv_Extra),
> and it enqueued by rtw_enqueue_cmd. rtw_cmd_thread dequeue pcmd by rtw_dequeue_cmd.
> The memory leak happened on this branch "if( _FAIL == rtw_cmd_filter(pcmdpriv, pcmd) )"
> which goto post_process directly against freeing pcmd->parmbuf->pbuf in
> rtw_drvextra_cmd_hdl which is the cmd_hdl if command is (_Set_Drv_Extra).
> This patch free pcmd->parmbuf->pbuf on the forgotten branch to avoid memory leak.
> 
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> Reviewed-by: Chuansheng Liu <chuansheng.liu@intel.com>
> 
> diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
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
> +                       if (pcmd->cmdcode == GEN_CMD_CODE(_Set_Drv_Extra)) {
> +                               extra_parm = (struct drvextra_cmd_parm *)pcmd->parmbuf;
> +                               if (extra_parm && extra_parm->pbuf && extra_parm->size > 0)
> +                                       rtw_mfree(extra_parm->pbuf, extra_parm->size);
> +                       }
>                         goto post_process;
>                 }
> 

This patch has all the tabs converted to spaces and can not be applied
:(

Please fix your email client and try again.

greg k-h
