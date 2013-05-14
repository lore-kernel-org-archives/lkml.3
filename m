Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab3ENJHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:07:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28903 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab3ENJHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:07:24 -0400
X-Spam-Score: -100.3
Message-ID: <5191FE96.6050607@asianux.com>
Date: Tue, 14 May 2013 17:06:30 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] fs/namespace.c: the direct cause of the warning for:
 "ida_remove called for id=0 which is not allocated" with mnt_release_group_id()
Content-Type: multipart/mixed;
 boundary="------------050202050000050200040605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050202050000050200040605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Maintainers:

After call collect_mounts(), then call drop_collected_mounts(), it will
report an warning: "ida_remove called for id=0 which is not allocated"
(one sample is audit_add_tree_rule() in kernel/audit_tree.c).

The direct cause (maybe also be the root cause):
  collect_mounts() passs 'CL_PRIVATE' to copy_tree() -> clone_mnt().
  it will set "mnt->mnt_group_id = 0" in clone_mnt().
  when drop_collected_mounts() -> mnt_release_group_id(), 'mnt->mnt_group_id == 0'.

Since it has already been marked as warn(), hope these information are
helpful to related members.


I just test audit subsystem, so find it (so execuse me, the test patch
and plan are still related audit sub system), the test patch is in
attachment, the test details and environments are below.


Test plan:
  code preparation for audit_tree.c:
    define a flag varaible.
    wait the flag to be true, before lock 'audit_filter_mutex' again. in audit_add_tree_rule()
    when evict_trunc() finish, set the flag true (also force 'postponed = NULL').
  firstly start: 'rm -rvf /tmp/gchen/linux-next'
  then start: 'audit -w /tmp/gchen/linux-next/drivers/char'
    (notice the order should not be changed, or all system call will be locked)

Test result:

if still set mnt->mnt_group_id =0 in clone_mnt():

---------------------------log begin--------------------------------------------

[    4.256275] gchen_tag: ffff88009b0d8000, mnt: ffff88003645e400, mnt_alloc_group_id(): id: 1, res: 0, name: /dev/sda12
[    4.256282] gchen_tag: ffff88009b0d8000, mnt: ffff88009ad40d00, mnt_alloc_group_id(): id: 2, res: 0, name: devtmpfs
[    4.256286] gchen_tag: ffff88009b0d8000, mnt: ffff88009ad4e200, mnt_alloc_group_id(): id: 3, res: 0, name: devpts
[    4.256290] gchen_tag: ffff88009b0d8000, mnt: ffff88009ad08a00, mnt_alloc_group_id(): id: 4, res: 0, name: tmpfs
[    4.256293] gchen_tag: ffff88009b0d8000, mnt: ffff880036d61900, mnt_alloc_group_id(): id: 5, res: 0, name: proc
[    4.256297] gchen_tag: ffff88009b0d8000, mnt: ffff88009ad4ee00, mnt_alloc_group_id(): id: 6, res: 0, name: sysfs
[    4.256301] gchen_tag: ffff88009b0d8000, mnt: ffff880036bcd600, mnt_alloc_group_id(): id: 7, res: 0, name: securityfs
[    4.256304] gchen_tag: ffff88009b0d8000, mnt: ffff880036bcdc00, mnt_alloc_group_id(): id: 8, res: 0, name: selinuxfs
[    4.256308] gchen_tag: ffff88009b0d8000, mnt: ffff880098035700, mnt_alloc_group_id(): id: 9, res: 0, name: tmpfs
[    4.256312] gchen_tag: ffff88009b0d8000, mnt: ffff880098035600, mnt_alloc_group_id(): id: 10, res: 0, name: cgroup
[    4.256315] gchen_tag: ffff88009b0d8000, mnt: ffff88009b353b00, mnt_alloc_group_id(): id: 11, res: 0, name: tmpfs
[    4.274360] gchen_tag: ffff88009b0d8000, mnt: ffff8800986a1300, mnt_alloc_group_id(): id: 12, res: 0, name: cgroup
[    4.274598] gchen_tag: ffff88009b0d8000, mnt: ffff8800986a1100, mnt_alloc_group_id(): id: 13, res: 0, name: cgroup
[    4.274961] gchen_tag: ffff88009b0d8000, mnt: ffff880097858700, mnt_alloc_group_id(): id: 14, res: 0, name: cgroup
[    4.275181] gchen_tag: ffff88009b0d8000, mnt: ffff8800986a3800, mnt_alloc_group_id(): id: 15, res: 0, name: cgroup
[    4.275371] gchen_tag: ffff88009b0d8000, mnt: ffff8800986a3500, mnt_alloc_group_id(): id: 16, res: 0, name: cgroup
[    4.275575] gchen_tag: ffff88009b0d8000, mnt: ffff8800986a3a00, mnt_alloc_group_id(): id: 17, res: 0, name: cgroup
[    4.275839] gchen_tag: ffff88009b0d8000, mnt: ffff8800986a3e00, mnt_alloc_group_id(): id: 18, res: 0, name: cgroup
[    4.276065] gchen_tag: ffff88009b0d8000, mnt: ffff8800986a3300, mnt_alloc_group_id(): id: 19, res: 0, name: cgroup
[    5.416658] gchen_tag: ffff88009b0d8000, mnt: ffff880036a25b00, mnt_alloc_group_id(): id: 20, res: 0, name: systemd-1
[    6.278586] gchen_tag: ffff880036cdc650, mnt: ffff880036295e00, mnt_alloc_group_id(): id: 21, res: 0, name: mqueue
[    6.279539] gchen_tag: ffff880036deddc0, mnt: ffff880036295900, mnt_alloc_group_id(): id: 22, res: 0, name: configfs
[    6.281696] gchen_tag: ffff880036a19770, mnt: ffff88009a80db00, mnt_alloc_group_id(): id: 23, res: 0, name: tmpfs
[    6.300232] gchen_tag: ffff880036cdddc0, mnt: ffff88009a80df00, mnt_alloc_group_id(): id: 24, res: 0, name: debugfs
[    6.300318] gchen_tag: ffff880036adaee0, mnt: ffff880036e5c800, mnt_alloc_group_id(): id: 25, res: 0, name: hugetlbfs

[  129.989188] gchen_tag: ffff88009a0ec650, clone_mnt() let mnt->mnt_group_id = 0
[  129.989202] gchen_tag: ffff88009a0ec650, get_tree(): count before: 1
[  129.989210] gchen_tag: ffff88009a0ec650, get_tree(): count before: 2
[  129.989217] gchen_tag: ffff88009a0ec650, mnt: ffff8800361de600, mnt_release_group_id(): id: 0, name: /dev/sda12
[  129.989221] ------------[ cut here ]------------
[  129.989230] WARNING: CPU: 0 PID: 895 at lib/idr.c:1065 ida_remove+0xbf/0x100()
[  129.989233] ida_remove called for id=0 which is not allocated.
[  129.989235] Modules linked in: lockd bnep bluetooth rfkill sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables snd_intel8x0 snd_ac97_codec ac97_bus snd_seq iTCO_wdt snd_seq_device iTCO_vendor_support snd_pcm snd_page_alloc snd_timer ppdev lpc_ich mfd_core snd 8139too 8139cp parport_pc parport mii i2c_i801 microcode soundcore pcspkr uinput i915 video i2c_algo_bit drm_kms_helper drm i2c_core
[  129.989288] CPU: 0 PID: 895 Comm: auditctl Not tainted 3.10.0-rc1-next-20130513+ #6
[  129.989292] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080012  11/14/2006
[  129.989295]  0000000000000009 ffff88009a07f8a8 ffffffff81621df0 0000000000000007
[  129.989301]  ffff88009a07f8f8 ffff88009a07f8e8 ffffffff8104a157 ffffffff819f2080
[  129.989307]  ffffffff81f94220 ffff880036bd2380 0000000000040000 0000000000000000
[  129.989313] Call Trace:
[  129.989324]  [<ffffffff81621df0>] dump_stack+0x46/0x58
[  129.989332]  [<ffffffff8104a157>] warn_slowpath_common+0x87/0xb0
[  129.989337]  [<ffffffff8104a236>] warn_slowpath_fmt+0x46/0x50
[  129.989342]  [<ffffffff812da79f>] ida_remove+0xbf/0x100
[  129.989349]  [<ffffffff811a3636>] mnt_release_group_id+0x56/0x80
[  129.989356]  [<ffffffff811b0085>] change_mnt_propagation+0x1a5/0x270
[  129.989362]  [<ffffffff811a484e>] umount_tree+0x15e/0x1c0
[  129.989367]  [<ffffffff811a5064>] drop_collected_mounts+0x34/0x50
[  129.989374]  [<ffffffff810cd1b0>] audit_add_tree_rule+0x1a0/0x340
[  129.989379]  [<ffffffff810c652c>] audit_receive_filter+0x71c/0x8b0
[  129.989386]  [<ffffffff8127edd9>] ? selinux_capable+0x39/0x50
[  129.989391]  [<ffffffff810c4060>] audit_receive+0x370/0xa30
[  129.989397]  [<ffffffff8150c22c>] ? __kmalloc_reserve.isra.52+0x3c/0xa0
[  129.989403]  [<ffffffff81545e59>] netlink_unicast+0x159/0x1d0
[  129.989408]  [<ffffffff8154618a>] netlink_sendmsg+0x2ba/0x370
[  129.989414]  [<ffffffff81503f16>] sock_sendmsg+0xa6/0xd0
[  129.989420]  [<ffffffff8114705d>] ? handle_pte_fault+0x8d/0xa00
[  129.989427]  [<ffffffff81504808>] SYSC_sendto+0x128/0x180
[  129.989433]  [<ffffffff8109c8ec>] ? ktime_get_ts+0x4c/0xf0
[  129.989439]  [<ffffffff81198da2>] ? poll_select_set_timeout+0x72/0x90
[  129.989445]  [<ffffffff81504e4e>] SyS_sendto+0xe/0x10
[  129.989451]  [<ffffffff81630602>] system_call_fastpath+0x16/0x1b
[  129.989454] ---[ end trace c01114c6695f73ff ]---
[  129.989466] gchen_tag: ffff88009a0ec650, audit_add_tree_rule(): begin waiting 100...., rule: ffff880036a40220
[  137.079385] gchen_tag: ffff88009a0eaee0, evict_chunk(): enter function postponed:           (null)
[  137.079405] gchen_tag: ffff88009a0eaee0, evict_chunk(): kill_rull postponed:           (null)
[  137.079410] gchen_tag: ffff88009a0eaee0, kill_rules(): list_del_init, rule: ffff880036a40220, tree:           (null)
[  137.079415] gchen_tag: ffff88009a0eaee0, evict_chunk(): audit_schedule_prune postponed:           (null)
[  137.081487] gchen_tag: ffff88009a0eaee0, evict_chunk(): set audit_test_count = true, postponed:           (null)
[  137.081497] gchen_tag: ffff88009a0ec650, audit_add_tree_rule(): end waiting, rule: ffff880036a40220
[  137.081505] gchen_tag: ffff88009a0ec650, audit_add_tree_rule(): list empty for rule->rlist and return fail: ffff880036a40220
[  137.081509] gchen_tag: ffff88009a0ec650, put_tree(): count before: 3
[  137.081591] gchen_tag: ffff88009a0ec650, audit_free_rule(): remove entry: ffff880036a40200
[  137.081964] gchen_tag: ffff8800361f9770, put_tree(): count before: 2
[  137.086017] gchen_tag: ffff8800361fc650, put_tree(): count before: 1

---------------------------log end----------------------------------------------


if set mnt->mnt_group_id with real value in clone_mnt(), the log will
be (will not report warning):

[  251.239821] gchen_tag: ffff8800987a0000, get_tree(): count before: 1
[  251.239832] gchen_tag: ffff8800987a0000, get_tree(): count before: 2
[  251.239840] gchen_tag: ffff8800987a0000, mnt: ffff880099aa6e00, mnt_release_group_id(): id: 1, name: /dev/sda12
[  251.239854] gchen_tag: ffff8800987a0000, audit_add_tree_rule(): begin waiting 100...., rule: ffff880036085820
[  257.465740] gchen_tag: ffff8800987a1770, evict_chunk(): enter function postponed:           (null)
[  257.465821] gchen_tag: ffff8800987a1770, evict_chunk(): kill_rull postponed:           (null)
[  257.465831] gchen_tag: ffff8800987a1770, kill_rules(): list_del_init, rule: ffff880036085820, tree:           (null)
[  257.465835] gchen_tag: ffff8800987a1770, evict_chunk(): audit_schedule_prune postponed:           (null)
[  257.465977] gchen_tag: ffff8800987a1770, evict_chunk(): set audit_test_count = true, postponed:           (null)
[  257.465985] gchen_tag: ffff8800987a0000, audit_add_tree_rule(): end waiting, rule: ffff880036085820
[  257.465990] gchen_tag: ffff8800987a0000, audit_add_tree_rule(): list empty for rule->rlist and return fail: ffff880036085820
[  257.465994] gchen_tag: ffff8800987a0000, put_tree(): count before: 3
[  257.466083] gchen_tag: ffff8800987a0000, audit_free_rule(): remove entry: ffff880036085800
[  257.466712] gchen_tag: ffff880036005dc0, put_tree(): count before: 2
[  257.470049] gchen_tag: ffff8800987a1770, put_tree(): count before: 1




The other information about my machine:

[root@dhcp122 lib]# mount
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
devtmpfs on /dev type devtmpfs (rw,nosuid,seclabel,size=1269756k,nr_inodes=317439,mode=755)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,seclabel,gid=5,mode=620,ptmxmode=000)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,seclabel)
tmpfs on /run type tmpfs (rw,nosuid,nodev,seclabel,mode=755)
/dev/sda12 on / type ext4 (rw,relatime,seclabel,data=ordered)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
selinuxfs on /sys/fs/selinux type selinuxfs (rw,relatime)
tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,seclabel,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct,cpu)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
cgroup on /sys/fs/cgroup/net_cls type cgroup (rw,nosuid,nodev,noexec,relatime,net_cls)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=24,pgrp=1,timeout=300,minproto=5,maxproto=5,direct)
tmpfs on /media type tmpfs (rw,nosuid,nodev,noexec,relatime,seclabel,mode=755)
debugfs on /sys/kernel/debug type debugfs (rw,relatime)
mqueue on /dev/mqueue type mqueue (rw,relatime,seclabel)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime,seclabel)
configfs on /sys/kernel/config type configfs (rw,relatime)
[root@dhcp122 lib]# df -Th
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  1.3G     0  1.3G   0% /dev
tmpfs          tmpfs     1.3G   84K  1.3G   1% /dev/shm
tmpfs          tmpfs     1.3G 1008K  1.3G   1% /run
/dev/sda12     ext4       37G   20G   17G  55% /
tmpfs          tmpfs     1.3G     0  1.3G   0% /sys/fs/cgroup
tmpfs          tmpfs     1.3G     0  1.3G   0% /media
[root@dhcp122 lib]#
[root@dhcp122 ~]# uname -a
Linux dhcp122.asianux.net 3.10.0-rc1-next-20130513+ #7 SMP Wed May 15 00:31:54 CST 2013 x86_64 x86_64 x86_64 GNU/Linux
[root@dhcp122 ~]# cat /proc/meminfo 
MemTotal:        2559344 kB
MemFree:         2054536 kB
Buffers:           55256 kB
Cached:           248740 kB
SwapCached:            0 kB
Active:           172812 kB
Inactive:         247612 kB
Active(anon):     117252 kB
Inactive(anon):   101024 kB
Active(file):      55560 kB
Inactive(file):   146588 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       4095996 kB
SwapFree:        4095996 kB
Dirty:                 4 kB
Writeback:             0 kB
AnonPages:        116468 kB
Mapped:            37964 kB
Shmem:            101856 kB
Slab:              44872 kB
SReclaimable:      16992 kB
SUnreclaim:        27880 kB
KernelStack:        1128 kB
PageTables:        10760 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     5375668 kB
Committed_AS:     632456 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      279600 kB
VmallocChunk:   34359454080 kB
HardwareCorrupted:     0 kB
AnonHugePages:     14336 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       53056 kB
DirectMap2M:     2560000 kB
[root@dhcp122 ~]# cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	: Intel(R) Pentium(R) 4 CPU 3.20GHz
stepping	: 5
microcode	: 0x7
cpu MHz		: 3200.000
cache size	: 2048 KB
physical id	: 0
siblings	: 1
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc pebs bts nopl pni dtes64 monitor ds_cpl est tm2 cid cx16 xtpr pdcm lahf_lm
bogomips	: 6384.22
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	: Intel(R) Pentium(R) 4 CPU 3.20GHz
stepping	: 5
microcode	: 0x7
cpu MHz		: 3200.000
cache size	: 2048 KB
physical id	: 0
siblings	: 1
core id		: 0
cpu cores	: 0
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc pebs bts nopl pni dtes64 monitor ds_cpl est tm2 cid cx16 xtpr pdcm lahf_lm
bogomips	: 6384.22
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 48 bits virtual
power management:






--------------050202050000050200040605
Content-Type: text/x-patch;
 name="test_warnings.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test_warnings.patch"

diff --git a/fs/namespace.c b/fs/namespace.c
index 7b1ca9b..0445fc2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -114,6 +114,9 @@ static int mnt_alloc_group_id(struct mount *mnt)
 	if (!res)
 		mnt_group_start = mnt->mnt_group_id + 1;
 
+	printk(KERN_INFO "gchen_tag: %p, mnt: %p, %s(): id: %d, res: %d, name: %s\n",
+		current, mnt, __FUNCTION__, mnt->mnt_group_id, res, mnt->mnt_devname);
+
 	return res;
 }
 
@@ -123,6 +126,10 @@ static int mnt_alloc_group_id(struct mount *mnt)
 void mnt_release_group_id(struct mount *mnt)
 {
 	int id = mnt->mnt_group_id;
+
+	printk(KERN_INFO "gchen_tag: %p, mnt: %p, %s(): id: %d, name: %s\n",
+		current, mnt, __FUNCTION__, id, mnt->mnt_devname);
+
 	ida_remove(&mnt_group_ida, id);
 	if (mnt_group_start > id)
 		mnt_group_start = id;
@@ -814,10 +821,13 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	mnt = alloc_vfsmnt(old->mnt_devname);
 	if (!mnt)
 		return ERR_PTR(-ENOMEM);
-
-	if (flag & (CL_SLAVE | CL_PRIVATE | CL_SHARED_TO_SLAVE))
+#if 0
+	if (flag & (CL_SLAVE | CL_PRIVATE | CL_SHARED_TO_SLAVE)) {
+		printk(KERN_INFO "gchen_tag: %p, %s() let mnt->mnt_group_id = 0\n", current, __FUNCTION__);
 		mnt->mnt_group_id = 0; /* not a peer of original */
+	}
 	else
+#endif
 		mnt->mnt_group_id = old->mnt_group_id;
 
 	if ((flag & CL_MAKE_SHARED) && !mnt->mnt_group_id) {
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 43c307d..23bbdfb 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -38,6 +38,8 @@ struct audit_chunk {
 static LIST_HEAD(tree_list);
 static LIST_HEAD(prune_list);
 
+static volatile bool audit_test_count;
+
 /*
  * One struct chunk is attached to each inode of interest.
  * We replace struct chunk on tagging/untagging.
@@ -90,11 +92,13 @@ static struct audit_tree *alloc_tree(const char *s)
 
 static inline void get_tree(struct audit_tree *tree)
 {
+	printk(KERN_INFO "gchen_tag: %p, %s(): count before: %d\n", current, __FUNCTION__, atomic_read(&tree->count));
 	atomic_inc(&tree->count);
 }
 
 static inline void put_tree(struct audit_tree *tree)
 {
+	printk(KERN_INFO "gchen_tag: %p, %s(): count before: %d\n", current, __FUNCTION__, atomic_read(&tree->count));
 	if (atomic_dec_and_test(&tree->count))
 		kfree_rcu(tree, head);
 }
@@ -474,7 +478,9 @@ static void kill_rules(struct audit_tree *tree)
 		entry = container_of(rule, struct audit_entry, rule);
 
 		list_del_init(&rule->rlist);
+		printk(KERN_INFO "gchen_tag: %p, %s(): list_del_init, rule: %p, tree: %p\n", current, __FUNCTION__, rule, rule->tree);
 		if (rule->tree) {
+			printk(KERN_INFO "gchen_tag: %p, %s(): remove entry: %p\n", current, __FUNCTION__, entry);
 			/* not a half-baked one */
 			audit_log_remove_rule(rule);
 			rule->tree = NULL;
@@ -657,6 +663,9 @@ int audit_add_tree_rule(struct audit_krule *rule)
 	struct path path;
 	struct vfsmount *mnt;
 	int err;
+	long long i = 0;
+
+	audit_test_count = false;
 
 	rule->tree = NULL;
 	list_for_each_entry(tree, &tree_list, list) {
@@ -698,8 +707,20 @@ int audit_add_tree_rule(struct audit_krule *rule)
 		goto Err;
 	}
 
+	printk(KERN_INFO "gchen_tag: %p, %s(): begin waiting 100...., rule: %p\n", current, __FUNCTION__, rule);
+	while (!audit_test_count) {
+		schedule();
+		if (i++ > 1000000*100) {
+			printk(KERN_INFO "gchen_tag: %p, %s(): i exceed.\n", current, __FUNCTION__);
+			break;
+		}
+	}
+	printk(KERN_INFO "gchen_tag: %p, %s(): end waiting, rule: %p\n", current, __FUNCTION__, rule);
+
+
 	mutex_lock(&audit_filter_mutex);
 	if (list_empty(&rule->rlist)) {
+		printk(KERN_INFO "gchen_tag: %p, %s(): list empty for rule->rlist and return fail: %p\n", current, __FUNCTION__, rule);
 		put_tree(tree);
 		return -ENOENT;
 	}
@@ -883,6 +904,8 @@ static void evict_chunk(struct audit_chunk *chunk)
 	if (chunk->dead)
 		return;
 
+	printk(KERN_INFO "gchen_tag: %p, %s(): enter function postponed: %p\n", current, __FUNCTION__, postponed);
+
 	chunk->dead = 1;
 	mutex_lock(&audit_filter_mutex);
 	spin_lock(&hash_lock);
@@ -894,6 +917,7 @@ static void evict_chunk(struct audit_chunk *chunk)
 		list_del_init(&owner->same_root);
 		spin_unlock(&hash_lock);
 		if (!postponed) {
+			printk(KERN_INFO "gchen_tag: %p, %s(): kill_rull postponed: %p\n", current, __FUNCTION__, postponed);
 			kill_rules(owner);
 			list_move(&owner->list, &prune_list);
 			need_prune = 1;
@@ -906,9 +930,14 @@ static void evict_chunk(struct audit_chunk *chunk)
 	for (n = 0; n < chunk->count; n++)
 		list_del_init(&chunk->owners[n].list);
 	spin_unlock(&hash_lock);
-	if (need_prune)
+	if (need_prune) {
+		printk(KERN_INFO "gchen_tag: %p, %s(): audit_schedule_prune postponed: %p\n", current, __FUNCTION__, postponed);
 		audit_schedule_prune();
+	}
 	mutex_unlock(&audit_filter_mutex);
+
+	printk(KERN_INFO "gchen_tag: %p, %s(): set audit_test_count = true, postponed: %p\n", current, __FUNCTION__, postponed);
+	audit_test_count = true;
 }
 
 static int audit_tree_handle_event(struct fsnotify_group *group,
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 83a2970..a6ae516 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -72,6 +72,8 @@ static inline void audit_free_rule(struct audit_entry *e)
 	int i;
 	struct audit_krule *erule = &e->rule;
 
+	printk(KERN_INFO "gchen_tag: %p, %s(): remove entry: %p\n", current, __FUNCTION__, e);
+
 	/* some rules don't have associated watches */
 	if (erule->watch)
 		audit_put_watch(erule->watch);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9845cb3..8e063b7 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2417,8 +2417,11 @@ void __audit_seccomp(unsigned long syscall, long signr, int code)
 
 struct list_head *audit_killed_trees(void)
 {
+	return NULL;
+#if 0
 	struct audit_context *ctx = current->audit_context;
 	if (likely(!ctx || !ctx->in_syscall))
 		return NULL;
 	return &ctx->killed_trees;
+#endif
 }

--------------050202050000050200040605--
