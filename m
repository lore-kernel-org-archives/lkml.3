Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbbAQSXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 13:23:52 -0500
Received: from mail.eperm.de ([89.247.134.16]:59519 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbbAQSXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 13:23:50 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: tadeusz.struk@intel.com, aidan.o.mahony@intel.com,
        gabriele.paoloni@intel.com, adrian.hoban@intel.com
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Intel GCM: __driver-gcm-aes-aesni setkey missing
Date: Sat, 17 Jan 2015 19:23:42 +0100
Message-ID: <1976848.LqsUs5V3zD@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabriele, Adrian, Tadeusz, Aidan,

during testing of my algif_aead patch with the different GCM implementations I 
am able to trigger a kernel crash from user space using __driver-gcm-aes-
aesni.

As I hope that algif_aead is going to be included, unprivileged userspace 
would then reliably crash the kernel -- with the current kernel code, 
userspace has no interface to trigger the issue.

Looking into the kernel code I think I see where the issue is. The crash 
happens when setkey is invoked. The kernel crypto API defines setkey as the 
following:

static inline int crypto_aead_setkey(struct crypto_aead *tfm, const u8 *key,
                                     unsigned int keylen)
{
        struct aead_tfm *crt = crypto_aead_crt(tfm);

        return crt->setkey(crt->base, key, keylen);
}

This means that the kernel crypto API expects that ciphers always implement a 
setkey callback.

However, __driver-gcm-aes-aesni does not implement a setkey:

                .aead = {
                        .encrypt        = __driver_rfc4106_encrypt,
                        .decrypt        = __driver_rfc4106_decrypt,
                },

As I am not sure what the purpose of __driver-gcm-aes-aesni is (only a backend 
for RFC4106 GCM or a regular cipher), I did not yet create a patch. IMHO there 
are two solutions:

- either create a valid setkey callback so that a key is set

- or create a noop setkey that returns -EOPNOTSUPP which effectively disables 
that cipher for regular consumption.

Note, if it is only a backend for the RFC4106 implementation, may I ask why 
__driver-gcm-aes-aesni is implemented as a separate cipher that is registered 
with the kernel crypto API?

-- 
Ciao
Stephan
