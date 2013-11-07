Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab3KGFDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:03:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab3KGFDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:03:48 -0500
Date: Thu, 7 Nov 2013 13:38:38 +1100
From: NeilBrown <neilb@suse.de>
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "shli@kernel.org" <shli@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] raid0: Set discard_granularity to correct value after
 reshape.
Message-ID: <20131107133838.742d83b1@notabene.brown>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F01783D0B@IRSMSX105.ger.corp.intel.com>
References: <20131030122022.20862.97997.stgit@gklab-154-222.igk.intel.com>
	<20131031111612.2735d0c1@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F01783D0B@IRSMSX105.ger.corp.intel.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rKqHyDjE6jlNFe_j18iH3ZL"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rKqHyDjE6jlNFe_j18iH3ZL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Nov 2013 14:25:19 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> On Thursday, October 31, 2013 1:16 AM NeilBrown <neilb@suse.de> wrote:
> > On Wed, 30 Oct 2013 13:20:22 +0100 Pawel Baldysiak
> > <pawel.baldysiak@intel.com> wrote:
> >=20
> > > In case of reshape of raid0 through raid4 a value of
> > > discard_granularity will be set to stripe size. MD driver should
> > > re-set this value to correct one when migration will be finished.
> > > Otherwise array will be left with wrong value and discard operations =
will not
> > work properly.
> > >
> > > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > > Cc: Shaohua Li <shli@kernel.org>
> > > ---
> > >  drivers/md/raid0.c |    2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c index
> > > c4d420b..807ca3a 100644
> > > --- a/drivers/md/raid0.c
> > > +++ b/drivers/md/raid0.c
> > > @@ -266,6 +266,8 @@ static int create_strip_zones(struct mddev *mddev,
> > struct r0conf **private_conf)
> > >  	}
> > >  	mddev->queue->backing_dev_info.congested_fn =3D raid0_congested;
> > >  	mddev->queue->backing_dev_info.congested_data =3D mddev;
> > > +	mddev->queue->limits.discard_granularity =3D
> > > +			queue_logical_block_size(mddev->queue);
> > >
> > >  	/*
> > >  	 * now since we have the hard sector sizes, we can make sure
> >=20
> > Thanks, but this doesn't seem like the right sort of fix.  It is to spe=
cific to the
> > symptom rather than trying to address the underlying problem.
> >=20
> > Maybe something like this?  Can you review and test?
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> > diff --git a/drivers/md/md.c b/drivers/md/md.c index
> > 628cd529343f..740b6340f980 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -3620,6 +3620,7 @@ level_store(struct mddev *mddev, const char
> > *buf, size_t len)
> >  		mddev->in_sync =3D 1;
> >  		del_timer_sync(&mddev->safemode_timer);
> >  	}
> > +	blk_set_stacking_limit(&mddev->queue->limits);
> >  	pers->run(mddev);
> >  	set_bit(MD_CHANGE_DEVS, &mddev->flags);
> >  	mddev_resume(mddev);
> Hi Neil,
> I have tested Yours patch, and everything works well.
> TRIM operation are made correctly.
> Could You apply it to upstream?=20
>=20
> BTW. Correct name of this function is blk_set_stacking_limits();
>=20
> Thanks,
> Pawe=C5=82 Baldysiak

Thanks for testing.  I've queue the following up for submission soonish.

NeilBrown

=46rom 3d2b31bb23ccb8170fafdf358098bb3cb0836080 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 7 Nov 2013 13:36:36 +1100
Subject: [PATCH] md: fix calculation of stacking limits on level change.

The various ->run routines of md personalities assume that the 'queue'
has been initialised by the blk_set_stacking_limits() call in
md_alloc().

However when the level is changed (by level_store()) the ->run routine
for the new level is called for an array which has already had the
stacking limits modified.  This can result in incorrect final
settings.

So call blk_set_stacking_limits() before ->run in level_store().

A specific consequence of this bug is that it causes
discard_granularity to be set incorrectly when reshaping a RAID4 to a
RAID0.

This is suitable for any -stable kernel since 3.3 in which
blk_set_stacking_limits() was introduced.

Cc: stable@vger.kernel.org (3.3+)
Reported-by: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 628cd529343f..b3a75afee560 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3620,6 +3620,7 @@ level_store(struct mddev *mddev, const char *buf, siz=
e_t len)
 		mddev->in_sync =3D 1;
 		del_timer_sync(&mddev->safemode_timer);
 	}
+	blk_set_stacking_limits(&mddev->queue->limits);
 	pers->run(mddev);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	mddev_resume(mddev);

--Sig_/rKqHyDjE6jlNFe_j18iH3ZL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnr9Ljnsnt1WYoG5AQLIyg//QRKMfZOJ6b25ayXzh7+hn9oHl6YLf0xI
O23WZs6JsMQ7fHUYzHQUCCc6m9X+DUZdYqlhZVRXYesiRaPYtppezvS6WXuzH1/O
IDxfhcNjox7UwvS62RnWuTNIZEi1TWk+yHrRyDylsrlwbnhM7wBhlCJo8vWR/fB5
7pn1sbV803wsEO5KFPl7FXqp38ScaPnMDaSBwOWGkoQBFO27+6yPG5Qte+rPRI23
Pl03pGGiZPVp4AvWCAXMloVNgBCT0V8mo7GyiVZN++S5rQTDuub6ONUh0/4ThwJ1
LPngSBVSMrolXqo5nsfun+VXJTBv3Eel5BnkWGlcmFf0j9FXjtsncXcDjv+Q7Tw/
38Mw4cONDd81TYS7KjDfsdu0YKuNnaNDJIO2J1tjziXx8q/h8j3JMoq4yaTDkQes
fF3v4A8YvKeDFzIiCAwma6p8cfUF8j3y+GAKrlWLwbB6clSKtnrIaNz13Tdnb6W+
H2MMn29P3KKGZNx2umwow/a43lERY1wVeR3PbglGJ7/zJdlU0wDgLw5chIY8ZkRf
iFS426Svceg6lA/2xtWBdW23Kis99xCibCQaZ6PpgIW0aUuHhL8qO+RS3FbkSOxN
2GGpSOjnaAXRAKqt/Z6xVU+oQO3qz5oMSrJZZQbiJiXLktHN84LdmSQfjmeKaZOv
f+jfbOEDkvU=
=4TFx
-----END PGP SIGNATURE-----

--Sig_/rKqHyDjE6jlNFe_j18iH3ZL--
