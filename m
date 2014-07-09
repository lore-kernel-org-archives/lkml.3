Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbaGISZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:25:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbaGISZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:25:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, bp@alien8.de,
        akpm@linux-foundation.org, dhowells@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 0/1] kexec: verify bzImage signature
Date: Wed,  9 Jul 2014 14:24:06 -0400
Message-Id: <1404930247-7546-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the final piece of the puzzle of verifying kernel image signature
during kexec_file_load() syscall.

It relies on following two patch series.

- kexec_file_load() syscall patches

  https://lkml.org/lkml/2014/6/26/497 

  This patch series is now available in -mm tree.

- PE File parsing and signature verification

  http://thread.gmane.org/gmane.linux.kernel/1742967	 

  This patch series is also available here.

  http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-modsign.git/log/?h=pefile

This patch calls into PE file routines to verify signature of bzImage. If
signature are valid, kexec_file_load() succeeds otherwise it fails.

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
openssl x509 -in signing_key.x509 -inform DER -out signing_key.x509.PEM -outform
PEM

- Generate a .p12 file from existing cert and private key file
openssl pkcs12 -export -out kernel-key.p12 -inkey signing_key.priv -in
signing_key.x509.PEM

- Import .p12 file into pesign db
pk12util -i /tmp/kernel-key.p12 -d /etc/pki/pesign

- Sign bzImage
pesign -i /boot/vmlinuz-3.16.0-rc3+ -o /boot/vmlinuz-3.16.0-rc3+.signed.pesign
-c "Glacier signing key - Magrathea" -s

sbsign
======
sbsign --key signing_key.priv --cert signing_key.x509.PEM --output
/boot/vmlinuz-3.16.0-rc3+.signed.sbsign /boot/vmlinuz-3.16.0-rc3+

Thanks
Vivek

Vivek Goyal (1):
  kexec: Verify the signature of signed PE bzImage

 arch/x86/Kconfig                   | 22 ++++++++++++++++++++++
 arch/x86/kernel/kexec-bzimage64.c  | 21 +++++++++++++++++++++
 arch/x86/kernel/machine_kexec_64.c | 11 +++++++++++
 include/linux/kexec.h              |  3 +++
 kernel/kexec.c                     | 15 +++++++++++++++
 5 files changed, 72 insertions(+)

-- 
1.9.0

