Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbaKSGa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 01:30:59 -0500
Received: from mail.eperm.de ([89.247.134.16]:54655 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaKSGa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 01:30:58 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 01/10] crypto: AF_ALG: add user space interface for AEAD
Date: Wed, 19 Nov 2014 07:30:52 +0100
Message-ID: <12318471.ucMNmAKX0e@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141119042704.GA19258@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <2398701.sGeMzIcHaz@tachyon.chronox.de> <20141119042704.GA19258@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 19. November 2014, 12:27:04 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Nov 19, 2014 at 05:20:42AM +0100, Stephan Mueller wrote:
> > When looking deeper into skcipher_sendmsg, I see that the input data is
> > copied into the kernel using memcpy_fromiovec. The memory is allocated
> > before the memcpy call by skcipher_alloc_sgl.
> 
> Zero-copy is done through sendpage.

I am slightly at a loss here -- if you could give me a hint on how you think 
it can be implemented, I would be grateful.

Let us assume the AD || plaintext buffer is known to the kernel, either 
through sendpage or sendmsg. The entire buffer is split into chunks of 
scatterlists with ctx->tsgl. After processing one scatterlist from ctx->tsgl, 
that scatterlist is released via skcipher_pull_sgl.

Now, for AD, we need to consider:

- AD can span multiple ctx->tsgl chunks

- these AD scatterlist chunks cannot be released after a normal encryption 
operation. The associated data must be available for multiple operations. So, 
while plaintext data is still flowing in, we need to keep operating with the 
same AD.

Thus I am wondering how the rather static nature of the AD can fit with the 
dynamic nature of the plaintext given the current implementation on how 
plaintext is handled in the kernel.

To me, AD in league with an IV considering its rather static nature. Having 
said that, the IV is also not transported via the plaintext interface, but via 
a setsockopt. Shouldn't the AD be handled the same way?
> 
> Cheers,


-- 
Ciao
Stephan
