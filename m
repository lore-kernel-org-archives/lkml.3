Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3JUWnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:43:22 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44115 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab3JUWnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:21 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>
Subject: [PATCH v2 00/23] ima: larger digests and extensible template support
Date: Mon, 21 Oct 2013 18:42:45 -0400
Message-Id: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-7182-0000-0000-000008D5914F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for additional hash algorithms with larger
digests, as well as support for additional file metadata in the IMA
measurement list.  The existing IMA measurement list entries, which are
exposed to userspace via the securityfs ascii/binary_runtime_measurement
lists, are fixed length, containing a file data hash, limited to a 20 byte
digest, and a pathname, limited to 255 characters.  Adding larger digest
support for signature verification, without the template changes, would result
in hashing the file twice, once for appraising the file signature and, again,
for the measurement list.

This patch set defines an extensible template architecture with support for
larger hash algorithms.  A description of the new template architecture is
described in the "ima: new templates management mechanism" patch description
and, with more detail, in Documentation/security/IMA-templates.txt.  The
two initial templates defined are: the original 'ima', for backwards
compatibility, and 'ima-ng', which eliminates the digest and pathname size
limitations.  Additional templates, that include other file metadata (eg.
uid/gid, LSM subject/object labels, file data signatures) will be posted
separately.

Two changes were made, since posting this patch set back in July
http://marc.info/?l=linux-security-module&m=137410629309961&w=2.  Namely, the
measurement list can now be walked and verified, without understanding the
template field data specifics; and "mutable" files can be labeled based on
different hash algorithms.  Walking and verifying the measurement list without
understanding the template field data specifics, will allow new templates to
be defined in the kernel, without breaking userspace applications.  Defining a
new extended attribute format, which includes the file hash algorithm,
eliminates the need for relabeling "mutable" files.

Changelog:
- fix lindent, sparse, checkpath warnings/errors
- define a new extended attribute type, which includes the file data
  hash algorithm.
- template changes:
  - simplify walking the binary measurement list
  - simplify calculating the template data hash
  - simplify parsing measurement entries by always prefixing the
    template data hash with the hash algorithm.

Mimi

Dmitry Kasatkin (10):
  crypto: provide single place for hash algo information
  keys: change asymmetric keys to use common hash definitions
  ima: provide support for arbitrary hash algorithms
  ima: read and use signature hash algorithm
  ima: pass full xattr with the signature
  ima: use dynamically allocated hash storage
  ima: provide dedicated hash algo allocation function
  ima: support arbitrary hash algorithms in ima_calc_buffer_hash
  ima: ima_calc_boot_agregate must use SHA1
  ima: provide hash algo info in the xattr

Mimi Zohar (4):
  ima: differentiate between template hash and file data hash sizes
  ima: add audit log support for larger hashes
  ima: add Kconfig default measurement list template
  ima: enable support for larger default filedata hash algorithms

Roberto Sassu (9):
  ima: pass the file descriptor to ima_add_violation()
  ima: pass the filename argument up to ima_add_template_entry()
  ima: define new function ima_alloc_init_template() to API
  ima: new templates management mechanism
  ima: define template fields library and new helpers
  ima: define new template ima-ng and template fields d-ng and n-ng
  ima: switch to new template management mechanism
  ima: defer determining the appraisal hash algorithm for 'ima' template
  ima: define kernel parameter 'ima_template=' to change configured
    default

 Documentation/kernel-parameters.txt       |  11 +-
 Documentation/security/00-INDEX           |   2 +
 Documentation/security/IMA-templates.txt  |  87 +++++++++
 crypto/Kconfig                            |   3 +
 crypto/Makefile                           |   1 +
 crypto/asymmetric_keys/Kconfig            |   1 +
 crypto/asymmetric_keys/public_key.c       |  12 --
 crypto/asymmetric_keys/rsa.c              |  14 +-
 crypto/asymmetric_keys/x509_cert_parser.c |  12 +-
 crypto/asymmetric_keys/x509_public_key.c  |   6 +-
 crypto/hash_info.c                        |  56 ++++++
 include/crypto/hash_info.h                |  40 ++++
 include/crypto/public_key.h               |  18 +-
 include/uapi/linux/hash_info.h            |  37 ++++
 kernel/module_signing.c                   |   8 +-
 security/integrity/digsig.c               |   5 +-
 security/integrity/digsig_asymmetric.c    |  11 --
 security/integrity/evm/evm_main.c         |   4 +-
 security/integrity/iint.c                 |   2 +
 security/integrity/ima/Kconfig            |  61 ++++++
 security/integrity/ima/Makefile           |   2 +-
 security/integrity/ima/ima.h              |  95 +++++++--
 security/integrity/ima/ima_api.c          | 129 ++++++++----
 security/integrity/ima/ima_appraise.c     | 100 ++++++++--
 security/integrity/ima/ima_crypto.c       | 134 +++++++++++--
 security/integrity/ima/ima_fs.c           |  64 +++---
 security/integrity/ima/ima_init.c         |  37 ++--
 security/integrity/ima/ima_main.c         |  50 ++++-
 security/integrity/ima/ima_queue.c        |  10 +-
 security/integrity/ima/ima_template.c     | 175 +++++++++++++++++
 security/integrity/ima/ima_template_lib.c | 313 ++++++++++++++++++++++++++++++
 security/integrity/ima/ima_template_lib.h |  39 ++++
 security/integrity/integrity.h            |  38 +++-
 33 files changed, 1368 insertions(+), 209 deletions(-)
 create mode 100644 Documentation/security/IMA-templates.txt
 create mode 100644 crypto/hash_info.c
 create mode 100644 include/crypto/hash_info.h
 create mode 100644 include/uapi/linux/hash_info.h
 create mode 100644 security/integrity/ima/ima_template.c
 create mode 100644 security/integrity/ima/ima_template_lib.c
 create mode 100644 security/integrity/ima/ima_template_lib.h

-- 
1.8.1.4

