Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaIHUsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 16:48:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbaIHUsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 16:48:31 -0400
Date: Mon, 8 Sep 2014 13:48:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: Larry.Finger@lwfinger.net, navin.patidar@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] rtl8188eu: rtw_xmit: Replace rcu_dereference() with
 rcu_access_pointer()
Message-ID: <20140908204830.GA19307@kroah.com>
References: <20140904171548.GA3265@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904171548.GA3265@ada>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 08:15:48PM +0300, Andreea-Cristina Bernat wrote:
> The "br_port" local variables obtained through the rcu_dereference() calls are
> not dereferenced in the rest of their function.
> Therefore, it is recommended to use rcu_access_pointer() instead of
> rcu_dereference().
> This patch makes the replacements.
> 
> The first step to detect this was made with the following Coccinelle semantic
> patch:
> @@
> identifier p;
> @@
> 
> * p = rcu_dereference(...)
> ... when any
>     when != p
> (
> * if( (<+...p...+>) ) { ... }
> |
> * while( (<+...p...+>) ) { ... }
> )
> ... when != p
> 
> After the analysis of the output, the change was made manually.
> 
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
> ---
>  drivers/staging/rtl8188eu/core/rtw_xmit.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
> index 1413ec8..93228dc 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
> @@ -1684,7 +1684,7 @@ static int rtw_br_client_tx(struct adapter *padapter, struct sk_buff **pskb)
>  	void *br_port = NULL;
>  
>  	rcu_read_lock();
> -	br_port = rcu_dereference(padapter->pnetdev->rx_handler_data);
> +	br_port = rcu_access_pointer(padapter->pnetdev->rx_handler_data);
>  	rcu_read_unlock();
>  	spin_lock_bh(&padapter->br_ext_lock);
>  	if (!(skb->data[0] & 1) && br_port &&
> @@ -1868,7 +1868,7 @@ s32 rtw_xmit(struct adapter *padapter, struct sk_buff **ppkt)
>  	}
>  
>  	rcu_read_lock();
> -	br_port = rcu_dereference(padapter->pnetdev->rx_handler_data);
> +	br_port = rcu_access_pointer(padapter->pnetdev->rx_handler_data);
>  	rcu_read_unlock();
>  
>  	if (br_port && check_fwstate(pmlmepriv, WIFI_STATION_STATE|WIFI_ADHOC_STATE)) {

This patch doesn't apply at all to my staging-next branch of the
staging.git tree on git.kernel.org :(

