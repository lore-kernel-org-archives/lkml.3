Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaFRBHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:07:20 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39671 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbaFRBHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:07:18 -0400
Message-ID: <1403053631.6929.9.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v2 1/3] KEYS: make key id matching as a dedicated
 function
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, jwboyer@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 17 Jun 2014 21:07:11 -0400
In-Reply-To: <3513a5dbfe2fc84eb07006a0fd4b9c929972edc1.1402994752.git.d.kasatkin@samsung.com>
References: <cover.1402994752.git.d.kasatkin@samsung.com>
	 <3513a5dbfe2fc84eb07006a0fd4b9c929972edc1.1402994752.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061801-1344-0000-0000-00000244ABDB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 11:56 +0300, Dmitry Kasatkin wrote: 
> Key id matching will also be used in the following patch.
> To avoid code duplication this patch moves functionality
> to a separate function.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

In refactoring asymmetric_key_match(), its changed.  The reason for this
change should be included in the patch description.  (Bug fixes should
be documented.)

thanks,

Mimi

> ---
>  crypto/asymmetric_keys/asymmetric_keys.h |  2 ++
>  crypto/asymmetric_keys/asymmetric_type.c | 50 ++++++++++++++++++++------------
>  2 files changed, 33 insertions(+), 19 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/asymmetric_keys.h b/crypto/asymmetric_keys/asymmetric_keys.h
> index 515b634..a63c551 100644
> --- a/crypto/asymmetric_keys/asymmetric_keys.h
> +++ b/crypto/asymmetric_keys/asymmetric_keys.h
> @@ -9,6 +9,8 @@
>   * 2 of the Licence, or (at your option) any later version.
>   */
> 
> +int asymmetric_keyid_match(const char *kid, const char *id);
> +
>  static inline const char *asymmetric_key_id(const struct key *key)
>  {
>  	return key->type_data.p[1];
> diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
> index b77eb53..1fd1d30 100644
> --- a/crypto/asymmetric_keys/asymmetric_type.c
> +++ b/crypto/asymmetric_keys/asymmetric_type.c
> @@ -23,6 +23,34 @@ static LIST_HEAD(asymmetric_key_parsers);
>  static DECLARE_RWSEM(asymmetric_key_parsers_sem);
> 
>  /*
> + * Match asymmetric key id with partial match
> + * @id:		key id to match in a form "id:<id>"
> + */
> +int asymmetric_keyid_match(const char *kid, const char *id)
> +{
> +	size_t idlen, kidlen;
> +
> +	if (!kid || !id)
> +		return 0;
> +
> +	/* make it possible to use id as in the request: "id:<id>" */
> +	if (strncmp(id, "id:", 3) == 0)
> +		id += 3;
> +
> +	/* Anything after here requires a partial match on the ID string */
> +	idlen = strlen(id);
> +	kidlen = strlen(kid);
> +	if (idlen > kidlen)
> +		return 0;
> +
> +	kid += kidlen - idlen;
> +	if (strcasecmp(id, kid) != 0)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +/*
>   * Match asymmetric keys on (part of) their name
>   * We have some shorthand methods for matching keys.  We allow:
>   *
> @@ -34,9 +62,8 @@ static int asymmetric_key_match(const struct key *key, const void *description)
>  {
>  	const struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
>  	const char *spec = description;
> -	const char *id, *kid;
> +	const char *id;
>  	ptrdiff_t speclen;
> -	size_t idlen, kidlen;
> 
>  	if (!subtype || !spec || !*spec)
>  		return 0;
> @@ -55,23 +82,8 @@ static int asymmetric_key_match(const struct key *key, const void *description)
>  	speclen = id - spec;
>  	id++;
> 
> -	/* Anything after here requires a partial match on the ID string */
> -	kid = asymmetric_key_id(key);
> -	if (!kid)
> -		return 0;
> -
> -	idlen = strlen(id);
> -	kidlen = strlen(kid);
> -	if (idlen > kidlen)
> -		return 0;
> -
> -	kid += kidlen - idlen;
> -	if (strcasecmp(id, kid) != 0)
> -		return 0;
> -
> -	if (speclen == 2 &&
> -	    memcmp(spec, "id", 2) == 0)
> -		return 1;
> +	if (speclen == 2 && memcmp(spec, "id", 2) == 0)
> +		return asymmetric_keyid_match(asymmetric_key_id(key), id);
> 
>  	if (speclen == subtype->name_len &&
>  	    memcmp(spec, subtype->name, speclen) == 0)


