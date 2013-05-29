Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966759Ab3E2UKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:10:07 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:15337 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965519Ab3E2UJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:09:58 -0400
Message-ID: <1369858192.1971.21.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH v6 net-next 1/5] net: add napi_id and hash
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Don Skidmore" <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        HPA <hpa@zytor.com>, Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 29 May 2013 21:09:52 +0100
In-Reply-To: <20130529063925.27486.46649.stgit@ladj378.jer.intel.com>
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>
	 <20130529063925.27486.46649.stgit@ladj378.jer.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19900.004
X-TM-AS-Result: No--13.811100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 09:39 +0300, Eliezer Tamir wrote:
> Adds a napi_id and a hashing mechanism to lookup a napi by id.
> This will be used by subsequent patches to implement low latency
> Ethernet device polling.
> Based on a code sample by Eric Dumazet.
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
[...]
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
[...]
> @@ -4136,6 +4143,53 @@ void napi_complete(struct napi_struct *n)
>  }
>  EXPORT_SYMBOL(napi_complete);
>  
> +void napi_hash_add(struct napi_struct *napi)
> +{
> +	if (!test_and_set_bit(NAPI_STATE_HASHED, &napi->state)) {
> +
> +		spin_lock(&napi_hash_lock);
> +
> +		/* 0 is not a valid id */
> +		napi->napi_id = 0;
> +		while (!napi->napi_id)
> +			napi->napi_id = ++napi_gen_id;

Suppose we're loading/unloading one driver repeatedly while another one
remains loaded the whole time.  Then once napi_gen_id wraps around, the
same ID can be assigned to multiple contexts.

So far as I can see, assigning the same ID twice will just make polling
stop working for one of the NAPI contexts; I don't think it causes a
crash.  And it is exceedingly unlikely to happen in production.  But if
you're going to the trouble of handling wrap-around at all, you'd better
handle this.

[...]
> +/* must be called under rcu_read_lock(), as we dont take a reference */
> +struct napi_struct *napi_by_id(int napi_id)
> +{
> +	unsigned int hash = napi_id % HASH_SIZE(napi_hash);
[...]

napi_id should be declared unsigned int here, as elsewhere.  The
division can't actually yield a negative result because HASH_SIZE() has
type size_t and napi_id is promoted to match, but I had to go and look
at hashtable.h to check that.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

