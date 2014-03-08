Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaCHC1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 21:27:49 -0500
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:53126 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751581AbaCHC1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 21:27:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:2:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2393:2553:2559:2562:2692:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3871:3872:3873:3874:4049:4118:4250:4321:4423:4559:4605:5007:7576:7652:7875:7903:7974:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13869:13894,0,RBL:none,CacheIP:none
X-HE-Tag: toy98_609e30ca71128
X-Filterd-Recvd-Size: 7435
Message-ID: <1394245662.6972.12.camel@joe-AO722>
Subject: Re: [PATCH v2] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
From: Joe Perches <joe@perches.com>
To: Behan Webster <behanw@converseincode.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu,
        Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>,
        =?ISO-8859-1?Q?Vin=EDcius?= Tinti <viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Date: Fri, 07 Mar 2014 18:27:42 -0800
In-Reply-To: <531A7D4F.7090303@converseincode.com>
References: <1394177091.4653.1.camel@jlt4.sipsolutions.net>
	 <1394241960-1764-1-git-send-email-behanw@converseincode.com>
	 <1394243809.6972.4.camel@joe-AO722> <531A7D4F.7090303@converseincode.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 18:15 -0800, Behan Webster wrote:
> On 03/07/14 17:56, Joe Perches wrote:
> > On Fri, 2014-03-07 at 17:26 -0800, behanw@converseincode.com wrote:
> >> From: Jan-Simon Möller <dl9pf@gmx.de>
> >>
> >> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> >> compliant equivalent. This is the original VLAIS struct.
> > []
> >> diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
> > []
> >> @@ -23,12 +23,14 @@ void ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
> >>   			       u8 *data, size_t data_len, u8 *mic)
> >>   {
> >>   	struct scatterlist assoc, pt, ct[2];
> >> -	struct {
> >> -		struct aead_request	req;
> >> -		u8			priv[crypto_aead_reqsize(tfm)];
> >> -	} aead_req;
> >>   
> >> -	memset(&aead_req, 0, sizeof(aead_req));
> >> +	char aead_req_data[sizeof(struct aead_request) +
> >> +				crypto_aead_reqsize(tfm) +
> >> +				CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
> > Can this be a too large amount of stack?
> >
> > Is crypto_aead_reqsize() limited to < ~1k?
> >
> > Perhaps it'd be better to use kzalloc for this
> > or another reserved pool
> No more stack being used than with the the original code. The stack 
> memory use is identical.

I do understand that, but that's not my question.

I appreciate you're getting this to compile for llvm.

Any idea of the max value of crypto_aead_reqsize?

include/linux/crypto.h:static inline unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
include/linux/crypto.h-{
include/linux/crypto.h- return crypto_aead_crt(tfm)->reqsize;
include/linux/crypto.h-}

$ grep-2.5.4 -rP --include=*.[ch] "(?:->|\.)\s*\breqsize\s*=[^=][^;]+;" *
arch/x86/crypto/aesni-intel_glue.c:	tfm->crt_aead.reqsize = sizeof(struct aead_request)
		+ crypto_aead_reqsize(&cryptd_tfm->base);
crypto/chainiv.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
crypto/authenc.c:	tfm->crt_aead.reqsize = sizeof(struct authenc_request_ctx) +
				ctx->reqoff +
				max_t(unsigned int,
				crypto_ahash_reqsize(auth) +
				sizeof(struct ahash_request),
				sizeof(struct skcipher_givcrypt_request) +
				crypto_ablkcipher_reqsize(enc));
crypto/authencesn.c:	tfm->crt_aead.reqsize = sizeof(struct authenc_esn_request_ctx) +
				ctx->reqoff +
				max_t(unsigned int,
				crypto_ahash_reqsize(auth) +
				sizeof(struct ahash_request),
				sizeof(struct skcipher_givcrypt_request) +
				crypto_ablkcipher_reqsize(enc));
crypto/shash.c:	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
crypto/cryptd.c:	tfm->crt_ablkcipher.reqsize =
		sizeof(struct cryptd_blkcipher_request_ctx);
crypto/cryptd.c:	tfm->crt_aead.reqsize = sizeof(struct cryptd_aead_request_ctx);
crypto/seqiv.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
crypto/seqiv.c:	tfm->crt_aead.reqsize = sizeof(struct aead_request);
crypto/ablk_helper.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
		crypto_ablkcipher_reqsize(&cryptd_tfm->base);
crypto/ctr.c:	tfm->crt_ablkcipher.reqsize = align +
		sizeof(struct crypto_rfc3686_req_ctx) +
		crypto_ablkcipher_reqsize(cipher);
crypto/eseqiv.c:	tfm->crt_ablkcipher.reqsize = reqsize +
				      sizeof(struct ablkcipher_request);
crypto/ccm.c:	tfm->crt_aead.reqsize = align +
				sizeof(struct crypto_ccm_req_priv_ctx) +
				crypto_ablkcipher_reqsize(ctr);
crypto/ccm.c:	tfm->crt_aead.reqsize = sizeof(struct aead_request) +
				ALIGN(crypto_aead_reqsize(aead),
				      crypto_tfm_ctx_alignment()) +
				align + 16;
crypto/gcm.c:	tfm->crt_aead.reqsize = align +
		offsetof(struct crypto_gcm_req_priv_ctx, u) +
		max(sizeof(struct ablkcipher_request) +
		    crypto_ablkcipher_reqsize(ctr),
		    sizeof(struct ahash_request) +
		    crypto_ahash_reqsize(ghash));
crypto/gcm.c:	tfm->crt_aead.reqsize = sizeof(struct aead_request) +
				ALIGN(crypto_aead_reqsize(aead),
				      crypto_tfm_ctx_alignment()) +
				align + 16;
crypto/gcm.c:	tfm->crt_aead.reqsize = sizeof(struct crypto_rfc4543_req_ctx) +
				ALIGN(crypto_aead_reqsize(aead),
				      crypto_tfm_ctx_alignment()) +
				align + 16;
crypto/pcrypt.c:	tfm->crt_aead.reqsize = sizeof(struct pcrypt_request)
		+ sizeof(struct aead_givcrypt_request)
		+ crypto_aead_reqsize(cipher);
drivers/staging/sep/sep_crypto.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct this_task_ctx);
drivers/crypto/n2_core.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct n2_request_context);
drivers/crypto/mxs-dcp.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct dcp_aes_req_ctx);
drivers/crypto/sahara.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct sahara_aes_reqctx);
drivers/crypto/ccp/ccp-crypto-aes.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct ccp_aes_req_ctx);
drivers/crypto/ccp/ccp-crypto-aes.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct ccp_aes_req_ctx);
drivers/crypto/ccp/ccp-crypto-aes-xts.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct ccp_aes_req_ctx) +
				      fallback_tfm->base.crt_ablkcipher.reqsize;
drivers/crypto/s5p-sss.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct s5p_aes_reqctx);
drivers/crypto/atmel-aes.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct atmel_aes_reqctx);
drivers/crypto/ixp4xx_crypto.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct ablk_ctx);
drivers/crypto/ixp4xx_crypto.c:	tfm->crt_aead.reqsize = sizeof(struct aead_ctx);
drivers/crypto/omap-des.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct omap_des_reqctx);
drivers/crypto/mv_cesa.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct mv_req_ctx);
drivers/crypto/omap-aes.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct omap_aes_reqctx);
drivers/crypto/hifn_795x.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct hifn_request_context);
drivers/crypto/amcc/crypto4xx_core.c:		tfm->crt_ablkcipher.reqsize = sizeof(struct crypto4xx_ctx);
drivers/crypto/atmel-tdes.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct atmel_tdes_reqctx);
drivers/crypto/picoxcell_crypto.c:	tfm->crt_aead.reqsize = sizeof(struct spacc_req);
drivers/crypto/picoxcell_crypto.c:	tfm->crt_ablkcipher.reqsize = sizeof(struct spacc_req);
include/crypto/internal/hash.h:	tfm->reqsize = reqsize;


