Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3KKMOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:14:40 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40907 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3KKMOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:14:31 -0500
Message-ID: <1384172064.18684.55.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC][PATCH 0/9] encrypted keys & key control op
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: d.kasatkin@samsung.com, Mimi Zohar <zohar@us.ibm.com>,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Safford <safford@linux.vnet.ibm.com>
Date: Mon, 11 Nov 2013 07:14:24 -0500
In-Reply-To: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
References: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111112-3532-0000-0000-000002EB3D36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2013-11-04 at 16:22 +0000, David Howells wrote:
> Hi Mimi, Dmitry,
> 
> Here's a series of patches, the last three of which attempt to fix up a
> problem with encrypted keys update method.  The preceding patches are fixes or
> are preparatory for other changes that I want to put underneath.
> 
> I really want to make all key types use ->preparse() to avoid a deadlock in
> the garbage collector with quota recycling, but encrypted_update() requires
> access to the old key - which you can't have in ->preparse() because the
> keyring isn't locked (and this lock is the root of the gc deadlock anyway).

Ok.

> Further, the existence of encrypted_update() means that add_key() will
> sometimes get things wrong with encrypted keys (add_key() will call ->update()
> if a matching key already exists rather than creating a new key).

I see.  The key_type structure defines a number of methods,
including .instantiate and .update.  I would have thought that
only .update would be allowed to update an existing key.  Instantiating
a new key should create a new key or fail, not update a key.  I'm sure
there is/was a good reason for add_key() to do both.

>   But you
> can't pre-search for the existence of a key and mould the payload accordingly
> because that means you can race against both add_key() and keyctl_unlink().

Would this still be the case, if you differentiated between
instantiating and updating a key?

> My solution is to add a new keyctl function that allows the caller to perform
> a type-specific operation on a key:
> 
> 	long keyctl_control(key_serial_t key_id,
> 			    const char *command,
> 			    char *reply_buffer,
> 			    size_t reply_size);

> This would then take a NUL-terminated string indicating the command and
> arguments and potentially return a reply up to the buffer length.

What is the usecase scenario that would require a reply_buffer?

> For instance:
> 
> 	keyctl_control(1234, "encrypted change-master-key fred's key", NULL, 0);
> 
> or, from the shell:
> 
> 	keyctl control 1234 "encrypted change-master-key fred's key"
> 
> (I think that requiring the command string to be prefixed with the expected
> key type is probably a good idea).

Agreed.  

Mimi

> The control op could also be used for other things like pushing a key into a
> TPM.

> What do you think?
> 
> David
> ---
> David Howells (9):
>       KEYS: The RSA public key algorithm needs to select MPILIB
>       KEYS: Provide a generic instantiation function
>       KEYS: struct key_preparsed_payload should have two payload pointers
>       KEYS: Allow expiry time to be set when preparsing a key
>       KEYS: Call ->free_preparse() even after ->preparse() returns an error
>       KEYS: Trusted: Use key preparsing
>       KEYS: Add a keyctl function to alter/control a key in type-dependent way
>       KEYS: Implement keyctl control for encrypted keys
>       KEYS: Fix encrypted key type update method
> 
> 
>  Documentation/security/keys.txt          |   48 +++++++-
>  crypto/asymmetric_keys/Kconfig           |    1 
>  crypto/asymmetric_keys/asymmetric_type.c |   27 ----
>  crypto/asymmetric_keys/x509_public_key.c |    2 
>  include/linux/key-type.h                 |   11 ++
>  include/uapi/linux/keyctl.h              |    1 
>  security/keys/compat.c                   |    6 +
>  security/keys/encrypted-keys/encrypted.c |  111 +++++++++++++-----
>  security/keys/internal.h                 |    2 
>  security/keys/key.c                      |   49 +++++++-
>  security/keys/keyctl.c                   |  104 ++++++++++++++++
>  security/keys/trusted.c                  |  190 ++++++++++++++----------------
>  12 files changed, 385 insertions(+), 167 deletions(-)
> 



