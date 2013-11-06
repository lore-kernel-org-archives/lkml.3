Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3KFRU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:20:57 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45589 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3KFRUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:20:54 -0500
X-AuditID: cbfec7f4-b7f0a6d000007b1b-20-527a7a7330d7
Message-id: <527A7A4E.4020702@samsung.com>
Date: Wed, 06 Nov 2013 19:20:14 +0200
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: David Howells <dhowells@redhat.com>, zohar@us.ibm.com
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/9] encrypted keys & key control op
References: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
In-reply-to: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xK7rFVVVBBgeWG1u8a/rNYjF710MW
	i8u75rBZfOh5xGbxuvsZswOrx7QTy1g83u+7yuZx7lofs8fnTXIBLFFcNimpOZllqUX6dglc
	GfdP9LAV/JOsWP95BnsD4z7hLkZODgkBE4m/O2cwQdhiEhfurWcDsYUEljJKbHzH08XIBWQ3
	Mkm8/LSdCcKZyyixbc1KsCpeAS2JQ7NesIDYLAKqEtcPPGQGsdkE9CQ2NP9gB7FFBSIkjq5+
	xgpRLyjxY/I9sHoRAUuJlS2nwGxmgUSJ9X8WgtUIC9hKfH70jRHiCleJiaufgO3iFHCTWPdq
	PSNEvbrEpHmLmCFseYnNa94yQ9SrSnSvXcsG8Y2ixOnJ55gnMArPQrJ6FpL2WUjaFzAyr2IU
	TS1NLihOSs811CtOzC0uzUvXS87P3cQIiYgvOxgXH7M6xCjAwajEw5sgXxkkxJpYVlyZe4hR
	goNZSYRXILQqSIg3JbGyKrUoP76oNCe1+BAjEwenVANjwWp9tfaisBLxq2c2MJStab24wjb3
	dbn8MZElwatFhQWYVWfcSz1+c972nJbDWz16Zh/tbT+xMzxVImr+qZ6kkz/b/jvryWlOXHC5
	x9oyUaFBsuD2fcEpjN2fo9zUsmYkf5WxEL+v0H1kstW8gxlzD3U+cMj7K/mZZf5iK534FmZr
	3bTn8ziUWIozEg21mIuKEwFQE0AaZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

I will be looking to patches today...

- Dmitry

On 04/11/13 18:22, David Howells wrote:
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
>
> Further, the existence of encrypted_update() means that add_key() will
> sometimes get things wrong with encrypted keys (add_key() will call ->update()
> if a matching key already exists rather than creating a new key).  But you
> can't pre-search for the existence of a key and mould the payload accordingly
> because that means you can race against both add_key() and keyctl_unlink().
>
> My solution is to add a new keyctl function that allows the caller to perform
> a type-specific operation on a key:
>
> 	long keyctl_control(key_serial_t key_id,
> 			    const char *command,
> 			    char *reply_buffer,
> 			    size_t reply_size);
>
> This would then take a NUL-terminated string indicating the command and
> arguments and potentially return a reply up to the buffer length.
>
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
>
> The control op could also be used for other things like pushing a key into a
> TPM.
>
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
>

