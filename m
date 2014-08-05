Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaHEVos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:44:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbaHEVor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:44:47 -0400
Date: Wed, 6 Aug 2014 07:44:30 +1000
From: NeilBrown <neilb@suse.de>
To: Steven Noonan <steven@uplinklabs.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] lockref: make lockref count signed
Message-ID: <20140806074430.102121ae@notabene.brown>
In-Reply-To: <1407268348-25949-1-git-send-email-steven@uplinklabs.net>
References: <1407268348-25949-1-git-send-email-steven@uplinklabs.net>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/u0tqbBYTmu+.t7Tcm8UraAl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/u0tqbBYTmu+.t7Tcm8UraAl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  5 Aug 2014 12:52:27 -0700 Steven Noonan <steven@uplinklabs.net>
wrote:

> There are numerous places where this is casted to a signed value anyway, =
for
> comparisons checking that the value hasn't been set to the 'dead' value of
> -128. This change turns the count value into a signed integer, which is h=
ow
> it's already being treated anyway. This reduces the chance for developer =
errors
> when making those comparisons.
>=20
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>

Thanks!  But you missed one "(int)" removal :-)

fs/autofs4/root.c:              if ((int) d_count(active) <=3D 0)

NeilBrown

> ---
>  fs/dcache.c             | 6 +++---
>  include/linux/lockref.h | 2 +-
>  lib/lockref.c           | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 06f6585..f7a592e 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -479,7 +479,7 @@ static void __dentry_kill(struct dentry *dentry)
>  	 * dentry_iput drops the locks, at which point nobody (except
>  	 * transient RCU lookups) can reach this dentry.
>  	 */
> -	BUG_ON((int)dentry->d_lockref.count > 0);
> +	BUG_ON(dentry->d_lockref.count > 0);
>  	this_cpu_dec(nr_dentry);
>  	if (dentry->d_op && dentry->d_op->d_release)
>  		dentry->d_op->d_release(dentry);
> @@ -532,7 +532,7 @@ static inline struct dentry *lock_parent(struct dentr=
y *dentry)
>  	struct dentry *parent =3D dentry->d_parent;
>  	if (IS_ROOT(dentry))
>  		return NULL;
> -	if (unlikely((int)dentry->d_lockref.count < 0))
> +	if (unlikely(dentry->d_lockref.count < 0))
>  		return NULL;
>  	if (likely(spin_trylock(&parent->d_lock)))
>  		return parent;
> @@ -848,7 +848,7 @@ static void shrink_dentry_list(struct list_head *list)
>  		 * We found an inuse dentry which was not removed from
>  		 * the LRU because of laziness during lookup. Do not free it.
>  		 */
> -		if ((int)dentry->d_lockref.count > 0) {
> +		if (dentry->d_lockref.count > 0) {
>  			spin_unlock(&dentry->d_lock);
>  			if (parent)
>  				spin_unlock(&parent->d_lock);
> diff --git a/include/linux/lockref.h b/include/linux/lockref.h
> index 4bfde0e..8558ff1 100644
> --- a/include/linux/lockref.h
> +++ b/include/linux/lockref.h
> @@ -28,7 +28,7 @@ struct lockref {
>  #endif
>  		struct {
>  			spinlock_t lock;
> -			unsigned int count;
> +			int count;
>  		};
>  	};
>  };
> diff --git a/lib/lockref.c b/lib/lockref.c
> index d2233de..e4c4255 100644
> --- a/lib/lockref.c
> +++ b/lib/lockref.c
> @@ -158,7 +158,7 @@ int lockref_get_not_dead(struct lockref *lockref)
> =20
>  	CMPXCHG_LOOP(
>  		new.count++;
> -		if ((int)old.count < 0)
> +		if (old.count < 0)
>  			return 0;
>  	,
>  		return 1;
> @@ -166,7 +166,7 @@ int lockref_get_not_dead(struct lockref *lockref)
> =20
>  	spin_lock(&lockref->lock);
>  	retval =3D 0;
> -	if ((int) lockref->count >=3D 0) {
> +	if (lockref->count >=3D 0) {
>  		lockref->count++;
>  		retval =3D 1;
>  	}


--Sig_/u0tqbBYTmu+.t7Tcm8UraAl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+FQPjnsnt1WYoG5AQJPxA/9G27H9DcFjstYNoUBDWA5Oa/3yQjMsX83
PT3IE1W/RnX6ko2h02mf3pLBdqhjJiVbQTxsbokYHO1GQueqDP87vDlqb4puURFi
jLh1r5VpBRpqiEmNA59CVP67mlbxthDeCCxocMB7qrWktNs9sMQj+gZipVi2sc+E
gDZjP9cFs62C9nVT6J0P+oJj1mhWCROQe0OKLIhZaExMwukRTFd9E+p26kEk8Evk
wh5tGYg2AxwvKLsvYZ8+mWtiCvAOCHLExvY29ebys0iNKWR/2cQE0iKEfJ7SSZgd
ifjPgy/n+8CfPASe2ckO9XsI5O1bgYh9y4NNVOyaIMs34fVlUpf3y3azOVGTxYV1
SOTB7x2ci7Y8ERyqsz2lnceucub4QVnszc5mhSQSSiuZ+0DqQlHkM30QqdQElhGa
ZwtYQoOBnNHSzZs2XenEi/ZxW1+38RokmG9xawIcum1sV13PN2fYlziLpOtA5+eb
RZv4a5QheVHaBVE3vHGn8RaK/N3OEsZca2lLkUh9gFxF2xLDpDxwIqbRzJvUTSF5
44eD08YCS1gdQovZhHWfU/HLa4PQMtGPUawsIhH9OpLyKvr9aYghFv+d5bAS5Hrx
88dKBx2W94YDgihjW9v34SNYjg5zcvsW/rSeFRmEfGbq8UNcOfQzsgsJXMVjzkaM
fevB3uZ1UeY=
=W+22
-----END PGP SIGNATURE-----

--Sig_/u0tqbBYTmu+.t7Tcm8UraAl--
