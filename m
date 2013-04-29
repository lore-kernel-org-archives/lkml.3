Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3D2IZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:25:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47705 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3D2IZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:25:48 -0400
Date: Mon, 29 Apr 2013 18:25:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20130429182537.1a6c83aa578271d427dd0ce2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_18_25_37_+1000_Fyc7DK016UovaLG5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_18_25_37_+1000_Fyc7DK016UovaLG5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/proc/internal.h between commit 4608da4a9433 ("proc: Move non-public
stuff from linux/proc_fs.h to fs/proc/internal.h") from the vfs tree and
commit "mm, vmalloc: move get_vmalloc_info() to vmalloc.c" from the akpm
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/proc/internal.h
index 04255b6,47eac85..0000000
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@@ -191,56 -157,36 +191,35 @@@ static inline struct proc_dir_entry *pd
  	atomic_inc(&pde->count);
  	return pde;
  }
 -void pde_put(struct proc_dir_entry *pde);
 -
 -int proc_fill_super(struct super_block *);
 -struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry =
*);
 -int proc_remount(struct super_block *sb, int *flags, char *data);
 +extern void pde_put(struct proc_dir_entry *);
 =20
  /*
 - * These are generic /proc routines that use the internal
 - * "struct proc_dir_entry" tree to traverse the filesystem.
 - *
 - * The /proc root directory has extended versions to take care
 - * of the /proc/<pid> subdirectories.
 + * inode.c
   */
 -int proc_readdir(struct file *, void *, filldir_t);
 -struct dentry *proc_lookup(struct inode *, struct dentry *, unsigned int);
 +struct pde_opener {
 +	struct file *file;
 +	struct list_head lh;
 +	int closing;
 +	struct completion *c;
 +};
 =20
 +extern const struct inode_operations proc_pid_link_inode_operations;
 =20
 +extern void proc_init_inodecache(void);
 +extern struct inode *proc_get_inode(struct super_block *, struct proc_dir=
_entry *);
 +extern int proc_fill_super(struct super_block *);
 +extern void proc_entry_rundown(struct proc_dir_entry *);
 =20
 -/* Lookups */
 -typedef struct dentry *instantiate_t(struct inode *, struct dentry *,
 -				struct task_struct *, const void *);
 -int proc_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
 -	const char *name, int len,
 -	instantiate_t instantiate, struct task_struct *task, const void *ptr);
 -int pid_revalidate(struct dentry *dentry, unsigned int flags);
 -struct inode *proc_pid_make_inode(struct super_block * sb, struct task_st=
ruct *task);
 -extern const struct dentry_operations pid_dentry_operations;
 -int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat=
 *stat);
 -int proc_setattr(struct dentry *dentry, struct iattr *attr);
 +/*
-  * mmu.c
-  */
- struct vmalloc_info {
- 	unsigned long	used;
- 	unsigned long	largest_chunk;
- };
-=20
- #ifdef CONFIG_MMU
- #define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
- extern void get_vmalloc_info(struct vmalloc_info *);
-=20
- #else
- #define VMALLOC_TOTAL 0UL
- static inline void get_vmalloc_info(struct vmalloc_info *vmi)
- {
- 	vmi->used =3D 0;
- 	vmi->largest_chunk =3D 0;
- }
- #endif
-=20
- /*
 + * proc_devtree.c
 + */
 +#ifdef CONFIG_PROC_DEVICETREE
 +extern void proc_device_tree_init(void);
 +#endif
 =20
 +/*
 + * proc_namespaces.c
 + */
  extern const struct inode_operations proc_ns_dir_inode_operations;
  extern const struct file_operations proc_ns_dir_operations;
 =20

--Signature=_Mon__29_Apr_2013_18_25_37_+1000_Fyc7DK016UovaLG5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfi6BAAoJEECxmPOUX5FEz+kP/2rv7GXus+f4n5+Kozs+kzA0
bumNaI1DS3NSFUH+iCWJ1tZqHiYk/KSTKKDL5UhVXIdQxNm7fZMpBL31N9tSh9vb
D6gsDo6YOMgZ307IClU+FriiRj/8W38e6cbVv1q0bDSswB/uTLikKq+gFA21J56E
fLMZVtcpdW8Rxjxb8m+UksUs63u8qZOoj09vU4556llyNp3d8NXFwWPaWb5sEbWN
8Ozy0XFoQXnXfLyAVW9W04tOZJKoGHwRQiPFSwKEKvB8PQoOEIUYGQAs/lZu4rm9
Cc4yV/1PkWb+JP4IXJj8IxcDtmP1jNkR1dYOmZu6bcOs2ALbptOpkpnx10ayttrp
uoAqbWsvXcKUeTotVkbs6LHPdaPDBMxoDRwIPBiMM9yvwTqcHcx4q7vD//BvhSX1
dyISv+P1TPen09MZq0cfQJ8XEVGZkP8pbG5oiB0xRQAKVVBiGLIWCEfD95zLPSL9
BxTaefA4i9ys0v8T5Z2jFqFJnpPyoOcN43Teli/Bctw7//NXx1H8XZNAB4WlaOOH
/qxh5QzeqeE5UihhKjIIZsADuz5cSAqlkgWjsOyb7CnD0GP45JMeRiojA8PwsPmV
3zu8cJ4sLT4V+a1a/0/twF+rrKu6imXtPwvcUSvmbxR2dl18Q10tZDAwffLQ0L3n
mG5jc+tuf+RyaZz9RzXj
=x7ey
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_18_25_37_+1000_Fyc7DK016UovaLG5--
