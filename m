Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaBYHiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:38:00 -0500
Received: from gproxy1-pub.mail.unifiedlayer.com ([69.89.25.95]:38894 "HELO
	gproxy1-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750712AbaBYHh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:37:57 -0500
X-Authority-Analysis: v=2.1 cv=RodWckWK c=1 sm=1 tr=0
 a=yEjhGPV9XlbPNRGz7jjbow==:117 a=yEjhGPV9XlbPNRGz7jjbow==:17 a=DsvgjBjRAAAA:8
 a=f5113yIGAAAA:8 a=G0W75ifUKZMA:10 a=neHJxMmKCwgA:10 a=IkcTkHD0fZMA:10
 a=wCmvBT1CAAAA:8 a=sXxnF9VgnFIA:10 a=djd9j7hWnewA:10 a=3DfWnJiXAAAA:8
 a=KyNao9NFgDkmYdB0uOEA:9 a=0smWq2rNXhb6E6jH:21 a=TBdnAsnq3r0FcN5f:21
 a=QEXdDO2ut3YA:10 a=nrQdhOzvz4kA:10 a=oUQuMaGMe1cA:10
Message-ID: <1393313845.2233.9.camel@slavad-CELSIUS-H720>
Subject: Re: [PATCH 1/1] hfsplus: fix longname handling
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: sougata@tuxera.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Feb 2014 11:37:25 +0400
In-Reply-To: <1393270107.27792.9.camel@ultrabook>
References: <1393270107.27792.9.camel@ultrabook>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.92 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sougata,

On Mon, 2014-02-24 at 21:28 +0200, Sougata Santra wrote:
> -ENAMETOOLONG returned from hfsplus_asc2uni was not propaged to iops. This
> allowed hfsplus to create files/directories with HFSPLUS_MAX_STRLEN and
> incorrect keys, leaving the FS in an inconsistent state. This patch fixes
> this issue.
> 

Good fix. Thank you.

I have some small remarks. Please, see below.

> Signed-off-by: Sougata Santra <sougata@tuxera.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/hfsplus/catalog.c    | 89 ++++++++++++++++++++++++++++++++++++-------------
>  fs/hfsplus/dir.c        | 11 ++++--
>  fs/hfsplus/hfsplus_fs.h |  4 ++-
>  fs/hfsplus/super.c      |  4 ++-
>  4 files changed, 79 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
> index 968ce41..389c474 100644
> --- a/fs/hfsplus/catalog.c
> +++ b/fs/hfsplus/catalog.c
> @@ -38,21 +38,30 @@ int hfsplus_cat_bin_cmp_key(const hfsplus_btree_key *k1,
>  	return hfsplus_strcmp(&k1->cat.name, &k2->cat.name);
>  }
>  
> -void hfsplus_cat_build_key(struct super_block *sb, hfsplus_btree_key *key,
> -			   u32 parent, struct qstr *str)
> +/* Generates key for catalog file/folders record. */
> +int hfsplus_cat_build_key(struct super_block *sb,
> +		hfsplus_btree_key *key, u32 parent, struct qstr *str)
>  {
> -	int len;
> +	int len, err;
>  
>  	key->cat.parent = cpu_to_be32(parent);
> -	if (str) {
> -		hfsplus_asc2uni(sb, &key->cat.name, HFSPLUS_MAX_STRLEN,
> -					str->name, str->len);
> -		len = be16_to_cpu(key->cat.name.length);
> -	} else {
> -		key->cat.name.length = 0;
> -		len = 0;
> -	}
> +	err = hfsplus_asc2uni(sb, &key->cat.name, HFSPLUS_MAX_STRLEN,
> +			str->name, str->len);
> +	if (unlikely(err < 0))
> +		return err;
> +
> +	len = be16_to_cpu(key->cat.name.length);
>  	key->key_len = cpu_to_be16(6 + 2 * len);

I think that maybe it is time to change hardcoded 6 on sensible named
constant. What do you think?

> +	return 0;
> +}
> +
> +/* Generates key for catalog thread record. */
> +void hfsplus_cat_build_key_with_cnid(struct super_block *sb,
> +			hfsplus_btree_key *key, u32 parent)
> +{
> +	key->cat.parent = cpu_to_be32(parent);
> +	key->cat.name.length = 0;
> +	key->key_len = cpu_to_be16(6);

Ditto.

>  }
>  
>  static void hfsplus_cat_build_key_uni(hfsplus_btree_key *key, u32 parent,

We have such code for hfsplus_cat_build_key_uni():

 58 static void hfsplus_cat_build_key_uni(hfsplus_btree_key *key, u32 parent,
 59                                       struct hfsplus_unistr *name)
 60 {
 61         int ustrlen;
 62 
 63         ustrlen = be16_to_cpu(name->length);

I suppose that it makes sense to check name->length here and return
error. We can check possible volume corruption here.

 64         key->cat.parent = cpu_to_be32(parent);
 65         key->cat.name.length = cpu_to_be16(ustrlen);
 66         ustrlen *= 2;
 67         memcpy(key->cat.name.unicode, name->unicode, ustrlen);
 68         key->key_len = cpu_to_be16(6 + ustrlen);
 69 }

What do you think about such suggestion?

> diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
> index 08846425b..66671c4 100644
> --- a/fs/hfsplus/hfsplus_fs.h
> +++ b/fs/hfsplus/hfsplus_fs.h
> @@ -443,8 +443,10 @@ int hfsplus_cat_case_cmp_key(const hfsplus_btree_key *,
>  		const hfsplus_btree_key *);
>  int hfsplus_cat_bin_cmp_key(const hfsplus_btree_key *,
>  		const hfsplus_btree_key *);
> -void hfsplus_cat_build_key(struct super_block *sb,
> +int hfsplus_cat_build_key(struct super_block *sb,
>  		hfsplus_btree_key *, u32, struct qstr *);
> +void hfsplus_cat_build_key_with_cnid(struct super_block *sb,

The whole style of the fix is good. But such mess looks not very good.
But it is not critical, of course. :)

Thanks,
Vyacheslav Dubeyko.


