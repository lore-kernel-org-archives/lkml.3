Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaLCUIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:08:12 -0500
Received: from mail.eperm.de ([89.247.134.16]:54905 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbaLCUHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:07:52 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: herbert@gondor.apana.org.au
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v4 0/5] crypto: AF_ALG: add AEAD and RNG support
Date: Wed, 03 Dec 2014 20:54:09 +0100
Message-ID: <2105559.EmODblLYuY@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.4-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
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

Both, AEAD and RNG implementations are stand-alone and do not depend
other AF_ALG interfaces (like hash or skcipher).

The AEAD implementation uses the same approach as provided with
skcipher by offering the following interfaces:

	* sendmsg and recvmsg interfaces allowing multiple
	  invocations supporting a threaded user space. To support
	  multi-threaded user space, kernel-side buffering
	  is implemented similarly to skcipher.

	* splice / vmsplice interfaces allowing a zero-copy
	  invocation

The RNG interface only implements the recvmsg interface as
zero-copy is not applicable.

The new AEAD and RNG interfaces are fully tested with the test application
provided at [1]. That test application exercises all newly added user space
interfaces. The testing covers:

	* use of the sendmsg/recvmsg interface

	* use of the splice / vmsplice interface

	* invocation of all AF_ALG types (aead, rng, skcipher, hash)

	* using all types of operation (encryption, decryption, keyed MD,
	  MD, random numbers, AEAD decryption with positive and negative
	  authentication verification)

	* stress testing by running all tests for 30 minutes in an
	  endless loop

	* test execution on 64 bit and 32 bit

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

Changes v4:
* stand-alone implementation of AEAD
* testing of all interfaces offered by AEAD
* stress testing of AEAD and RNG

Stephan Mueller (5):
  crypto: AF_ALG: add user space interface for AEAD
  crypto: AF_ALG: add AEAD support
  crypto: AF_ALG: enable AEAD interface compilation
  crypto: AF_ALG: add random number generator support
  crypto: AF_ALG: enable RNG interface compilation

 crypto/Kconfig              |  18 ++
 crypto/Makefile             |   2 +
 crypto/af_alg.c             |   6 +
 crypto/algif_aead.c         | 668 ++++++++++++++++++++++++++++++++++++++++++++
 crypto/algif_rng.c          | 186 ++++++++++++
 include/crypto/if_alg.h     |   1 +
 include/uapi/linux/if_alg.h |   2 +
 7 files changed, 883 insertions(+)
 create mode 100644 crypto/algif_aead.c
 create mode 100644 crypto/algif_rng.c

-- 
2.1.0


