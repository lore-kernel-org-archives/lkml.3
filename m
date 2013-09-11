Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3IKAaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:30:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48962 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3IKAaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:30:17 -0400
Date: Wed, 11 Sep 2013 10:30:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130911103005.edd86001b641e53becc05ad2@canb.auug.org.au>
In-Reply-To: <20130910154400.75bb3328fbb9eaa937715652@linux-foundation.org>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
	<20130910152753.662599171456233c5f91edb4@linux-foundation.org>
	<CA+55aFwiK+=7N3EDoX+s8dVCoraba9bCPrgqHgsMKppogEFBnw@mail.gmail.com>
	<20130910154400.75bb3328fbb9eaa937715652@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Sep_2013_10_30_05_+1000_Z+V/V4WQVGZvmKZz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Sep_2013_10_30_05_+1000_Z+V/V4WQVGZvmKZz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Tue, 10 Sep 2013 15:44:00 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Tue, 10 Sep 2013 15:35:04 -0700 Linus Torvalds <torvalds@linux-foundat=
ion.org> wrote:
>=20
> > So I'd (once again) suggest you base your pile of patches on the
> > previous stable kernel, and that linux-next take it *first* rather
> > than take it last.
>=20
> That's what we're now doing.  But this particular patchset was
> different because it's changing multiple subsystems, several of which
> are concurrently being changed in an uncoordinated fashion.

Yeah, Andrew and I came to an arrangement this round so that almost all
of his series is based only on your tree.  Currently I have 375 patches
based on v3.11-rc7-14-gfa8218d in a branch that I just merge each day.
The remaining bit (which contains the series that caused this thread) is
now only 38 patches (after removing the stuff that Al has taken) is still
rebased on top of linux-next each day due to dependencies on other trees
in linux-next.  (Yes, I know this is not ideal, but it is a work in
progress.)

So, Andrew, you should be able to just about send those 375 patches to
Linus (I know that there may be some fix folding to do before that) and
have him apply them on top of v3.11-rc7-14-gfa8218d in a separate branch
and then merge that branch.   I have included the "git diff-tree --cc"
output from my merge of that into linux-next yesterday.  Some of it is
not applicable yet (since there are still some other outstanding trees),
but it gives you some idea of how little the merge is a problem.

I hope this is helpful.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/kernel/kprobes.c
index adbbe7f,cb7ac9e..0ce9fb2
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@@ -100,17 -120,13 +120,16 @@@ static int __kprobes get_fixup_type(kpr
  			fixup |=3D FIXUP_RETURN_REGISTER;
  		break;
  	case 0xc0:
- 		if ((insn[0] & 0x0f) =3D=3D 0x00 ||	/* larl  */
- 		    (insn[0] & 0x0f) =3D=3D 0x05)	/* brasl */
- 		fixup |=3D FIXUP_RETURN_REGISTER;
+ 		if ((insn[0] & 0x0f) =3D=3D 0x05)	/* brasl */
+ 			fixup |=3D FIXUP_RETURN_REGISTER;
  		break;
  	case 0xeb:
 -		if ((insn[2] & 0xff) =3D=3D 0x44 ||	/* bxhg  */
 -		    (insn[2] & 0xff) =3D=3D 0x45)	/* bxleg */
 +		switch (insn[2] & 0xff) {
 +		case 0x44: /* bxhg  */
 +		case 0x45: /* bxleg */
  			fixup =3D FIXUP_BRANCH_NOT_TAKEN;
 +			break;
 +		}
  		break;
  	case 0xe3:	/* bctg	*/
  		if ((insn[2] & 0xff) =3D=3D 0x46)
diff --cc arch/x86/lib/csum-wrappers_64.c
index 7609e0e,aaba241..2528500
--- a/arch/x86/lib/csum-wrappers_64.c
+++ b/arch/x86/lib/csum-wrappers_64.c
@@@ -4,9 -4,9 +4,10 @@@
   *
   * Wrappers of assembly checksum functions for x86-64.
   */
+ #include <linux/sched.h>
  #include <asm/checksum.h>
  #include <linux/module.h>
 +#include <asm/smap.h>
 =20
  /**
   * csum_partial_copy_from_user - Copy and checksum from user space.
diff --cc drivers/staging/lustre/lustre/llite/remote_perm.c
index dedd56a,ceac936..50de0f0
--- a/drivers/staging/lustre/lustre/llite/remote_perm.c
+++ b/drivers/staging/lustre/lustre/llite/remote_perm.c
@@@ -44,7 -44,9 +44,8 @@@
  #define DEBUG_SUBSYSTEM S_LLITE
 =20
  #include <linux/module.h>
+ #include <linux/sched.h>
  #include <linux/types.h>
 -#include <linux/version.h>
 =20
  #include <lustre_lite.h>
  #include <lustre_ha.h>
diff --cc fs/fat/file.c
index 33711ff,00b5810..26c8e32
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@@ -148,6 -151,22 +151,22 @@@ static long fat_generic_compat_ioctl(st
 =20
  static int fat_file_release(struct inode *inode, struct file *filp)
  {
+=20
+ 	struct super_block *sb =3D inode->i_sb;
+ 	loff_t mmu_private_ideal;
+=20
+ 	/*
+ 	 * Release unwritten fallocated blocks on file release.
+ 	 * Do this only when the last open file descriptor is closed.
+ 	 */
+ 	mutex_lock(&inode->i_mutex);
+ 	mmu_private_ideal =3D round_up(inode->i_size, sb->s_blocksize);
+=20
+ 	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
 -	    filp->f_dentry->d_count =3D=3D 1)
++	    d_count(filp->f_dentry) =3D=3D 1)
+ 		fat_truncate_blocks(inode, inode->i_size);
+ 	mutex_unlock(&inode->i_mutex);
+=20
  	if ((filp->f_mode & FMODE_WRITE) &&
  	     MSDOS_SB(inode->i_sb)->options.flush) {
  		fat_flush_inodes(inode->i_sb, inode, NULL);
diff --cc fs/xfs/xfs_mount.c
index 5dcc680,eb9ba15..65dbf17
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@@ -15,9 -15,10 +15,10 @@@
   * along with this program; if not, write the Free Software Foundation,
   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
   */
+ #include <linux/sched.h>
  #include "xfs.h"
  #include "xfs_fs.h"
 -#include "xfs_types.h"
 +#include "xfs_format.h"
  #include "xfs_bit.h"
  #include "xfs_log.h"
  #include "xfs_inum.h"
diff --cc kernel/fork.c
index fb4406b,04a8c2a..5ede60b
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@@ -1173,13 -1171,15 +1171,16 @@@ static struct task_struct *copy_process
  		return ERR_PTR(-EINVAL);
 =20
  	/*
- 	 * If the new process will be in a different pid namespace
- 	 * don't allow the creation of threads.
+ 	 * If the new process will be in a different pid or user namespace
+ 	 * do not allow it to share a thread group or signal handlers or
+ 	 * parent with the forking task.
  	 */
- 	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
- 	    (task_active_pid_ns(current) !=3D
- 	     current->nsproxy->pid_ns_for_children))
- 		return ERR_PTR(-EINVAL);
+ 	if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
+ 		if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
 -		    (task_active_pid_ns(current) !=3D current->nsproxy->pid_ns))
++		    (task_active_pid_ns(current) !=3D
++		     current->nsproxy->pid_ns_for_children))
+ 			return ERR_PTR(-EINVAL);
+ 	}
 =20
  	retval =3D security_task_create(clone_flags);
  	if (retval)
diff --cc kernel/watchdog.c
index 51c4f34,410d5bb..373d3e1
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@@ -553,6 -607,14 +607,6 @@@ void __init lockup_detector_init(void
  {
  	set_sample_period();
 =20
 -#ifdef CONFIG_NO_HZ_FULL
 -	if (watchdog_user_enabled) {
 -		watchdog_user_enabled =3D 0;
 -		pr_warning("Disabled lockup detectors by default for full dynticks\n");
 -		pr_warning("You can reactivate it with 'sysctl -w kernel.watchdog=3D1'\=
n");
 -	}
 -#endif
 -
  	if (watchdog_user_enabled)
- 		watchdog_enable_all_cpus();
+ 		watchdog_enable_all_cpus(false);
  }

--Signature=_Wed__11_Sep_2013_10_30_05_+1000_Z+V/V4WQVGZvmKZz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSL7mRAAoJEECxmPOUX5FEn58P/1b9GaPgwWuTcPenVZPK30no
gzJk+020NKCuUUVcjIKVn60rabTQeyNboKbzPoCbZ5+LlgSJzwnqtZCe8OvhBdr1
pVpeU9bQqYgwR4D9TfoJSWXuLCqkzoIQH5PW8IG3AUl/ASiSjZyhiHPxjnqD54bU
Eg6SwN9jwszBvVLmjSPAJKr+f3sAKJnKZ8eLCy0URRIj9Ho4GzgRDqm7e0zQtYHG
feJzx/FcEhQ/jxxHXZQKyg4+x/x+3D4LxuLDFGfwDK6uZAjusdVxH8f74O2HD6bj
dvxxiOklHfa4m5Mn67Q6WhJsX62AghFrUK6OvnyJhctArsd+hAuWRbtFhEgXM/cS
FGzjPtLiAr2yNh631/+RffBxtZUxMop3uABSiBfrP5BTxY099gPJwJm3BwobM5tw
ylOzdt1fC9F+LkiRNbldaT5o+WyZh1OK5FZeEE3P+zeLTCxr29uCoppKPeVH2RdK
3zacDFkicUTQWL82tKqnHyfVXLsFcTjwI+jgqRTtdVIBshIxmxx8VF00wDfDauqD
xQTSUbIecxrYbeBCHG3xYtK3czhgcOFBhhJJusMXwudfRbjDMGsNIoiWGcGssGad
u+8n6jD0RdWTE40XFnd/MqW+9jwL2723uHI04Ez1vAveo92o1bg4mzvDwAp/C0kN
neO8gjyPFs5VXTSL3rmW
=V158
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Sep_2013_10_30_05_+1000_Z+V/V4WQVGZvmKZz--
