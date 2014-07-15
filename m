Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbaGOM4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:56:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54160 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669AbaGOM4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:56:23 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-9e-53c524e9b23b
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 0/4] ima: require signed user-space initialization
Date: Tue, 15 Jul 2014 15:54:19 +0300
Message-id: <cover.1405428802.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t/xK7ovVY4GG3y9zWgxZ/0aNotbf/cy
	W7xr+s1i8WVpncXLGfPYLS7vmsNm8aHnEZvFpxWTmB04PHbOusvucWLGbxaPB4c2s3jsXvCZ
	yeP9vqtsHn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJVxt2snY8EXoYpVK7axNTD28XcxcnJI
	CJhInP+3gQ3CFpO4cG89mC0ksJRRYkofYxcjF5DdySTx6Pt/VpAEm4CexIbmH+wgCRGBdkaJ
	A9dPs4MkmAVqJB72LGIBsYUFXCXaF+4BauDgYBFQlZjUmA8S5hWwlLjePIcVYpmcxMljk1kn
	MHIvYGRYxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESQF93MC49ZnWIUYCDUYmH98a0I8FC
	rIllxZW5hxglOJiVRHgLlY4GC/GmJFZWpRblxxeV5qQWH2Jk4uCUamCctn7u/vluOQb5PzIe
	7F9tEuW1dEOB0IdDNyZL7+i5sbDd6Czfu/0P370oan3m2dL/X09ZMZiFq/1GgKbfhcjbUzIX
	dMcpX5mo8Y5BY+FFx7rNUz9/eTNp+2GGRS2xXxuOsft5RvwJ46hsapxdFsd7682mJ+t9/M0O
	yitHGTPY/ThnNas0a4uzEktxRqKhFnNRcSIAmXbGMP4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently secure IMA/EVM initialization has to be done from the initramfs,
embedded in the signed kernel image. Many systems do not want to use
initramfs or usage of embedded initramfs makes it difficult to have
multi-target kernels.

This is a very simple patchset which makes it possible to perform secure
initialization by requiring initial user-space to be signed.

It does it by:
- introducing IMA public keys loading hook
- loading IMA trusted public key into .ima trusted keyring
- making default IMA appraisal policy to require everything to be signed

When builtin initramfs is not in use, keys cannot be read from initcalls,
because root filesystem is not yet mounted. In order to read keys before
executing init process, ima_prepare_keys() hook is introduced. Reading
public keys from the kernel is justified because signature verification
key is needed in order to verify anything else which is read from the
file system. Public keys are X509 certificates and itself signed by the
trusted key from the .system keyring. Kernel BIG KEYS support is an example
of reading keys directly by the kernel.

CONFIG_IMA_APPRAISE_SIGNED_INIT kernel option is provided to make the IMA
default appraisal policy to required signature validation. Signed init
process need to initialize EVM key and load appropriate IMA policy which
would not require everything to be signed.

Unless real '/sbin/init' is signed, a simple and practical way is to place
all signed programs, libraries, scripts and configuration files under
dedicated directory, for example '/ima', and run signed init process by
providing a kernel command line parameter 'init=/ima/init'

-Dmitry

Dmitry Kasatkin (4):
  ima: provide hook to load IMA keys when rootfs is ready
  integrity: provide file reading API
  integrity: provide x509 certificate loading from the kernel
  ima: require signed user-space initialization

 include/linux/ima.h                 |  9 +++++
 init/main.c                         |  6 ++-
 security/integrity/Kconfig          |  7 ++++
 security/integrity/digsig.c         | 78 +++++++++++++++++++++++++++++++++++++
 security/integrity/ima/Kconfig      | 15 +++++++
 security/integrity/ima/ima_init.c   | 17 ++++++++
 security/integrity/ima/ima_policy.c |  5 +++
 security/integrity/integrity.h      | 11 +++++-
 8 files changed, 146 insertions(+), 2 deletions(-)

-- 
1.9.1

