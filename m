Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaCZIxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 04:53:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23842 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaCZIxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 04:53:30 -0400
Date: Wed, 26 Mar 2014 11:53:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: gregkh@linuxfoundation.org, valentina.manea.m@gmail.com,
        standby24x7@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dongxing.zhang@intel.com,
        chuansheng.liu@intel.com
Subject: Re: [PATCH] [staging][r8188eu]: memory leak in rtw_free_cmd_obj if
 command is (_Set_Drv_Extra)
Message-ID: <20140326085313.GC7045@mwanda>
References: <1395152727.31547.5.camel@wxm-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395152727.31547.5.camel@wxm-ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 10:25:27AM -0400, Wang, Xiaoming wrote:
> pcmd->parmbuf->pbuf has been allocated if command is GEN_CMD_CODE(_Set_Drv_Extra),
> and it enqueued by rtw_enqueue_cmd. rtw_cmd_thread dequeue pcmd by rtw_dequeue_cmd.
> The memory leak happened on this branch "if( _FAIL == rtw_cmd_filter(pcmdpriv, pcmd) )"
> which goto post_process directly against freeing pcmd->parmbuf->pbuf in
> rtw_drvextra_cmd_hdl which is the cmd_hdl if command is (_Set_Drv_Extra).
> This patch free pcmd->parmbuf->pbuf on the forgotten branch to avoid memory leak.
> 
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> 
> diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
> index c0a0a52..1c7f505 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
> @@ -288,7 +288,7 @@ int rtw_cmd_thread(void *context)
>  	void (*pcmd_callback)(struct adapter *dev, struct cmd_obj *pcmd);
>  	struct adapter *padapter = (struct adapter *)context;
>  	struct cmd_priv *pcmdpriv = &(padapter->cmdpriv);
> -
> +	struct drvextra_cmd_parm *extra_parm = NULL;

Don't do this.  It disables GCC's uninitialized variable check so it can
hide bugs.  It's just another assignment to read and remember so it
takes reviewer time.

>  
>  	thread_enter("RTW_CMD_THREAD");
>  
> @@ -323,6 +323,11 @@ _next:
>  
>  		if (_FAIL == rtw_cmd_filter(pcmdpriv, pcmd)) {
>  			pcmd->res = H2C_DROPPED;
> +			if (pcmd->cmdcode == GEN_CMD_CODE(_Set_Drv_Extra)) {
> +				extra_parm = (struct drvextra_cmd_parm *)pcmd->parmbuf;
> +				if (extra_parm && extra_parm->pbuf && extra_parm->size > 0)
> +					rtw_mfree(extra_parm->pbuf, extra_parm->size);

Like Greg says, there isn't a rtw_mfree() anymore.  This code is so
confusing and GEN_CMD_CODE is horrible and
"make drivers/staging/rtl8188eu/core/rtw_cmd.i" doesn't work and I don't
know how to even review this...  :/  But I'll try again when you
re-submit.

> +			}
>  			goto post_process;
>  		}
>  

regards,
dan carpenter
