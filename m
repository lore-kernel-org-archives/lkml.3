Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3AUNnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:43:00 -0500
Received: from tundra.namei.org ([65.99.196.166]:36516 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab3AUNm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:42:58 -0500
Date: Tue, 22 Jan 2013 00:42:32 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem bugfixes
Message-ID: <alpine.LRH.2.02.1301220041370.2864@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull these fixes for your current tree.

The following changes since commit 9a9284153d965a57edc7162a8e57c14c97f3a935:
  Linus Torvalds (1):
        Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Dmitry Kasatkin (1):
      evm: checking if removexattr is not a NULL

Jerry Snitselaar (1):
      security/device_cgroup: lock assert fails in dev_exception_clean()

 security/device_cgroup.c            |    2 ++
 security/integrity/evm/evm_crypto.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)


---

commit 103a197c0c4ec936f5a243b5b092e4e49213f569
Author: Jerry Snitselaar <jerry.snitselaar@oracle.com>
Date:   Thu Jan 17 01:04:14 2013 -0700

    security/device_cgroup: lock assert fails in dev_exception_clean()
    
    devcgroup_css_free() calls dev_exception_clean() without the devcgroup_mutex being locked.
    
    Shutting down a kvm virt was giving me the following trace:
    
    [36280.732764] ------------[ cut here ]------------
    [36280.732778] WARNING: at /home/snits/dev/linux/security/device_cgroup.c:172 dev_exception_clean+0xa9/0xc0()
    [36280.732782] Hardware name: Studio XPS 8100
    [36280.732785] Modules linked in: xt_REDIRECT fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM iptable_mangle bridge stp llc nf_conntrack_ipv4 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_defrag_ipv4 ip6table_filter it87 hwmon_vid xt_state nf_conntrack ip6_tables snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq coretemp snd_seq_device crc32c_intel snd_pcm snd_page_alloc snd_timer snd broadcom tg3 serio_raw i7core_edac edac_core ptp pps_core lpc_ich pcspkr mfd_core soundcore microcode i2c_i801 nfsd auth_rpcgss nfs_acl lockd vhost_net sunrpc tun macvtap macvlan kvm_intel kvm uinput binfmt_misc autofs4 usb_storage firewire_ohci firewire_core crc_itu_t radeon drm_kms_helper ttm
    [36280.732921] Pid: 933, comm: libvirtd Tainted: G        W    3.8.0-rc3-00307-g4c217de #1
    [36280.732922] Call Trace:
    [36280.732927]  [<ffffffff81044303>] warn_slowpath_common+0x93/0xc0
    [36280.732930]  [<ffffffff8104434a>] warn_slowpath_null+0x1a/0x20
    [36280.732932]  [<ffffffff812deaf9>] dev_exception_clean+0xa9/0xc0
    [36280.732934]  [<ffffffff812deb2a>] devcgroup_css_free+0x1a/0x30
    [36280.732938]  [<ffffffff810ccd76>] cgroup_diput+0x76/0x210
    [36280.732941]  [<ffffffff8119eac0>] d_delete+0x120/0x180
    [36280.732943]  [<ffffffff81195cff>] vfs_rmdir+0xef/0x130
    [36280.732945]  [<ffffffff81195e47>] do_rmdir+0x107/0x1c0
    [36280.732949]  [<ffffffff8132d17e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
    [36280.732951]  [<ffffffff81198646>] sys_rmdir+0x16/0x20
    [36280.732954]  [<ffffffff8173bd82>] system_call_fastpath+0x16/0x1b
    [36280.732956] ---[ end trace ca39dced899a7d9f ]---
    
    Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
    Cc: stable@kernel.org
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 19ecc8d..d794abc 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -215,7 +215,9 @@ static void devcgroup_css_free(struct cgroup *cgroup)
 	struct dev_cgroup *dev_cgroup;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
+	mutex_lock(&devcgroup_mutex);
 	dev_exception_clean(dev_cgroup);
+	mutex_unlock(&devcgroup_mutex);
 	kfree(dev_cgroup);
 }
 

commit a67adb997419fb53540d4a4f79c6471c60bc69b6
Author: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Date:   Fri Jan 18 23:56:39 2013 +0200

    evm: checking if removexattr is not a NULL
    
    The following lines of code produce a kernel oops.
    
    fd = socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0);
    fchmod(fd, 0666);
    
    [  139.922364] BUG: unable to handle kernel NULL pointer dereference at   (null)
    [  139.924982] IP: [<  (null)>]   (null)
    [  139.924982] *pde = 00000000
    [  139.924982] Oops: 0000 [#5] SMP
    [  139.924982] Modules linked in: fuse dm_crypt dm_mod i2c_piix4 serio_raw evdev binfmt_misc button
    [  139.924982] Pid: 3070, comm: acpid Tainted: G      D      3.8.0-rc2-kds+ #465 Bochs Bochs
    [  139.924982] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
    [  139.924982] EIP is at 0x0
    [  139.924982] EAX: cf5ef000 EBX: cf5ef000 ECX: c143d600 EDX: c15225f2
    [  139.924982] ESI: cf4d2a1c EDI: cf4d2a1c EBP: cc02df10 ESP: cc02dee4
    [  139.924982]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
    [  139.924982] CR0: 80050033 CR2: 00000000 CR3: 0c059000 CR4: 000006d0
    [  139.924982] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
    [  139.924982] DR6: ffff0ff0 DR7: 00000400
    [  139.924982] Process acpid (pid: 3070, ti=cc02c000 task=d7705340 task.ti=cc02c000)
    [  139.924982] Stack:
    [  139.924982]  c1203c88 00000000 cc02def4 cf4d2a1c ae21eefa 471b60d5 1083c1ba c26a5940
    [  139.924982]  e891fb5e 00000041 00000004 cc02df1c c1203964 00000000 cc02df4c c10e20c3
    [  139.924982]  00000002 00000000 00000000 22222222 c1ff2222 cf5ef000 00000000 d76efb08
    [  139.924982] Call Trace:
    [  139.924982]  [<c1203c88>] ? evm_update_evmxattr+0x5b/0x62
    [  139.924982]  [<c1203964>] evm_inode_post_setattr+0x22/0x26
    [  139.924982]  [<c10e20c3>] notify_change+0x25f/0x281
    [  139.924982]  [<c10cbf56>] chmod_common+0x59/0x76
    [  139.924982]  [<c10e27a1>] ? put_unused_fd+0x33/0x33
    [  139.924982]  [<c10cca09>] sys_fchmod+0x39/0x5c
    [  139.924982]  [<c13f4f30>] syscall_call+0x7/0xb
    [  139.924982] Code:  Bad EIP value.
    
    This happens because sockets do not define the removexattr operation.
    Before removing the xattr, verify the removexattr function pointer is
    not NULL.
    
    Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
    Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index dfb2691..7dd538e 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -205,9 +205,9 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 		rc = __vfs_setxattr_noperm(dentry, XATTR_NAME_EVM,
 					   &xattr_data,
 					   sizeof(xattr_data), 0);
-	}
-	else if (rc == -ENODATA)
+	} else if (rc == -ENODATA && inode->i_op->removexattr) {
 		rc = inode->i_op->removexattr(dentry, XATTR_NAME_EVM);
+	}
 	return rc;
 }
 
