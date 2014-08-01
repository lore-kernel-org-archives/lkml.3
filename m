Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaHAOos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:44:48 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36546 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaHAOor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:44:47 -0400
MIME-Version: 1.0
In-Reply-To: <53DB58A8.3070600@freescale.com>
References: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
 <1406626353-23309-2-git-send-email-cristian.stoica@freescale.com>
 <53DAA097.90005@amacapital.net> <53DB58A8.3070600@freescale.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 1 Aug 2014 07:44:23 -0700
Message-ID: <CALCETrX3r2shBVTCR=WEmXNV+L=Qk7+ZxKYamWZ4EjVLgqU5kg@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: add support for TLS 1.0 record encryption
To: Cristian Stoica <cristian.stoica@freescale.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 2:06 AM, Cristian Stoica
<cristian.stoica@freescale.com> wrote:
> Hi Andy
>
> On 31.07.2014 23:01, Andy Lutomirski wrote:
>> On 07/29/2014 02:32 AM, Cristian Stoica wrote:
> ...

>>> +static int crypto_tls_decrypt(struct aead_request *req)
>>> +{

>>> +    /*
>>> +     * Step 2 - Verify padding
>>> +     * Retrieve the last byte of the payload; this is the padding size
>>> +     */
>>> +    cryptlen -= 1;
>>> +    scatterwalk_map_and_copy(&pad_size, req->dst, cryptlen, 1, 0);
>>> +
>>> +    /* RFC recommendation to defend against timing attacks is to continue
>>> +     * with hash calculation even if the padding is incorrect */
>>> +    if (cryptlen < pad_size + hash_size) {
>>> +            pad_size = 0;
>>> +            paderr = -EBADMSG;

If this happens, then pad_size == 0.

>>> +    }

else pad_size is likely to be nonzero.

>>> +    cryptlen -= pad_size;

So now cryptlen depends on the result of the decryption, which means
that this part is not constant time:

>>> +
>>> +    /* Now compute and compare our ICV with the one from the packet */
>>> +    err = crypto_tls_genicv(hash, req->dst, cryptlen, req);
>>> +    if (!err)
>>> +            err = crypto_memneq(hash, ihash, hash_size) ? -EBADMSG : 0;
>>
>> This looks like it's vulnerable to the Lucky 13 attack.
>
> Digest is always calculated and in this particular case memneq should
> help with some of the timing leaks. ICV calculation is expected to pass
> and any failures should be only for internal reasons. There are maybe
> some other problems that I've never thought of. Did you have something
> else in mind when you mentioned this attack?
>
> Cristian S.

If I understand it correctly, the issue is that cryptlen depends on
the padding.  I added some notes inline above.  See here, too:

https://www.imperialviolet.org/2013/02/04/luckythirteen.html

--Andy
