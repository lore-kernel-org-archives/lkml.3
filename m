Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaGOQhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:37:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaGOQhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:37:15 -0400
Date: Tue, 15 Jul 2014 18:37:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
Message-ID: <20140715163700.GP6758@twins.programming.kicks-ass.net>
References: <1405110784.2970.655.camel@schen9-DESK>
 <20140714101611.GS9918@twins.programming.kicks-ass.net>
 <1405354214.2970.663.camel@schen9-DESK>
 <20140714161432.GC9918@twins.programming.kicks-ass.net>
 <1405357534.2970.701.camel@schen9-DESK>
 <20140714181738.GI9918@twins.programming.kicks-ass.net>
 <1405364908.2970.729.camel@schen9-DESK>
 <20140714191504.GO9918@twins.programming.kicks-ass.net>
 <20140715133627.GS3588@twins.programming.kicks-ass.net>
 <20140715152149.GC19570@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/CLXJPJLvRXjqaTD"
Content-Disposition: inline
In-Reply-To: <20140715152149.GC19570@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/CLXJPJLvRXjqaTD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 11:21:49AM -0400, Tejun Heo wrote:
> On Tue, Jul 15, 2014 at 03:36:27PM +0200, Peter Zijlstra wrote:
> > So, just to expand on this, we're already getting 'bug' reports because
> > worker threads are not cgroup aware. If work gets generated inside some
> > cgroup, the worker doesn't care and runs the worker thread wherever
> > (typically the root cgroup).
> >=20
> > This means that the 'work' escapes the cgroup confines and creates
> > resource inversion etc. The same is of course true for nice and RT
> > priorities.
> >=20
> > TJ, are you aware of this and/or given it any throught?
>=20
> Yeap, I'm aware of the issue but haven't read any actual bug reports
> yet.  Can you point me to the reports?

lkml.kernel.org/r/53A8EC1E.1060504@linux.vnet.ibm.com

The root level workqueue thingies disturb the cgroup level scheduling to
'some' extend.

That whole thread is somewhat confusing and I think there's more than
just this going on, but they're really seeing this as a pain point.

> Given that worker pool management is dynamic, spawning separate pools
> for individual cgroups on-demand should be doable.  Haven't been able
> to decide how much we should be willing to pay in terms of complexity
> yet.

Yah, I figured. Back before you ripped up the workqueue I had a
worklet-PI patch in -rt, which basically sorted and ran works in a
RR/FIFO priority order, including boosting the current work when a
higher prio one was pending etc.

I never really figured out a way to make the new concurrent stuff do
something like that, and this 'problem' here is harder still, because
they're not static prios etc.

Ideally we'd run the works _in_ the same task-context (from a scheduler
POV) as the task creating the work. There's some very obvious problems
of implementation there, and some less obvious others, so bleh.

Also, there's the whole softirq trainwreck, which has many of the same
problems. Much of the network stack isn't necessarily aware for whom
they're doing work, so no way to propagate.

Point in case for the crypto stuff I suppose, that's a combination of
the two, god only knows who we should be accounting it to and in what
context things should run.

Ideally a socket has a 'single' (ha! if only) owner, and we'd know
throughout the entirely rx/tx paths, but I doubt we actually have that.

(Note that there's people really suffering because of this..)

Same for the 'shiny' block-mq stuff I suppose :-(

--/CLXJPJLvRXjqaTD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxVisAAoJEHZH4aRLwOS6hhAP/iRsDHatR50i80mFmRGMh1sN
xXBxeodnHqvlkBPsPmtmo9h+Eb0ihLanHKi1GPXtpdhdjTLYMznZuxGbG5otxdfB
HQzCZTPkByjpwS0LcN+As4jTd2A7t7MnWMcCjK7w+fo/olI6zFeasUvQI4hgO1SA
3McG2rUN+GpOMlRqIYcroJf9OLa5TY7o+TYA+f1i5DUH7IpReZ15pb2mEiVp+Vdz
/PQdyRQS8a6vdd5+yiwe7UrgRohbO4PcF+XZ9vikfdt4QCk/iIR3DoTdvQkBiDaB
5Z6uwbZRciSnZ79bKJB6gFCcWrs0h49iQqHGOI692pDdgc88Ku+RnlE3hiVJVn3H
PyXS6NQ0bZClUtbFsFxvguEV74EhOPlwCuVLx9FIVHKw75n0asfU10xfXgSbOSNH
UsHQ1osEjUImXeKvx6DUG2/z6F7+TuyAMzlGelLXZMc317w4nxtyWOQD7mx3qAmi
sQUajZdUPJnU4VAxc88aELHA0B5f7sFim5PqHGzhM3GIlxHRDG1dfSKFit2L5cpb
ZT1ST2PkEDqs5tlvmUiXUamN7UBU4zIiUfwEkYWLzmRF218AL7nd0GoMfnakO92Z
ObAcXSB0mdW8ASYnz6SEL1Ih029jZSoCgbaPZydwWQSsjwzuaPFMNYC9ZAAOXqYi
PT8nbFjT06uwNEqLvzve
=2lHS
-----END PGP SIGNATURE-----

--/CLXJPJLvRXjqaTD--
