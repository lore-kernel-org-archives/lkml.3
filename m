Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaA3OBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:01:16 -0500
Received: from relay2.sgi.com ([192.48.179.30]:38567 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752873AbaA3OBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:01:15 -0500
Date: Thu, 30 Jan 2014 08:01:13 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/2] gru: unlocking should be conditional in
 gru_dump_context()
Message-ID: <20140130140113.GC15484@sgi.com>
References: <20140130121044.GB13267@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130121044.GB13267@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Dimitri Sivanich <sivanich@sgi.com>

On Thu, Jan 30, 2014 at 03:10:44PM +0300, Dan Carpenter wrote:
> I was reviewing this and noticed that unlocking should be conditional on
> the error path.  I've changed it to unlock and return directly since we
> only do it once and it seems unlikely to change in the near future.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/misc/sgi-gru/grukdump.c b/drivers/misc/sgi-gru/grukdump.c
> index 9b2062d17327..2bef3f76032a 100644
> --- a/drivers/misc/sgi-gru/grukdump.c
> +++ b/drivers/misc/sgi-gru/grukdump.c
> @@ -139,8 +139,11 @@ static int gru_dump_context(struct gru_state *gru, int ctxnum,
>  
>  	ubuf += sizeof(hdr);
>  	ubufcch = ubuf;
> -	if (gru_user_copy_handle(&ubuf, cch))
> -		goto fail;
> +	if (gru_user_copy_handle(&ubuf, cch)) {
> +		if (cch_locked)
> +			unlock_cch_handle(cch);
> +		return -EFAULT;
> +	}
>  	if (cch_locked)
>  		ubufcch->delresp = 0;
>  	bytes = sizeof(hdr) + GRU_CACHE_LINE_BYTES;
> @@ -179,10 +182,6 @@ static int gru_dump_context(struct gru_state *gru, int ctxnum,
>  		ret = -EFAULT;
>  
>  	return ret ? ret : bytes;
> -
> -fail:
> -	unlock_cch_handle(cch);
> -	return -EFAULT;
>  }
>  
>  int gru_dump_chiplet_request(unsigned long arg)
