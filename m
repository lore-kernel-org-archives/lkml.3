Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab3IIFiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:38:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60386 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3IIFit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:38:49 -0400
Date: Mon, 9 Sep 2013 15:38:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <dchinner@redhat.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130909153840.1783766acc78ea419e68b071@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Sep_2013_15_38_40_+1000_ZHGpZ1T5KunzfwYt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Sep_2013_15_38_40_+1000_ZHGpZ1T5KunzfwYt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/dcache.c
between commit db14fc3abcd5 ("vfs: add d_walk()") from Linus' tree and
commit "dcache: convert to use new lru list infrastructure" from the akpm
tree.

I fixed it up (hopefully - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/dcache.c
index fc05994,e4df9de..0000000
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@@ -1313,46 -1197,94 +1297,47 @@@ out
   * drop the lock and return early due to latency
   * constraints.
   */
 -static int select_parent(struct dentry *parent, struct list_head *dispose)
 -{
 -	struct dentry *this_parent;
 -	struct list_head *next;
 -	unsigned seq;
 -	int found =3D 0;
 -	int locked =3D 0;
 =20
 -	seq =3D read_seqbegin(&rename_lock);
 -again:
 -	this_parent =3D parent;
 -	spin_lock(&this_parent->d_lock);
 -repeat:
 -	next =3D this_parent->d_subdirs.next;
 -resume:
 -	while (next !=3D &this_parent->d_subdirs) {
 -		struct list_head *tmp =3D next;
 -		struct dentry *dentry =3D list_entry(tmp, struct dentry, d_u.d_child);
 -		next =3D tmp->next;
 -
 -		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 +struct select_data {
 +	struct dentry *start;
 +	struct list_head dispose;
 +	int found;
 +};
 =20
 -		/*
 -		 * move only zero ref count dentries to the dispose list.
 -		 *
 -		 * Those which are presently on the shrink list, being processed
 -		 * by shrink_dentry_list(), shouldn't be moved.  Otherwise the
 -		 * loop in shrink_dcache_parent() might not make any progress
 -		 * and loop forever.
 -		 */
 -		if (dentry->d_lockref.count) {
 -			dentry_lru_del(dentry);
 -		} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
 -			dentry_lru_del(dentry);
 -			list_add_tail(&dentry->d_lru, dispose);
 -			dentry->d_flags |=3D DCACHE_SHRINK_LIST;
 -			found++;
 -		}
 -		/*
 -		 * We can return to the caller if we have found some (this
 -		 * ensures forward progress). We'll be coming back to find
 -		 * the rest.
 -		 */
 -		if (found && need_resched()) {
 -			spin_unlock(&dentry->d_lock);
 -			goto out;
 -		}
 +static enum d_walk_ret select_collect(void *_data, struct dentry *dentry)
 +{
 +	struct select_data *data =3D _data;
 +	enum d_walk_ret ret =3D D_WALK_CONTINUE;
 =20
 -		/*
 -		 * Descend a level if the d_subdirs list is non-empty.
 -		 */
 -		if (!list_empty(&dentry->d_subdirs)) {
 -			spin_unlock(&this_parent->d_lock);
 -			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
 -			this_parent =3D dentry;
 -			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
 -			goto repeat;
 -		}
 +	if (data->start =3D=3D dentry)
 +		goto out;
 =20
 -		spin_unlock(&dentry->d_lock);
 -	}
  	/*
 -	 * All done at this level ... ascend and resume the search.
 +	 * move only zero ref count dentries to the dispose list.
 +	 *
 +	 * Those which are presently on the shrink list, being processed
 +	 * by shrink_dentry_list(), shouldn't be moved.  Otherwise the
 +	 * loop in shrink_dcache_parent() might not make any progress
 +	 * and loop forever.
  	 */
 -	if (this_parent !=3D parent) {
 -		struct dentry *child =3D this_parent;
 -		this_parent =3D try_to_ascend(this_parent, locked, seq);
 -		if (!this_parent)
 -			goto rename_retry;
 -		next =3D child->d_u.d_child.next;
 -		goto resume;
 +	if (dentry->d_lockref.count) {
 +		dentry_lru_del(dentry);
 +	} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
- 		dentry_lru_move_list(dentry, &data->dispose);
++		dentry_lru_del(dentry);
++		list_add_tail(&dentry->d_lru, &data->dispose);
 +		dentry->d_flags |=3D DCACHE_SHRINK_LIST;
 +		data->found++;
 +		ret =3D D_WALK_NORETRY;
  	}
 +	/*
 +	 * We can return to the caller if we have found some (this
 +	 * ensures forward progress). We'll be coming back to find
 +	 * the rest.
 +	 */
 +	if (data->found && need_resched())
 +		ret =3D D_WALK_QUIT;
  out:
 -	spin_unlock(&this_parent->d_lock);
 -	if (!locked && read_seqretry(&rename_lock, seq))
 -		goto rename_retry;
 -	if (locked)
 -		write_sequnlock(&rename_lock);
 -	return found;
 -
 -rename_retry:
 -	if (found)
 -		return found;
 -	if (locked)
 -		goto again;
 -	locked =3D 1;
 -	write_seqlock(&rename_lock);
 -	goto again;
 +	return ret;
  }
 =20
  /**

--Signature=_Mon__9_Sep_2013_15_38_40_+1000_ZHGpZ1T5KunzfwYt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLV7lAAoJEECxmPOUX5FE+s4P/080WAY/64Q6SR2i2xuyh4J9
/WzDBkAh1YdvHrATHXFa9QJmzV6fAIdh8jc9PUcIF5I1eL+FJ5hV0HIK3/E9Bafm
qevzC51G2ggiUz0l8//B06L6HGoF+SPs20cF5BhMuPFqPeuvbNgWKgW71iyPiGTq
POo/6B7uuwcjmB3wd8QuiJxg+Gi33HtZ0cvY29oZdoXXuF38DxHSpIhXYWPjoPuT
yDOzYN7aHPg05w4EUaopHLir3Z2M02MJHQV60d0DyLSvZIFqzN8AjsRuI3vXnwZJ
hWgd6nwBWNjFS58bDJ7FDCL+YXcX4sMnKJreXb+KlF/G7bW9lYZXFjkm2DeiUQqt
ViBdGzLDVWk1SjHWBqX1HQI4RfDag3H5BQRXyGsAajh2YubL8JjZIk/yNNalzWWy
OnYKuv6wPl8ufRcgi4qToxafwe683MXVJMNgKAcWFXfxhuik0mdxuW/ylCJQE3I9
1p6Y3ykSfSDE5CShrBUZdTdpv1bPVQq9l7vPkBSkmab1KixQrZh0ihz6armzIJ8O
X2lkOLpL8n1Sjbz1Ge/1V/5AbGgKZaleWxXy8Jo8SxxTT+GcrUghddHFqQ3fsfT2
6TAcv1AvODt3t1wRpmlUwWJaMBpAoYC2rG6uDs5OE8/JWBEiqTk3k2zjes3HmsfS
WNkOmJJjnnX+s8XYWynh
=Pa+p
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Sep_2013_15_38_40_+1000_ZHGpZ1T5KunzfwYt--
