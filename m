Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaHAJG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:06:58 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:5889
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750716AbaHAJGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:06:54 -0400
Message-ID: <53DB58A8.3070600@freescale.com>
Date: Fri, 1 Aug 2014 12:06:48 +0300
From: Cristian Stoica <cristian.stoica@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] crypto: add support for TLS 1.0 record encryption
References: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
 <1406626353-23309-2-git-send-email-cristian.stoica@freescale.com>
 <53DAA097.90005@amacapital.net>
In-Reply-To: <53DAA097.90005@amacapital.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(24454002)(199002)(189002)(479174003)(377454003)(80316001)(87936001)(23756003)(81342001)(44976005)(97736001)(33656002)(65806001)(83506001)(87266999)(69596002)(2201001)(59896001)(54356999)(76482001)(46102001)(107046002)(92726001)(86362001)(47776003)(80022001)(64126003)(106466001)(81156004)(20776003)(76176999)(81542001)(65956001)(74662001)(92566001)(79102001)(65816999)(99396002)(31966008)(83322001)(68736004)(26826002)(95666004)(50986999)(105606002)(50466002)(83072002)(84676001)(6806004)(102836001)(4396001)(77982001)(19580395003)(74502001)(64706001)(36756003)(85852003)(104016003)(21056001)(85306004);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB568;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029097202E
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy

On 31.07.2014 23:01, Andy Lutomirski wrote:
> On 07/29/2014 02:32 AM, Cristian Stoica wrote:
...
>> + * crypto_tls_genicv - Calculate hmac digest for a TLS record
>> + * @hash:	(output) buffer to save the digest into
>> + * @src:	(input) scatterlist with the payload data
>> + * @srclen:	(input) size of the payload data
>> + * @req:	(input) aead request (with pointers to associated data)
>> + **/
>> +static int crypto_tls_genicv(u8 *hash, struct scatterlist *src,
>> +			     unsigned int srclen, struct aead_request *req)
>> +{
>> +	struct crypto_aead *tls = crypto_aead_reqtfm(req);
>> +	struct crypto_tls_ctx *ctx = crypto_aead_ctx(tls);
>> +	struct tls_request_ctx *treq_ctx = aead_request_ctx(req);
>> +	struct scatterlist *assoc = req->assoc;
>> +	struct scatterlist *icv = treq_ctx->icv;
>> +	struct async_op ahash_op;
>> +	struct ahash_request *ahreq = (void *)(treq_ctx->tail + ctx->reqoff);
>> +	unsigned int flags = CRYPTO_TFM_REQ_MAY_SLEEP;
>> +	int err = -EBADMSG;
>> +
>> +	/*
>> +	 * Bail out as we have only two maneuvering scatterlists in icv. Check
>> +	 * also if the request assoc len matches the scatterlist len
>> +	 */
>> +	if (!req->assoclen || !sg_is_last(assoc) ||
>> +	    req->assoclen != assoc->length)
>> +		return err;
>> +
>> +	/*
>> +	 * Prepend associated data to the source scatterlist. If the source is
>> +	 * empty, use directly the associated data scatterlist
>> +	 */
>> +	if (srclen) {
>> +		sg_init_table(icv, 2);
>> +		sg_set_page(icv, sg_page(assoc), assoc->length, assoc->offset);
>> +		scatterwalk_sg_chain(icv, 2, src);
>> +	} else {
>> +		icv = assoc;
>> +	}
>> +	srclen += assoc->length;
>> +
>> +	init_completion(&ahash_op.completion);
>> +
>> +	/* the hash transform to be executed comes from the original request */
>> +	ahash_request_set_tfm(ahreq, ctx->auth);
>> +	/* prepare the hash request with input data and result pointer */
>> +	ahash_request_set_crypt(ahreq, icv, hash, srclen);
>> +	/* set the notifier for when the async hash function returns */
>> +	ahash_request_set_callback(ahreq, aead_request_flags(req) & flags,
>> +				   tls_async_op_done, &ahash_op);
>> +
>> +	/* Calculate the digest on the given data. The result is put in hash */
>> +	err = crypto_ahash_digest(ahreq);
>> +	if (err == -EINPROGRESS) {
>> +		err = wait_for_completion_interruptible(&ahash_op.completion);
>> +		if (!err)
>> +			err = ahash_op.err;
>> +	}
>> +
>> +	return err;
>> +}
>> +
...
>> +static int crypto_tls_decrypt(struct aead_request *req)
>> +{
>> +	struct crypto_aead *tls = crypto_aead_reqtfm(req);
>> +	struct crypto_tls_ctx *ctx = crypto_aead_ctx(tls);
>> +	struct tls_request_ctx *treq_ctx = aead_request_ctx(req);
>> +	struct scatterlist *assoc = req->assoc;
>> +	unsigned int cryptlen = req->cryptlen;
>> +	unsigned int hash_size = crypto_aead_authsize(tls);
>> +	unsigned int block_size = crypto_aead_blocksize(tls);
>> +	struct ablkcipher_request *abreq = (void *)(treq_ctx->tail +
>> +						    ctx->reqoff);
>> +	u8 padding[255]; /* padding can be 0-255 bytes */
>> +	u8 pad_size;
>> +	u16 *len_field;
>> +	u8 *ihash, *hash = treq_ctx->tail;
>> +
>> +	int paderr = 0;
>> +	int err = -EINVAL;
>> +	int i;
>> +	struct async_op ciph_op;
>> +
>> +	/*
>> +	 * Rule out bad packets. The input packet length must be at least one
>> +	 * byte more than the hash_size
>> +	 */
>> +	if (cryptlen <= hash_size || cryptlen % block_size)
>> +		goto out;
>> +
>> +	/*
>> +	 * Step 1 - Decrypt the source
>> +	 */
>> +	init_completion(&ciph_op.completion);
>> +
>> +	ablkcipher_request_set_tfm(abreq, ctx->enc);
>> +	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
>> +					tls_async_op_done, &ciph_op);
>> +	ablkcipher_request_set_crypt(abreq, req->src, req->dst, cryptlen,
>> +				     req->iv);
>> +	err = crypto_ablkcipher_decrypt(abreq);
>> +	if (err == -EINPROGRESS) {
>> +		err = wait_for_completion_interruptible(&ciph_op.completion);
>> +		if (!err)
>> +			err = ciph_op.err;
>> +	}
>> +	if (err)
>> +		goto out;
>> +
>> +	/*
>> +	 * Step 2 - Verify padding
>> +	 * Retrieve the last byte of the payload; this is the padding size
>> +	 */
>> +	cryptlen -= 1;
>> +	scatterwalk_map_and_copy(&pad_size, req->dst, cryptlen, 1, 0);
>> +
>> +	/* RFC recommendation to defend against timing attacks is to continue
>> +	 * with hash calculation even if the padding is incorrect */
>> +	if (cryptlen < pad_size + hash_size) {
>> +		pad_size = 0;
>> +		paderr = -EBADMSG;
>> +	}
>> +	cryptlen -= pad_size;
>> +	scatterwalk_map_and_copy(padding, req->dst, cryptlen, pad_size, 0);
>> +
>> +	/* Padding content must be equal with pad_size. We verify it all */
>> +	for (i = 0; i < pad_size; i++)
>> +		if (padding[i] != pad_size)
>> +			paderr = -EBADMSG;
>> +
>> +	/*
>> +	 * Step 3 - Verify hash
>> +	 * Align the digest result as required by the hash transform. Enough
>> +	 * space was allocated in crypto_tls_init_tfm
>> +	 */
>> +	hash = (u8 *)ALIGN((unsigned long)hash +
>> +			   crypto_ahash_alignmask(ctx->auth),
>> +			   crypto_ahash_alignmask(ctx->auth) + 1);
>> +	/*
>> +	 * Two bytes at the end of the associated data make the length field.
>> +	 * It must be updated with the length of the cleartext message before
>> +	 * the hash is calculated.
>> +	 */
>> +	len_field = sg_virt(assoc) + assoc->length - 2;
>> +	cryptlen -= hash_size;
>> +	*len_field = htons(cryptlen);
>> +
>> +	/* This is the hash from the decrypted packet. Save it for later */
>> +	ihash = hash + hash_size;
>> +	scatterwalk_map_and_copy(ihash, req->dst, cryptlen, hash_size, 0);
>> +
>> +	/* Now compute and compare our ICV with the one from the packet */
>> +	err = crypto_tls_genicv(hash, req->dst, cryptlen, req);
>> +	if (!err)
>> +		err = crypto_memneq(hash, ihash, hash_size) ? -EBADMSG : 0;
> 
> This looks like it's vulnerable to the Lucky 13 attack.

Digest is always calculated and in this particular case memneq should
help with some of the timing leaks. ICV calculation is expected to pass
and any failures should be only for internal reasons. There are maybe
some other problems that I've never thought of. Did you have something
else in mind when you mentioned this attack?

Cristian S.
