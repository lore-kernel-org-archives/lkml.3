Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3BUPsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:48:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab3BUPsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:48:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, jwboyer@redhat.com, pjones@redhat.com,
        vgoyal@redhat.com, mjg59@srcf.ucam.org, keescook@chromium.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Load keys from signed PE binaries
Date: Thu, 21 Feb 2013 15:47:58 +0000
Message-ID: <30665.1361461678@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you pull this patchset please?

It provides a facility by which keys can be added dynamically to a kernel that
is running in secure-boot mode.  To permit a key to be loaded under such a
condition, we require that the new key be signed by a key that we already have
(and trust) - where keys that we "already have" could include those embedded in
the kernel, those in the UEFI database and those in cryptographic hardware.

Now, "keyctl add" will already handle X.509 certificates that are so signed,
but Microsoft's signing service will only sign runnable EFI PE binaries.

We could require that the user reboot into the BIOS, add the key, and then
switch back, but under some circumstances we want to be able to do this whilst
the kernel is running.

The way we have come up with to get around this is to embed an X.509
certificate containing the key in a section called ".keylist" in an EFI PE
binary and then get the binary signed by Microsoft.  The key can then be passed
to the kernel by passing the signed binary:

	keyctl padd asymmetric "" {ID of .system_keyring} <pekey.efi.signed

This command executes the following steps:

 (1) Parse the PE binary to locate the signature and the new key.

 (2) Parse the PKCS#7 message in the PE binary.

 (3) Parse the content of the PKCS#7 message which is in "Microsoft individual
     code signing form" (the mscode bits in my patches).  This contains the PE
     binary digest type and the expected resultant digest value.

 (4) Digest the signed parts of the PE binary and compare the digest obtained
     to the digest expected (obtained in step (3)).

 (5) Digest the signed parts of the PKCS#7 message (which covers the content
     data used in step (3)).

 (6) Verify the signature on the PKCS#7 message against one of the X.509
     certificates it contains.

 (7) Check the signatures on the chain of X.509 certificates in the PKCS#7
     message as far as possible.

 (8) Cross-reference the chain of X.509 certificates against the known keys the
     kernel already possesses, and if one is found, verify the signature of the
     nearest object to the PKCS#7 message that we can (or the PKCS#7 message
     itself) against the trusted key.

 (9) Pass the X.509 certificate embedded in the message to the X.509 parser to
     be turned into a key.

To make this work, step (8) requires access to the .module_sign keyring, so
this is separated from the module code to make the build dependencies simpler.
It is also renamed to .system_keyring as it can then be generic.

To make life easier whilst testing, I got rid of the "extra_certificates" file
and replaced it with a glob that just glues together all the "*.x509" files in
the source and build root directories.

Since this requires the ability to add to .system_keyring, I have had to turn
on WRITE permission for root - but so that _only_ trusted keys can be added,
I've added two more flags in key->flags:

	KEY_FLAG_TRUSTED - this key is trusted.

	KEY_FLAG_TRUSTED_ONLY - only links to trusted keys can be made to this
				keyring.

I'm not sure that this is the best mechanism by which to filter keyring
additions, but it's not currently visible to the user, and so can be changed.
One thing we might want to consider is using X.509 extension fields to contain
bitfields that indicate what is permitted of the key inside an X.509
certificate.  These contribute to the X.509 cryptographic digest and so are
secure.


What these patches then do is allow you to add new keys by signing them with a
key a user will already have.  There can be more than one source for these
keys: firstly, there is a key built into the kernel for module signing
purposes, and secondly, we have patches under development for extracting keys
from the UEFI signature database.


Note: Though we don't actually execute the PE binary container to get at the
key, the binary must be executable in the EFI environment for Microsoft to sign
it.

The test wrapper I'm using is this:

	#include <efi.h>
	#include <efilib.h>

	EFI_STATUS
	efi_main (EFI_HANDLE image_handle, EFI_SYSTEM_TABLE *systab)
	{
		InitializeLib(image_handle, systab);
		Print(L"This program contains a list of public keys.\n");
		return EFI_SUCCESS;
	}

	extern __attribute__((section(".keylist"))) const uint8_t certificate_list[];
	extern __attribute__((section(".keylist"))) const uint8_t certificate_list_end[];
	asm(".section .keylist,\"a\"\n"
	    "certificate_list:\n"
	    ".incbin \"signing_key.x509\"\n"
	    "certificate_list_end:"
	    );

and is built from pekey.c by something like this:

	CPPFLAGS := -nostdinc -I /usr/include/efi -I /usr/include/efi/x86_64

	CFLAGS := -O2 -fpic \
		-Wall -fshort-wchar -fno-strict-aliasing \
		-fno-merge-constants -mno-red-zone

	LDSCRIPT := /usr/lib64/gnuefi/elf_x86_64_efi.lds
	CRT0	:= /usr/lib64/gnuefi/crt0-efi-x86_64.o
	X509	:= magrathea
	KEY	:= /data/modsign/linux-modsign/signing_key.priv

	pekey.efi.signed: pekey.efi
		pesign -i $< -o $@ -c $(X509) -p $(KEY) -s -f

	pekey.efi: pekey.so
		objcopy \
			-j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel \
			-j .rela -j .reloc -j .keylist --target=efi-app-x86_64 $< $@

	pekey.so: pekey.o
		$(LD) -nostdlib -T $(LDSCRIPT) -shared -Bsymbolic $(CRT0) $< -o $@ \
			-L /usr/lib64 -lefi -lgnuefi \
			-L /usr/lib/gcc/x86_64-redhat-linux/4.7.2 -lgcc

	pekey.o: pekey.c Makefile
		$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

Signed-off-by: David Howells <dhowells@redhat.com>
---
The following changes since commit 406089d01562f1e2bf9f089fd7637009ebaad589:

  Merge tag 'trace-3.8-rc3-regression-fix' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace (2013-01-14 20:22:16 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.git tags/pekey-20130221

for you to fetch changes up to 4ea349d3bb1d3521b7df8dbf0e88fe41cd3c0683:

  MODSIGN: Fix including certificate twice when the signing_key.x509 already exists (2013-02-21 14:11:40 +0000)

----------------------------------------------------------------
(from the branch description for devel-pekey local branch)

clone of "master"
signed-pefile contained key

----------------------------------------------------------------
Chun-Yi Lee (1):
      MODSIGN: Fix including certificate twice when the signing_key.x509 already exists

David Howells (27):
      KEYS: Load *.x509 files into kernel keyring
      KEYS: Separate the kernel signature checking keyring from module signing
      KEYS: Add a 'trusted' flag and a 'trusted only' flag
      KEYS: Rename public key parameter name arrays
      KEYS: Move the algorithm pointer array from x509 to public_key.c
      KEYS: Store public key algo ID in public_key struct
      KEYS: Split public_key_verify_signature() and make available
      KEYS: Store public key algo ID in public_key_signature struct
      X.509: struct x509_certificate needs struct tm declaring
      X.509: Add bits needed for PKCS#7
      X.509: Embed public_key_signature struct and create filler function
      X.509: Check the algorithm IDs obtained from parsing an X.509 certificate
      X.509: Handle certificates that lack an authorityKeyIdentifier field
      X.509: Export certificate parse and free functions
      PKCS#7: Implement a parser [RFC 2315]
      PKCS#7: Digest the data in a signed-data message
      PKCS#7: Find the right key in the PKCS#7 key list and verify the signature
      PKCS#7: Verify internal certificate chain
      PKCS#7: Find intersection between PKCS#7 message and known, trusted keys
      Provide PE binary definitions
      pefile: Parse a PE binary to find a key and a signature contained therein
      pefile: Strip the wrapper off of the cert data block
      pefile: Parse the presumed PKCS#7 content of the certificate blob
      pefile: Parse the "Microsoft individual code signing" data blob
      pefile: Digest the PE binary and compare to the PKCS#7 data
      PEFILE: Validate PKCS#7 trust chain
      PEFILE: Load the contained key if we consider the container to be validly signed

 crypto/asymmetric_keys/Kconfig                     |  20 +-
 crypto/asymmetric_keys/Makefile                    |  30 ++
 crypto/asymmetric_keys/mscode.asn1                 |  28 ++
 crypto/asymmetric_keys/mscode_parser.c             | 110 +++++
 crypto/asymmetric_keys/pefile_parser.c             | 479 +++++++++++++++++++++
 crypto/asymmetric_keys/pefile_parser.h             |  36 ++
 crypto/asymmetric_keys/pkcs7.asn1                  | 127 ++++++
 crypto/asymmetric_keys/pkcs7_parser.c              | 326 ++++++++++++++
 crypto/asymmetric_keys/pkcs7_parser.h              |  72 ++++
 crypto/asymmetric_keys/pkcs7_trust.c               | 149 +++++++
 crypto/asymmetric_keys/pkcs7_verify.c              | 260 +++++++++++
 crypto/asymmetric_keys/public_key.c                |  60 ++-
 crypto/asymmetric_keys/public_key.h                |   6 +
 crypto/asymmetric_keys/x509.asn1                   |   2 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |  55 ++-
 crypto/asymmetric_keys/x509_parser.h               |  28 +-
 crypto/asymmetric_keys/x509_public_key.c           | 119 ++---
 include/crypto/public_key.h                        |   9 +-
 include/keys/system_keyring.h                      |  23 +
 include/linux/key-type.h                           |   1 +
 include/linux/key.h                                |   3 +
 include/linux/oid_registry.h                       |   7 +-
 include/linux/pe.h                                 | 448 +++++++++++++++++++
 init/Kconfig                                       |  13 +
 kernel/Makefile                                    |  47 +-
 kernel/modsign_pubkey.c                            | 104 -----
 kernel/module-internal.h                           |   2 -
 kernel/module_signing.c                            |   7 +-
 ...modsign_certificate.S => system_certificates.S} |   7 +-
 kernel/system_keyring.c                            | 103 +++++
 security/keys/key.c                                |   8 +
 security/keys/keyring.c                            |   4 +
 32 files changed, 2478 insertions(+), 215 deletions(-)
 create mode 100644 crypto/asymmetric_keys/mscode.asn1
 create mode 100644 crypto/asymmetric_keys/mscode_parser.c
 create mode 100644 crypto/asymmetric_keys/pefile_parser.c
 create mode 100644 crypto/asymmetric_keys/pefile_parser.h
 create mode 100644 crypto/asymmetric_keys/pkcs7.asn1
 create mode 100644 crypto/asymmetric_keys/pkcs7_parser.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_parser.h
 create mode 100644 crypto/asymmetric_keys/pkcs7_trust.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_verify.c
 create mode 100644 include/keys/system_keyring.h
 create mode 100644 include/linux/pe.h
 delete mode 100644 kernel/modsign_pubkey.c
 rename kernel/{modsign_certificate.S => system_certificates.S} (72%)
 create mode 100644 kernel/system_keyring.c
