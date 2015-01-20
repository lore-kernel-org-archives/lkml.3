Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbbATDT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:19:29 -0500
Received: from mail.eperm.de ([89.247.134.16]:59552 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbbATDI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:08:56 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v8 1/2] crypto: AF_ALG: add AEAD support
Date: Tue, 20 Jan 2015 04:08:48 +0100
Message-ID: <2322046.U2aPs8NjYq@tauon>
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150120030017.GA10475@gondor.apana.org.au>
References: <33040723.pAXIT3fl8h@tachyon.chronox.de> <1639027.yRSjDuRfFC@tachyon.chronox.de> <20150120030017.GA10475@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 20. Januar 2015, 14:00:17 schrieb Herbert Xu:

Hi Herbert,

>On Fri, Jan 09, 2015 at 04:30:45AM +0100, Stephan Mueller wrote:
>> Am Donnerstag, 8. Januar 2015, 22:09:31 schrieb Herbert Xu:
>> 
>> Hi Herbert,
>> 
>> > On Wed, Jan 07, 2015 at 04:51:38PM +0100, Stephan Mueller wrote:
>> > > +		if (!aead_writable(sk)) {
>> > > +			/*
>> > > +			 * If there is more data to be expected, 
but we cannot
>> > > +			 * write more data, forcefully define 
that we do not
>> > > +			 * expect more data to invoke the AEAD 
operation. This
>> > > +			 * prevents a deadlock in user space.
>> > > +			 */
>> > > +			ctx->more = 0;
>> > 
>> > We should return EMSGSIZE here.  Also we should clear out the
>> > existing data so that the socket may be reused again.
>> 
>> Is this really wise considering that we want to support a threaded
>> caller? For example, one thread sends data and another reads data.
>> For some reason, the reading thread is throttled or slower than the
>> sender. Now, with the current solution, the sender is put on hold
>> (i.e. throttled) until the reader can catch up. I.e. we have an
>> automated synchronization between sender/receiver.
>> 
>> Thus, when we remove the wait here and return an error, the sender
>> will be shut down and there is no synchronization of the
>> reader/writer any more.
>> 
>> Note, the same applies to the very similar code in aead_sendpage too.
>
>No, if we're in this case then something seriously wrong has
>happened.  IOW the application writer has screwed up.  We're
>not able to carry out the wish of user-space because of resource
>limits on the socket.  Attempting to continue at this point will
>only cause confusion.
>
>So we should loudly declare that there was an error.

Ok. Your suggestion implies that it needs to be removed in aead_sendmsg 
and aead_sendpage. That in turn implies aead_wait_for_wmem can go as 
well.

Also, my previous suggestion with MSG_TRUNC can be removed as well.

I will do that with my next installment.

Ciao
Stephan
