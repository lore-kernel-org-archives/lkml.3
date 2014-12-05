Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaLEWDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:03:06 -0500
Received: from mail.eperm.de ([89.247.134.16]:54928 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaLEWDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:03:04 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v4 4/5] crypto: AF_ALG: add random number generator support
Date: Fri, 05 Dec 2014 23:02:59 +0100
Message-ID: <7181491.MIJ5ay4MmI@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.4-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141205155359.GA30224@gondor.apana.org.au>
References: <2105559.EmODblLYuY@tachyon.chronox.de> <1480776.TeURZV8VLa@tachyon.chronox.de> <20141205155359.GA30224@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 5. Dezember 2014, 23:53:59 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Dec 03, 2014 at 08:59:01PM +0100, Stephan Mueller wrote:
> > +static int rng_recvmsg(struct kiocb *unused, struct socket *sock,
> > +		       struct msghdr *msg, size_t len, int flags)
> > +{
> > +	struct sock *sk = sock->sk;
> > +	struct alg_sock *ask = alg_sk(sk);
> > +	struct rng_ctx *ctx = ask->private;
> > +	int err = -EFAULT;
> > +
> > +	if (len == 0)
> > +		return 0;
> > +	if (len > MAXSIZE)
> > +		len = MAXSIZE;
> > +
> > +	lock_sock(sk);
> 
> This lock simply protects ctx->result.  Since you're using a
> tiny buffer why not just put it on the stack?

When I developed the DRBG code, I got comments that 128 byte variables shall 
not be on the stack in kernel code.

But if you agree that I can put a 128 byte variable on the stack, I will see 
it done.

> 
> > +		u8 *buf = kmalloc(seedsize, GFP_KERNEL);
> > +		if (!buf)
> > +			goto err;
> > +		get_random_bytes(buf, seedsize);
> > +		ret = crypto_rng_reset(private, buf, len);
> 
> I think you should leave the seeding and the seed to the user.
> Perhaps do it through setsockopt (on the parent socket).

Sure. But please note that the seeding happens only when seedsize > 0. Such 
seeding therefore is not performed for krng, and the DRBG because both seed 
automatically.

Therefore, may I propose the following: We offer a setsockopt for (re)seeding. 
For all RNGs with seedsize > 0, we return EAGAIN for recvmsg until a 
setsockopt for at least seedsize is provided. That would imply that krng and 
DRBG would be usable without seeding from user space.

-- 
Ciao
Stephan
