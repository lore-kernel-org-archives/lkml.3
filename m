Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934828Ab3DKN1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:27:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab3DKN1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:27:42 -0400
Subject: [PATCH 00/26] Eliminate create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk
Date: Thu, 11 Apr 2013 14:27:40 +0100
Message-ID: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is a series of patches to eliminate create_proc_read_entry(), replacing it
with proc_create() and proc_create_data() and the use of seq_file facilities.

This requires file_operations structs and open methods to be provided in most
cases, though single_open() and single_open_size() suffice for the actual
translation into the seq_file environment.  I did try and reduce the number of
file_operations structs and open methods added by placing the show function
pointer into seq_file::private in some places.

Certain places (hostap most notably) required conversion of some files into
full seq_file iterators to handle the possibility that large lists might
overrun a single buffer full of data.

This reduces the size of the proc_dir_entry by the removal of the read_proc
pointer, plus the support mechanisms for these have been removed from the
procfs code.

These patches have been compile tested as best I can (apart from SH for which I
don't have a working compiler).  No runtime testing has been done outside of
the core procfs code as I don't have the requisite hardware.

These patches can be seen here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=vfs-experimental

David
---
David Howells (26):
      procfs: Mark create_proc_read_entry deprecated
      rtl8192u: Don't use create_proc_read_entry()
      rtl8187se: Don't use create_proc_read_entry()
      ft1000: Don't use create_proc_read_entry()
      comedi: Don't use create_proc_read_entry()
      csr: Don't use create_proc_read_entry()
      cxt1e1: Don't use create_proc_read_entry()
      wlags49_h2: Don't use create_proc_read_entry()
      goku_udc: Don't use create_proc_read_entry()
      fsl_udc: Don't use create_proc_read_entry()
      nubus: Don't use create_proc_read_entry()
      hp_sdc_rtc: Don't use create_proc_read_entry()
      genrtc: Don't use create_proc_read_entry()
      efirtc: Don't use create_proc_read_entry()
      ds1620: Don't use create_proc_read_entry()
      atmel: Don't use create_proc_read_entry()
      hostap: Don't use create_proc_read_entry()
      megaraid: Don't use create_proc_read_entry()
      sh: Don't use create_proc_read_entry()
      parisc: Don't use create_proc_read_entry()
      mips: Don't use create_proc_read_entry()
      ia64: Don't use create_proc_read_entry()
      h8300: Don't use create_proc_read_entry()
      cris: Don't use create_proc_read_entry()
      arm: Don't use create_proc_read_entry()
      proc: Delete create_proc_read_entry()


 arch/arm/kernel/swp_emulate.c                      |   42 -
 arch/arm/mach-omap1/pm.c                           |   58 -
 arch/cris/arch-v10/kernel/fasttimer.c              |  299 +++---
 arch/cris/arch-v32/kernel/fasttimer.c              |  296 +++---
 arch/h8300/kernel/gpio.c                           |   34 -
 arch/ia64/kernel/palinfo.c                         |  502 +++++-----
 arch/ia64/kernel/salinfo.c                         |   39 -
 arch/ia64/sn/kernel/sn2/prominfo_proc.c            |  108 +-
 arch/mips/kernel/smtc-proc.c                       |   64 -
 arch/mips/pci/ops-pmcmsp.c                         |   95 +-
 arch/mips/sibyte/sb1250/bus_watcher.c              |   81 +-
 arch/parisc/kernel/pdc_chassis.c                   |   47 -
 arch/sh/drivers/dma/dma-api.c                      |   28 -
 drivers/char/ds1620.c                              |   33 -
 drivers/char/efirtc.c                              |   83 +-
 drivers/char/genrtc.c                              |   48 -
 drivers/input/misc/hp_sdc_rtc.c                    |   58 -
 drivers/net/wireless/atmel.c                       |   69 +
 drivers/net/wireless/hostap/hostap_ap.c            |  375 ++++---
 drivers/net/wireless/hostap/hostap_download.c      |   68 +
 drivers/net/wireless/hostap/hostap_hw.c            |   38 -
 drivers/net/wireless/hostap/hostap_proc.c          |  589 ++++++-----
 drivers/net/wireless/hostap/hostap_wlan.h          |    3 
 drivers/nubus/nubus.c                              |   55 -
 drivers/nubus/proc.c                               |   81 +-
 drivers/scsi/megaraid.c                            | 1041 +++++++-------------
 drivers/scsi/megaraid.h                            |   17 
 drivers/staging/comedi/proc.c                      |   52 +
 drivers/staging/csr/csr_wifi_hip_udi.c             |  353 ++-----
 drivers/staging/csr/csr_wifi_hip_unifi_udi.h       |   17 
 drivers/staging/csr/io.c                           |  151 +--
 drivers/staging/cxt1e1/Makefile                    |    3 
 drivers/staging/cxt1e1/sbeproc.c                   |  460 +++------
 drivers/staging/cxt1e1/sbeproc.h                   |   14 
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |  132 +--
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |  131 +--
 drivers/staging/rtl8187se/r8180_core.c             |  135 +--
 drivers/staging/rtl8192e/rtllib_crypt_ccmp.c       |   21 
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c       |   44 -
 drivers/staging/rtl8192e/rtllib_crypt_wep.c        |    6 
 drivers/staging/rtl8192u/r8192U_core.c             |  215 ++--
 drivers/staging/wlags49_h2/wl_main.c               |  320 +++---
 drivers/usb/gadget/fsl_udc_core.c                  |  124 +-
 drivers/usb/gadget/goku_udc.c                      |   89 +-
 fs/proc/generic.c                                  |  168 ---
 fs/proc/inode.c                                    |   35 -
 fs/proc/internal.h                                 |    2 
 include/linux/nubus.h                              |    4 
 include/linux/proc_fs.h                            |   14 
 include/net/lib80211.h                             |    4 
 net/wireless/lib80211_crypt_ccmp.c                 |   29 -
 net/wireless/lib80211_crypt_tkip.c                 |   44 -
 net/wireless/lib80211_crypt_wep.c                  |    5 
 53 files changed, 3003 insertions(+), 3820 deletions(-)

