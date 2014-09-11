Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaIKOfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:35:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36155 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752065AbaIKOfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:35:05 -0400
Message-ID: <5411B304.4000203@fb.com>
Date: Thu, 11 Sep 2014 10:34:44 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <behanw@converseincode.com>, <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH v2] btrfs: LLVMLinux: Remove VLAIS
References: <1409957901-28962-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1409957901-28962-1-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-11_05:2014-09-11,2014-09-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=6.99440505513849e-15 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409110125
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/05/2014 06:58 PM, behanw@converseincode.com wrote:
> From: Vinícius Tinti <viniciustinti@gmail.com>
> 
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This is the original VLAIS struct.
> 
> struct {
> 	struct shash_desc shash;
> 	char ctx[crypto_shash_descsize(tfm)];
> } desc;
> 
> This patch instead allocates the appropriate amount of memory using an char
> array.
> 
> The new code can be compiled with both gcc and clang.
> 
> struct shash_desc contains a flexible array member member ctx declared with
> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
> of the array declared after struct shash_desc with long long.
> 
> No trailing padding is required because it is not a struct type that can
> be used in an array.
> 
> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
> as would be the case for a struct containing a member with
> CRYPTO_MINALIGN_ATTR.

We copied this from one of the other crypto api users, and I'm sure
cooking up all these patches was not a great way to your afternoon.

But, can I talk you into making a helper macro of some kind for this and
putting it into the crypto api headers?  Honestly this setup seems
really error prone.

-chris

> 
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> ---
>  fs/btrfs/hash.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/hash.c b/fs/btrfs/hash.c
> index 85889aa..a62743f 100644
> --- a/fs/btrfs/hash.c
> +++ b/fs/btrfs/hash.c
> @@ -33,18 +33,18 @@ void btrfs_hash_exit(void)
>  
>  u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length)
>  {
> -	struct {
> -		struct shash_desc shash;
> -		char ctx[crypto_shash_descsize(tfm)];
> -	} desc;
> +	char desc[sizeof(struct shash_desc) +
> +		crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
> +	struct shash_desc *shash = (struct shash_desc *)desc;
> +	u32 *ctx = (u32 *)shash_desc_ctx(shash);
>  	int err;
>  
> -	desc.shash.tfm = tfm;
> -	desc.shash.flags = 0;
> -	*(u32 *)desc.ctx = crc;
> +	shash->tfm = tfm;
> +	shash->flags = 0;
> +	*ctx = crc;
>  
> -	err = crypto_shash_update(&desc.shash, address, length);
> +	err = crypto_shash_update(shash, address, length);
>  	BUG_ON(err);
>  
> -	return *(u32 *)desc.ctx;
> +	return *ctx;
>  }
> 
