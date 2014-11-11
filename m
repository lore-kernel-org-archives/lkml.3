Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaKKCGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:06:41 -0500
Received: from mail.eperm.de ([89.247.134.16]:54316 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbaKKCGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:06:40 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: crypto: zeroization of sensitive data in af_alg
Date: Tue, 11 Nov 2014 03:06:32 +0100
Message-ID: <1533864.71MuF2upah@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141110140518.GD8578@gondor.apana.org.au>
References: <1979092.odOtqL46qU@tachyon.chronox.de> <20141110140518.GD8578@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 10. November 2014, 22:05:18 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Nov 09, 2014 at 11:33:52PM +0100, Stephan Mueller wrote:
> > while working on the AF_ALG interface, I saw no active zeroizations of
> > memory that may hold sensitive data that is maintained outside the kernel
> > crypto API cipher handles. I think the following memory segments fall
> > under that
> > category:
> Are you talking about temporary data that we generate as part of
> the processing? If so they should be zeroed by the entity that
> generates them.

I currently see that the IV buffer (owned by skcipher) and the message digest 
buffer (owned by hash) are not memset(0) before freeing them. I agree that 
both are not really sensitive data. But wouldn't it be prudent to memset(0) 
them nonetheless in the skcipher_sock_destruct and hash_sock_destruct 
functions, respectively? 
> 
> > However, I am failing to find the right spot to add a zeroization for the
> > latter one, i.e. the code that handles the pages send in by the user or
> > the
> > pages that are returned by the crypto API. Initially I thought
> > skcipher_pull_sgl is a good spot for the symmetric ciphers as it evicts
> > the
> > used pages out of the scope of the kernel crypto API. I added a
> > clear_page(sg_page(sg+1)) as well as memset(sg_page(sg+1), 0, plen) right
> > before the put_page call. All that I got in return was a BUG() from the
> > memory management layer.
> 
> I don't think I understand what exactly you're trying to zero.
> Can you give an example?

Apologies, my bad as I did not check get_user_pages_fast well enough. I see 
now that we operate on the pages in user space directly without copy_from_user 
that would imply a kernel-internal copy. Please disregard my comment.
> 
> Thanks,


-- 
Ciao
Stephan
