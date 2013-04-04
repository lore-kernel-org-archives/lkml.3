Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833Ab3DDM2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:28:18 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49836 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759779Ab3DDM1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:27:41 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 0/6] Chainsaw efivars.c
Date: Thu,  4 Apr 2013 13:18:49 +0100
Message-Id: <1365077935-6859-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

drivers/firmware/efivars.c has grown pretty large and is ~2K lines.

Inside efivars.c there's currently,

  o code for handling EFI variables at the firmware-level
  o sysfs code for exposing EFI variables
  o a new EFI variable filesystem
  o a persistent storage backend

all intertwined and smushed together. This situation is only going to get worse
as new EFI support is added.

We need an interface that hides the EFI variable operations in use so code
isn't tempted to access them directly, e.g. efivarfs currently uses '__efivars'
which means it doesn't work for CONFIG_GOOGLE_SMI as that uses different
variable ops. With this interface in place, we can start moving independent
code out into separate files, allowing users to only turn on the functionality
that they want.

This patch series introduces the new efivar_entry API, and splits out the major
parts of efivars.c into new files. In particular, having the efivarfs code
under fs/ allows building an efivarfs.ko module, which means mount(8) can
automatically load it.

The remaining EFI code is repositioned under drivers/firmware/efi/.

The series is also available on the 'chainsaw' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/linux.git

Matt Fleming (5):
  efi: move utf16 string functions to efi.h
  efivars: Keep a private global pointer to efivars
  efivars: efivar_entry API
  efivars: Move pstore code into the new EFI directory
  efivarfs: Move to fs/efivarfs

Tom Gundersen (1):
  efi: split efisubsystem from efivars

 MAINTAINERS                       |   13 +-
 drivers/firmware/Kconfig          |   36 +-
 drivers/firmware/Makefile         |    2 +-
 drivers/firmware/efi/Kconfig      |   45 +
 drivers/firmware/efi/Makefile     |    6 +
 drivers/firmware/efi/efi-pstore.c |  244 +++++
 drivers/firmware/efi/efi.c        |  145 +++
 drivers/firmware/efi/efivars.c    |  615 +++++++++++
 drivers/firmware/efi/vars.c       | 1020 +++++++++++++++++
 drivers/firmware/efivars.c        | 2171 -------------------------------------
 drivers/firmware/google/gsmi.c    |   30 +-
 fs/Kconfig                        |    1 +
 fs/Makefile                       |    1 +
 fs/efivarfs/Kconfig               |   12 +
 fs/efivarfs/Makefile              |    7 +
 fs/efivarfs/file.c                |  111 ++
 fs/efivarfs/inode.c               |  173 +++
 fs/efivarfs/internal.h            |   22 +
 fs/efivarfs/super.c               |  266 +++++
 include/linux/efi.h               |  132 ++-
 20 files changed, 2818 insertions(+), 2234 deletions(-)
 create mode 100644 drivers/firmware/efi/Kconfig
 create mode 100644 drivers/firmware/efi/Makefile
 create mode 100644 drivers/firmware/efi/efi-pstore.c
 create mode 100644 drivers/firmware/efi/efi.c
 create mode 100644 drivers/firmware/efi/efivars.c
 create mode 100644 drivers/firmware/efi/vars.c
 delete mode 100644 drivers/firmware/efivars.c
 create mode 100644 fs/efivarfs/Kconfig
 create mode 100644 fs/efivarfs/Makefile
 create mode 100644 fs/efivarfs/file.c
 create mode 100644 fs/efivarfs/inode.c
 create mode 100644 fs/efivarfs/internal.h
 create mode 100644 fs/efivarfs/super.c

-- 
1.7.10.4

