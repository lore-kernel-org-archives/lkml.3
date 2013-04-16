Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935365Ab3DPS0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:26:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935170Ab3DPSZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:25:55 -0400
Subject: [PATCH 00/28] Privatise procfs internals [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Date: Tue, 16 Apr 2013 19:25:51 +0100
Message-ID: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is a series of patches to make the procfs internals private to the procfs
filesystem.  This is built on top of the patches to eliminate
create_proc_read_entry() after the kill-read_proc_t tag.

These patches include fixes for the places that are attempting to abuse
proc_dir_entry->count and doing it incorrectly because PID namespaces now
exist.

All accesses to the PDE struct have been replaced with out-of-line accessor
functions.  This is a bit less efficient than it used to be, but this could be
mitigated by using inode->i_private.

The internal procfs structs have moved to fs/procfs/internal.h.  Some of the
remaining stuff in linux/proc_fs.h has been split out to linux/kcore.h and
linux/proc_ns.h as they's separate specialised intefaces.

These patches can be seen here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=vfs-experimental

David
---
David Howells (28):
      Include missing linux/slab.h inclusions
      Include missing linux/magic.h inclusions
      proc: Split kcore bits from linux/procfs.h into linux/kcore.h
      proc: Supply PDE attribute setting accessor functions
      proc: Uninline pid_delete_dentry()
      proc: Move proc_fd() to fs/proc/fd.h
      proc: Split the namespace stuff out into linux/proc_ns.h
      proc: Move PDE_NET() to fs/proc/proc_net.c
      proc: Move some bits from linux/proc_fs.h to linux/{of.h,signal.h,tty.h}
      proc: Add proc_mkdir_data()
      rtl8187se: Use a dir under /proc/net/r8180/
      rtl8192u: Don't need to save device proc dir PDE
      airo: Use remove_proc_subtree()
      proc: Supply an accessor for getting the data from a PDE's parent
      reiserfs: Don't access the proc_dir_entry in r_open(), r_start() r_show()
      zoran: Don't print proc_dir_entry data in debug
      drm: Constify drm_proc_list[]
      drm: proc: Use minor->index to label things, not PDE->name
      drm: proc: Use remove_proc_subtree()
      hostap: proc: Use remove_proc_subtree()
      dgrp: Clean up the use of procfs
      ppc: Clean up rtas_flash driver somewhat
      ppc: Clean up scanlog
      proc: Supply an accessor to get the name in a proc_dir_entry struct
      proc: Supply an accessor to get the process ID associated with some proc files
      proc: Supply a function to remove a proc entry by PDE
      proc: Make the PROC_I() and PDE() macros internal to procfs
      proc: Move non-public stuff from linux/proc_fs.h to fs/proc/internal.h


 arch/mips/mm/init.c                       |    1 
 arch/powerpc/kernel/proc_powerpc.c        |    2 
 arch/powerpc/kernel/rtas_flash.c          |  446 +++++++++++++----------------
 arch/powerpc/platforms/pseries/reconfig.c |    2 
 arch/powerpc/platforms/pseries/scanlog.c  |   29 +-
 arch/s390/kernel/os_info.c                |    1 
 arch/score/mm/init.c                      |    2 
 arch/sparc/kernel/sun4d_irq.c             |    1 
 arch/x86/mm/init_64.c                     |    1 
 arch/x86/platform/efi/efi.c               |    1 
 arch/x86/platform/efi/efi_64.c            |    1 
 drivers/acpi/sbs.c                        |   21 -
 drivers/char/ipmi/ipmi_msghandler.c       |    2 
 drivers/firmware/efivars.c                |    1 
 drivers/gpu/drm/drm_proc.c                |   41 +--
 drivers/gpu/drm/drm_stub.c                |    2 
 drivers/media/pci/ttpci/av7110_ir.c       |    2 
 drivers/media/pci/zoran/zoran_procfs.c    |    2 
 drivers/message/i2o/i2o_proc.c            |    8 -
 drivers/misc/sgi-gru/gruprocfs.c          |    2 
 drivers/mtd/mtdcore.c                     |    1 
 drivers/net/irda/vlsi_ir.c                |    2 
 drivers/net/wireless/airo.c               |   83 ++---
 drivers/net/wireless/hostap/hostap_proc.c |   20 -
 drivers/of/base.c                         |   11 -
 drivers/pci/proc.c                        |   14 -
 drivers/pps/clients/pps_parport.c         |    1 
 drivers/scsi/megaraid.c                   |    6 
 drivers/staging/dgrp/dgrp_dpa_ops.c       |    1 
 drivers/staging/dgrp/dgrp_mon_ops.c       |    1 
 drivers/staging/dgrp/dgrp_net_ops.c       |    2 
 drivers/staging/dgrp/dgrp_specproc.c      |   83 ++---
 drivers/staging/rtl8187se/r8180.h         |    1 
 drivers/staging/rtl8187se/r8180_core.c    |   28 +-
 drivers/staging/rtl8192u/r8192U.h         |    1 
 drivers/staging/rtl8192u/r8192U_core.c    |   21 -
 fs/namespace.c                            |    6 
 fs/proc/base.c                            |   14 +
 fs/proc/fd.h                              |    5 
 fs/proc/generic.c                         |   71 +++--
 fs/proc/inode.c                           |    9 -
 fs/proc/internal.h                        |  346 +++++++++++++++-------
 fs/proc/kcore.c                           |    2 
 fs/proc/namespaces.c                      |   17 +
 fs/proc/proc_devtree.c                    |    2 
 fs/proc/proc_net.c                        |    4 
 fs/proc/self.c                            |    1 
 fs/proc/vmcore.c                          |    5 
 fs/reiserfs/procfs.c                      |   32 +-
 include/drm/drmP.h                        |    5 
 include/linux/kcore.h                     |   38 ++
 include/linux/of.h                        |   10 +
 include/linux/proc_fs.h                   |  299 +++----------------
 include/linux/proc_ns.h                   |   74 +++++
 include/linux/signal.h                    |    5 
 include/linux/tty.h                       |    7 
 init/version.c                            |    2 
 ipc/msgutil.c                             |    2 
 ipc/namespace.c                           |    2 
 kernel/cgroup.c                           |    3 
 kernel/configs.c                          |    2 
 kernel/cpuset.c                           |    3 
 kernel/irq/proc.c                         |    6 
 kernel/nsproxy.c                          |    6 
 kernel/pid.c                              |    1 
 kernel/pid_namespace.c                    |    2 
 kernel/profile.c                          |    2 
 kernel/user.c                             |    2 
 kernel/user_namespace.c                   |    2 
 kernel/utsname.c                          |    2 
 net/8021q/vlanproc.c                      |    9 -
 net/core/net_namespace.c                  |    7 
 net/core/pktgen.c                         |    6 
 net/ipv4/netfilter/ipt_CLUSTERIP.c        |    4 
 net/ipv6/proc.c                           |    3 
 net/netfilter/xt_hashlimit.c              |    6 
 net/netfilter/xt_recent.c                 |    3 
 sound/core/info.c                         |   21 -
 78 files changed, 898 insertions(+), 994 deletions(-)
 create mode 100644 include/linux/kcore.h
 create mode 100644 include/linux/proc_ns.h

