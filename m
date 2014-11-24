Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaKXO3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:29:55 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:36534 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaKXO3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:29:52 -0500
Date: Mon, 24 Nov 2014 22:29:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3 4/7] crypto: AF_ALG: add AEAD support
Message-ID: <20141124142945.GB31469@gondor.apana.org.au>
References: <4088013.2O8zCP0xXa@tachyon.chronox.de>
 <2175035.5IWBGpA0Ko@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2175035.5IWBGpA0Ko@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 06:32:16AM +0100, Stephan Mueller wrote:
> This patch adds the AEAD support for AF_ALG.
> 
> The AEAD implementation uses the entire memory handling and
> infrastructure of the existing skcipher implementation.
> 
> To use AEAD, the user space consumer has to use the salg_type named
> "aead". The AEAD extension only uses the bind callback as the key
> differentiator. The previously added functions that select whether to
> use AEAD or ablkcipher crypto API functions depend on the TFM type
> allocated during the bind() call.
> 
> The addition of AEAD brings a bit of overhead to calculate the size of
> the ciphertext, because the AEAD implementation of the kernel crypto API
> makes implied assumption on the location of the authentication tag. When
> performing an encryption, the tag will be added to the created
> ciphertext (note, the tag is placed adjacent to the ciphertext). For
> decryption, the caller must hand in the ciphertext with the tag appended
> to the ciphertext. Therefore, the selection of the used memory
> needs to add/subtract the tag size from the source/destination buffers
> depending on the encryption type. The code is provided with comments
> explainint when and how that operation is performed.
> 
> Note: The AF_ALG interface does not support zero length input data.
> Such zero length input data may be used if one wants to access the hash
> implementation of an AEAD directly (e.g. the GHASH of GCM or CMAC for
> CCM). However, this is a use case that is not of interest. GHASH or
> CMAC is directly available via the hash AF_ALG interface and we
> therefore do not need to take precautions for this use case.
> 
> A fully working example using all aspects of AEAD is provided at
> http://www.chronox.de/libkcapi.html
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

I appreciate the effort to share code, but shoe-horning AEAD into
algif_skcipher is just too ugly.

How about let's just start with a separate algif_aead and then
add helpers to merge common code as applicable?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
