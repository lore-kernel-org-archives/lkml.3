Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab3KFGUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 01:20:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54014 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3KFGUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 01:20:10 -0500
Date: Wed, 6 Nov 2013 17:19:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: linux-next: manual merge of the audit tree with Linus' tree
Message-Id: <20131106171950.9a0823c8207fc897d387d612@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Nov_2013_17_19_50_+1100_DXvQY8hZdSkneiPr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Nov_2013_17_19_50_+1100_DXvQY8hZdSkneiPr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the audit tree got a conflict in fs/exec.c
between commit(s) from Linus' tree and commit 9410d228a4cf ("audit: call
audit_bprm() only once to add AUDIT_EXECVE information") from the audit
tree.

I fixed it up (using the supplied resolution - thanks - see below) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/exec.c
index 8875dd10ae7a,c5c24f2fc44a..000000000000
--- a/fs/exec.c
+++ b/fs/exec.c
@@@ -1385,71 -1383,72 +1385,68 @@@ int search_binary_handler(struct linux_
  	if (retval)
  		return retval;
 =20
- 	retval =3D audit_bprm(bprm);
- 	if (retval)
- 		return retval;
-=20
 +	retval =3D -ENOENT;
 + retry:
 +	read_lock(&binfmt_lock);
 +	list_for_each_entry(fmt, &formats, lh) {
 +		if (!try_module_get(fmt->module))
 +			continue;
 +		read_unlock(&binfmt_lock);
 +		bprm->recursion_depth++;
 +		retval =3D fmt->load_binary(bprm);
 +		bprm->recursion_depth--;
 +		if (retval >=3D 0 || retval !=3D -ENOEXEC ||
 +		    bprm->mm =3D=3D NULL || bprm->file =3D=3D NULL) {
 +			put_binfmt(fmt);
 +			return retval;
 +		}
 +		read_lock(&binfmt_lock);
 +		put_binfmt(fmt);
 +	}
 +	read_unlock(&binfmt_lock);
 +
 +	if (need_retry && retval =3D=3D -ENOEXEC) {
 +		if (printable(bprm->buf[0]) && printable(bprm->buf[1]) &&
 +		    printable(bprm->buf[2]) && printable(bprm->buf[3]))
 +			return retval;
 +		if (request_module("binfmt-%04x", *(ushort *)(bprm->buf + 2)) < 0)
 +			return retval;
 +		need_retry =3D false;
 +		goto retry;
 +	}
 +
 +	return retval;
 +}
 +EXPORT_SYMBOL(search_binary_handler);
 +
 +static int exec_binprm(struct linux_binprm *bprm)
 +{
 +	pid_t old_pid, old_vpid;
 +	int ret;
 +
  	/* Need to fetch pid before load_binary changes it */
  	old_pid =3D current->pid;
  	rcu_read_lock();
  	old_vpid =3D task_pid_nr_ns(current, task_active_pid_ns(current->parent)=
);
  	rcu_read_unlock();
 =20
 -	retval =3D -ENOENT;
 -	for (try=3D0; try<2; try++) {
 -		read_lock(&binfmt_lock);
 -		list_for_each_entry(fmt, &formats, lh) {
 -			int (*fn)(struct linux_binprm *) =3D fmt->load_binary;
 -			if (!fn)
 -				continue;
 -			if (!try_module_get(fmt->module))
 -				continue;
 -			read_unlock(&binfmt_lock);
 -			bprm->recursion_depth =3D depth + 1;
 -			retval =3D fn(bprm);
 -			bprm->recursion_depth =3D depth;
 -			if (retval >=3D 0) {
 -				if (depth =3D=3D 0) {
 -					audit_bprm(bprm);
 -					trace_sched_process_exec(current, old_pid, bprm);
 -					ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 -				}
 -				put_binfmt(fmt);
 -				allow_write_access(bprm->file);
 -				if (bprm->file)
 -					fput(bprm->file);
 -				bprm->file =3D NULL;
 -				current->did_exec =3D 1;
 -				proc_exec_connector(current);
 -				return retval;
 -			}
 -			read_lock(&binfmt_lock);
 -			put_binfmt(fmt);
 -			if (retval !=3D -ENOEXEC || bprm->mm =3D=3D NULL)
 -				break;
 -			if (!bprm->file) {
 -				read_unlock(&binfmt_lock);
 -				return retval;
 -			}
 +	ret =3D search_binary_handler(bprm);
 +	if (ret >=3D 0) {
++		audit_bprm(bprm);
 +		trace_sched_process_exec(current, old_pid, bprm);
 +		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 +		current->did_exec =3D 1;
 +		proc_exec_connector(current);
 +
 +		if (bprm->file) {
 +			allow_write_access(bprm->file);
 +			fput(bprm->file);
 +			bprm->file =3D NULL; /* to catch use-after-free */
  		}
 -		read_unlock(&binfmt_lock);
 -#ifdef CONFIG_MODULES
 -		if (retval !=3D -ENOEXEC || bprm->mm =3D=3D NULL) {
 -			break;
 -		} else {
 -#define printable(c) (((c)=3D=3D'\t') || ((c)=3D=3D'\n') || (0x20<=3D(c) =
&& (c)<=3D0x7e))
 -			if (printable(bprm->buf[0]) &&
 -			    printable(bprm->buf[1]) &&
 -			    printable(bprm->buf[2]) &&
 -			    printable(bprm->buf[3]))
 -				break; /* -ENOEXEC */
 -			if (try)
 -				break; /* -ENOEXEC */
 -			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
 -		}
 -#else
 -		break;
 -#endif
  	}
 -	return retval;
 -}
 =20
 -EXPORT_SYMBOL(search_binary_handler);
 +	return ret;
 +}
 =20
  /*
   * sys_execve() executes a new program.

--Signature=_Wed__6_Nov_2013_17_19_50_+1100_DXvQY8hZdSkneiPr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSed+OAAoJEMDTa8Ir7ZwVH04P/2+Z3Xmjw12XH7+PoLA8HxgF
oly+4s9uqFsOJhl8CCLOKtxigq//o/MOD92uVfZXMNpnv9h2JoutNb3jsDGpxRWx
ZvnFlgH2yS7TxFH4vLWMU+FpVxNHjT36gxowgniaZWurwJD3wdMwPZJV3hdujxOX
Iy8hTR1HbsRw3GhZ5yr5oJbYS8mlSHEtnCiDH7b9ldS+H8P2ynkhimmO9SPmhdFX
PAUXS63DMgqzKldpWBNicPUTJ+5fAMpfKVOK2pjqolgheGRKJAu76l9Oq+cv7By2
96sfwTS6l58S5Qult1rG8+1doSo4YzqoUjwECgU5HlkqR2GwU7a96EMaWOHKwCvR
efX932mpGzhQ6gBoxkfmieQuFa+319xxhMKC6lwnrE2VycFsL75KU6fTiO335/5b
VThLA3fQoAWX25DkaT6J+830LDi3ZigMjey+uQdUZ1E3VcH5RN+xolvX+reUt++0
GLR1vqyHF3VbJN8SJmPtavdlm9WIgQvqTVmLR0QTUXtGkM7x2r4N/YeiMQPb5S4I
StlRw2Fnt9Qbl4jdczdihbOnRoiDDf77DZ3maIPeT9V3PyM8lFJMulieXQ7ApUkc
SWL9z+bixckmQk9HfgOu1dvcwILIB371J7fO71vdwD7Yy0LFEcd5OPwNOixtLUq9
zc0MtfxQyS4UdEeM6dRP
=9mYw
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Nov_2013_17_19_50_+1100_DXvQY8hZdSkneiPr--
