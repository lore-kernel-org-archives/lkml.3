Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaJXOfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:35:11 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38568 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752465AbaJXOfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:35:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+pG4UO6DzjfwfZYqOlHxKHtfRZAUg9vwk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 5B230607696
Date: Fri, 24 Oct 2014 10:35:04 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/7] staging: skein: Adds CryptoAPI Support
Message-ID: <20141024143504.GC12718@titan.lakedaemon.net>
References: <cover.1414151639.git.eric.rost@mybabylon.net>
 <d931d8e441d9dfd566848111ad4fbdc71a96e972.1414151639.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d931d8e441d9dfd566848111ad4fbdc71a96e972.1414151639.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

We're almost there... :)

On Fri, Oct 24, 2014 at 06:55:33AM -0500, Eric Rost wrote:
> Adds CryptoAPI support to the Skein Hashing Algorithm driver.
> 
> Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
> ---
>  drivers/staging/skein/Makefile        |   3 +-
>  drivers/staging/skein/skein_generic.c | 191 ++++++++++++++++++++++++++++++++++
>  2 files changed, 193 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/staging/skein/skein_generic.c
> 
> diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
> index ca746a9..d8177cc 100644
> --- a/drivers/staging/skein/Makefile
> +++ b/drivers/staging/skein/Makefile
> @@ -5,4 +5,5 @@ obj-$(CONFIG_CRYPTO_SKEIN) += skein_base.o \
>  			      skein_api.o \
>  			      skein_block.o \
>  			      threefish_block.o \
> -			      threefish_api.o
> +			      threefish_api.o \
> +			      skein_generic.o
> diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
> new file mode 100644
> index 0000000..39332e8
> --- /dev/null
> +++ b/drivers/staging/skein/skein_generic.c
...
> +static int __init skein_generic_init(void)
> +{
> +	if (crypto_register_shash(&alg256) || crypto_register_shash(&alg512)
> +		|| crypto_register_shash(&alg1024)) {
> +		crypto_unregister_shash(&alg256);
> +		crypto_unregister_shash(&alg512);
> +		crypto_unregister_shash(&alg1024);
> +		return -1;
> +	}
> +	return 0;
> +}

This really needs to be something like:

	if (crypto_register_shash(&alg256))
		goto bail;
	if (crypto_register_shash(&alg512))
		goto unreg256;
	if (crypto_register_shash(&alg1024))
		goto unreg512;

	return 0;

unreg512:
	crypto_unregister_shash(&alg512);
unreg256:
	crypto_unregister_shash(&alg256);
bail:
	return -1;

thx,

Jason.
