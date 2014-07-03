Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030256AbaGCVIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:08:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030219AbaGCVIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:08:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, dhowells@redhat.com, pjones@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 0/9] kexec: Verify signature of PE signed bzImage
Date: Thu,  3 Jul 2014 17:07:12 -0400
Message-Id: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series enables signature verification of signed PE bzimage. This
patches series needs two more patch series before it.

First one is kexec_file_load() syscall support posted here.

https://lkml.org/lkml/2014/6/26/497

This patch seris is also available in -mm tree now.

Second one is PKCS7 signature parsing and verification support. These
patches are available in David Howells's modsign tree in pkcs7 branch.

https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-modsign.git/log/?h=pkcs7

This patch series is based on David Howells's work of PE file parsing
and PKCS7 signature verificaiton. Now PKCS7 signature part is available
in his tree. So I have taken PE file parsing patches, changed them a
bit and posting these here.

Now kexec bzImage loader calls into pefile parser and passes the PE
signed bzImage for signature verification.

Two new config options have been intorduced. First one is
CONFIG_KEXEC_VERIFY_SIG. This option enforces that kernel has to be
validly signed otherwise kernel load will fail. If this option is not
set, no signature verification will be done. Only exception will be
when secureboot is enabled. In that case signature verification should
be automatically enforced when secureboot is enabled. But that will
happen when secureboot patches are merged.

Second config option is CONFIG_KEXEC_BZIMAGE_VERIFY_SIG. This option
enables signature verification support on bzImage. If this option is
not set and previous one is set, kernel image loading will fail because
kernel does not have support to verify signature of bzImage.

I tested these patches with both "pesign" and "sbsign" signed bzImages.

I used signing_key.priv key and signing_key.x509 cert for signing as
generated during kernel build process (if module signing is enabled).

Used following method to sign bzImage.

pesign
======
- Convert DER format cert to PEM format cert
openssl x509 -in signing_key.x509 -inform DER -out signing_key.x509.PEM -outform PEM

- Generate a .p12 file from existing cert and private key file
openssl pkcs12 -export -out kernel-key.p12 -inkey signing_key.priv -in signing_key.x509.PEM

- Import .p12 file into pesign db
pk12util -i /tmp/kernel-key.p12 -d /etc/pki/pesign

- Sign bzImage
pesign -i /boot/vmlinuz-3.16.0-rc3+ -o /boot/vmlinuz-3.16.0-rc3+.signed.pesign -c "Glacier signing key - Magrathea" -s

sbsign
======
sbsign --key signing_key.priv --cert signing_key.x509.PEM --output /boot/vmlinuz-3.16.0-rc3+.signed.sbsign /boot/vmlinuz-3.16.0-rc3+

Please review. Any feedback is welcome.

Thanks
Vivek

Vivek Goyal (9):
  pkcs7: Forward declare struct key in pkcs7.h
  Provide PE binary definitions
  pefile: Parse a PE binary and verify signature
  pefile: Strip the wrapper off of the cert data block
  pefile: Parse the presumed PKCS#7 content of the certificate blob
  pefile: Parse the "Microsoft individual code signing" data blob
  pefile: Digest the PE binary and compare to the PKCS#7 data
  PEFILE: Validate PKCS#7 trust chain
  kexec: Verify the signature of signed PE bzImage

 arch/x86/Kconfig                   |  31 +++
 arch/x86/kernel/Makefile           |   7 +
 arch/x86/kernel/kexec-bzimage64.c  |  11 +
 arch/x86/kernel/machine_kexec_64.c |  11 +
 arch/x86/kernel/mscode.asn1        |  28 +++
 arch/x86/kernel/mscode_parser.c    | 126 +++++++++++
 arch/x86/kernel/pefile_parser.c    | 437 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pefile_parser.h    |  36 +++
 include/crypto/pkcs7.h             |   1 +
 include/linux/kexec.h              |   3 +
 include/linux/oid_registry.h       |   7 +-
 include/linux/pe.h                 | 448 +++++++++++++++++++++++++++++++++++++
 kernel/kexec.c                     |  15 ++
 13 files changed, 1160 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/mscode.asn1
 create mode 100644 arch/x86/kernel/mscode_parser.c
 create mode 100644 arch/x86/kernel/pefile_parser.c
 create mode 100644 arch/x86/kernel/pefile_parser.h
 create mode 100644 include/linux/pe.h

-- 
1.9.0

