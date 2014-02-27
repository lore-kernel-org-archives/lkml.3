Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaB0XIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:08:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbaB0XIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:08:14 -0500
Date: Fri, 28 Feb 2014 10:07:57 +1100
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux RAID <linux-raid@vger.kernel.org>,
        "majianpeng" <majianpeng@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md / procfs: avoid Oops if md-mod removed while
 /proc/mdstat is being polled.
Message-ID: <20140228100757.7dbd3dae@notabene.brown>
In-Reply-To: <20140227135125.92a56ff656b3ca8d0b5d9029@linux-foundation.org>
References: <20140227172445.13644477@notabene.brown>
	<20140227125807.d034c50c7fe2e1a9f3c38ec1@linux-foundation.org>
	<20140228083443.64c92382@notabene.brown>
	<20140227135125.92a56ff656b3ca8d0b5d9029@linux-foundation.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aW/_4ubRLvZ80=MDGXQVRCU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/aW/_4ubRLvZ80=MDGXQVRCU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Feb 2014 13:51:25 -0800 Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Fri, 28 Feb 2014 08:34:43 +1100 NeilBrown <neilb@suse.de> wrote:
>=20
> > On Thu, 27 Feb 2014 12:58:07 -0800 Andrew Morton <akpm@linux-foundation=
.org>
> > wrote:
> >=20
> > > On Thu, 27 Feb 2014 17:24:45 +1100 NeilBrown <neilb@suse.de> wrote:
> > >=20
> > > > If poll or select is waiting on /proc/mdstat when md-mod is unloaded
> > > > an oops will ensure when the poll/select completes.
> > > >=20
> > > > This is because the wait_queue_head which is registered with poll_w=
ait()
> > > > is local to the module and no longer exists when the poll completes=
 and
> > > > detaches that wait_queue_head (in poll_free_wait -> remove_wait_que=
ue).
> > > >=20
> > > > To fix this we need the wait_queue_head to have (at least) the same=
 life
> > > > time as the proc_dir_entry.  So this patch places it in that struct=
ure.
> > > >=20
> > > > We:
> > > >   - add pde_poll_wait to struct proc_dir_entry
> > > >   - call poll_wait() passing this when poll() is called on the proc=
 file
> > > >   - export a function proc_wake_up which will call wake_up() on pde=
_poll_wait
> > > >=20
> > > > and make use of all that in md.c
> > >=20
> > > This sounds wrong.  If a userspace process is waiting on
> > > md_event_waiters then the md module is "busy" and the rmmod attempt
> > > should fail?
> >=20
> > Al Viro says "no" quite firmly.
> >=20
> > I think the core argument is that
> >=20
> >   rmmod md-mod < /proc/mdstat
> >=20
> > would deadlock.
>=20
> Well, only if the rmmod hangs around waiting for the module to go idle.
> I'm thinking rmmod should fail.  EBUSY.
>=20
> > http://marc.info/?l=3Dlinux-fsdevel&m=3D133024267507384
>=20
> Why don't a billion blocking-procfs-read sites have this problem?
>=20

This issue of a file in /proc (actually /proc/fs/nfsd which is a separate
filesystem) blocking came up on the NFS list recently.
Experiments suggested that no other files in /proc block reads
(though /proc/vmcore takes somewhat longer to 'cat' than most).
So the offending file was changed to never block.

i.e. I think your 'billion' estimate is a little high, by one billion.
:-)

NeilBrown

--Sig_/aW/_4ubRLvZ80=MDGXQVRCU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUw/FTjnsnt1WYoG5AQIHWA/9HY63RoqwhhmlEhEgTdOEflQq5xzl/E6N
xpKCTT+9cLaHspS9RsdapfpOYwIViBeh0poo8OxTm+ibrT9S+bMbZp/LDWHi3nvk
gRorUXNuR6CPPrJnenCKCU3lifG4bSrmQfIYu7jRDenmWM6+0NnRhIe3JuuLOZGa
SKvz/KiHXKTbkHJXpPUeMqQbCLGXybg4ec9rFjA/O2rFwAelzHtZZ6ex8jtuEoW7
N/J6nSyPC4KB784OP0nPbUhgBTMSKZnp2F9g4KVjrLhmZ71nNh+k5L941y1xO+L8
AQafqla67+1CDGSwYVFn3BttTi3A33ClpEPmdZsTBB/M0hRHB0CAlnKfPPMYUhgu
d4bjTdwmLFE1CbqSm/CnTTcjx5AlcB0BgYZdaS7PiC4KqwKiieQ0hjrISYgskYKo
qSQwVsdAaVBJVJ0y1GAYZjvoYqqMD4OeHK3nIlHOmupRKIu6AXzNfdEjD1h//cj0
FGkxnG/5Z8EOO+CKRhcgL7p6aFjc8GYg/3EUkhvdK9uwbF5VRfmyqlEYi+Lwinkb
FO93RSMC82FqXgqCfpZghfenBSLGGIh/FfP9zzdJlFMfFHbTwVDbdTqJ5MAGSpIq
3ZzUXPlJtPbJZDDPBAZhjh7NAxm79kr95WQUoqfHJt1MyAeAhHXdAXcrGG1tFUiA
qWnnVr8mjCc=
=T4/D
-----END PGP SIGNATURE-----

--Sig_/aW/_4ubRLvZ80=MDGXQVRCU--
