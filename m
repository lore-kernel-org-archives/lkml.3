Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbaKUFm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 00:42:59 -0500
Received: from mail.eperm.de ([89.247.134.16]:54767 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757772AbaKUFm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 00:42:57 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH v3 0/7] crypto: AF_ALG: add AEAD and RNG support
Date: Fri, 21 Nov 2014 06:29:36 +0100
Message-ID: <4088013.2O8zCP0xXa@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.3-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set adds AEAD and RNG support to the AF_ALG interface
exported by the kernel crypto API. By extending AF_ALG with AEAD and RNG
support, all cipher types the kernel crypto API allows access to are
now accessible from userspace.

The RNG support is stand-alone.

The AEAD implementation is added to algif_skcipher.c to prevent
re-implementation of the memory moving logic.

The extension for the AEAD support can be summarized with the following
types of changes:

        * select the correct crypto API functions (either the ablkcipher
          or the aead functions)

        * apply the additional data needed for AEAD at the right time
          (associated data, authentication tag) -- this includes the addition
          of user space interfaces to allow setting this data.

        * add the calculation for the memory size needed for encryption and
          decryption.

In addition, the patch set adds a getsockopt implementation to skcipher to
allow user space to inquire about properties of the ciphers (IV size,
block size, authentication data size). This extension would be needed for a
generic user space usage of these ciphers.

The new AEAD and RNG interfaces are fully tested with the test application
provided at [1]. That test application exercises all newly added user space
interfaces.


Stephan Mueller (7):
*tch set was tested on x86_64 and i386.

[1] http://www.chronox.de/libkcapi.html

Changes v2:
* rebase to current cryptodev-2.6 tree
* use memzero_explicit to zeroize AEAD associated data
* use sizeof for determining length of AEAD associated data
* update algif_rng.c covering all suggestions from Daniel Borkmann
  <dborkman@redhat.com>
* addition of patch 9: add digestsize interface for hashes
* addition of patch to update documentation covering the userspace interface
* change numbers of getsockopt options: separate them from sendmsg interface
  definitions

Changes v3:
* remove getsockopt interface
* AEAD: associated data is set prepended to the plain/ciphertext
* AEAD: allowing arbitrary associated data lengths
* remove setkey patch as protection was already in the existing code

  crypto: AF_ALG: add user space interface for AEAD
  crypto: AF_ALG: extend data structuers for AEAD
  crypto: AF_ALG: crypto API calls to inline functions
  crypto: AF_ALG: add AEAD support
  crypto: AF_ALG: add random number generator support
  crypto: AF_ALG: enable RNG interface compilation
  crypto: AF_ALG: document the user space interface

 Documentation/crypto/crypto-API-userspace.txt |  70 +++++-
 crypto/Kconfig                                |   9 +
 crypto/Makefile                               |   1 +
 crypto/af_alg.c                               |  12 +
 crypto/algif_rng.c                            | 186 ++++++++++++++++
 crypto/algif_skcipher.c                       | 308 +++++++++++++++++++++++---
 include/crypto/if_alg.h                       |   2 +
 include/uapi/linux/if_alg.h                   |   2 +
 8 files changed, 559 insertions(+), 31 deletions(-)
 create mode 100644 crypto/algif_rng.c

-- 
2.1.0


