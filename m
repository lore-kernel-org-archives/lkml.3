Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbaCRWYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 18:24:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbaCRWYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 18:24:38 -0400
Date: Wed, 19 Mar 2014 09:24:27 +1100
From: NeilBrown <neilb@suse.de>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>
Subject: Re: For review: open_by_name_at(2) man page
Message-ID: <20140319092427.0812263c@notabene.brown>
In-Reply-To: <53283DFB.6040105@gmail.com>
References: <53271B69.3000305@gmail.com>
	<20140318090007.3adee3d0@notabene.brown>
	<20140318094321.GA17024@infradead.org>
	<53283DFB.6040105@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/x+Yk=bx9SqqacHk=CKDVHiH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/x+Yk=bx9SqqacHk=CKDVHiH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Mar 2014 13:37:15 +0100 "Michael Kerrisk (man-pages)"
<mtk.manpages@gmail.com> wrote:

> On 03/18/2014 10:43 AM, Christoph Hellwig wrote:
> > On Tue, Mar 18, 2014 at 09:00:07AM +1100, NeilBrown wrote:
> >> ESTALE is also returned if the filesystem does not support file-handle=
 ->
> >> file mappings.
> >> On filesystems which don't provide export_operations (/sys /proc ubifs
> >> romfs cramfs nfs coda ... several others) name_to_handle_at will produ=
ce a
> >> generic handle using the 32 bit inode and 32 bit i_generation.
> >=20
> > Do we?  Seems like the code is erroring out early if there are no
> > export_ops?
>=20
> It appears to me that Neil's statement isn't correct, at least for /proc
> and /sys (see my other mail, to Neil). I'm unsure about whether it is true
> for some of those other FSes thought.


Indeed, I was wrong.

I was looking at

int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
			     int *max_len, struct inode *parent)
{
	const struct export_operations *nop =3D inode->i_sb->s_export_op;

	if (nop && nop->encode_fh)
		return nop->encode_fh(inode, fid->raw, max_len, parent);

	return export_encode_fh(inode, fid, max_len, parent);
}


which uses a default if there is no 'nop'.

However do_sys_name_to_handle() contains

	if (!path->dentry->d_sb->s_export_op ||
	    !path->dentry->d_sb->s_export_op->fh_to_dentry)
		return -EOPNOTSUPP;

long before export_encode_inode_fh() gets called.  So the default isn't use=
d.

I would have thought that exportfs_encode_inode_fh would never get called if
there were no s_export_op pointer - certainly name_to_handle_at and nfsd
would never call it in that case.
However it seems that

    This routine will be used to generate a file handle in fdinfo output for
    inotify subsystem, where if no s_export_op present the general
    export_encode_fh should be used.  Thus add a test if s_export_op present
    inside exportfs_encode_fh itself.

according to

commit ab49bdecc3ebb46ab661f5f05d5c5ea9606406c6
Author: Cyrill Gorcunov <gorcunov@openvz.org>
Date:   Mon Dec 17 16:05:06 2012 -0800


I guess that means that you can extract filehandles from /proc/self/fdinfo/=
$FD
when $FD is an inotify fd which is watching the particular file.....  I
wouldn't have expected that, but maybe it is a good idea.

So yes: if the filesystem doesn't support filehandles you get EOPNOTSUPP.
So if you get ESTALE from open_by_handle_at(), then it really is a stale
handle.  Sorry for the confusion.

NeilBrown

--Sig_/x+Yk=bx9SqqacHk=CKDVHiH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUyjHmznsnt1WYoG5AQLsqw/+MJfNBHPYvP1nneFQXXoYwI25LNdiA7yH
WBB+QJdRTNc/E/Ql6A0F132J3AF/QO0itZasLD37tXJcRI1C9Q5spf4ms9Zg/MtU
YF7Rt4IdaKDJLDUaJ0bBTGH3Nfnd2Tv2vphBOwz4Z1kYimj/4MnFFB6ljSMSWAdo
t3CNqMIV3CKC8agtOrq7YO6ZDqSWwklH7w7BTEvv1SKa1KQO8jw/4g6pJzBj2On7
5CezxvCCSTfJFiBz6r9sMPEYPkCgLy7eb8MM4xmKvX/DA0DMqUp1yJckYdZ5jCtT
LeZViGL2s2+LAZKDmzYXCRWko6RXiII7AvW6GNTdjmZsRV6KxmKnzvsRaE9ORn5O
6Sf3382wZWqPPWywftb7mok4d/P/WfgUjdwCDJvdPSHTRgrQClCz2jgtMTtzFL4B
81J/onpXBE5/QuMYAZgiVHPb7btDa6MBvOWHY7KnmmYwc4fOSlNQ1kumdKyTaO9O
FkjyhE5EN8dVirPCAOstm6FK/tGYDPRBDbuuzxMI8uuHAHttuIMRioWBc9Bt1q+m
43vwfXfahx0DJnqIshcO4JJIx024WHe17qvtKUhAr7LbVsTswh5nAaipLso41Ocm
ktMGUl6o24Hbaj2llKVsmGgfsyc6NcXZns1xd3Tw8ZSHzvx0/i4GoK+rNACLR/0P
bikrvYKu9jA=
=7IQb
-----END PGP SIGNATURE-----

--Sig_/x+Yk=bx9SqqacHk=CKDVHiH--
