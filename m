Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbbATTNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:13:12 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53163 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbbATTNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:13:09 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 00/11] extend initramfs archive format to support xattrs
Date: Tue, 20 Jan 2015 14:12:49 -0500
Message-Id: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012019-0029-0000-0000-000001BC858C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the Linux security/integrity features are dependent on file
metadata, stored as extended attributes (xattrs), for making decisions.
These features need to be initialized during initcall and enabled as
early as possible for complete security coverage. 

The linux kernel creates the rootfs file system and extracts the contents
of the initramfs, a compressed CPIO archive, onto it. If CONFIG_TMPFS is
enabled (and "root=" is not specified on the boot command line), rootfs
will use tmpfs instead of ramfs by default.  Although the tmpfs filesystem
supports xattrs, the CPIO archive specification does not define a method
for including them in the archive.  Other archive formats have added xattr
support (eg. tar).

There are a couple of ways to include and label the rootfs filesystem:
- include a file manifest containing the xattrs in the initramfs
- extend CPIO to support xattrs
- add tar support

This patch set extends the existing newc CPIO archive format to include
xattrs in the initramfs.  This change affects usr/gen_init_cpio,
scripts/gen_initramfs_list.sh, and init/initramfs.c.  Included in this
patch set are the associated IMA and EVM policy changes.

Changelog v1:
- Patch "init: remove "root=" command line option test for tmpfs decision"
  was previously included for testing without userspace application (eg.
  systemd, dracut) changes.  The associated userspace changes will be
  posted to the relevant mailing lists. Patch dropped.
- replace simple_strtoul with kstrtoul
- add some input data checking
- change size of mtime and file length to 64 bits
- define new gen_initramfs_list.sh "-x" command line option
- define new IMA_APPRAISE_ROOTFS Kconfig option

Mimi

Mimi Zohar (11):
  initramfs: separate reading cpio method from header
  initramfs: replace simple_strtoul() with kstrtoul()
  initramfs: add extended attribute support
  initramfs: change size of mtime and file length to 64 bits
  gen_init_cpio: replace inline format string with common variable
  gen_init_cpio: define new CPIO format to support xattrs
  gen_init_cpio: include the file extended attributes
  gen_init_cpio: change size of mtime and file length to 64 bits
  gen_initramfs_list.sh: include xattrs
  evm: make rootfs a special case
  ima: include rootfs (tmpfs) in ima_appraise_tcb policy

 init/initramfs.c                    | 130 +++++++++++++++++++++++++----
 scripts/gen_initramfs_list.sh       |   8 +-
 security/integrity/evm/evm_main.c   |  12 ++-
 security/integrity/ima/Kconfig      |  12 +++
 security/integrity/ima/ima_policy.c |   8 ++
 usr/gen_init_cpio.c                 | 159 ++++++++++++++++++++++++++++++------
 6 files changed, 282 insertions(+), 47 deletions(-)

-- 
1.8.1.4

