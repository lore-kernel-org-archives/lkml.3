Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab3KNWO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 17:14:56 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:48002 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab3KNWOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:14:49 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonas Bonn <jonas@southpole.se>, linux-kbuild@vger.kernel.org
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [RFC] initramfs: Prefix simple paths with $(srctree)
Date: Thu, 14 Nov 2013 23:14:43 +0100
Message-Id: <1384467283-14806-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_INITRAMFS_SOURCE contains relative paths inside the source tree
(e.g. in a defconfig pointing to arch-specific files), the corresponding
file system entries are not found when building outside the source tree.

Prefix all simple paths (paths not starting with "/", "../", or "./") with
$(srctree) to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This issue happens when building an OpenRISC defconfig from
git://openrisc.net/jonas/linux. Mainline doesn't have the OpenRISC
initramfs.

Questions:
  1. Is this an acceptable solution for mainline?
  2. My make-foo is limited. is there a better way to accomplish this, than
     by prefixing all paths and removing the prefixes again where they're
     not wanted?
   
 usr/Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/usr/Makefile b/usr/Makefile
index e767f019accf..2170c38936ce 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -41,6 +41,12 @@ hostprogs-y := gen_init_cpio
 initramfs   := $(CONFIG_SHELL) $(srctree)/scripts/gen_initramfs_list.sh
 ramfs-input := $(if $(filter-out "",$(CONFIG_INITRAMFS_SOURCE)), \
 			$(shell echo $(CONFIG_INITRAMFS_SOURCE)),-d)
+ifneq ("$(ramfs-input)", "-d")
+ramfs-input := $(patsubst %, $(srctree)/%, $(ramfs-input))
+ramfs-input := $(patsubst $(srctree)//%, /%, $(ramfs-input))
+ramfs-input := $(patsubst $(srctree)/../%, ../%, $(ramfs-input))
+ramfs-input := $(patsubst $(srctree)/./%, ./%, $(ramfs-input))
+endif
 ramfs-args  := \
         $(if $(CONFIG_INITRAMFS_ROOT_UID), -u $(CONFIG_INITRAMFS_ROOT_UID)) \
         $(if $(CONFIG_INITRAMFS_ROOT_GID), -g $(CONFIG_INITRAMFS_ROOT_GID))
-- 
1.7.9.5

