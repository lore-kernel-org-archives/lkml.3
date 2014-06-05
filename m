Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaFEOL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:11:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaFEOL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:11:57 -0400
Date: Thu, 5 Jun 2014 16:11:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug
 workaround
Message-ID: <20140605141150.GL6758@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-6-git-send-email-eranian@google.com>
 <20140605134841.GL3213@twins.programming.kicks-ass.net>
 <CAHzUATjSd0Cio25RvwNaph0vFZYQB-pKBt=xz7C=_MhZvpFXxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CqfQkoYPE/jGoa5Q"
Content-Disposition: inline
In-Reply-To: <CAHzUATjSd0Cio25RvwNaph0vFZYQB-pKBt=xz7C=_MhZvpFXxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CqfQkoYPE/jGoa5Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 05:01:25PM +0300, Maria Dimakopoulou wrote:
> On Thu, Jun 5, 2014 at 4:48 PM, Peter Zijlstra <peterz@infradead.org> wro=
te:
> > On Wed, Jun 04, 2014 at 11:34:14PM +0200, Stephane Eranian wrote:
> >
> >> +static struct event_constraint *
> >> +intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_ev=
ent *event,
> >> +                        struct event_constraint *c)
> >> +{
> >
> >> +     if (!(c->flags & PERF_X86_EVENT_DYNAMIC)) {
> >> +
> >> +             /*
> >> +              * in case we fail, we assume no counter
> >> +              * is supported to be on the safe side
> >> +              */
> >> +             cx =3D kmalloc(sizeof(*cx), GFP_KERNEL);
> >> +             if (!cx)
> >> +                     return &emptyconstraint;
> >> +
> >
> > Ok, so forgive me if I'm wrong, but the way we get here is through:
> >
> > x86_schedule_event()
> >   ->start_scheduling()
> >     spin_lock()
> >   ->get_event_constraints()
> >     intel_get_excl_constraints()
> >       kmalloc(.gfp=3DGFP_KERNEL)
> >
> > How can that ever work?

> Are you saying it is illegal to call kmalloc() from
> this context?

Nobody will come and arrest you for it, so no. Broken though. GFP_KERNEL
will attempt to sleep to wait for reclaim, and you're holding a
spinlock.

> kmalloc is needed because we need to allocate
> a new constraint struct since the static constraint
> cannot be modified.
>=20
> Worst case we can statically allocate a second
> constraint struct in the event struct.

Nah, since you will need at most one constraint per counter, you could
preallocate num_counter constraints for each cpu.

--CqfQkoYPE/jGoa5Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkHqmAAoJEHZH4aRLwOS6zz4P/16sDR68V4uCS50dI+WXm++T
gyifkPUGrV7cEn+TtTwAEvTS2wgGmitk2FwMzRNUm57airbzqViASmbcKeC+TqKA
hjkcUgYoITfOvziBXXlEpmMR9ww03FbI3LoDqL+VuTncW2JbNrcwg7QusZqLCsoi
cUXV1OMnmy0rwk7oV8KYwZKlmfsJo86jrBmViA1KOqwlTAV1/jqxbV3reprbzXMe
sn6X1Zu4EERLfnD8OL16Frt+P/NXpW2pbf79li/EDYcgG24nYTf9X9FDtw0KXG4c
LvoGnAvRPE7ZefYxTzqD9xa6vO5zdqiBaTMst6v9342x3FxxC2EyRlOV96/GnF9W
wdw7FncnTjPEmRRaqhyPplA2SY8ArwxHZ3OkQFf9BYSjwSCTYjScomsO51JnFO1J
Pp17Kjfk0oRu4fln21uGvxCZaWxPtoEbY4RlPWMzm4ag+Ov+VYu8mY3MIuJOQnIu
BgltaxYkTd1Eht20/T0TCU9L0oZgRfTguHDsc0ZCpNxTbq7WKVOfxQpkUxpMF1G2
uGVLoIRsUwwKodXIOWk8+j2Q0bQT85jK8Qbe+WE3h4qNiuuZ11t/JzmcGibvb7GV
KTqhvfOF6wEX6yb0tDWBNuyiUpiIXCrRsvIDjKoVM/Le0guPk2GD9+e0zkspc5sz
URmVSw8nHFWGv4EPyOeU
=JlS8
-----END PGP SIGNATURE-----

--CqfQkoYPE/jGoa5Q--
