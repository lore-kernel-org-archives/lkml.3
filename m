Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbaGBRog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:44:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49996 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbaGBRoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:44:34 -0400
Message-ID: <1404323065.596.65.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v2 1/3] ima: use ahash API for file hash calculation
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Date: Wed, 02 Jul 2014 13:44:25 -0400
In-Reply-To: <72d68808fd8db2b896a459b120f3e550e5f976c1.1404245510.git.d.kasatkin@samsung.com>
References: <cover.1404245510.git.d.kasatkin@samsung.com>
	 <72d68808fd8db2b896a459b120f3e550e5f976c1.1404245510.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070217-0928-0000-0000-00000320FDB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-01 at 23:12 +0300, Dmitry Kasatkin wrote:

> -/*
> - * Calculate the MD5/SHA1 file digest
> - */
> +static struct crypto_ahash *ima_alloc_atfm(enum hash_algo algo)
> +{
> +	struct crypto_ahash *tfm = ima_ahash_tfm;
> +	int rc;
> +
> +	if ((algo != ima_hash_algo && algo < HASH_ALGO__LAST) || !tfm) {
> +		tfm = crypto_alloc_ahash(hash_algo_name[algo], 0, 0);

In the case where algo isn't the same as ima_hash_algo, won't this
replace the existing ima_ahash_tfm without freeing it?

Mimi

> +		if (!IS_ERR(tfm)) {
> +			if (algo == ima_hash_algo)
> +				ima_ahash_tfm = tfm;
> +		} else {
> +			rc = PTR_ERR(tfm);
> +			pr_err("Can not allocate %s (reason: %d)\n",
> +			       hash_algo_name[algo], rc);
> +		}
> +	}
> +	return tfm;
> +}
> +
> +static void ima_free_atfm(struct crypto_ahash *tfm)
> +{
> +	if (tfm != ima_ahash_tfm)
> +		crypto_free_ahash(tfm);
> +}



