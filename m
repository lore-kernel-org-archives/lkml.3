Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaDWN3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:29:49 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8244 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbaDWN3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:45 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-3e-5357c047851c
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 00/20] in-kernel IMA/EVM initialization
Date: Wed, 23 Apr 2014 16:30:18 +0300
Message-id: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xq7ruB8KDDTZOMra49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mpo2XOateCyeMWHNXkNjKeEuhg5OSQETCTu7nvKBGGLSVy4
	t56ti5GLQ0hgKaPErw2/mSGcTiaJC+s/sINUsQnoSWxo/gFmiwi4SOye08cEUsQs0MMosfvP
	YmaQhLCAucST6efAxrIIqEocWXuRDcTmFbCUOHNiMtQ6BYllX9YyT2DkXsDIsIpRNLU0uaA4
	KT3XUK84Mbe4NC9dLzk/dxMjJFi+7GBcfMzqEKMAB6MSD6/E8rBgIdbEsuLK3EOMEhzMSiK8
	SxaFBwvxpiRWVqUW5ccXleakFh9iZOLglGpgLJ2xgdd5Q8KzWJ2UB7P11CULwhXPrX/FeObh
	8p+WN20eff3yZcHjysjrFfwaz/cqxxgXNe9/MaHgi+sx58sPXu15JXnaZrb8jOUPTQ6vl6jc
	uq4mUynW/XXj1IC55hXsim4tf+KKOXsW1i6KVNiwdc5bTcfp6euvffO8leD3918+o/Dek4v0
	mZRYijMSDbWYi4oTARsR4fn0AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently secure IMA/EVM initialization has to be done from the
initramfs, embedded in the signed kernel image. Many systems do
not want to use initramfs or use unsigned locally generated images.

This patchset introduces kernel functionality, which allows to perform
IMA/EVM initialization without initramfs from the kernel, which
includes mainly following:
- loading EVM hmac encrypted keys
- loading and verification of signed X509 certificates
- loading and verification of signed IMA policy

Patchset introduces the set of new kernel configuration options,
which makes this functionality entirely configurable.
Not enabling any of the options does not change original IMA/EVM
behavior. In order not to bloat security configuration menu,
integrity subsystem options were moved to the separate menu.
It does not affect existing configuration. Re-configuration is
not needed.

-Dmitry

Dmitry Kasatkin (19):
  integrity: initialize EVM before IMA
  ima: move asymmetric keys config option
  integrity: move integrity subsystem options to a separate menu
  integrity: provide builtin 'trusted' keyrings
  ima: create '_ima' as a builtin 'trusted' keyring
  integrity: provide x509 certificate loading from the kernel
  ima: load x509 certificate from the kernel
  evm: create '_evm' as a builtin 'trusted' keyring
  evm: load x509 certificate from the kernel
  ima: added kernel parameter for disabling IMA
  ima: provide buffer hash calculation function
  ima: replace opencount with bitop
  ima: check if policy was set at open
  ima: path based policy loading interface
  ima: load policy from the kernel
  ima: make IMA policy replaceable at runtime
  evm: added kernel parameter for disabling EVM
  evm: try enable EVM from the kernel
  evm: read EVM key from the kernel

Mimi Zohar (1):
  KEYS: verify a certificate is signed by a 'trusted' key

 crypto/asymmetric_keys/x509_public_key.c |  85 +++++++++++++++++++++++-
 security/integrity/Kconfig               |  41 ++++++++----
 security/integrity/Makefile              |   4 +-
 security/integrity/digsig.c              | 103 +++++++++++++++++++++++++++++
 security/integrity/evm/Kconfig           |  32 +++++++--
 security/integrity/evm/evm.h             |  14 ++++
 security/integrity/evm/evm_crypto.c      | 101 ++++++++++++++++++++++++++++
 security/integrity/evm/evm_main.c        |  25 +++++--
 security/integrity/evm/evm_secfs.c       |  13 ++--
 security/integrity/ima/Kconfig           |  49 +++++++++++++-
 security/integrity/ima/ima.h             |  19 ++++++
 security/integrity/ima/ima_crypto.c      |  11 +++-
 security/integrity/ima/ima_fs.c          |  48 ++++++++++----
 security/integrity/ima/ima_init.c        |   3 +
 security/integrity/ima/ima_main.c        |  12 +++-
 security/integrity/ima/ima_policy.c      | 109 ++++++++++++++++++++++++++++---
 security/integrity/integrity.h           |  20 ++++++
 17 files changed, 626 insertions(+), 63 deletions(-)

-- 
1.8.3.2

