Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaKHAch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:32:37 -0500
Received: from mail.eperm.de ([89.247.134.16]:54293 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbaKHAcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:32:36 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: crypto: algif_skcipher: check for IV size superfluous?
Date: Sat, 08 Nov 2014 01:32:30 +0100
Message-ID: <8150359.mtACJVFlUb@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

I am in the process to extend algif_skcipher to support AEAD ciphers as well. 
The code already works but I want to run final tests before releasing it.

In the course of the development I stumbled over the following code:

static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
			    struct msghdr *msg, size_t size)
{
...
		if (con.iv && con.iv->ivlen != ivsize)
			return -EINVAL;

This code effectively requires that any user space code trying to use a cipher 
must provide an IV that is equal to the blocksize of the cipher.

I am wondering why this check is there or whether we can remove that.

When using the kernel crypto API inside the kernel, there is no such 
enforcement. One can take shorter IVs which are implicitly padded with 
trailing zeros.

I would like to allow such non-aligned IVs from user space as well. As the 
user space interface invokes the kernel crypto API functions that allow the 
non-aligned use inside the kernel, I would not anticipate a problem.

However, if we conclude that the check should remain, then I am wondering 
whether we have to move it to the various _setiv functions of the kernel 
crypto API instead of leaving it in the skcipher interface. 

During my testing, I removed the check and provided different sized IVs just 
as I would in kernel space. The kernel crypto API processed them normally and 
the resulting ciphertext / plaintext is as expected.

An example that I used are the following parameters for a decryption operation 
successfully taken from the FIPS 140-2 CAVS tool with an IV shorter than the 
blocksize:

AEAD_name_1="gcm(aes)"
AEAD_msg_1="d127b39d365d16246d2866b2ebabd201"	# Ciphertext
AEAD_key_1="38bd9eb2cb29cc42ac38d6cdbe116760"	# key
AEAD_iv_1="aac774c39e399e7d6371ec1d"		# IV
AEAD_tag_1="34a21cc3562f0ba141d73242e5a3b666"	# Authentication Tag
AEAD_taglen_1="16"
AEAD_assoc_1="5dbb2884f3fe93664613e863c3bd2572855cf808765880ef1fa5787ceef8c793"
						# Associated data
AEAD_exp_1="8f9ec088580c23fc6f5fc011d52f061b"	# Expected plaintext


Thank you
-- 
Ciao
Stephan
