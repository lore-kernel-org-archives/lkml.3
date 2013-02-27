Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686Ab3B0DYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 22:24:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55116 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab3B0DYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 22:24:08 -0500
Date: Wed, 27 Feb 2013 03:24:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 1
Message-ID: <20130227032406.GM4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Assorted stuff - cleaning namei.c up a bit, fixing ->d_name/->d_parent
locking violations, etc.  The most visible changes here are death of
FS_REVAL_DOT (replaced with "has ->d_weak_revalidate()") and a new helper
getting from struct file to inode.  Some bits of preparation to xattr
method interface changes.  Misc patches by various people sent this cycle
*and* ocfs2 fixes from several cycles ago that should've been upstream right
then.

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

PS: the next vfs pile will be xattr stuff.

Shortlog:
Al Viro (33):
      mount: consolidate permission checks
      new helper: file_inode(file)
      propagate error from get_empty_filp() to its callers
      clean shmem_file_setup() a bit
      link_path_walk(): move assignments to nd->last/nd->last_type up
      get rid of name and type arguments of walk_component()
      lookup_fast: get rid of name argument
      lookup_slow: get rid of name argument
      constify __d_lookup() arguments
      constify d_lookup() arguments
      __d_materialise_unique() is too generic
      xenfs: switch to pure simple_fill_super()
      hostfs: directory methods have no business in non-directory inode_operations
      spufs_mkdir(): don't d_add() on negative parent
      oprofilefs: add missing ->i_mutex locking in object creation
      shmem_setup_file(): use d_alloc_pseudo() instead of d_alloc()
      hugetlb_file_setup(): use d_alloc_pseudo()
      lirc: get rid of bogus checks
      tegra: don't wank with d_find_alias()
      9p: add fid-based variant of v9fs_xattr_set()
      9p: lift the call of set_cached_acl() into the callers of v9fs_set_acl()
      9p: switch v9fs_set_acl() from dentry to fid
      9p: switch v9fs_acl_chmod() from dentry to inode+fid
      9p: split dropping the acls from v9fs_set_create_acl()
      9p: switch v9fs_set_create_acl() to inode+fid, do it before d_instantiate()
      d_hash_and_lookup(): export, switch open-coded instances
      default SET_PERSONALITY() in linux/elf.h
      switch vfs_getattr() to struct path
      kill f_vfsmnt
      export kernel_write(), convert open-coded instances
      target: writev() on single-element vector is pointless
      get_empty_filp()/alloc_file() leave both ->f_pos and ->f_version zero
      saner proc_get_inode() calling conventions

Anatol Pomozov (1):
      fs: Preserve error code in get_empty_filp(), part 2

Dan Carpenter (1):
      ocfs2/dlm: use GFP_ATOMIC inside a spin_lock

J. Bruce Fields (1):
      nfsd: handle vfs_getattr errors in acl protocol

Jan Kara (2):
      fs: Fix possible use-after-free with AIO
      ocfs2: fix possible use-after-free with AIO

Jeff Layton (2):
      vfs: remove d_path_with_unreachable
      vfs: kill FS_REVAL_DOT by adding a d_weak_revalidate dentry op

Maxim Patlasov (1):
      proc: avoid extra pde_put() in proc_fill_super()

Namjae Jeon (1):
      fs: encode_fh: return FILEID_INVALID if invalid fid_type

Sage Weil (1):
      ceph: prepopulate inodes only when request is aborted

Sunil Mushran (1):
      ocfs2: Fix oops in ocfs2_fast_symlink_readpage() code path

Yuanhan Liu (1):
      fs/exec.c: make bprm_mm_init() static

Zhao Hongjiang (1):
      fs: change return values from -EACCES to -EPERM

Diffstat:
 Documentation/filesystems/Locking               |    2 +
 Documentation/filesystems/porting               |    4 +
 Documentation/filesystems/vfs.txt               |   24 ++++++-
 arch/alpha/kernel/srm_env.c                     |    2 +-
 arch/avr32/include/asm/elf.h                    |    3 -
 arch/blackfin/include/asm/elf.h                 |    3 -
 arch/blackfin/kernel/cplbinfo.c                 |    2 +-
 arch/c6x/include/asm/elf.h                      |    3 -
 arch/cris/arch-v10/drivers/sync_serial.c        |    8 +-
 arch/cris/arch-v32/drivers/cryptocop.c          |    3 +-
 arch/cris/arch-v32/drivers/sync_serial.c        |    8 +-
 arch/cris/include/asm/elf.h                     |    3 -
 arch/frv/include/asm/elf.h                      |    3 -
 arch/h8300/include/asm/elf.h                    |    3 -
 arch/hexagon/include/asm/elf.h                  |    5 --
 arch/ia64/include/asm/elf.h                     |    3 -
 arch/ia64/kernel/perfmon.c                      |    4 +-
 arch/ia64/kernel/salinfo.c                      |    6 +-
 arch/m32r/include/asm/elf.h                     |    3 -
 arch/m68k/include/asm/elf.h                     |    3 -
 arch/mips/kernel/rtlx.c                         |   13 +---
 arch/mips/kernel/vpe.c                          |    2 +-
 arch/mips/lasat/picvue_proc.c                   |    2 +-
 arch/mn10300/include/asm/elf.h                  |    5 --
 arch/openrisc/include/asm/elf.h                 |    3 -
 arch/powerpc/include/asm/elf.h                  |    2 -
 arch/powerpc/kernel/proc_powerpc.c              |    6 +-
 arch/powerpc/kernel/rtas_flash.c                |   16 ++--
 arch/powerpc/platforms/cell/spufs/coredump.c    |    4 +-
 arch/powerpc/platforms/cell/spufs/file.c        |    6 +-
 arch/powerpc/platforms/cell/spufs/inode.c       |   68 +++++++-------------
 arch/powerpc/platforms/cell/spufs/syscalls.c    |    2 +-
 arch/powerpc/platforms/pseries/hvCall_inst.c    |    2 +-
 arch/powerpc/platforms/pseries/scanlog.c        |    8 +--
 arch/s390/hypfs/hypfs_dbfs.c                    |    2 +-
 arch/s390/hypfs/inode.c                         |    2 +-
 arch/s390/include/asm/elf.h                     |    5 +-
 arch/s390/kernel/debug.c                        |    2 +-
 arch/s390/pci/pci_debug.c                       |    4 +-
 arch/score/include/asm/elf.h                    |    5 --
 arch/sh/mm/alignment.c                          |    2 +-
 arch/sparc/include/asm/elf_32.h                 |    3 -
 arch/x86/ia32/ia32_aout.c                       |    6 +-
 arch/x86/kernel/cpuid.c                         |    4 +-
 drivers/base/devtmpfs.c                         |    3 +-
 drivers/base/firmware_class.c                   |    2 +-
 drivers/block/DAC960.c                          |    2 +-
 drivers/block/loop.c                            |    2 +-
 drivers/block/nbd.c                             |    2 +-
 drivers/char/dsp56k.c                           |    8 +-
 drivers/char/dtlk.c                             |    4 +-
 drivers/char/lp.c                               |    8 +-
 drivers/char/mem.c                              |    4 +-
 drivers/char/nsc_gpio.c                         |    4 +-
 drivers/char/pcmcia/cm4000_cs.c                 |    2 +-
 drivers/char/ppdev.c                            |    6 +-
 drivers/char/ps3flash.c                         |    2 +-
 drivers/char/raw.c                              |    2 +-
 drivers/char/sonypi.c                           |    2 +-
 drivers/char/tb0219.c                           |    4 +-
 drivers/gpu/drm/gma500/gtt.c                    |    2 +-
 drivers/gpu/drm/i915/i915_gem.c                 |   10 ++--
 drivers/gpu/drm/ttm/ttm_tt.c                    |    4 +-
 drivers/gpu/drm/udl/udl_gem.c                   |    2 +-
 drivers/hid/hid-roccat.c                        |    2 +-
 drivers/hid/hidraw.c                            |    6 +-
 drivers/i2c/i2c-dev.c                           |    4 +-
 drivers/ide/ide-proc.c                          |    4 +-
 drivers/infiniband/core/uverbs_cmd.c            |    2 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c    |    4 +-
 drivers/infiniband/hw/ipath/ipath_fs.c          |    6 +-
 drivers/infiniband/hw/qib/qib_file_ops.c        |    2 +-
 drivers/infiniband/hw/qib/qib_fs.c              |    4 +-
 drivers/iommu/tegra-smmu.c                      |   16 +----
 drivers/isdn/hardware/eicon/divasproc.c         |    6 +-
 drivers/isdn/hysdn/hysdn_proclog.c              |    4 +-
 drivers/isdn/i4l/isdn_common.c                  |    8 +-
 drivers/isdn/i4l/isdn_ppp.c                     |    2 +-
 drivers/md/bitmap.c                             |    4 +-
 drivers/media/pci/zoran/zoran_procfs.c          |    2 +-
 drivers/media/rc/lirc_dev.c                     |   19 ++----
 drivers/media/v4l2-core/v4l2-dev.c              |    2 +-
 drivers/mtd/nand/nandsim.c                      |   34 ++++------
 drivers/mtd/ubi/cdev.c                          |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |    2 +-
 drivers/net/wan/cosa.c                          |    4 +-
 drivers/net/wireless/ray_cs.c                   |    2 +-
 drivers/oprofile/oprofilefs.c                   |   16 ++++-
 drivers/parisc/led.c                            |    2 +-
 drivers/pci/proc.c                              |   10 ++--
 drivers/platform/x86/sony-laptop.c              |    2 +-
 drivers/platform/x86/thinkpad_acpi.c            |    2 +-
 drivers/platform/x86/toshiba_acpi.c             |    8 +-
 drivers/pnp/isapnp/proc.c                       |    4 +-
 drivers/pnp/pnpbios/proc.c                      |    2 +-
 drivers/s390/char/fs3270.c                      |    4 +-
 drivers/s390/char/tape_char.c                   |    8 +-
 drivers/s390/char/vmur.c                        |    2 +-
 drivers/s390/cio/qdio_debug.c                   |    4 +-
 drivers/sbus/char/display7seg.c                 |    2 +-
 drivers/scsi/3w-9xxx.c                          |    2 +-
 drivers/scsi/3w-sas.c                           |    2 +-
 drivers/scsi/3w-xxxx.c                          |    2 +-
 drivers/scsi/csiostor/csio_init.c               |    2 +-
 drivers/scsi/dpt_i2o.c                          |    4 +-
 drivers/scsi/st.c                               |    2 +-
 drivers/staging/bcm/Misc.c                      |    2 +-
 drivers/staging/ccg/f_mass_storage.c            |    2 +-
 drivers/staging/ccg/rndis.c                     |    2 +-
 drivers/staging/ccg/storage_common.c            |    2 +-
 drivers/staging/dgrp/dgrp_specproc.c            |    4 +-
 drivers/staging/omapdrm/omap_gem_helpers.c      |    2 +-
 drivers/staging/usbip/usbip_common.c            |    2 +-
 drivers/staging/vme/devices/vme_user.c          |    8 +-
 drivers/target/target_core_alua.c               |   35 +++-------
 drivers/target/target_core_file.c               |    2 +-
 drivers/target/target_core_pr.c                 |   27 ++------
 drivers/tty/vt/vc_screen.c                      |    8 +-
 drivers/usb/core/devices.c                      |    4 +-
 drivers/usb/core/devio.c                        |    6 +-
 drivers/usb/gadget/atmel_usba_udc.c             |    8 +-
 drivers/usb/gadget/f_mass_storage.c             |    2 +-
 drivers/usb/gadget/printer.c                    |    2 +-
 drivers/usb/gadget/rndis.c                      |    2 +-
 drivers/usb/gadget/storage_common.c             |    2 +-
 drivers/video/fb_defio.c                        |    2 +-
 drivers/video/fbmem.c                           |    2 +-
 drivers/video/msm/mdp.c                         |    2 +-
 drivers/watchdog/cpwd.c                         |    4 +-
 drivers/xen/xenfs/super.c                       |   66 +++----------------
 drivers/zorro/proc.c                            |    4 +-
 fs/9p/acl.c                                     |   37 ++++++-----
 fs/9p/acl.h                                     |   20 ++++--
 fs/9p/vfs_dentry.c                              |    1 +
 fs/9p/vfs_file.c                                |   10 ++--
 fs/9p/vfs_inode_dotl.c                          |   75 +++++++++++-----------
 fs/9p/vfs_super.c                               |    2 +-
 fs/9p/xattr.c                                   |   33 +++++----
 fs/9p/xattr.h                                   |    2 +
 fs/adfs/dir.c                                   |    2 +-
 fs/affs/dir.c                                   |    2 +-
 fs/afs/dir.c                                    |    4 +-
 fs/afs/flock.c                                  |    4 +-
 fs/afs/write.c                                  |    7 +-
 fs/anon_inodes.c                                |   10 +--
 fs/autofs4/autofs_i.h                           |    2 +-
 fs/autofs4/dev-ioctl.c                          |    2 +-
 fs/autofs4/root.c                               |    6 +-
 fs/befs/linuxvfs.c                              |    2 +-
 fs/bfs/dir.c                                    |    2 +-
 fs/binfmt_aout.c                                |    4 +-
 fs/binfmt_elf.c                                 |    2 +-
 fs/binfmt_elf_fdpic.c                           |    4 +-
 fs/binfmt_flat.c                                |    2 +-
 fs/binfmt_misc.c                                |    4 +-
 fs/block_dev.c                                  |    2 +-
 fs/btrfs/export.c                               |    4 +-
 fs/btrfs/file.c                                 |    8 +-
 fs/btrfs/inode.c                                |    4 +-
 fs/btrfs/ioctl.c                                |   52 +++++++-------
 fs/btrfs/send.c                                 |    2 +-
 fs/buffer.c                                     |    4 +-
 fs/ceph/addr.c                                  |   12 ++--
 fs/ceph/dir.c                                   |    6 +-
 fs/ceph/export.c                                |    4 +-
 fs/ceph/file.c                                  |   10 ++--
 fs/ceph/inode.c                                 |   40 +++++++++++-
 fs/ceph/ioctl.c                                 |   16 ++--
 fs/ceph/locks.c                                 |    2 +-
 fs/cifs/cifsfs.c                                |    6 +-
 fs/cifs/file.c                                  |   26 ++++----
 fs/cifs/inode.c                                 |    8 +-
 fs/cifs/ioctl.c                                 |    2 +-
 fs/cifs/readdir.c                               |   12 ++--
 fs/coda/dir.c                                   |    2 +-
 fs/coda/file.c                                  |   12 ++--
 fs/coda/inode.c                                 |    2 +-
 fs/coda/pioctl.c                                |    2 +-
 fs/compat_ioctl.c                               |    2 +-
 fs/configfs/dir.c                               |    2 +-
 fs/coredump.c                                   |    4 +-
 fs/cramfs/inode.c                               |    2 +-
 fs/dcache.c                                     |   80 ++++++-----------------
 fs/direct-io.c                                  |    2 +-
 fs/dlm/config.c                                 |    2 +-
 fs/ecryptfs/ecryptfs_kernel.h                   |    6 ++
 fs/ecryptfs/file.c                              |    4 +-
 fs/ecryptfs/inode.c                             |    3 +-
 fs/ecryptfs/read_write.c                        |    6 +--
 fs/efs/dir.c                                    |    2 +-
 fs/exec.c                                       |   10 ++--
 fs/exofs/dir.c                                  |    2 +-
 fs/ext2/dir.c                                   |    2 +-
 fs/ext2/ioctl.c                                 |    2 +-
 fs/ext3/dir.c                                   |    8 +-
 fs/ext3/ioctl.c                                 |    2 +-
 fs/ext3/namei.c                                 |    4 +-
 fs/ext4/dir.c                                   |    8 +-
 fs/ext4/extents.c                               |    4 +-
 fs/ext4/file.c                                  |    2 +-
 fs/ext4/inline.c                                |    2 +-
 fs/ext4/inode.c                                 |    6 +-
 fs/ext4/ioctl.c                                 |    2 +-
 fs/ext4/move_extent.c                           |    6 +-
 fs/ext4/namei.c                                 |    2 +-
 fs/ext4/super.c                                 |    2 +-
 fs/f2fs/dir.c                                   |    2 +-
 fs/fat/dir.c                                    |    6 +-
 fs/fat/file.c                                   |    4 +-
 fs/fcntl.c                                      |    2 +-
 fs/file_table.c                                 |   31 ++++-----
 fs/freevxfs/vxfs_lookup.c                       |    2 +-
 fs/fuse/control.c                               |    2 +-
 fs/fuse/dir.c                                   |    2 +-
 fs/fuse/inode.c                                 |    2 +-
 fs/gfs2/export.c                                |    4 +-
 fs/gfs2/file.c                                  |   17 ++---
 fs/gfs2/rgrp.c                                  |    2 +-
 fs/gfs2/sys.c                                   |   18 +++---
 fs/hfs/dir.c                                    |    2 +-
 fs/hfs/inode.c                                  |    2 +-
 fs/hfsplus/dir.c                                |    2 +-
 fs/hfsplus/inode.c                              |    2 +-
 fs/hfsplus/ioctl.c                              |    4 +-
 fs/hostfs/hostfs_kern.c                         |   10 +---
 fs/hpfs/dir.c                                   |    4 +-
 fs/hpfs/file.c                                  |    2 +-
 fs/hppfs/hppfs.c                                |    8 +-
 fs/hugetlbfs/inode.c                            |   33 ++++++----
 fs/inode.c                                      |    2 +-
 fs/ioctl.c                                      |   12 ++--
 fs/isofs/compress.c                             |    2 +-
 fs/isofs/dir.c                                  |    2 +-
 fs/isofs/export.c                               |    4 +-
 fs/jffs2/dir.c                                  |    4 +-
 fs/jfs/ioctl.c                                  |    2 +-
 fs/jfs/jfs_dtree.c                              |    2 +-
 fs/lockd/clntlock.c                             |    2 +-
 fs/lockd/clntproc.c                             |    2 +-
 fs/lockd/svclock.c                              |   16 ++--
 fs/lockd/svcsubs.c                              |    2 +-
 fs/locks.c                                      |   24 ++++----
 fs/logfs/dir.c                                  |    4 +-
 fs/logfs/file.c                                 |    2 +-
 fs/minix/dir.c                                  |    2 +-
 fs/namei.c                                      |   67 ++++++++-----------
 fs/namespace.c                                  |   42 ++----------
 fs/ncpfs/dir.c                                  |   10 +--
 fs/ncpfs/inode.c                                |    4 +-
 fs/ncpfs/ioctl.c                                |    4 +-
 fs/ncpfs/mmap.c                                 |    2 +-
 fs/nfs/dir.c                                    |   48 ++++++++++++-
 fs/nfs/file.c                                   |    2 +-
 fs/nfs/idmap.c                                  |    2 +-
 fs/nfs/inode.c                                  |    4 +-
 fs/nfs/nfs3proc.c                               |    2 +-
 fs/nfs/nfs4file.c                               |    2 +-
 fs/nfs/nfs4super.c                              |    6 +-
 fs/nfs/proc.c                                   |    2 +-
 fs/nfs/super.c                                  |    6 +-
 fs/nfsd/fault_inject.c                          |    6 +-
 fs/nfsd/nfs2acl.c                               |   23 ++++++-
 fs/nfsd/nfs3proc.c                              |    5 +-
 fs/nfsd/nfs3xdr.c                               |   10 ++--
 fs/nfsd/nfs4xdr.c                               |    4 +-
 fs/nfsd/nfsctl.c                                |    2 +-
 fs/nfsd/nfsproc.c                               |   12 +---
 fs/nfsd/nfsxdr.c                                |    7 +-
 fs/nfsd/vfs.c                                   |    6 +-
 fs/nfsd/vfs.h                                   |    8 ++
 fs/nfsd/xdr.h                                   |    2 +-
 fs/nfsd/xdr3.h                                  |    2 +
 fs/nilfs2/dir.c                                 |    2 +-
 fs/nilfs2/file.c                                |    2 +-
 fs/nilfs2/ioctl.c                               |    2 +-
 fs/nilfs2/namei.c                               |    4 +-
 fs/notify/dnotify/dnotify.c                     |    4 +-
 fs/notify/fanotify/fanotify_user.c              |    2 +-
 fs/ntfs/dir.c                                   |    2 +-
 fs/ocfs2/aops.c                                 |    6 +-
 fs/ocfs2/dir.c                                  |    4 +-
 fs/ocfs2/dlm/dlmmaster.c                        |    2 +-
 fs/ocfs2/dlmfs/dlmfs.c                          |    6 +-
 fs/ocfs2/export.c                               |    4 +-
 fs/ocfs2/file.c                                 |   14 ++--
 fs/ocfs2/ioctl.c                                |    4 +-
 fs/ocfs2/mmap.c                                 |   10 ++--
 fs/ocfs2/move_extents.c                         |    2 +-
 fs/ocfs2/refcounttree.c                         |    4 +-
 fs/ocfs2/symlink.c                              |    2 +-
 fs/omfs/dir.c                                   |    4 +-
 fs/open.c                                       |   34 +++++-----
 fs/openpromfs/inode.c                           |    2 +-
 fs/pipe.c                                       |   20 +++---
 fs/proc/base.c                                  |   45 +++++++------
 fs/proc/generic.c                               |   31 ++++------
 fs/proc/inode.c                                 |   43 +++++++------
 fs/proc/nommu.c                                 |    2 +-
 fs/proc/proc_net.c                              |    2 +-
 fs/proc/proc_sysctl.c                           |    4 +-
 fs/proc/task_mmu.c                              |    6 +-
 fs/proc/task_nommu.c                            |    2 +-
 fs/qnx4/dir.c                                   |    2 +-
 fs/qnx6/dir.c                                   |    2 +-
 fs/ramfs/file-nommu.c                           |    2 +-
 fs/read_write.c                                 |    8 +-
 fs/readdir.c                                    |    2 +-
 fs/reiserfs/file.c                              |    2 +-
 fs/reiserfs/inode.c                             |    4 +-
 fs/reiserfs/ioctl.c                             |    2 +-
 fs/reiserfs/procfs.c                            |    2 +-
 fs/romfs/super.c                                |    2 +-
 fs/splice.c                                     |    7 +-
 fs/squashfs/dir.c                               |    2 +-
 fs/stat.c                                       |   13 ++--
 fs/sync.c                                       |    2 +-
 fs/sysfs/bin.c                                  |    6 +-
 fs/sysv/dir.c                                   |    2 +-
 fs/ubifs/dir.c                                  |    2 +-
 fs/ubifs/file.c                                 |    2 +-
 fs/ubifs/ioctl.c                                |    2 +-
 fs/udf/dir.c                                    |    2 +-
 fs/udf/file.c                                   |    6 +-
 fs/udf/namei.c                                  |    4 +-
 fs/ufs/dir.c                                    |    2 +-
 fs/xfs/xfs_dfrag.c                              |    8 +-
 fs/xfs/xfs_export.c                             |    4 +-
 fs/xfs/xfs_file.c                               |    4 +-
 fs/xfs/xfs_ioctl.c                              |    6 +-
 fs/xfs/xfs_ioctl32.c                            |    2 +-
 include/linux/binfmts.h                         |    1 -
 include/linux/dcache.h                          |    8 ++-
 include/linux/elf.h                             |    4 +
 include/linux/fs.h                              |   14 +++--
 include/linux/fsnotify.h                        |    2 +-
 include/linux/hugetlb.h                         |    2 +-
 include/linux/lockd/lockd.h                     |    2 +-
 ipc/mqueue.c                                    |   16 ++--
 ipc/shm.c                                       |   11 ++--
 kernel/acct.c                                   |    2 +-
 kernel/cgroup.c                                 |    6 +-
 kernel/events/core.c                            |    2 +-
 kernel/fork.c                                   |    2 +-
 kernel/irq/proc.c                               |    2 +-
 kernel/module.c                                 |    2 +-
 kernel/nsproxy.c                                |    2 +-
 kernel/relay.c                                  |    4 +-
 kernel/sys.c                                    |    8 +-
 kernel/sysctl_binary.c                          |   39 ++---------
 mm/cleancache.c                                 |    2 +-
 mm/fadvise.c                                    |    2 +-
 mm/filemap.c                                    |    2 +-
 mm/hugetlb.c                                    |    4 +-
 mm/mmap.c                                       |    8 +-
 mm/nommu.c                                      |   12 ++--
 mm/shmem.c                                      |   52 +++++++++------
 mm/swapfile.c                                   |    2 +-
 net/atm/proc.c                                  |    2 +-
 net/core/net_namespace.c                        |    2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c              |    2 +-
 net/netfilter/xt_recent.c                       |    2 +-
 net/netlink/af_netlink.c                        |    2 +-
 net/socket.c                                    |    5 +-
 net/sunrpc/auth_gss/auth_gss.c                  |    2 +-
 net/sunrpc/cache.c                              |   28 ++++----
 net/sunrpc/rpc_pipe.c                           |   10 ++--
 net/unix/garbage.c                              |    2 +-
 security/apparmor/domain.c                      |    4 +-
 security/apparmor/file.c                        |    4 +-
 security/apparmor/lsm.c                         |    6 +-
 security/commoncap.c                            |    2 +-
 security/integrity/ima/ima_api.c                |    6 +-
 security/integrity/ima/ima_crypto.c             |    2 +-
 security/integrity/ima/ima_main.c               |    4 +-
 security/selinux/hooks.c                        |   10 ++--
 security/selinux/selinuxfs.c                    |   20 ++----
 security/smack/smack_lsm.c                      |   14 +---
 security/tomoyo/securityfs_if.c                 |    2 +-
 sound/core/info.c                               |    2 +-
 sound/core/pcm_native.c                         |    2 +-
 sound/oss/msnd_pinnacle.c                       |    6 +-
 sound/oss/soundcard.c                           |   10 ++--
 sound/sound_firmware.c                          |    2 +-
 383 files changed, 1277 insertions(+), 1424 deletions(-)
