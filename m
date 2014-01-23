Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaAWENw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 23:13:52 -0500
Received: from ozlabs.org ([203.10.76.45]:45837 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbaAWEN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 23:13:26 -0500
Date: Thu, 23 Jan 2014 15:13:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Deng-Cheng Zhu" <dengcheng.zhu@imgtec.com>,
        "Steven J. Hill" <Steven.Hill@imgtec.com>
Subject: linux-next: manual merge of the userns tree with the mips tree
Message-Id: <20140123151318.2829ff70e3157df9ea6285b2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__23_Jan_2014_15_13_18_+1100_Yj_JnW5942nZCiuE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Jan_2014_15_13_18_+1100_Yj_JnW5942nZCiuE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got conflicts in
arch/mips/include/asm/vpe.h and arch/mips/kernel/vpe.c between commits
1a2a6d7e8816 ("MIPS: APRP: Split VPE loader into separate files") and
5792bf643865 ("MIPS: APRP: Code formatting clean-ups") from the mips tree
and commit f58437f1f916 ("MIPS: VPE: Remove vpe_getuid and vpe_getgid")
from the userns tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/include/asm/vpe.h
index e0684f5f0054,0880fe8809b1..000000000000
--- a/arch/mips/include/asm/vpe.h
+++ b/arch/mips/include/asm/vpe.h
@@@ -9,88 -18,7 +9,87 @@@
  #ifndef _ASM_VPE_H
  #define _ASM_VPE_H
 =20
 +#include <linux/init.h>
 +#include <linux/list.h>
 +#include <linux/smp.h>
 +#include <linux/spinlock.h>
 +
 +#define VPE_MODULE_NAME "vpe"
 +#define VPE_MODULE_MINOR 1
 +
 +/* grab the likely amount of memory we will need. */
 +#ifdef CONFIG_MIPS_VPE_LOADER_TOM
 +#define P_SIZE (2 * 1024 * 1024)
 +#else
 +/* add an overhead to the max kmalloc size for non-striped symbols/etc */
 +#define P_SIZE (256 * 1024)
 +#endif
 +
 +#define MAX_VPES 16
 +#define VPE_PATH_MAX 256
 +
 +static inline int aprp_cpu_index(void)
 +{
 +#ifdef CONFIG_MIPS_CMP
 +	return setup_max_cpus;
 +#else
 +	extern int tclimit;
 +	return tclimit;
 +#endif
 +}
 +
 +enum vpe_state {
 +	VPE_STATE_UNUSED =3D 0,
 +	VPE_STATE_INUSE,
 +	VPE_STATE_RUNNING
 +};
 +
 +enum tc_state {
 +	TC_STATE_UNUSED =3D 0,
 +	TC_STATE_INUSE,
 +	TC_STATE_RUNNING,
 +	TC_STATE_DYNAMIC
 +};
 +
 +struct vpe {
 +	enum vpe_state state;
 +
 +	/* (device) minor associated with this vpe */
 +	int minor;
 +
 +	/* elfloader stuff */
 +	void *load_addr;
 +	unsigned long len;
 +	char *pbuffer;
 +	unsigned long plen;
- 	unsigned int uid, gid;
 +	char cwd[VPE_PATH_MAX];
 +
 +	unsigned long __start;
 +
 +	/* tc's associated with this vpe */
 +	struct list_head tc;
 +
 +	/* The list of vpe's */
 +	struct list_head list;
 +
 +	/* shared symbol address */
 +	void *shared_ptr;
 +
 +	/* the list of who wants to know when something major happens */
 +	struct list_head notify;
 +
 +	unsigned int ntcs;
 +};
 +
 +struct tc {
 +	enum tc_state state;
 +	int index;
 +
 +	struct vpe *pvpe;	/* parent VPE */
 +	struct list_head tc;	/* The list of TC's with this VPE */
 +	struct list_head list;	/* The global list of tc's */
 +};
 +
  struct vpe_notifications {
  	void (*start)(int vpe);
  	void (*stop)(int vpe);
@@@ -98,36 -26,10 +97,34 @@@
  	struct list_head list;
  };
 =20
 +struct vpe_control {
 +	spinlock_t vpe_list_lock;
 +	struct list_head vpe_list;      /* Virtual processing elements */
 +	spinlock_t tc_list_lock;
 +	struct list_head tc_list;       /* Thread contexts */
 +};
 +
 +extern unsigned long physical_memsize;
 +extern struct vpe_control vpecontrol;
 +extern const struct file_operations vpe_fops;
 +
 +int vpe_notify(int index, struct vpe_notifications *notify);
 +
 +void *vpe_get_shared(int index);
- int vpe_getuid(int index);
- int vpe_getgid(int index);
 +char *vpe_getcwd(int index);
 +
 +struct vpe *get_vpe(int minor);
 +struct tc *get_tc(int index);
 +struct vpe *alloc_vpe(int minor);
 +struct tc *alloc_tc(int index);
 +void release_vpe(struct vpe *v);
 =20
 -extern int vpe_notify(int index, struct vpe_notifications *notify);
 +void *alloc_progmem(unsigned long len);
 +void release_progmem(void *ptr);
 =20
 -extern void *vpe_get_shared(int index);
 -extern char *vpe_getcwd(int index);
 +int __weak vpe_run(struct vpe *v);
 +void cleanup_tc(struct tc *tc);
 =20
 +int __init vpe_module_init(void);
 +void __exit vpe_module_exit(void);
  #endif /* _ASM_VPE_H */
diff --cc arch/mips/kernel/vpe.c
index 42d3ca08bd28,2d5c142bad67..000000000000
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@@ -899,35 -1262,14 +896,13 @@@ void *vpe_get_shared(int index
 =20
  	return v->shared_ptr;
  }
 -
  EXPORT_SYMBOL(vpe_get_shared);
 =20
- int vpe_getuid(int index)
- {
- 	struct vpe *v =3D get_vpe(index);
-=20
- 	if (v =3D=3D NULL)
- 		return -1;
-=20
- 	return v->uid;
- }
- EXPORT_SYMBOL(vpe_getuid);
-=20
- int vpe_getgid(int index)
- {
- 	struct vpe *v =3D get_vpe(index);
-=20
- 	if (v =3D=3D NULL)
- 		return -1;
-=20
- 	return v->gid;
- }
- EXPORT_SYMBOL(vpe_getgid);
-=20
  int vpe_notify(int index, struct vpe_notifications *notify)
  {
 -	struct vpe *v;
 +	struct vpe *v =3D get_vpe(index);
 =20
 -	if ((v =3D get_vpe(index)) =3D=3D NULL)
 +	if (v =3D=3D NULL)
  		return -1;
 =20
  	list_add(&notify->list, &v->notify);

--Signature=_Thu__23_Jan_2014_15_13_18_+1100_Yj_JnW5942nZCiuE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS4JbiAAoJEMDTa8Ir7ZwVNMMP/0eOPfxLt4cezaWI3uhJKfJV
f4xCtHaQtHJYsAEEMUQs7/7BLE/EQyc9NXwxdmQuj2Fgo3EG88VKs2gqTkMwrb30
QSnK8l9GTmchcEnw/eeReChhYHGQlwa/CyfvLcM0fxs6bubnBrbrQN25hiNokBKq
OckhJatam1wjnzWybtOxR+STfgZfxobBa7jemAgp971MBx4wv0vXyaacC9OyfK8+
r9jQI6Lav0/FcnPlNQ8Hfc8keFcX5U+NyZztiGKlu7pqNgkk3dVu3NOzcGEZgB9W
FbvqTST2drjhJsMcl+TnSfj8dyL4WItmBzEtC1OPnHMFcXvJIhkR562JgfPp7qBe
H4NHM53TyHfzoz7VoWrX7Em9uKaB0LnseY9QSlax5i8PBrNxlQTMXHDVVjByiBSh
06aplNX5vsJujgyQJSHH2zimr1xW1hTKDUAOWMTZXfj2lowft37T+5jxhoaonB3r
fNTuUUb04EUYOrk9QGcN4sM2TKQaCrha4QPWb+tS1gmtL7i9y0V9+m7K40uB22yV
ecx9wtdPYeBSWqN44NHApqBoZKeKB2w7WH/vwVmL4lOQP4H/krz6QYNGPX534Cnn
UgwLOyYPnSfumv6p403d4kTZAj5Otatnlx7GgEJweogAGBELaaHRpLp9GeUz76q7
lgQsKiLKtX5UmP0RnPsJ
=s9UY
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Jan_2014_15_13_18_+1100_Yj_JnW5942nZCiuE--
