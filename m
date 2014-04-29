Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaD2JrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:47:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43096 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaD2JrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:47:17 -0400
Date: Tue, 29 Apr 2014 12:46:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Niu Yawei <yawei.niu@intel.com>
Subject: Re: [PATCH 11/47] staging/lustre/ptlrpc: add rpc_cache
Message-ID: <20140429094658.GZ26890@mwanda>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
 <1398618431-29757-12-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398618431-29757-12-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 01:06:35PM -0400, Oleg Drokin wrote:
> diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
> index 0efd358..251ae75 100644
> --- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
> +++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
> @@ -73,29 +73,34 @@ __init int ptlrpc_init(void)
>  		return rc;
>  
>  	cleanup_phase = 1;
> +	rc = ptlrpc_request_cache_init();
> +	if (rc)
> +		GOTO(cleanup, rc);
>  
> +	cleanup_phase = 2;
>  	rc = ptlrpc_init_portals();
>  	if (rc)
>  		GOTO(cleanup, rc);
> -	cleanup_phase = 2;
> +
> +	cleanup_phase = 3;
>  
>  	rc = ptlrpc_connection_init();
>  	if (rc)
>  		GOTO(cleanup, rc);
> -	cleanup_phase = 3;
>  
> +	cleanup_phase = 4;
>  	ptlrpc_put_connection_superhack = ptlrpc_connection_put;
>  
>  	rc = ptlrpc_start_pinger();
>  	if (rc)
>  		GOTO(cleanup, rc);
> -	cleanup_phase = 4;
>  
> +	cleanup_phase = 5;
>  	rc = ldlm_init();
>  	if (rc)
>  		GOTO(cleanup, rc);
> -	cleanup_phase = 5;
>  
> +	cleanup_phase = 6;
>  	rc = sptlrpc_init();
>  	if (rc)
>  		GOTO(cleanup, rc);
> @@ -115,19 +120,29 @@ cleanup:
>  	switch (cleanup_phase) {
>  	case 8:
>  		ptlrpc_nrs_fini();
> +		/* Fall through */
>  	case 7:
>  		sptlrpc_fini();
> -	case 5:
> +		/* Fall through */
> +	case 6:
>  		ldlm_exit();
> -	case 4:
> +		/* Fall through */
> +	case 5:
>  		ptlrpc_stop_pinger();
> -	case 3:
> +		/* Fall through */
> +	case 4:
>  		ptlrpc_connection_fini();
> -	case 2:
> +		/* Fall through */
> +	case 3:
>  		ptlrpc_exit_portals();
> +		/* Fall through */
> +	case 2:
> +		ptlrpc_request_cache_fini();
> +		/* Fall through */
>  	case 1:
>  		ptlrpc_hr_fini();
>  		req_layout_fini();
> +		/* Fall through */
>  	default: ;
>  	}
>  

Heh.  Oh wow.  That's horrible.  :P

Hopefully next time someone will fix this pile of monkey poo instead
just renumbering all the grains of corn.

regards,
dan carpenter


