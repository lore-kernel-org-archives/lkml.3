Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaE0MtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:49:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaE0MtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:49:11 -0400
Date: Tue, 27 May 2014 14:48:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 02/11] sched: remove a wake_affine condition
Message-ID: <20140527124848.GQ30445@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-3-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HGQiUpf3h2mG3oks"
Content-Disposition: inline
In-Reply-To: <1400860385-14555-3-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HGQiUpf3h2mG3oks
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 05:52:56PM +0200, Vincent Guittot wrote:
> I have tried to understand the meaning of the condition :
>  (this_load <=3D load &&
>   this_load + target_load(prev_cpu, idx) <=3D tl_per_task)
> but i failed to find a use case that can take advantage of it and i haven=
't
> found description of it in the previous commits' log.

commit 2dd73a4f09beacadde827a032cf15fd8b1fa3d48

    int try_to_wake_up():
   =20
    in this function the value SCHED_LOAD_BALANCE is used to represent the =
load
    contribution of a single task in various calculations in the code that
    decides which CPU to put the waking task on.  While this would be a val=
id
    on a system where the nice values for the runnable tasks were distribut=
ed
    evenly around zero it will lead to anomalous load balancing if the
    distribution is skewed in either direction.  To overcome this problem
    SCHED_LOAD_SCALE has been replaced by the load_weight for the relevant =
task
    or by the average load_weight per task for the queue in question (as
    appropriate).

                        if ((tl <=3D load &&
-                               tl + target_load(cpu, idx) <=3D SCHED_LOAD_=
SCALE) ||
-                               100*(tl + SCHED_LOAD_SCALE) <=3D imbalance*=
load) {
+                               tl + target_load(cpu, idx) <=3D tl_per_task=
) ||
+                               100*(tl + p->load_weight) <=3D imbalance*lo=
ad) {


commit a3f21bce1fefdf92a4d1705e888d390b10f3ac6f


+                       if ((tl <=3D load &&
+                               tl + target_load(cpu, idx) <=3D SCHED_LOAD_=
SCALE) ||
+                               100*(tl + SCHED_LOAD_SCALE) <=3D imbalance*=
load) {


So back when the code got introduced, it read:

	target_load(prev_cpu, idx) - sync*SCHED_LOAD_SCALE < source_load(this_cpu,=
 idx) &&
	target_load(prev_cpu, idx) - sync*SCHED_LOAD_SCALE + target_load(this_cpu,=
 idx) < SCHED_LOAD_SCALE

So while the first line makes some sense, the second line is still
somewhat challenging.

I read the second line something like: if there's less than one full
task running on the combined cpus.

Now for idx=3D=3D0 this is hard, because even when sync=3D1 you can only ma=
ke
it true if both cpus are completely idle, in which case you really want
to move to the waking cpu I suppose.

One task running will have it =3D=3D SCHED_LOAD_SCALE.

But for idx>0 this can trigger in all kinds of situations of light load.

--HGQiUpf3h2mG3oks
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThImwAAoJEHZH4aRLwOS6Rl8P/2arnQH4gmeXUxYDAFio5+B7
nIjuCs/lJyeKDC/B+ER7TVkisKbB+R+QUqf4mvtfzaxjm/WnGGxh8tLmJw8oNKrw
JuKiynht/2e0kw7fpyLVKmmSHIv1UMoV9uTxHaES9S2rqdSo7clcL32cjtDI8U+A
r84B+BSxLHqscx0xm3xpYa5sXn8v4YKMNRiZSA/N6aB5PfQtf7youQJD/FrXxY1J
miso9PN3stwREyhZewjNImlna2aHK8WcxRezdHJOhAuMZMuPosqp2GVH/FN61zDA
UTjjTj7Vn0BGE1N15Hs6uyIJe2DDnvWL7c6shDvH6A+l3sHF5Hgob/dPpeECes7M
xU5IuzDZqvCcsg42EIh0PfXMVpMVpIKNoQn/KUxhkMauEqDPVEHOP3bdeQXIhVXY
bBCXL+xmA4pI8yPFj+CbhqssgzXfHzeVISWJ7vRg+S8Cdeu60EbUgWAWg36DQHCQ
ZOXZvFsjQ55i9YYYW5ebF5Y/zThrj5Y9AeUkTBIU+GrnGXXlwMpctx2WqUGz09+5
uQO5DPnpshDZECyolnuj4rTRf/vtHEPdYZo7+SlW1XNfRBB4bib+XY23U5v08Nd1
adqztqpdQ5BcGtVCm5L0LtdmYa3KIFqcFo0fOp6E5dLpbWI+KhG4w2jAUtxbEGVV
hYhfdd+x8oI1d/70IOLn
=RuYG
-----END PGP SIGNATURE-----

--HGQiUpf3h2mG3oks--
