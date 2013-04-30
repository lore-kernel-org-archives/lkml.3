Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab3D3FzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:55:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43626 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3D3FzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:55:05 -0400
Date: Tue, 30 Apr 2013 15:54:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20130430155452.f04d1ddf48f402ab50a7002d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__30_Apr_2013_15_54_52_+1000_2x3zIFRBt60HQIOr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Apr_2013_15_54_52_+1000_2x3zIFRBt60HQIOr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in ipc/util.c
between commit 823a5ed16606 ("ipc_schedule_free() can do vfree() now")
from the vfs tree and commit "ipc: make refcounter atomic" from the akpm
tree.

I fixed it up (I hope - see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc ipc/util.c
index 6515f95,5e60ebd..0000000
--- a/ipc/util.c
+++ b/ipc/util.c
@@@ -477,7 -478,8 +477,7 @@@ void ipc_free(void* ptr, int size
   */
  struct ipc_rcu_hdr
  {
- 	int refcount;
+ 	atomic_t refcount;
 -	int is_vmalloc;
  	void *data[0];
  };
 =20
@@@ -497,30 -516,48 +497,28 @@@ struct ipc_rcu_grac
   *	@size: size desired
   *
   *	Allocate memory for the rcu header structure +  the object.
-  *	Returns the pointer to the object.
-  *	NULL is returned if the allocation fails.=20
+  *	Returns the pointer to the object or NULL upon failure.
   */
- =20
- void* ipc_rcu_alloc(int size)
+ void *ipc_rcu_alloc(int size)
  {
 -	void* out;
 -
 -	/*
 -	 * We prepend the allocation with the rcu struct, and
 -	 * workqueue if necessary (for vmalloc).
 +	size_t len =3D size + HDRLEN;
 +	void *out;
 +	/*=20
 +	 * We prepend the allocation with the rcu struct
  	 */
 -	if (rcu_use_vmalloc(size)) {
 -		out =3D vmalloc(HDRLEN_VMALLOC + size);
 -		if (!out)
 -			goto done;
 -
 -		out +=3D HDRLEN_VMALLOC;
 -		container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc =3D 1;
 -	} else {
 -		out =3D kmalloc(HDRLEN_KMALLOC + size, GFP_KERNEL);
 -		if (!out)
 -			goto done;
 -
 -		out +=3D HDRLEN_KMALLOC;
 -		container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc =3D 0;
 +	out =3D (len > PAGE_SIZE) ? vmalloc(len) : kmalloc(len, GFP_KERNEL);
 +	if (out) {
 +		out +=3D HDRLEN;
- 		container_of(out, struct ipc_rcu_hdr, data)->refcount =3D 1;
++		atomic_set(&container_of(out, struct ipc_rcu_hdr, data)->refcount, 1);
  	}
  	return out;
  }
 =20
- void ipc_rcu_getref(void *ptr)
+ int ipc_rcu_getref(void *ptr)
  {
- 	container_of(ptr, struct ipc_rcu_hdr, data)->refcount++;
+ 	return atomic_inc_not_zero(&container_of(ptr, struct ipc_rcu_hdr, data)-=
>refcount);
  }
 =20
 -static void ipc_do_vfree(struct work_struct *work)
 -{
 -	vfree(container_of(work, struct ipc_rcu_sched, work));
 -}
 -
  /**
   * ipc_schedule_free - free ipc + rcu space
   * @head: RCU callback structure for queued work
@@@ -534,10 -580,10 +532,10 @@@ static void ipc_schedule_free(struct rc
 =20
  void ipc_rcu_putref(void *ptr)
  {
- 	if (--container_of(ptr, struct ipc_rcu_hdr, data)->refcount > 0)
+ 	if (!atomic_dec_and_test(&container_of(ptr, struct ipc_rcu_hdr, data)->r=
efcount))
  		return;
 =20
 -	if (container_of(ptr, struct ipc_rcu_hdr, data)->is_vmalloc) {
 +	if (is_vmalloc_addr(ptr)) {
  		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
  				ipc_schedule_free);
  	} else {

--Signature=_Tue__30_Apr_2013_15_54_52_+1000_2x3zIFRBt60HQIOr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRf1ysAAoJEECxmPOUX5FEc80P/2jlgMKZe2n4k6zn+yPauF55
t8jixi0mGSJmVZngs8iFwYh/edVCMPhVxuTrCCb5brqLHtKHnvrGJ63KwGjiAufa
LTRuiaGHPQlaomIGfdldllMsQEmSV2g6Jhu9ks37XLg3V5O2otLuwuy3TZy6Pp0Q
/ISgeDAktrIMbYJJGkSUPUr+lUf4X9lX2tywjfdlk3PbpAWxVpfwuLTqySPFjcWh
mWkV42Us86R9/fm5SkS0SSu48NoRYSemVXENbN1hBprpEG8BqWj/n3KhH2TbbrtU
Y6AuvXrJ4uylUk4cHsutMpl5MXuV83ifvRJz6dqyCCFVuEUUUpJ36vdg08zlwOkh
lP82WVh9jg9FjteuPnEAh2+mlNvS5FwDLPuxhZ6jqJEpfdv7uQigXzl7BTUPMpCU
WiCJkMd/Y4R3+BdsDS9h0OB215TapztZUYfMp8ZZdR9Wq8IrmAXMMe29LWFnnL8H
jVzJPkHVXx9vP+D7C9ncU+szoQ8aviApJyUUlemh644BeFbbPcM7IZmqzn9GKqy4
HKk+efTeMjyTpJFL61hEx+6CcUDaCCzzRM0UJPMxEUQQDq9Smr1BQVYtC4E9jH5J
QbwQjZH67C34+f553CZWE9KtSg7M/YVTLhC+0MXJub6HmNEymEJJa08b3hQYmsj9
UNetcDTll97ktrZpSbOR
=ovF/
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Apr_2013_15_54_52_+1000_2x3zIFRBt60HQIOr--
