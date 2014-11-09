Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaKJHxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:53:21 -0500
Received: from mail.eperm.de ([89.247.134.16]:54309 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaKJHxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:53:14 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: crypto: zeroization of sensitive data in af_alg
Date: Sun, 09 Nov 2014 23:33:52 +0100
Message-ID: <1979092.odOtqL46qU@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

while working on the AF_ALG interface, I saw no active zeroizations of memory 
that may hold sensitive data that is maintained outside the kernel crypto API 
cipher handles. I think the following memory segments fall under that 
category:

	* message digest

	* IV

	* plaintext / ciphertext handed in by consumer

	* ciphertext / plaintext that is send back to the consumer

May I ask whether such zeroizations are present? At least I did not find it. 
If we conclude that there is a need for adding such zeroizations, I checked 
the code for the appropriate locations:

I think I found the location for the first one: hash_sock_destruct that should 
be enhanced with a memset(0) of ctx->result. I have a patch ready which is 
tested and works.

For the IV, I think I found the spot as well: skcipher_sock_destruct. This 
function should be enhanced with a memset(0) of ctx->iv. Again, I have a patch 
ready which is tested and works.

However, I am failing to find the right spot to add a zeroization for the 
latter one, i.e. the code that handles the pages send in by the user or the 
pages that are returned by the crypto API. Initially I thought 
skcipher_pull_sgl is a good spot for the symmetric ciphers as it evicts the 
used pages out of the scope of the kernel crypto API. I added a 
clear_page(sg_page(sg+1)) as well as memset(sg_page(sg+1), 0, plen) right 
before the put_page call. All that I got in return was a BUG() from the memory 
management layer.

Then I tried the same in af_alg_free_sg() as this function is used by 
algif_hash.c -- with the same result.

That makes me wonder: where should such a zeroization call be added?

Thanks

-- 
Ciao
Stephan
