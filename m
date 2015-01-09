Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbbAIDay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:30:54 -0500
Received: from mail.eperm.de ([89.247.134.16]:59412 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbbAIDaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:30:52 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v8 1/2] crypto: AF_ALG: add AEAD support
Date: Fri, 09 Jan 2015 04:30:45 +0100
Message-ID: <1639027.yRSjDuRfFC@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150108110931.GA8568@gondor.apana.org.au>
References: <33040723.pAXIT3fl8h@tachyon.chronox.de> <6260799.4x68Msg3Li@tachyon.chronox.de> <20150108110931.GA8568@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 8. Januar 2015, 22:09:31 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Jan 07, 2015 at 04:51:38PM +0100, Stephan Mueller wrote:
> > +		if (!aead_writable(sk)) {
> > +			/*
> > +			 * If there is more data to be expected, but we cannot
> > +			 * write more data, forcefully define that we do not
> > +			 * expect more data to invoke the AEAD operation. This
> > +			 * prevents a deadlock in user space.
> > +			 */
> > +			ctx->more = 0;
> 
> We should return EMSGSIZE here.  Also we should clear out the
> existing data so that the socket may be reused again.

Is this really wise considering that we want to support a threaded caller? For 
example, one thread sends data and another reads data. For some reason, the 
reading thread is throttled or slower than the sender. Now, with the current 
solution, the sender is put on hold (i.e. throttled) until the reader can 
catch up. I.e. we have an automated synchronization between sender/receiver.

Thus, when we remove the wait here and return an error, the sender will be 
shut down and there is no synchronization of the reader/writer any more.

Note, the same applies to the very similar code in aead_sendpage too.
> 
> > +	ctx->more = msg->msg_flags & MSG_MORE;
> > +	if (!ctx->more && !aead_sufficient_data(ctx))
> > +		err = -EINVAL;
> 
> Ditto, we should discard the data that's queued up.  Also perhaps
> use EBADMSG instead of EINVAL.

Agreed that we should clear out the buffer. I will provide that in the next 
release for both, the sendmsg and sendpage implementations.

However, I am not sure whether using EBADMSG is a good idea. The error of 
EBADMSG in the kernel crypto API is only used for integrity errors of AEAD 
ciphers. But our error case here has nothing to do with the integrity error.

I would be fine with any other error number -- EMSGSIZE as you suggested 
above?
> 
> > +	/*
> > +	 * Require exactly one IOV block as the AEAD operation is a one shot
> > +	 * due to the authentication tag.
> > +	 */
> > +	if (msg->msg_iter.nr_segs != 1)
> > +		return -ENOMSG;
> 
> Why does the receive buffer have to be contiguous?

I thought for quite some time about how we can use multiple iovecs. But I 
found no satisfactory solution. The solution I see is described below.

If we consider the skcipher implementation, the code iterates over the iovecs 
as the outermost loop. In each loop iteration the cipher operation is 
triggered.

Now in case of AEAD, all provided data the kernel received has to be operated 
on with exactly one cipher invocation. Looking at skcipher, that would mean 
that we only perform one loop iteration, i.e. processing exactly one iovec.

A possible solution would be that I use an array of struct af_alg_sgl and 
iterate over that array for each iovec. Something like the following:

struct aead_ctx {
...
	struct af_alg_sgl rsgl[ALG_MAX_PAGES];

for(i = 0; i < ALG_MAX_PAGES; i++) {
	af_alg_make_sg(rsgl[i], iov[i])
	scatterwalk_sg_chain(rsgl[i-1].sg rsgl[i]);
}

But my concern is that with the array of rsgl we occupy a sizable amount of 
memory as af_alg_sgl again defines arrays of entries.

Do you think whether such approach makes sense? If yes, which limit to the 
number of rsgl should we apply -- is ALG_MAX_PAGES good?

-- 
Ciao
Stephan
