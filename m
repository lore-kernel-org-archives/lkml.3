Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaJMPzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:55:51 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11473 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaJMPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:55:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18IKfCfeQgGUj5HFirEKweq2wM2tdcjpnE=
X-DKIM: OpenDKIM Filter v2.0.1 titan 663985FCDEF
Date: Sun, 12 Oct 2014 15:22:09 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Amit Shah <amit.shah@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] char: hw_random: core.c:  Changed from using
 strncat to strlcat
Message-ID: <20141012192209.GC14147@titan.lakedaemon.net>
References: <1413110971-17392-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413110971-17392-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard,

On Sun, Oct 12, 2014 at 12:49:31PM +0200, Rickard Strandqvist wrote:
> Changed from using strncat to strlcat to simplify the code

I'd like to see a little more explicit discussion here.  As Guenter got
caught up in the mis-understanding, I doubt he'd be the only one.  I
think it's worth spelling out that the old code prevents overflowing the
buffer 'buf' of size PAGE_SIZE.  And that strlcat() does that internally
allowing this code to be more readable.

It should also be mentioned that the final strlen(buf) is safe because
every operation on buf will insert a NULL terminator within the
buffers limit.

thx,

Jason.

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/char/hw_random/core.c |   12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index aa30a25..1500cfd 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -281,7 +281,6 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>  					 char *buf)
>  {
>  	int err;
> -	ssize_t ret = 0;
>  	struct hwrng *rng;
>  
>  	err = mutex_lock_interruptible(&rng_mutex);
> @@ -289,16 +288,13 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>  		return -ERESTARTSYS;
>  	buf[0] = '\0';
>  	list_for_each_entry(rng, &rng_list, list) {
> -		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
> -		ret += strlen(rng->name);
> -		strncat(buf, " ", PAGE_SIZE - ret - 1);
> -		ret++;
> +		strlcat(buf, rng->name, PAGE_SIZE);
> +		strlcat(buf, " ", PAGE_SIZE);
>  	}
> -	strncat(buf, "\n", PAGE_SIZE - ret - 1);
> -	ret++;
> +	strlcat(buf, "\n", PAGE_SIZE);
>  	mutex_unlock(&rng_mutex);
>  
> -	return ret;
> +	return strlen(buf);
>  }
>  
>  static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
> -- 
> 1.7.10.4
> 
