Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaLGM41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 07:56:27 -0500
Received: from mail.eperm.de ([89.247.134.16]:54941 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbaLGM4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 07:56:25 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v4 2/5] crypto: AF_ALG: add AEAD support
Date: Sun, 07 Dec 2014 13:56:18 +0100
Message-ID: <7942347.xfhvIblSTf@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.4-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141205154606.GA30180@gondor.apana.org.au>
References: <2105559.EmODblLYuY@tachyon.chronox.de> <4875720.jRoMDtjHB4@tachyon.chronox.de> <20141205154606.GA30180@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 5. Dezember 2014, 23:46:06 schrieb Herbert Xu:

Hi Herbert,

> > +static struct proto_ops algif_aead_ops = {
> > +	.family		=	PF_ALG,
> > +
> > +	.connect	=	sock_no_connect,
> > +	.socketpair	=	sock_no_socketpair,
> > +	.getname	=	sock_no_getname,
> > +	.ioctl		=	sock_no_ioctl,
> > +	.listen		=	sock_no_listen,
> > +	.shutdown	=	sock_no_shutdown,
> > +	.getsockopt	=	sock_no_getsockopt,
> > +	.mmap		=	sock_no_mmap,
> > +	.bind		=	sock_no_bind,
> > +	.accept		=	sock_no_accept,
> > +
> > +	.release	=	af_alg_release,
> > +	.sendmsg	=	aead_sendmsg,
> > +	.sendpage	=	aead_sendpage,
> > +	.recvmsg	=	aead_recvmsg,
> > +	.poll		=	aead_poll,
> > +	.setsockopt	=	aead_setsockopt,
> 
> No it should go into the parent setsockopt.  Perhaps add a setsockopt
> to af_alg_type in order to keep this out of the generic code.

What about adding a setauthsize to af_alg_type that is called from the parent 
setsockopt? I would like to keep all user space interfaces as close together 
as possible. With a new setsockopt callback, I fear that user space interface 
handling may be scattered around.

Currently I am simply thinking about the following:

partent setsockopt:

        case ALG_SET_AEAD_AUTHSIZE:
                if (sock->state == SS_CONNECTED)
                        goto unlock;
                if (!type->setauthsize)
                        goto unlock;
                err = type->setauthsize(ask->private, optlen);

af_alg_type:

int (*setauthsize)(void *private, unsigned int authsize);

-- 
Ciao
Stephan
