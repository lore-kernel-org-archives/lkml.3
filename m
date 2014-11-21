Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbaKUPdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:33:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321AbaKUPdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:33:39 -0500
Date: Fri, 21 Nov 2014 10:33:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: mmarek@suse.cz, d.kasatkin@samsung.com, rusty@rustcorp.com.au,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] X.509: Support X.509 lookup by Issuer+Serial form
 AuthorityKeyIdentifier
Message-ID: <20141121153320.GB22306@redhat.com>
References: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
 <20141120165414.5264.95354.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120165414.5264.95354.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 04:54:14PM +0000, David Howells wrote:

[..]
> @@ -215,21 +219,42 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
>  		/* Look through the X.509 certificates in the PKCS#7 message's
>  		 * list to see if the next one is there.
>  		 */
> -		pr_debug("- want %*phN\n",
> -			 x509->auth_skid->len, x509->auth_skid->data);
> -		for (p = pkcs7->certs; p; p = p->next) {
> -			if (!p->skid)
> -				continue;
> -			pr_debug("- cmp [%u] %*phN\n",
> -				 p->index, p->skid->len, p->skid->data);
> -			if (asymmetric_key_id_same(p->skid, x509->auth_skid))
> -				goto found_issuer;
> +		auth = x509->auth_id;
> +		if (auth) {
> +			pr_debug("- want %*phN\n", auth->len, auth->data);
> +			for (p = pkcs7->certs; p; p = p->next) {
> +				pr_debug("- cmp [%u] %*phN\n",
> +					 p->index, p->id->len, p->id->data);
> +				if (asymmetric_key_id_same(p->id, auth))
> +					goto found_issuer_check_skid;
> +			}
> +		} else {
> +			auth = x509->auth_skid;
> +			pr_debug("- want %*phN\n", auth->len, auth->data);
> +			for (p = pkcs7->certs; p; p = p->next) {
> +				if (!p->skid)
> +					continue;
> +				pr_debug("- cmp [%u] %*phN\n",
> +					 p->index, p->skid->len, p->skid->data);
> +				if (asymmetric_key_id_same(p->skid, auth))
> +					goto found_issuer;
> +			}
>  		}
>  
>  		/* We didn't find the root of this chain */
>  		pr_debug("- top\n");
>  		return 0;
>  
> +	found_issuer_check_skid:
> +		/* We matched issuer + serialNumber, but if there's an
> +		 * authKeyId.keyId, that must match the CA subjKeyId also.
> +		 */
> +		if (x509->auth_skid &&
> +		    !asymmetric_key_id_same(p->skid, x509->auth_skid)) {
> +			pr_warn("Sig %u: X.509 chain contains auth-skid nonmatch (%u->%u)\n",
> +				sinfo->index, x509->index, p->index);
> +			return -EKEYREJECTED;
> +		}

Hi David,

A minor nit.

pkcs7_verify_sig_chain() is getting big with multiple goto labels. Will
it make sense to introduce a helper function to see if cert B is authority
cert of cert A or not. And then we should be able to get rid of labels
like found_issuer_check_skid() and some of the inline code also go away.

Thanks
Vivek
