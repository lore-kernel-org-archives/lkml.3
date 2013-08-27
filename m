Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3H0Hen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:34:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab3H0Hek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:34:40 -0400
Date: Tue, 27 Aug 2013 17:34:26 +1000
From: NeilBrown <neilb@suse.de>
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, djbw@fb.com,
        tj@kernel.org
Subject: Re: [patch 0/3 v2] raid5: make stripe handling multi-threading
Message-ID: <20130827173426.027c40d6@notabene.brown>
In-Reply-To: <20130812021803.325887805@kernel.org>
References: <20130812021803.325887805@kernel.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wfPbY+Tc2G/457=HzZ2DTS4"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wfPbY+Tc2G/457=HzZ2DTS4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Aug 2013 10:18:03 +0800 Shaohua Li <shli@kernel.org> wrote:

> Neil,
>=20
> This is another attempt to make raid5 stripe handling multi-threading.
> Recent workqueue improvement for unbound workqueue looks very promising t=
o the
> raid5 usage. I had details in the first patch.
>=20
> The patches are against your tree with patch 'raid5: make release_stripe
> lockless' and 'raid5: fix stripe release order' but without 'raid5: create
> multiple threads to handle stripes'
>=20
> My test setup has 7 PCIe SSD, chunksize 8k, stripe_cache_size 2048. If en=
abling
> multi-threading, group_thread_cnt is set to 8.
>=20
> randwrite	throughput(ratio) unpatch/patch		requestsize(sectors) unpatch/p=
atch
> 4k		1/5.9					8/8
> 8k		1/5.5					16/13
> 16k		1/4.8					16/13
> 32k		1/4.6					18/14
> 64k		1/4.7					17/13
> 128k		1/4.2					23/16
> 256k		1/3.5					41/21
> 512k		1/3					75/28
> 1M		1/2.6					134/34
>=20
> For example, in 1M randwrite test, patched kernel is 2.6x faster, but ave=
rage
> request sending to each disk is drop to 34 sectors from 134 sectors long.
>=20
> Currently the biggest problem is request size is dropped, because there a=
re
> multiple threads dispatching requests. This indicates multi-threading mig=
ht not
> be proper for all setup, so I disable it by default in this version. But =
since
> throughput is largly improved, I thought this isn't a blocking issue. I'm=
 still
> working on improving this, maybe schedule stripes from one block plug as a
> whole.
>=20
> Thanks,
> Shaohua


Thanks.  I like this a lot more than the previous version.

It doesn't seem to apply exactly to my current 'for-next' - probably because
I have moved things around and have a different set of patches applied :-(
If you could rebase it on my current for-next I'll apply it and probably
submit for next merge window.
A couple of little changes I'd like made:

1/ alloc_thread_groups need to use GFP_NOIO, it least when called from
raid5_store_group_thread_cnt.  At this point in time IO to the RAID5 is
stalled so if the malloc needs to free memory it might wait for writeout to
the RAID5 and so deadlock.  GFP_NOIO prevents that.

2/ could we move the

+                       if (!cpu_online(cpu)) {
+                               cpu =3D cpumask_any(cpu_online_mask);
+                               sh->cpu =3D cpu;
+                       }

inside raid5_wakeup_stripe_thread() ?

It isn't a perfect fit, but I think it is a better place for it.
It could check list_empty(&sh->lru) and if it is empty, add to
the appropriate group->handle_list.

The code in do_release_stripe would become
                else {
                        clear_bit(STRIPE_DELAYED, &sh->state);
                        clear_bit(STRIPE_BIT_DELAY, &sh->state);
+                       if (conf->worker_cnt_per_group =3D=3D 0) {
+                               list_add_tail(&sh->lru, &conf->handle_list);
+                       } else {
+                               raid5_wakeup_stripe_thread(sh);
+                               return;
+                       }
                }
                md_wakeup_thread(conf->mddev->thread);

??

NeilBrown

--Sig_/wfPbY+Tc2G/457=HzZ2DTS4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhxWgjnsnt1WYoG5AQJrww//VFZ5GWMaJZ2Vkkj4YXzwb0bpvvK+1yRa
8MLvsEvp6VKkwst2Rs4JY1I2CWavnK9Qpo6m7ZtcQLBJV1RoJGUTE40EUJNRPqwW
Ogm2wTjmoxaQR29j8ksiR6jmtbYoI/tx8u9Iu8WYx2kCEBLzjwr5zo0qLvgY3eIb
sE+K0XjqYnD6u64IWL8MCpeyeyWw4VVUrLcMY/cOdRhR/kk5cIbVzXsJjH69ECn1
ag4os5M8OObJCri4oBS9VG8XDKTaLoVoWp1fRmgiFAKuVw1Q85psrJoZf4tVXEjK
D6ABYNJdgaIkvDbY23VdAc1gBjuU3R+6BxDRaZbk5oJjAVOCOAM6+G+PDgzU2dXq
jcxXNVpB3phuijIpqqj+lCvV+hf5Tp7+1+Nx/XuKIb1NYwaAK8OUCB/ZIzsJDK5Y
0TuSo9QT3/Pq8s81Ie/v/xAUGctUVteqcgZBB6WUG4TD+phIuPFfAZr159Zgjkpm
EcRtSRntzRIcilkLl2Z+bU5zdZGl6pRR5Jppq31T0Z2bHair8FJW+kFR8UkTQn0N
MNdfDZg8cNf7eFu0XCGwjFRBiPNQwKQkHBCzF7r0K1V5k8Z/2z+VSwlF+Kh8Xaao
INeGgiJ6/8YI85vi2PF8RX5f/Y+11Bmraeu/5K5+ayPVMtP+ym/SasiMJCaqMeS5
lBCRKCi50bg=
=4f1R
-----END PGP SIGNATURE-----

--Sig_/wfPbY+Tc2G/457=HzZ2DTS4--
