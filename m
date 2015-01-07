Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbbAGUgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:36:17 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38090 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbbAGUgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:36:15 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: mimi.e.zohar@gmail.com
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/9] extend initramfs archive format to support xattrs 
Date: Wed,  7 Jan 2015 15:36:07 -0500
Message-Id: <1420662967-18257-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010720-0037-0000-0000-00000049AED1
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
xattrs in the initramfs.  The changes are limited to gen_init_cpio, the
kernel build tree tool used to generate an initramfs, and init/initramfs.c,
the parser, with minor changes to IMA and EVM.

Mimi


Mimi Zohar (9):
  initramfs: separate reading cpio method from header
  initramfs: add extended attribute support
  gen_init_cpio: replace inline format string with common variable
  gen_init_cpio: define new CPIO format to support xattrs
  gen_init_cpio: include the file extended attributes
  gen_initramfs_list.sh: include xattrs
  evm: make rootfs a special case
  ima: include tmpfs in ima_appraise_tcb policy
  init: remove "root=" command line option test for tmpfs decision

 init/do_mounts.c                    |   2 +-
 init/initramfs.c                    |  95 +++++++++++++++++++++---
 scripts/gen_initramfs_list.sh       |   2 +-
 security/integrity/evm/evm_main.c   |  12 ++-
 security/integrity/ima/ima_policy.c |   2 +
 usr/gen_init_cpio.c                 | 142 ++++++++++++++++++++++++++++++------
 6 files changed, 218 insertions(+), 37 deletions(-)

-- 
1.8.1.4

