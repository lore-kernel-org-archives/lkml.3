Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaKXOGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:06:19 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60074 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaKXOGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:06:16 -0500
Message-ID: <1416837968.25352.34.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 5/5] MODSIGN: Use PKCS#7 messages as module signatures
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: mmarek@suse.cz, d.kasatkin@samsung.com, rusty@rustcorp.com.au,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Nov 2014 09:06:08 -0500
In-Reply-To: <20141120165448.5264.72787.stgit@warthog.procyon.org.uk>
References: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
	 <20141120165448.5264.72787.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112414-0009-0000-0000-0000068F1A82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-20 at 16:54 +0000, David Howells wrote:

> 
>  /*
> @@ -186,12 +81,8 @@ static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
>   */
>  int mod_verify_sig(const void *mod, unsigned long *_modlen)
>  {
> -	struct public_key_signature *pks;
>  	struct module_signature ms;
> -	struct key *key;
> -	const void *sig;
>  	size_t modlen = *_modlen, sig_len;
> -	int ret;
> 
>  	pr_devel("==>%s(,%zu)\n", __func__, modlen);
> 
> @@ -205,46 +96,23 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
>  	if (sig_len >= modlen)
>  		return -EBADMSG;
>  	modlen -= sig_len;
> -	if ((size_t)ms.signer_len + ms.key_id_len >= modlen)
> -		return -EBADMSG;
> -	modlen -= (size_t)ms.signer_len + ms.key_id_len;
> -
>  	*_modlen = modlen;
> -	sig = mod + modlen;
> -
> -	/* For the moment, only support RSA and X.509 identifiers */
> -	if (ms.algo != PKEY_ALGO_RSA ||
> -	    ms.id_type != PKEY_ID_X509)
> -		return -ENOPKG;
> 
> -	if (ms.hash >= PKEY_HASH__LAST ||
> -	    !hash_algo_name[ms.hash])
> +	if (ms.id_type != PKEY_ID_PKCS7) {
> +		pr_err("Module is not signed with expected PKCS#7 message\n");
>  		return -ENOPKG;

Perhaps because modules are resigned with each kernel build, it is
acceptable to totally replace one signature format with another like
this, and fail the old method.

Mimi

