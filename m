Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaKSGqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 01:46:07 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:33679 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaKSGqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 01:46:05 -0500
Date: Wed, 19 Nov 2014 14:45:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 01/10] crypto: AF_ALG: add user space interface for
 AEAD
Message-ID: <20141119064549.GA19918@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2398701.sGeMzIcHaz@tachyon.chronox.de>
 <20141119042704.GA19258@gondor.apana.org.au>
 <12318471.ucMNmAKX0e@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12318471.ucMNmAKX0e@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 07:30:52AM +0100, Stephan Mueller wrote:
> 
> - these AD scatterlist chunks cannot be released after a normal encryption 
> operation. The associated data must be available for multiple operations. So, 
> while plaintext data is still flowing in, we need to keep operating with the 
> same AD.

We don't start an AEAD operation until the entire input has been
received.  Unlike ciphers you cannot process AEAD requests as you
go.

So there is no need to special-case AD chunks since you will have
everything at your disposal before you can feed the request to the
crypto API.

> Thus I am wondering how the rather static nature of the AD can fit with the 
> dynamic nature of the plaintext given the current implementation on how 
> plaintext is handled in the kernel.
> 
> To me, AD in league with an IV considering its rather static nature. Having 
> said that, the IV is also not transported via the plaintext interface, but via 
> a setsockopt. Shouldn't the AD be handled the same way?

AD is not like an IV at all.  An IV is a fixed-size (and small)
input while AD can be of any length.

Think about how this is used in real life.  For IPsec AD is the part
of the packet that we don't encrypt.  So there is nothing fundamentally
different between AD and the plain-text that we do encrypt except
that you don't encrypt it :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
