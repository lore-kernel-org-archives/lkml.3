Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3KDSOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:14:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab3KDSOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:14:23 -0500
Subject: [RFC][PATCH 0/9] encrypted keys & key control op
To: d.kasatkin@samsung.com, zohar@us.ibm.com
From: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Nov 2013 16:22:16 +0000
Message-ID: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mimi, Dmitry,

Here's a series of patches, the last three of which attempt to fix up a
problem with encrypted keys update method.  The preceding patches are fixes or
are preparatory for other changes that I want to put underneath.

I really want to make all key types use ->preparse() to avoid a deadlock in
the garbage collector with quota recycling, but encrypted_update() requires
access to the old key - which you can't have in ->preparse() because the
keyring isn't locked (and this lock is the root of the gc deadlock anyway).

Further, the existence of encrypted_update() means that add_key() will
sometimes get things wrong with encrypted keys (add_key() will call ->update()
if a matching key already exists rather than creating a new key).  But you
can't pre-search for the existence of a key and mould the payload accordingly
because that means you can race against both add_key() and keyctl_unlink().

My solution is to add a new keyctl function that allows the caller to perform
a type-specific operation on a key:

	long keyctl_control(key_serial_t key_id,
			    const char *command,
			    char *reply_buffer,
			    size_t reply_size);

This would then take a NUL-terminated string indicating the command and
arguments and potentially return a reply up to the buffer length.

For instance:

	keyctl_control(1234, "encrypted change-master-key fred's key", NULL, 0);

or, from the shell:

	keyctl control 1234 "encrypted change-master-key fred's key"

(I think that requiring the command string to be prefixed with the expected
key type is probably a good idea).

The control op could also be used for other things like pushing a key into a
TPM.

What do you think?

David
---
David Howells (9):
      KEYS: The RSA public key algorithm needs to select MPILIB
      KEYS: Provide a generic instantiation function
      KEYS: struct key_preparsed_payload should have two payload pointers
      KEYS: Allow expiry time to be set when preparsing a key
      KEYS: Call ->free_preparse() even after ->preparse() returns an error
      KEYS: Trusted: Use key preparsing
      KEYS: Add a keyctl function to alter/control a key in type-dependent way
      KEYS: Implement keyctl control for encrypted keys
      KEYS: Fix encrypted key type update method


 Documentation/security/keys.txt          |   48 +++++++-
 crypto/asymmetric_keys/Kconfig           |    1 
 crypto/asymmetric_keys/asymmetric_type.c |   27 ----
 crypto/asymmetric_keys/x509_public_key.c |    2 
 include/linux/key-type.h                 |   11 ++
 include/uapi/linux/keyctl.h              |    1 
 security/keys/compat.c                   |    6 +
 security/keys/encrypted-keys/encrypted.c |  111 +++++++++++++-----
 security/keys/internal.h                 |    2 
 security/keys/key.c                      |   49 +++++++-
 security/keys/keyctl.c                   |  104 ++++++++++++++++
 security/keys/trusted.c                  |  190 ++++++++++++++----------------
 12 files changed, 385 insertions(+), 167 deletions(-)

