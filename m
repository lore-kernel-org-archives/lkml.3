Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaKXLwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:52:18 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43398 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaKXLwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:52:16 -0500
Message-ID: <1416829928.25352.6.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 3/5] PKCS#7: Allow detached data to be supplied for
 signature checking purposes
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: mmarek@suse.cz, d.kasatkin@samsung.com, rusty@rustcorp.com.au,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Nov 2014 06:52:08 -0500
In-Reply-To: <20141120165425.5264.24661.stgit@warthog.procyon.org.uk>
References: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
	 <20141120165425.5264.24661.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112411-0005-0000-0000-0000069361AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-20 at 16:54 +0000, David Howells wrote: 
> It is possible for a PKCS#7 message to have detached data.  However, to verify
> the signatures on a PKCS#7 message, we have to be able to digest the data.
> Provide a function to supply that data.  An error is given if the PKCS#7
> message included embedded data.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Ok, PCKS#7 supports detached data.  I assume this is not needed for
kernel modules.  What is the motivation for adding this support to the
kernel?

Mimi

> ---
> 
>  crypto/asymmetric_keys/pkcs7_verify.c |   26 ++++++++++++++++++++++++++
>  include/crypto/pkcs7.h                |    3 +++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
> index 667064daf66b..c6ee41bfda6e 100644
> --- a/crypto/asymmetric_keys/pkcs7_verify.c
> +++ b/crypto/asymmetric_keys/pkcs7_verify.c
> @@ -382,3 +382,29 @@ int pkcs7_verify(struct pkcs7_message *pkcs7)
>  	return enopkg;
>  }
>  EXPORT_SYMBOL_GPL(pkcs7_verify);
> +
> +/**
> + * pkcs7_supply_detached_data - Supply the data needed to verify a PKCS#7 message
> + * @pkcs7: The PKCS#7 message
> + * @data: The data to be verified
> + * @datalen: The amount of data
> + *
> + * Supply the detached data needed to verify a PKCS#7 message.  Note that no
> + * attempt to retain/pin the data is made.  That is left to the caller.  The
> + * data will not be modified by pkcs7_verify() and will not be freed when the
> + * PKCS#7 message is freed.
> + *
> + * Returns -EINVAL if data is already supplied in the message, 0 otherwise.
> + */
> +int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
> +			       const void *data, size_t datalen)
> +{
> +	if (pkcs7->data) {
> +		pr_debug("Data already supplied\n");
> +		return -EINVAL;
> +	}
> +	pkcs7->data = data;
> +	pkcs7->data_len = datalen;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pkcs7_supply_detached_data);
> diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
> index 691c79172a26..e235ab4957ee 100644
> --- a/include/crypto/pkcs7.h
> +++ b/include/crypto/pkcs7.h
> @@ -34,3 +34,6 @@ extern int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
>   * pkcs7_verify.c
>   */
>  extern int pkcs7_verify(struct pkcs7_message *pkcs7);
> +
> +extern int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
> +				      const void *data, size_t datalen);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


