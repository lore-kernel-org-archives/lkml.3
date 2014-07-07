Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaGGLCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:02:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbaGGLCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:02:05 -0400
Date: Mon, 7 Jul 2014 21:01:57 +1000
From: NeilBrown <neilb@suse.de>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: linux-man@vger.kernel.org,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        lkml <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [patch[ epoll_ctl.2, epoll.7: document EPOLLWAKEUP
Message-ID: <20140707210157.1aa38ed0@notabene.brown>
In-Reply-To: <53BA4244.30502@gmail.com>
References: <20140706190351.423e9a93@notabene.brown>
	<53BA4244.30502@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ryAieyiS4Xod5WCxzxhl62b"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ryAieyiS4Xod5WCxzxhl62b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


(adding lkml and linux-pm and I probably should have done from the start).

On Mon, 07 Jul 2014 08:46:28 +0200 "Michael Kerrisk (man-pages)"
<mtk.manpages@gmail.com> wrote:

> Hi Neil,
>=20
> On 07/06/2014 11:03 AM, NeilBrown wrote:
> >=20
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > --
> >=20
> > I noticed that this was missing so had a go at writing something.
>=20
> Thanks. I applied this, and also added the additional piece shown=20
> at the end of this mail.
>=20
> > Is there / Should there be a section 7 man page describing suspend and
> > autosuspend and wakelocks etc??
>=20
> Sounds like it might be useful, but I don't know for sure. On the=20
> assumption that it might be possible to convince you to write one,
> could you briefly list what you think should be covered in the page?

I was particularly thinking of "/sys/power/autosleep" because my change to
epoll.7 mentioned autosleep, but there was no man page to reference.
The interaction of /sys/power/wakeup_count" with suspend/resume is also wor=
th
documenting as is the use of wake_locks via /sys/power/wake_{,un}lock (which
could also usefully be referenced by epoll(7)).

Given the number of filenames here, maybe this belongs in section 5 rather
than section 7.  Similar to proc(5) we could have power(5) which
documents /sys/power ???
(OK, I can see this might be opening a can of worms - we'll be having
class(5) and bus(5) and devices(5) next... but maybe this is a good thing.
And seeing these are all part of the kernel API, maybe they should be in
section 2 with the systemcalls.  Or do with need a new section of API virtu=
al
files ....)

So I guess "ls /sys/power" is a brief list of what should be included in the
page :-)

And thanks for your improvements to my submission!

NeilBrown


>=20
> > Comments (of course) welcome.
> >=20
> > NeilBrown
> >=20
> >=20
> > diff --git a/man2/epoll_ctl.2 b/man2/epoll_ctl.2
> > index 1fbe74eeea4e..6388f19195f1 100644
> > --- a/man2/epoll_ctl.2
> > +++ b/man2/epoll_ctl.2
> > @@ -154,6 +154,26 @@ The user must call
> >  with
> >  .B EPOLL_CTL_MOD
> >  to rearm the file descriptor with a new event mask.
> > +.TP
> > +.BR EPOLLWAKEUP " (since Linux 3.5)"
> > +If
> > +.B EPOLLONESHOT
> > +and
> > +.B EPOLLET
> > +are clear and the process has the
> > +.B CAP_BLOCK_SUSPEND
> > +.BR capability (7),
> > +ensure that the system does not enter "suspend" or
> > +"hibernate" while this event is pending or being processed.
> > +The event is considered as being "processed" from when it returned by
> > +a call to
> > +.BR epoll_wait (2)
> > +until the next call to
> > +.BR epoll_wait (2)
> > +on the same
> > +.BR epoll (7)
> > +file descriptor.
> > +.\" commit 4d7e30d98939a0340022ccd49325a3d70f7e0238
> >  .SH RETURN VALUE
> >  When successful,
> >  .BR epoll_ctl ()
> > diff --git a/man7/epoll.7 b/man7/epoll.7
> > index a372d9727978..31b1a8c8c9ba 100644
> > --- a/man7/epoll.7
> > +++ b/man7/epoll.7
> > @@ -173,6 +173,35 @@ it is the caller's responsibility to rearm the file
> > descriptor using .BR epoll_ctl (2)
> >  with
> >  .BR EPOLL_CTL_MOD .
> > +.SS Interaction with autosleep
> > +If the system is in
> > +.B autosleep
> > +mode via
> > +.I /sys/power/autosleep
> > +and an event happens which wakes the device from sleep, the device
> > +driver will only keep the device awake until that event is queued.  To
> > +keep the device awake until the event has been processed it is
> > +necessary to use
> > +.B epoll
> > +and the
> > +.B EPOLLWAKEUP
> > +flag.
> > +
> > +When this flag is set in the
> > +.B events
> > +field for a
> > +.I struct epoll_event
> > +then system will be kept awake from the moment the event is queued,
> > +through the
> > +.IR epoll_wait (2)
> > +call which returns the event until the subsequent
> > +.IR epoll_wait (2)
> > +call.  If the event should keep the system awake beyond that time,
> > +the a separate
> > +.I wake_lock
> > +should be taken before the second
> > +.IR epoll_wait (2)
> > +call.
> >  .SS /proc interfaces
> >  The following interfaces can be used to limit the amount of
> >  kernel memory consumed by epoll:
>=20
> All of the above looks good. I also added the piece sad little=20
> detail shown below.
>=20
> Cheers,
>=20
> Michael
>=20
> --- a/man2/epoll_ctl.2
> +++ b/man2/epoll_ctl.2
> @@ -174,6 +174,7 @@ until the next call to
>  on the same
>  .BR epoll (7)
>  file descriptor.
> +See also BUGS.
>  .SH RETURN VALUE
>  When successful,
>  .BR epoll_ctl ()
> @@ -270,6 +271,33 @@ when using
>  Applications that need to be portable to kernels before 2.6.9
>  should specify a non-null pointer in
>  .IR event .
> +
> +If
> +.B EPOLLWAKEUP
> +is specified in
> +.IR flags ,
> +but the caller does not have the
> +.BR CAP_BLOCK_SUSPEND
> +capability, then the
> +.B EPOLLWAKEUP
> +flag is
> +.IR "silently ignored" .
> +This unfortunate behavior is necessary because no validity
> +checks were performed on the
> +.IR flags
> +argument in the original implementation, and the addition of the
> +.B EPOLLWAKEUP
> +with a check that caused the call to fail if the caller did not have the
> +.B CAP_BLOCK_SUSPEND
> +capability caused a breakage in at least one existing user-space
> +application that happened to randomly (and uselessly) specify this bit.
> +.\" commit a8159414d7e3af7233e7a5a82d1c5d85379bd75c (behavior change)
> +.\" https://lwn.net/Articles/520198/
> +A robust application should therefore double check that it has the
> +.B CAP_BLOCK_SUSPEND
> +capability if attempting to use the
> +.B EPOLLWAKEUP
> +flag.
>  .SH SEE ALSO
>  .BR epoll_create (2),
>  .BR epoll_wait (2),
>=20
>=20
>=20
>=20


--Sig_/ryAieyiS4Xod5WCxzxhl62b
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU7p+JTnsnt1WYoG5AQIPtA/9GbZMfak5B9NJB4mApRHmZnHSMcQKokYo
0Bx9HIK1Ub8owc0hKG/21BmvC6OXLoiEKlNsDF9KCOIzh+OPVdUOyrI0DDN9M8Gw
/m62C1W2eR841HvHxojG1lb8aMms65GfQxgLy61EHe0JzCM1UYtdCS3pd8DRPLvl
Xu1VtGlifsZW0ruFs8kpixb/99Gc5//s11fblOfmnWSqjef0BVmcjxtWI1zK+5Ta
7tgg92xigRNQuZ/QEaV6IyW3JzrZNLeG5kSQdZhUeQjpkbt6vzjeLWUdaVIrcUKU
WCteCvaU7spd7gYn7g7QlNsVjdIL0AoQGhop5wApzO1Fe5z9kg8/fp0stSMb35z2
XeV4/wp69Mg6+WiF+95ZstO/tC+UEx/WF+qziZ2NZZx+223cO4hgvaLI4O/VS19l
zIc/KO+EJdRNsf+yZWVDHvzyk0s2TyimbYh3oqrMq2Seypwt9wHN+d0YdulKK+wY
6unrRPVMalxGoGEVS0UfOJu51I9rLp/yYRCBt4ENwqriru4Quh3+J/f7QTTM2kGb
5hRz7UcYWtQfCDsJ3gH+zS+jlsa63prQnevuc+7R/VgClP+GCFG/tPSXtH/+VPDB
PtAkNeKJ/tDZMyXbWZaJWm0dBqQlqBfSLKFEf9IdN6aZtt/oo+hZX2XYPh0cX0NW
BJfXfurKIUg=
=X3g/
-----END PGP SIGNATURE-----

--Sig_/ryAieyiS4Xod5WCxzxhl62b--
