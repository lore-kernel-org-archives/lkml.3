Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbaLWOwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:52:40 -0500
Received: from mail.eperm.de ([89.247.134.16]:51013 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704AbaLWOwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:52:37 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Date: Tue, 23 Dec 2014 15:52:27 +0100
Message-ID: <4537021.IXSvIIgcH4@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141223115626.GA31450@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de> <101382546.xjTjAHLGAb@tachyon.chronox.de> <20141223115626.GA31450@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 23. Dezember 2014, 22:56:26 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Dec 23, 2014 at 09:14:43AM +0100, Stephan Mueller wrote:
> > - the check aead_readable() immediately before this check implements the
> > blocking if we do not have sufficient data *and* more data is to be
> > expected
> Good point.
> 
> In fact AEAD is rather awkward because you need to do everything
> in one go.  Perhaps we could adapt our kernel interface to allow
> partial AEAD operations?


I am not sure what you are referring to. The invocation does not need to be in 
one go. You can have arbitrary number of sendmsg calls. But all input data 
needs to be supplied before you call recvmsg.

Please see my test code that implements the following call sequence using the 
libkcapi wrapper API calls where I dissect the data to be sent to the kernel 
for testing purposes:

if (cavs_test->enc) {
                /* send assoc with init call */
                ret = kcapi_aead_stream_init_enc(&handle, &iov, 1);
                if (0 > ret) {
                        printf("Initialization of cipher buffer failed\n");
                        goto out;
                }
                /* send plaintext with last call */
                iov.iov_base = cavs_test->pt;
                iov.iov_len = cavs_test->ptlen;
                ret = kcapi_aead_stream_update_last(&handle, &iov, 1);
                if (0 > ret) {
                        printf("Sending last update buffer failed\n");
                        goto out;
                }
                ret = kcapi_aead_stream_op(&handle, &outiov, 1);
        } else {
                /* send assoc with init call */
                ret = kcapi_aead_stream_init_dec(&handle, &iov, 1);
                if (0 > ret) {
                        printf("Initialization of cipher buffer failed\n");
                        goto out;
                }
                /* send plaintext with intermediary call */
                iov.iov_base = cavs_test->ct;
                iov.iov_len = cavs_test->ctlen;
                ret = kcapi_aead_stream_update(&handle, &iov, 1);
                if (0 > ret) {
                        printf("Sending update buffer failed\n");
                        goto out;
                }
                /* send tag with last send call */
                iov.iov_base = cavs_test->tag;
                iov.iov_len = cavs_test->taglen;
                ret = kcapi_aead_stream_update_last(&handle, &iov, 1);
                if (0 > ret) {
                        printf("Sending last update buffer failed\n");
                        goto out;
                }
                ret = kcapi_aead_stream_op(&handle, &outiov, 1);
        }

Every call to kcapi_aead_stream_init_dec / kcapi_aead_stream_update / 
kcapi_aead_stream_update_last invokes one sendmsg syscall.

In essence, kcapi_aead_stream_update can be invoked with every byte you want 
to add to the message stream. This "stream" API of libkcapi is logially 
equivalent to the init/update/final of message digests.
> 
> I want to be very careful before we pin down our user-space
> interface since that's something that we cannot easily change
> while the kernel interface can be modified at any time.

I am fully with you and try to patiently present solutions.
> 
> Thanks,


-- 
Ciao
Stephan
