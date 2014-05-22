Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaEVIoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:44:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52405 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaEVIoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:44:30 -0400
Date: Thu, 22 May 2014 10:44:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
Message-ID: <20140522084419.GS30445@twins.programming.kicks-ass.net>
References: <CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
 <20140414110245.GG11096@twins.programming.kicks-ass.net>
 <CAKohpo==1=K0=gZz_Z_Y0zO2PtyvA-Q67_+VKTJN7kbQgbiHTg@mail.gmail.com>
 <20140414114744.GI11096@twins.programming.kicks-ass.net>
 <CAKohpon=_ZR+QbfacGT+G_atgcc21KMYG3YxPf0nkSDLBH8Q2A@mail.gmail.com>
 <20140414120600.GJ11096@twins.programming.kicks-ass.net>
 <20140415093002.GL1877@localhost.localdomain>
 <CAKohpomKLyK0XZbB2j1Gjxe123b6JkcdSTpvdFFD23Hb_EmmpA@mail.gmail.com>
 <CAKohpomik2L906GLST=XSG_zhDcCWMNBw4X7qJd8ejcOF0Fusw@mail.gmail.com>
 <20140513233036.GH13828@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gtHcOevdugseuBBz"
Content-Disposition: inline
In-Reply-To: <20140513233036.GH13828@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gtHcOevdugseuBBz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 01:30:39AM +0200, Frederic Weisbecker wrote:
> On Fri, May 09, 2014 at 02:14:10PM +0530, Viresh Kumar wrote:
> > On 23 April 2014 16:42, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > > On 15 April 2014 15:00, Frederic Weisbecker <fweisbec@gmail.com> wrot=
e:
> > >> Ok, I'm a bit buzy with a conference right now but I'm going to summ=
arize that
> > >> soonish.
> >=20
> > Hi Frederic,
> >=20
> > Please see if you can find some time to close this, that would be very
> > helpful :)
> >=20
> > Thanks
>=20
> I'm generally worried about the accounting in update_curr() that periodic=
ally
> updates stats. I have no idea which of these stats could be read by other=
 CPUs:
> vruntime, load bandwitdth, etc...

update_curr() principally does the sum_exec_runtime and vruntime. Now
vruntime is only interesting for other cpus when moving tasks across
CPUs, so see below on load-balancing.

sum_exec_runtime is used for a number of task stats, but when nobody
looks at those it shouldn't matter.

So rather than constantly force update them for no purpose, update them
on-demand. So when someone reads those cputime stats, prod the task/cpu.
I think you can do a remote update_curr() just fine.

And I suppose you also need to do something with task_tick_numa(), that
relies on the tick regardless of nr_running. And that's very much not
something you can do remotely. As it stands I think the numa balancing
and nohz_full are incompatible.

> Also without tick:
>=20
> * we don't poll anymore on trigger_load_balance()
>=20
> * __update_cpu_load() requires fixed rate periodic polling. Alex Shi had
> patches for that but I'm not sure if that's going to be merged
>=20
> * rq->rt_avg accounting?

So I think typically we don't want load-balancing to happen when we're
on a nohz_full cpu and there's only the one task running.

So what you can do is extend the existing nohz balancing (which
currently only deals with CPU_IDLE) to also remote balance CPU_NOT_IDLE
when nr_running =3D=3D 1.


--gtHcOevdugseuBBz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfbjjAAoJEHZH4aRLwOS6swYQALNGrKSaBqApYBFUrTxPZKWh
pvbvVLhKvtLDYtQXK2hvk7vkrccKyYuuyYVz2JekW3wNSrohklx8mUnsXacvRQhJ
vxWma200DMCITC+6R3j3sdu8HUZjql8TgcQw334O56j4NUIsgO5ReOd/4qIRkamg
00RTbYUxyY49t+zI0aOVvAGtYoYDUwc5bvdoYBph5E+5x9jF85TLn/H8HJltmhJ3
FV2oAwXo/GUizH5olqUFg93lfZeLniqDvk25T7UhvXkYGaf/g9hyqAR9ybVJP9UA
FsSjqrx7UTk6mEdVNwBxypQrvpdGUPGa4Lwjzje06c3deG4YYHOr4YKqTKYVDn+D
DNlnLDFN+OU/p8TIPx7FpUabedDyRLHFzSymyXaa4fiBNCsxq2vswma2czubso5E
vNQHjGlwCPGATtH6VYIWGEsz64XSgXvOAf2OMoY04peO2+1kH3CrMv0dK0JTheFN
yP4o4CeVBRG/iMlB/WWqqUnFrVsx3juPT8Eb3mifThaqWV0rBqnawMRaHL+FyNhK
YfPaGL2eIYg3K0utjTkAPszXc5AcJgVSF9xY2iQz5quBX9E9C0fsV/dXiNTaaztp
1Bgl6YWbx0x3Gm8V/9pPbIGhwhmPOJdSkFR29/tBEFoySP3915e1hvjlpVWLUde0
AQuJ0R0+YJQccbq6XCIk
=QzLu
-----END PGP SIGNATURE-----

--gtHcOevdugseuBBz--
