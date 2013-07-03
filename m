Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3GCM3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:29:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45434 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab3GCM3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:29:20 -0400
Date: Wed, 3 Jul 2013 13:29:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git part 2
Message-ID: <20130703122918.GK4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Assorted f_pos race fixes, making do_splice_direct() safe to
call with i_mutex on parent, O_TMPFILE support, Jeff's locks.c series,
->d_hash/->d_compare calling conventions changes from Linus, misc stuff
all over the place.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (46):
      pcm_native: switch to fdget()/fdput()
      do_last(): fix missing checks for LAST_BIND case
      lift file_*_write out of do_splice_from()
      lift file_*_write out of do_splice_direct()
      allow build_open_flags() to return an error
      [O_TMPFILE] it's still short a few helpers, but infrastructure should be OK now...
      allow the temp files created by open() to be linked to
      ext3 ->tmpfile() support
      udf: provide ->tmpfile()
      don't call file_pos_write() if vfs_{read,write}{,v}() fails
      ncpfs: don't bother with EBUSY on removal of busy directories
      proc_fill_cache(): kill pointless check
      proc_pid_readdir(): stop wanking with proc_fill_cache() for /proc/self
      proc_fill_cache(): just make instantiate_t return int
      proc_fill_cache(): clean up, get rid of pointless find_inode_number() use
      coda: don't bother with find_inode_number()
      kill find_inode_number()
      more open-coded file_inode() calls
      comedi: quit wanking with FASYNC in ->release()
      fanotify: quit wanking with FASYNC in ->release()
      btrfs: more open-coded file_inode()
      fuse: another open-coded file_inode()
      ecryptfs: switch ecryptfs_decode_and_decrypt_filename() from dentry to sb
      new helper: fixed_size_llseek()
      mtdchar: switch to fixed_size_llseek()
      zorro: switch to fixed_size_llseek()
      bna: switch to fixed_size_llseek()
      eisa_eeprom: switch to fixed_size_llseek()
      vc: switch to fixed_size_llseek()
      fnic: switch to fixed_size_llseek()
      bfa: switch to fixed_size_llseek()
      wlcore: use *ppos, not file->f_pos
      ps3flash: switch to generic_file_llseek_size()
      constify rw_verify_area()
      splice: lift checks from do_splice_from() into callers
      lpfc: switch to fixed_size_llseek()
      isapnp: switch to fixed_size_llseek()
      pci/proc: switch to fixed_size_llseek()
      ubi/cdev: switch to fixed_size_llseek()
      proc_powerpc: switch to fixed_size_llseek()
      tile-srom: switch to fixed_size_llseek()
      cpqphp_sysfs: switch to fixed_size_llseek()
      block_dev: switch to fixed_size_llseek()
      lseek_execute() doesn't need an inode passed to it
      ext4: ->tmpfile() support
      Document ->tmpfile()

Dan Carpenter (1):
      minix: bug widening a binary "not" operation

David Howells (2):
      Replace a bunch of file->dentry->d_inode refs with file_inode()
      SELinux: Institute file_path_has_perm()

Jeff Layton (12):
      locks: drop the unused filp argument to posix_unblock_lock
      cifs: use posix_unblock_lock instead of locks_delete_block
      locks: make generic_add_lease and generic_delete_lease static
      locks: comment cleanups and clarifications
      locks: make "added" in __posix_lock_file a bool
      locks: encapsulate the fl_link list handling
      locks: protect most of the file_lock handling with i_lock
      locks: avoid taking global lock if possible when waking up blocked waiters
      locks: convert fl_link to a hlist_node
      locks: turn the blocked_list into a hashtable
      locks: add a new "lm_owner_key" lock operation
      locks: give the blocked_hash its own spinlock

Jie Liu (1):
      vfs: export lseek_execute() to modules

Linus Torvalds (1):
      Don't pass inode to ->d_hash() and ->d_compare()

Diffstat:
 Documentation/filesystems/Locking               |   35 ++-
 Documentation/filesystems/vfs.txt               |   24 +-
 arch/alpha/include/uapi/asm/fcntl.h             |    1 +
 arch/arc/kernel/troubleshoot.c                  |    2 +-
 arch/parisc/include/uapi/asm/fcntl.h            |    1 +
 arch/powerpc/kernel/proc_powerpc.c              |   20 +--
 arch/sparc/include/uapi/asm/fcntl.h             |    1 +
 drivers/char/ps3flash.c                         |   28 +--
 drivers/char/tile-srom.c                        |   28 +--
 drivers/mtd/mtdchar.c                           |   20 +--
 drivers/mtd/ubi/cdev.c                          |   26 +--
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c |   22 +--
 drivers/net/wireless/ti/wlcore/debugfs.c        |    4 +-
 drivers/parisc/eisa_eeprom.c                    |   15 +-
 drivers/pci/hotplug/cpqphp_sysfs.c              |   22 +--
 drivers/pci/proc.c                              |   23 +--
 drivers/pnp/isapnp/proc.c                       |   22 +--
 drivers/scsi/bfa/bfad_debugfs.c                 |   28 +--
 drivers/scsi/fnic/fnic_debugfs.c                |   16 +--
 drivers/scsi/lpfc/lpfc_debugfs.c                |   18 +--
 drivers/staging/android/logger.c                |    2 +-
 drivers/staging/comedi/comedi_fops.c            |    3 -
 drivers/tty/vt/vc_screen.c                      |   17 +--
 drivers/zorro/proc.c                            |   22 +--
 fs/adfs/dir.c                                   |    6 +-
 fs/affs/namei.c                                 |   26 +--
 fs/afs/flock.c                                  |    7 +-
 fs/aio.c                                        |    2 +
 fs/block_dev.c                                  |   23 +--
 fs/btrfs/file.c                                 |   15 +--
 fs/btrfs/ioctl.c                                |    8 +-
 fs/ceph/file.c                                  |   11 +-
 fs/ceph/locks.c                                 |    2 +-
 fs/ceph/mds_client.c                            |    8 +-
 fs/cifs/cifsfs.c                                |    2 +-
 fs/cifs/dir.c                                   |    9 +-
 fs/cifs/file.c                                  |   15 +-
 fs/coda/dir.c                                   |    8 +-
 fs/dcache.c                                     |   66 ++----
 fs/ecryptfs/crypto.c                            |    5 +-
 fs/ecryptfs/ecryptfs_kernel.h                   |    2 +-
 fs/ecryptfs/file.c                              |    9 +-
 fs/ecryptfs/inode.c                             |    2 +-
 fs/efivarfs/super.c                             |    9 +-
 fs/exec.c                                       |   10 +-
 fs/ext2/namei.c                                 |   24 ++
 fs/ext3/namei.c                                 |   47 ++++-
 fs/ext4/file.c                                  |   24 +--
 fs/ext4/namei.c                                 |   47 ++++-
 fs/fat/namei_msdos.c                            |    6 +-
 fs/fat/namei_vfat.c                             |   12 +-
 fs/file_table.c                                 |    2 +-
 fs/fuse/file.c                                  |    3 +-
 fs/gfs2/dentry.c                                |    3 +-
 fs/gfs2/file.c                                  |    2 +-
 fs/hfs/hfs_fs.h                                 |    7 +-
 fs/hfs/string.c                                 |    6 +-
 fs/hfsplus/hfsplus_fs.h                         |    7 +-
 fs/hfsplus/unicode.c                            |    7 +-
 fs/hpfs/dentry.c                                |    7 +-
 fs/inode.c                                      |    4 +-
 fs/internal.h                                   |    6 +-
 fs/isofs/inode.c                                |   48 ++---
 fs/isofs/namei.c                                |    3 +-
 fs/jfs/namei.c                                  |    7 +-
 fs/lockd/svclock.c                              |   14 +-
 fs/lockd/svcsubs.c                              |   12 +-
 fs/locks.c                                      |  281 ++++++++++++++++-------
 fs/minix/dir.c                                  |    2 +-
 fs/minix/namei.c                                |   13 +
 fs/namei.c                                      |  113 +++++++---
 fs/ncpfs/dir.c                                  |   45 ++--
 fs/ncpfs/inode.c                                |    4 +
 fs/nfs/delegation.c                             |   10 +-
 fs/nfs/nfs4state.c                              |    8 +-
 fs/nfsd/nfs4state.c                             |    8 +-
 fs/notify/fanotify/fanotify_user.c              |    3 -
 fs/ocfs2/file.c                                 |   12 +-
 fs/open.c                                       |   63 +++--
 fs/proc/base.c                                  |  105 ++++-----
 fs/proc/fd.c                                    |   18 +-
 fs/proc/internal.h                              |    2 +-
 fs/proc/namespaces.c                            |   13 +-
 fs/proc/proc_sysctl.c                           |    7 +-
 fs/read_write.c                                 |   65 ++++--
 fs/splice.c                                     |   38 ++--
 fs/sysv/namei.c                                 |    3 +-
 fs/udf/namei.c                                  |   24 ++
 fs/xfs/xfs_file.c                               |    6 +-
 include/linux/dcache.h                          |   11 +-
 include/linux/fs.h                              |   49 +++--
 include/linux/fsnotify.h                        |    8 +-
 include/uapi/asm-generic/fcntl.h                |    4 +
 mm/shmem.c                                      |   37 +++-
 net/sunrpc/auth_gss/svcauth_gss.c               |    4 +-
 security/integrity/ima/ima_main.c               |    2 +-
 security/selinux/hooks.c                        |   24 ++-
 sound/core/pcm_native.c                         |   40 ++--
 98 files changed, 979 insertions(+), 986 deletions(-)
