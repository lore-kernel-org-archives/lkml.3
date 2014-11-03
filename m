Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaKCLEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:04:51 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:40259 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaKCLEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:04:40 -0500
Message-ID: <1415012678.18669.6.camel@BR9GV9YG.de.ibm.com>
Subject: Re: [PATCH 1/1] s390/net: Deletion of unnecessary checks before two
 function calls
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Date: Mon, 03 Nov 2014 12:04:38 +0100
In-Reply-To: <5453C98C.90105@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	 <530A086E.8010901@users.sourceforge.net>
	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	 <530A72AA.3000601@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net> <5453C98C.90105@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110311-0017-0000-0000-000001B0EBDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with your proposed debug_unregister() changes, but not with your
kfree_fsm() change.

Regards, Ursula Braun

On Fri, 2014-10-31 at 18:40 +0100, SF Markus Elfring wrote:
> The functions debug_unregister() and kfree_fsm() test whether their argument
> is NULL and then return immediately. Thus the test around the call
> is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/s390/net/claw.c      |  6 ++----
>  drivers/s390/net/ctcm_main.c |  6 ++----
>  drivers/s390/net/lcs.c       |  6 ++----
>  drivers/s390/net/netiucv.c   | 12 ++++--------
>  4 files changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
> index 213e54e..d609ca0 100644
> --- a/drivers/s390/net/claw.c
> +++ b/drivers/s390/net/claw.c
> @@ -109,10 +109,8 @@ static debug_info_t *claw_dbf_trace;
>  static void
>  claw_unregister_debug_facility(void)
>  {
> -	if (claw_dbf_setup)
> -		debug_unregister(claw_dbf_setup);
> -	if (claw_dbf_trace)
> -		debug_unregister(claw_dbf_trace);
> +	debug_unregister(claw_dbf_setup);
> +	debug_unregister(claw_dbf_trace);
>  }
> 
>  static int
> diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
> index e056dd4..34dc0f3 100644
> --- a/drivers/s390/net/ctcm_main.c
> +++ b/drivers/s390/net/ctcm_main.c
> @@ -1074,8 +1074,7 @@ static void ctcm_free_netdevice(struct net_device *dev)
>  	if (priv) {
>  		grp = priv->mpcg;
>  		if (grp) {
> -			if (grp->fsm)
> -				kfree_fsm(grp->fsm);
> +			kfree_fsm(grp->fsm);
>  			if (grp->xid_skb)
>  				dev_kfree_skb(grp->xid_skb);
>  			if (grp->rcvd_xid_skb)
> @@ -1672,8 +1671,7 @@ static int ctcm_shutdown_device(struct ccwgroup_device *cgdev)
>  		ctcm_free_netdevice(dev);
>  	}
> 
> -	if (priv->fsm)
> -		kfree_fsm(priv->fsm);
> +	kfree_fsm(priv->fsm);
> 
>  	ccw_device_set_offline(cgdev->cdev[1]);
>  	ccw_device_set_offline(cgdev->cdev[0]);
> diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
> index 0a7d87c..5dfa7dd 100644
> --- a/drivers/s390/net/lcs.c
> +++ b/drivers/s390/net/lcs.c
> @@ -88,10 +88,8 @@ static debug_info_t *lcs_dbf_trace;
>  static void
>  lcs_unregister_debug_facility(void)
>  {
> -	if (lcs_dbf_setup)
> -		debug_unregister(lcs_dbf_setup);
> -	if (lcs_dbf_trace)
> -		debug_unregister(lcs_dbf_trace);
> +	debug_unregister(lcs_dbf_setup);
> +	debug_unregister(lcs_dbf_trace);
>  }
> 
>  static int
> diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
> index 0a87809..bdcc3fe 100644
> --- a/drivers/s390/net/netiucv.c
> +++ b/drivers/s390/net/netiucv.c
> @@ -487,12 +487,9 @@ DEFINE_PER_CPU(char[256], iucv_dbf_txt_buf);
> 
>  static void iucv_unregister_dbf_views(void)
>  {
> -	if (iucv_dbf_setup)
> -		debug_unregister(iucv_dbf_setup);
> -	if (iucv_dbf_data)
> -		debug_unregister(iucv_dbf_data);
> -	if (iucv_dbf_trace)
> -		debug_unregister(iucv_dbf_trace);
> +	debug_unregister(iucv_dbf_setup);
> +	debug_unregister(iucv_dbf_data);
> +	debug_unregister(iucv_dbf_trace);
>  }
>  static int iucv_register_dbf_views(void)
>  {
> @@ -1975,8 +1972,7 @@ static void netiucv_free_netdevice(struct net_device *dev)
>  	if (privptr) {
>  		if (privptr->conn)
>  			netiucv_remove_connection(privptr->conn);
> -		if (privptr->fsm)
> -			kfree_fsm(privptr->fsm);
> +		kfree_fsm(privptr->fsm);
>  		privptr->conn = NULL; privptr->fsm = NULL;
>  		/* privptr gets freed by free_netdev() */
>  	}


