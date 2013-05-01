Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960Ab3EACLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 22:11:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36408 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058Ab3EACLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 22:11:13 -0400
Date: Wed, 1 May 2013 12:11:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Joonsoo Kim <js1304@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20130501121110.88f324c1c28493cf9a7b296f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__1_May_2013_12_11_10_+1000_GxOAbDC6vBOHPAjW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_May_2013_12_11_10_+1000_GxOAbDC6vBOHPAjW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/proc/internal.h between commit db3808c1bac6 ("mm, vmalloc: move
get_vmalloc_info() to vmalloc.c") from Linus' tree and commit
ae8970dd9ccb ("proc: Move non-public stuff from linux/proc_fs.h to
fs/proc/internal.h") from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/proc/internal.h
index 7571035,04255b6..0000000
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@@ -154,36 -191,56 +191,35 @@@ static inline struct proc_dir_entry *pd
  	atomic_inc(&pde->count);
  	return pde;
  }
- void pde_put(struct proc_dir_entry *pde);
-=20
- int proc_fill_super(struct super_block *);
- struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry =
*);
- int proc_remount(struct super_block *sb, int *flags, char *data);
+ extern void pde_put(struct proc_dir_entry *);
 =20
  /*
-  * These are generic /proc routines that use the internal
-  * "struct proc_dir_entry" tree to traverse the filesystem.
-  *
-  * The /proc root directory has extended versions to take care
-  * of the /proc/<pid> subdirectories.
+  * inode.c
   */
- int proc_readdir(struct file *, void *, filldir_t);
- struct dentry *proc_lookup(struct inode *, struct dentry *, unsigned int);
+ struct pde_opener {
+ 	struct file *file;
+ 	struct list_head lh;
+ 	int closing;
+ 	struct completion *c;
+ };
 =20
+ extern const struct inode_operations proc_pid_link_inode_operations;
 =20
+ extern void proc_init_inodecache(void);
+ extern struct inode *proc_get_inode(struct super_block *, struct proc_dir=
_entry *);
+ extern int proc_fill_super(struct super_block *);
+ extern void proc_entry_rundown(struct proc_dir_entry *);
 =20
- /* Lookups */
- typedef struct dentry *instantiate_t(struct inode *, struct dentry *,
- 				struct task_struct *, const void *);
- int proc_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
- 	const char *name, int len,
- 	instantiate_t instantiate, struct task_struct *task, const void *ptr);
- int pid_revalidate(struct dentry *dentry, unsigned int flags);
- struct inode *proc_pid_make_inode(struct super_block * sb, struct task_st=
ruct *task);
- extern const struct dentry_operations pid_dentry_operations;
- int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat=
 *stat);
- int proc_setattr(struct dentry *dentry, struct iattr *attr);
+ /*
 - * mmu.c
 - */
 -struct vmalloc_info {
 -	unsigned long	used;
 -	unsigned long	largest_chunk;
 -};
 -
 -#ifdef CONFIG_MMU
 -#define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
 -extern void get_vmalloc_info(struct vmalloc_info *);
 -
 -#else
 -#define VMALLOC_TOTAL 0UL
 -static inline void get_vmalloc_info(struct vmalloc_info *vmi)
 -{
 -	vmi->used =3D 0;
 -	vmi->largest_chunk =3D 0;
 -}
 -#endif
 -
 -/*
+  * proc_devtree.c
+  */
+ #ifdef CONFIG_PROC_DEVICETREE
+ extern void proc_device_tree_init(void);
+ #endif
 =20
+ /*
+  * proc_namespaces.c
+  */
  extern const struct inode_operations proc_ns_dir_inode_operations;
  extern const struct file_operations proc_ns_dir_operations;
 =20

--Signature=_Wed__1_May_2013_12_11_10_+1000_GxOAbDC6vBOHPAjW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgHm+AAoJEECxmPOUX5FEuqQQAJrXLumMLF9JxVa1e9H2P0uY
lRiOQ5NUYQ1BQUvHucqAkWMIGgPQoXmkidx8F30uWdY5fV4jKRQzEthLAp3HKNsI
OIv8ISIjcimQ0E3yOCIOh/1J1v5O3sawCVEMpnWNKP2jKViS4Ukh1Vx4w4L9r+vH
dqL25SkeG7o3YxMnyByuR5ao32sRhwzVyZpRC2ZUQbGkXCYlYzRC9HVZA6ArSy2r
/DrDuTEXovGWkZRsFSqkwwGYh0VxXvbnL0Cx2a982LlXgeD4BTWciAj4YQ7BPz14
c7IUg/rhNwjWaKgrULgfBseLO3ZeeFX651FBbTdRvLXfUVM46mEpVjLZfD01Z9vL
4Vpvi2y0JeYgUElIxPGVpmUDiB896Bb9iMb7Jh8wWgOc2sTULM8FWlI5O2b6Kh/g
zZxhmmAqyRO67yklwpRx7idcKDJzTaXLuiG/1aBvqoL5POHY7vohAGVr0OKbgQK7
cqedD0QmdDvVaSiM/fXyGK4u0EH7XYvd4QLTHMEFYPIjLTUvt5bBw/BlgwD06MCH
ls3JJV9GIchC0wuC52Tat7DgQ/dV6sMYmErjEo9XkLGlgBG8PoX4+nnTq6nDDIa4
wWr/PNZUIvNqesTuz8QQsVrfGeMY1nHwsYAet0kyCe+kZtEfdI4J7uHbnPAzx+fv
zsyfNdtaC6bv8cQ6LPMP
=JuzY
-----END PGP SIGNATURE-----

--Signature=_Wed__1_May_2013_12_11_10_+1000_GxOAbDC6vBOHPAjW--
