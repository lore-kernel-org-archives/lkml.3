Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbaLJTYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:24:23 -0500
Received: from gproxy6-pub.mail.unifiedlayer.com ([67.222.39.168]:56861 "HELO
	gproxy6-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932319AbaLJTYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:24:21 -0500
X-Authority-Analysis: v=2.1 cv=W++rC3mk c=1 sm=1 tr=0
 a=yEjhGPV9XlbPNRGz7jjbow==:117 a=yEjhGPV9XlbPNRGz7jjbow==:17 a=DsvgjBjRAAAA:8
 a=f5113yIGAAAA:8 a=IkcTkHD0fZMA:10 a=wCmvBT1CAAAA:8 a=djd9j7hWnewA:10
 a=YP2Gd-mDGRwA:10 a=A92cGCtB03wA:10 a=jNzdnLwGHkp4IYTkdewA:9 a=QEXdDO2ut3YA:10
Message-ID: <1418239407.2963.1.camel@ubuntu>
Subject: Re: [PATCH] fs: hfs: Fix comparison bug in hfs_cat_keycmp
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Dec 2014 11:23:27 -0800
In-Reply-To: <1418229164-4132-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418165449.5917.4.camel@ubuntu>
	 <1418229164-4132-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 199.255.44.5 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 17:32 +0100, Rasmus Villemoes wrote:
> Relying on the sign (after casting to int) of the difference of two
> quantities for comparison is usually wrong. For example, should a-b
> turn out to be 2^31, the return value of cmp(a,b) is -2^31; but that
> would also be the return value from cmp(b, a). So a compares less than
> b and b compares less than a. One can also easily find three values
> a,b,c such that a compares less than b, b compares less than c, but a
> does not compare less than c.
> 

Looks good for me. Thank you for the fix.

Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Vyacheslav Dubeyko.

> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  fs/hfs/catalog.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
> index ff0316b925a5..db458ee3a546 100644
> --- a/fs/hfs/catalog.c
> +++ b/fs/hfs/catalog.c
> @@ -162,14 +162,16 @@ err2:
>   */
>  int hfs_cat_keycmp(const btree_key *key1, const btree_key *key2)
>  {
> -	int retval;
> +	__be32 k1p, k2p;
>  
> -	retval = be32_to_cpu(key1->cat.ParID) - be32_to_cpu(key2->cat.ParID);
> -	if (!retval)
> -		retval = hfs_strcmp(key1->cat.CName.name, key1->cat.CName.len,
> -				    key2->cat.CName.name, key2->cat.CName.len);
> +	k1p = key1->cat.ParID;
> +	k2p = key2->cat.ParID;
>  
> -	return retval;
> +	if (k1p != k2p)
> +		return be32_to_cpu(k1p) < be32_to_cpu(k2p) ? -1 : 1;
> +
> +	return hfs_strcmp(key1->cat.CName.name, key1->cat.CName.len,
> +			  key2->cat.CName.name, key2->cat.CName.len);
>  }
>  
>  /* Try to get a catalog entry for given catalog id */


