Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaKXO6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:58:42 -0500
Received: from mail.eperm.de ([89.247.134.16]:54798 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbaKXO6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:58:39 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3 4/7] crypto: AF_ALG: add AEAD support
Date: Mon, 24 Nov 2014 15:58:34 +0100
Message-ID: <5492722.Cc6uZ9OM2L@tauon>
User-Agent: KMail/4.14.2 (Linux/3.17.2-200.fc20.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141124142945.GB31469@gondor.apana.org.au>
References: <4088013.2O8zCP0xXa@tachyon.chronox.de> <2175035.5IWBGpA0Ko@tachyon.chronox.de> <20141124142945.GB31469@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 24. November 2014, 22:29:46 schrieb Herbert Xu:

Hi Herbert,

>On Fri, Nov 21, 2014 at 06:32:16AM +0100, Stephan Mueller wrote:
>> This patch adds the AEAD support for AF_ALG.
>> 
>> The AEAD implementation uses the entire memory handling and
>> infrastructure of the existing skcipher implementation.
>> 
>> To use AEAD, the user space consumer has to use the salg_type named
>> "aead". The AEAD extension only uses the bind callback as the key
>> differentiator. The previously added functions that select whether to
>> use AEAD or ablkcipher crypto API functions depend on the TFM type
>> allocated during the bind() call.
>> 
>> The addition of AEAD brings a bit of overhead to calculate the size
>> of
>> the ciphertext, because the AEAD implementation of the kernel crypto
>> API makes implied assumption on the location of the authentication
>> tag. When performing an encryption, the tag will be added to the
>> created ciphertext (note, the tag is placed adjacent to the
>> ciphertext). For decryption, the caller must hand in the ciphertext
>> with the tag appended to the ciphertext. Therefore, the selection of
>> the used memory needs to add/subtract the tag size from the
>> source/destination buffers depending on the encryption type. The
>> code is provided with comments explainint when and how that
>> operation is performed.
>> 
>> Note: The AF_ALG interface does not support zero length input data.
>> Such zero length input data may be used if one wants to access the
>> hash implementation of an AEAD directly (e.g. the GHASH of GCM or
>> CMAC for CCM). However, this is a use case that is not of interest.
>> GHASH or CMAC is directly available via the hash AF_ALG interface
>> and we therefore do not need to take precautions for this use case.
>> 
>> A fully working example using all aspects of AEAD is provided at
>> http://www.chronox.de/libkcapi.html
>> 
>> Signed-off-by: Stephan Mueller <smueller@chronox.de>
>
>I appreciate the effort to share code, but shoe-horning AEAD into
>algif_skcipher is just too ugly.

Ok. But in the code you see that skcipher is a 100% subset of AEAD. For 
AEAD, all we need to do in addition to normal symmetric ciphers is to 
select the AEAD kernel crypto API calls, to locate and use the AD and to 
ensure we have the right memory size to process the tag.

How about the following:

Use algif_skcipher.c as the common code which requires:

- function pointers for the kernel crypto API backends

- function pointers for the AEAD specific handling which are invoked at 
the right places -- they are NULL in case of skcipher
>
>How about let's just start with a separate algif_aead and then
>add helpers to merge common code as applicable?

When we have a separate algif_aead, then I guess we want to allow 
skcipher and aead to be configured and compiled independently.

That raises the question where the common code should go? I would not 
suggest to put it into a header file. However, when adding it to a C 
file, how do you propose it should be considered in the Makefile. That C 
file needs to be compile once with either skcipher or aead.
>
>Thanks,


Ciao
Stephan
