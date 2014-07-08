Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaGHMvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:51:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:54555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaGHMvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:51:00 -0400
Date: Tue, 8 Jul 2014 14:50:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: bsegall@google.com
Cc: Yuyang Du <yuyang.du@intel.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140708125050.GA2923@twins.programming.kicks-ass.net>
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
 <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
 <20140707104646.GK6758@twins.programming.kicks-ass.net>
 <xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 03:25:07PM -0700, bsegall@google.com wrote:
> >> +static inline void enqueue_entity_load_avg(struct sched_entity *se)
> >>  {
> >> +	struct sched_avg *sa =3D &se->avg;
> >> +	struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
> >> +	u64 now =3D cfs_rq_clock_task(cfs_rq);
> >> +	u32 old_load_avg =3D cfs_rq->avg.load_avg;
> >> +	int migrated =3D 0;
> >> =20
> >> +	if (entity_is_task(se)) {
> >> +		if (sa->last_update_time =3D=3D 0) {
> >> +			sa->last_update_time =3D now;
> >> +			migrated =3D 1;
> >>  		}
> >> +		else
> >> +			__update_load_avg(now, sa, se->on_rq * se->load.weight);
> >>  	}
> >> =20
> >> +	__update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
> >> =20
> >> +	if (migrated)
> >> +		cfs_rq->avg.load_avg +=3D sa->load_avg;
> >> =20
> >> +	synchronize_tg_load_avg(cfs_rq, old_load_avg);
> >>  }
> >
> > So here you add the task to the cfs_rq avg when its got migrate in,
> > however:
> >
> >> @@ -4552,17 +4326,9 @@ migrate_task_rq_fair(struct task_struct *p, int=
 next_cpu)
> >>  	struct sched_entity *se =3D &p->se;
> >>  	struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
> >> =20
> >> +	/* Update task on old CPU, then ready to go (entity must be off the =
queue) */
> >> +	__update_load_avg(cfs_rq_clock_task(cfs_rq), &se->avg, 0);
> >> +	se->avg.last_update_time =3D 0;
> >> =20
> >>  	/* We have migrated, no longer consider this task hot */
> >>  	se->exec_start =3D 0;
> >
> > there you don't remove it first..
>=20
> Yeah, the issue is that you can't remove it, because you don't hold the
> lock. Thus the whole runnable/blocked split iirc. Also the
> cfs_rq_clock_task read is incorrect for the same reason (and while
> rq_clock_task could certainly be fixed min_vruntime-style,
> cfs_rq_clock_task would be harder).
>=20
> The problem with just working around the clock issue somehow and then usi=
ng an
> atomic to do this subtraction is that you have no idea when the /cfs_rq/
> last updated - there's no guarantee it is up to date, and if it's not
> then the subtraction is wrong. You can't update it to make it up to date
> like the se->avg, becasue you don't hold any locks. You would need
> decay_counter stuff like the current code, and I'm not certain how well
> that would work out without the runnable/blocked split.

Right; so the current code jumps through a few nasty hoops because of
this. But I think the proposed code got this wrong (understandably).

But yes, we spend a lot of time and effort to remove the rq->lock from
the remote wakeup path, which makes all this very tedious indeed.

Like you said, we can indeed make the time thing work, but the remote
subtraction is going to be messy. Can't seem to come up with anything
sane there either.

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu+klAAoJEHZH4aRLwOS6s3MP/A18s2wpAWMDjW56tmhRJPds
oOjNfY7shECeEdPPeT4wvHGE65/wwK25HMfXm4iNu/QgGO0C/iiGaFQmad/bmNJg
HHHoqi04o+s2aKxxS+iYenyn/JoSStJU/Rv3rl2olJ0ksXZwqklNYRQ5FeuyX0G+
ZDJ5iJ6yOTUgsdp5YyozIzhI3DWrMyOHDLHU0b0qafcbG1Ll+J1o2nmU66si6jNg
LiuhFGdHuUf2gEt3IE0mKSSdgqKp2aREQBF22hRx+iHcmR6rdDNjUmHvehBX6kVk
ZmUJ4NzrERu6b9a3xx9hcnTp9k90i5AtuSb0QSbIu4pRTnyaxWl0durAUei2GqQV
pyvoNhUzJYbfmDZDcALtEDapRknjjDTuyJlVIUh9mhlD1G61Ale1/gv+JZWMRRok
+z/00J+u7kBgxIylGDdt5f/aoxslY6wosVqM9wjiOf8pd2a9FIU8nXo7ssEYBI/A
Zku3gsXfgwdZrIjSIazj2JJ/xY4fQVRxcdyuJ3Qh1tYINcRgaXTkgINrecRLzcPf
p/3jm8AGvevJa3gAzk+ctT52tpnWziNWkSBUxCFGD5MzgfjTdYDMeliaXHao8FSU
0P8JhKz/hP1uOLaLwpznT+TgY9EzFroTOe+bWsaeYFru7nBGCfThdt0XW9RQgoH+
VehsoXWI2KQ3fukYGA8J
=LVhv
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
