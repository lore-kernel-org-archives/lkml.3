Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaLYWIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 17:08:50 -0500
Received: from mail.eperm.de ([89.247.134.16]:51080 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaLYWIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 17:08:47 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: leroy christophe <christophe.leroy@c-s.fr>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: algif_hash: splice of data > 2**16
Date: Thu, 25 Dec 2014 23:08:41 +0100
Message-ID: <3336170.jqoOL9TV9j@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1444883.Oc8SnflNUU@tachyon.chronox.de>
References: <8707521.TbV00HIEUx@tauon> <549AC946.2000909@c-s.fr> <1444883.Oc8SnflNUU@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. Dezember 2014, 16:12:53 schrieb Stephan Mueller:

Hi Christophe,

> Am Mittwoch, 24. Dezember 2014, 15:10:14 schrieb leroy christophe:
> 
> Hi leroy,
> 
> > Le 24/12/2014 10:03, Stephan Mueller a écrit :
> > > Am Dienstag, 23. Dezember 2014, 18:16:01 schrieb leroy christophe:
> > > 
> > > Hi leroy,
> > > 
> > >> Le 20/12/2014 07:37, Stephan Mueller a écrit :
> > >>> Am Donnerstag, 18. Dezember 2014, 13:22:20 schrieb leroy christophe:
> > >>> 
> > >>> Hi Christophe,
> > >>> 
> > >>>> Le 18/12/2014 13:15, Stephan Mueller a écrit :
> > >>>>> Hi Herbert,
> > >>>>> 
> > >>>>> While testing the vmsplice/splice interface of algif_hash I was made
> > >>>>> aware of the problem that data blobs larger than 16 pages do not
> > >>>>> seem
> > >>>>> to
> > >>>>> be hashed properly.
> > >>>>> 
> > >>>>> For testing, a file is mmap()ed and handed to vmsplice / splice. If
> > >>>>> the
> > >>>>> file is smaller than 2**16, the interface returns the proper hash.
> > >>>>> However, when the file is larger, only the first 2**16 bytes seem to
> > >>>>> be
> > >>>>> used.
> > >>>>> 
> > >>>>> When adding printk's to hash_sendpage, I see that this function is
> > >>>>> invoked exactly 16 times where the first 15 invocations have the
> > >>>>> MSG_MORE flag set and the last invocation does not have MSG_MORE.
> > >>>> 
> > >>>> Hi Stephan,
> > >>>> 
> > >>>> I have already noticed the same issue and proposed a patch, but I
> > >>>> never
> > >>>> got any feedback and it has never been merged, allthought I pinged it
> > >>>> a
> > >>>> few times.
> > >>>> 
> > >>>> See https://lkml.org/lkml/2014/4/18/276
> > >>> 
> > >>> After testing, this patch does not work for me. The operation still
> > >>> stops
> > >>> after 16 pages.
> > >> 
> > >> Yes, it looks like the function I fixed is exclusively used by
> > >> sendfile() system call.
> > >> So there is probably the same kind of fix to be done in another
> > >> function.
> > > 
> > > I do not believe that is the case. IMHO the blocking issue is found in
> > > the
> > > following code:
> > > 
> > > splice_from_pipe_feed walks the pipe->nrbufs. And vmsplice_to_pipe
> > > defines
> > > the maximum number of nrbufs as PIPE_DEF_BUFFERS -- which is 16. As
> > > subsequent functions allocate memory based on PIPE_DEF_BUFFERS, there is
> > > no trivial way to increase the number of pages to be processed.
> > > 
> > > Thus I see that the vmsplice/splice combo can at most operate on a chunk
> > > of 16 pages. Thus, you have to segment your input buffer into chunks of
> > > that size and invoke the vmsplice/splice syscalls for each segment.
> > 
> > Yes your are probably right. There splice needs to be called with
> > SPLICE_F_MORE flag, hope that works.
> 
> That is not the only one. Vmsplice works on a pipe. A pipe is backed by 16
> pages max. Thus, you have to call vmsplice once per 16 pages. The current
> code I am testing which seems to work is the following:
> 
> 	while (inlen) {
> 		size_t datalen = (inlen > MAXLEN) ? MAXLEN : inlen;
> 
> 		iov.iov_len = datalen;
> 		ret = _kcapi_common_vmsplice_data(handle, &iov, 1, datalen,
> 1);
> 		if (0 > ret)
> 			return ret;
> 		processed += ret;
> 		iov.iov_base = (void*)(uintptr_t)(in + processed);
> 		inlen -= ret;
> 	}
> 	return _kcapi_common_read_data(handle, out, outlen);

As I do not see an easy fix where a single vmsplice/splice syscall combo can 
be applied to an input data stream of arbitrary length, I added appropriate 
handling code in libkcapi version 0.6.2 [1].

This code follows the aforementioned approach to segment the input into 16 
PAGE_SIZE segments and send them to the kernel individually.

[1] http://www.chronox.de/libkcapi.html
-- 
Ciao
Stephan
