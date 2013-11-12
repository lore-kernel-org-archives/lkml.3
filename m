Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3KLA4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:56:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab3KLA4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:56:10 -0500
Date: Tue, 12 Nov 2013 11:55:56 +1100
From: NeilBrown <neilb@suse.de>
To: fengguang.wu@intel.com
Cc: Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [raid5] kernel BUG at drivers/md/raid5.c:701!
Message-ID: <20131112115556.6ee0e2e3@notabene.brown>
In-Reply-To: <20131111144757.GA20255@localhost>
References: <20131111144757.GA20255@localhost>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VF_udtmpmRClIxxFgl3mFJ8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VF_udtmpmRClIxxFgl3mFJ8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Nov 2013 22:47:57 +0800 fengguang.wu@intel.com wrote:

> 28cc2127527dcba2a0817afa8fd5a33c9e023090 is the first bad commit
> commit 28cc2127527dcba2a0817afa8fd5a33c9e023090
> Author: Shaohua Li <shli@kernel.org>
> Date:   Tue Sep 10 15:37:56 2013 +0800
>=20
>     raid5: relieve lock contention in get_active_stripe()
>    =20
>     get_active_stripe() is the last place we have lock contention. It has=
 two
>     paths. One is stripe isn't found and new stripe is allocated, the oth=
er is
>     stripe is found.
>    =20
>     The first path basically calls __find_stripe and init_stripe. It acce=
sses
>     conf->generation, conf->previous_raid_disks, conf->raid_disks,
>     conf->prev_chunk_sectors, conf->chunk_sectors, conf->max_degraded,
>     conf->prev_algo, conf->algorithm, the stripe_hashtbl and inactive_lis=
t. Except
>     stripe_hashtbl and inactive_list, other fields are changed very rarel=
y.
>    =20
>     With this patch, we split inactive_list and add new hash locks. Each =
free
>     stripe belongs to a specific inactive list. Which inactive list is de=
termined
>     by stripe's lock_hash. Note, even a stripe hasn't a sector assigned, =
it has a
>     lock_hash assigned. Stripe's inactive list is protected by a hash loc=
k, which
>     is determined by it's lock_hash too. The lock_hash is derivied from c=
urrent
>     stripe_hashtbl hash, which guarantees any stripe_hashtbl list will be=
 assigned
>     to a specific lock_hash, so we can use new hash lock to protect strip=
e_hashtbl
>     list too. The goal of the new hash locks introduced is we can only us=
e the new
>     locks in the first path of get_active_stripe(). Since we have several=
 hash
>     locks, lock contention is relieved significantly.
>    =20
>     The first path of get_active_stripe() accesses other fields, since th=
ey are
>     changed rarely, changing them now need take conf->device_lock and all=
 hash
>     locks. For a slow path, this isn't a problem.
>    =20
>     If we need lock device_lock and hash lock, we always lock hash lock f=
irst. The
>     tricky part is release_stripe and friends. We need take device_lock f=
irst.
>     Neil's suggestion is we put inactive stripes to a temporary list and =
readd it
>     to inactive_list after device_lock is released. In this way, we add s=
tripes to
>     temporary list with device_lock hold and remove stripes from the list=
 with hash
>     lock hold. So we don't allow concurrent access to the temporary list,=
 which
>     means we need allocate temporary list for all participants of release=
_stripe.
>    =20
>     One downside is free stripes are maintained in their inactive list, t=
hey can't
>     across between the lists. By default, we have total 256 stripes and 8=
 lists, so
>     each list will have 32 stripes. It's possible one list has free strip=
e but
>     other list hasn't. The chance should be rare because stripes allocati=
on are
>     even distributed. And we can always allocate more stripes for cache, =
several
>     mega bytes memory isn't a big deal.
>    =20
>     This completely removes the lock contention of the first path of
>     get_active_stripe(). It slows down the second code path a little bit =
though
>     because we now need takes two locks, but since the hash lock isn't co=
ntended,
>     the overhead should be quite small (several atomic instructions). The=
 second
>     path of get_active_stripe() (basically sequential write or big reques=
t size
>     randwrite) still has lock contentions.
>    =20
>     Signed-off-by: Shaohua Li <shli@fusionio.com>
>     Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> :040000 040000 84ab47136c389751c7c08ded47b1761b1bee7184 351047cfe3ac66013=
fc5c77f23d9bb04f869081d M	drivers
> bisect run success
>=20
> # bad: [86737931c2be292ec985df48f2e7fbafb4467f0e] Merge 'md/master' into =
devel-hourly-2013111107
> # good: [5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52] Linux 3.12
> git bisect start '86737931c2be292ec985df48f2e7fbafb4467f0e' '5e01dc7b26d9=
f24f39abace5da98ccbd6a5ceb52' '--'
> # good: [21136946c495b0e1e0f7e25a8de6f170efbdeadf] drm/vmwgfx: fix warnin=
g if config intel iommu is off.
> git bisect good 21136946c495b0e1e0f7e25a8de6f170efbdeadf
> # good: [ee360d688c8e37f81c92039f76bebaddbe36befe] Merge branch 'acpi-ass=
orted'
> git bisect good ee360d688c8e37f81c92039f76bebaddbe36befe
> # good: [cf0613d242805797f252535fcf7bb019512beb46] Merge branch 'gma500-n=
ext' of git://github.com/patjak/drm-gma500 into drm-next
> git bisect good cf0613d242805797f252535fcf7bb019512beb46
> # good: [feba070dbac6f7b477570e590a7dc960b7b0f784] Merge branch 'pm-sleep'
> git bisect good feba070dbac6f7b477570e590a7dc960b7b0f784
> # good: [6f092343855a71e03b8d209815d8c45bf3a27fcd] net: flow_dissector: f=
ail on evil iph->ihl
> git bisect good 6f092343855a71e03b8d209815d8c45bf3a27fcd
> # good: [7d963128c95a790b40ae5bac6af23646ceffcb54] Merge 'drm/drm-next' i=
nto devel-hourly-2013111107
> git bisect good 7d963128c95a790b40ae5bac6af23646ceffcb54
> # bad: [917bb50339fbbea9c5f47d257ea42f9652129c3f] raid1: Replace raise_ba=
rrier/lower_barrier with freeze_array/unfreeze_array when reconfiguring the=
 array.
> git bisect bad 917bb50339fbbea9c5f47d257ea42f9652129c3f
> # bad: [28cc2127527dcba2a0817afa8fd5a33c9e023090] raid5: relieve lock con=
tention in get_active_stripe()
> git bisect bad 28cc2127527dcba2a0817afa8fd5a33c9e023090
> # good: [09b06d70464536cb3cce7cf1c52f23a321604f62] md: fix calculation of=
 stacking limits on level change.
> git bisect good 09b06d70464536cb3cce7cf1c52f23a321604f62
> # good: [c0f773604d33616b07d61841463a056a780f5ae7] wait: add wait_event_c=
md()
> git bisect good c0f773604d33616b07d61841463a056a780f5ae7
> # first bad commit: [28cc2127527dcba2a0817afa8fd5a33c9e023090] raid5: rel=
ieve lock contention in get_active_stripe()
>=20

I think I've fixed this by merging in the follow.

Shaohua: could you please review and confirm if you  agree?

Thanks,
NeilBrown

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c37ffca1b13c..93090b2afab4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -697,6 +697,7 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
 				if (list_empty(&sh->lru) &&
+				    !test_bit(STRIPE_ON_RELEASE_LIST, &sh->state) &&
 				    !test_bit(STRIPE_EXPANDING, &sh->state))
 					BUG();
 				list_del_init(&sh->lru);

--Sig_/VF_udtmpmRClIxxFgl3mFJ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoF8nDnsnt1WYoG5AQLiOA//ekzMkOgmGfyA1K+tEIDLq6BtdNuNatfC
B3b7U8/OtLr+kB3ImCWuRueH2QcAHz9/4FjOUnm8H8cnJzw9CAY2acxzf2gMqwEM
32V6AlY+dsR+tVm7gxs6PHGj0gS/vE5VCWTqUY7smgc5iCohB+i5M87VlCqg5KoH
E7hbPXcUmG1oFuwM9ivfWnedtoxVS5dZrhMVWAXTXu8zqS35IKvjHlgpRWYIs8R3
3gwbU0Qsy5Sm87gzlKKUsfPul+iBDQ3brMZ9RpyD/SGTK8woxGr6pVJGMXJzEQ/+
D4vNlJsoRil/ZJP+x9YPM516OYX3o7z2IxscFmbEZOo3usDReB5bqc8hyKXcknxc
cYa7eJs0MovqGfxK07eURw18lC8PLrIHd1WvdnVV/N6961OhevYsz9c5m2Uo5rje
1qTyANPxz87tCW41cVlxWkph8NpNAwLpwXvva5i3cHxl5+3I7pqKtSmwEWOoJ34i
Z9Y9qWGkfMUscVSQ/QbuJnWWoMUNAh3VslFlCnbZiz9kZ+HXwp2EQkoL9o0+XKKb
g3Zpm+/n7xTBbOqh6oinTf1mK304haTandox8vmg6AmoI4iS+9WvpD1OTT21RTqU
76VcdjuAafJj8CaK8B2r4kuGh028o7iwmKzJEvTCU09zBsYmZ78TPRxJNZaMFLHn
/0cErOwz+Ys=
=IBPg
-----END PGP SIGNATURE-----

--Sig_/VF_udtmpmRClIxxFgl3mFJ8--
