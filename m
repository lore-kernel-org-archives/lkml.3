Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbaGOJLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:11:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:56400 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882AbaGOJLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:11:13 -0400
Date: Tue, 15 Jul 2014 11:11:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/5] perf: Destroy event's children on task exit
Message-ID: <20140715091104.GU9918@twins.programming.kicks-ass.net>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
 <1405079782-8139-3-git-send-email-jolsa@kernel.org>
 <20140714111833.GU19379@twins.programming.kicks-ass.net>
 <20140714201854.GJ17761@krava.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2OFxhqPNSAodNyNc"
Content-Disposition: inline
In-Reply-To: <20140714201854.GJ17761@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2OFxhqPNSAodNyNc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 10:18:54PM +0200, Jiri Olsa wrote:
> On Mon, Jul 14, 2014 at 01:18:33PM +0200, Peter Zijlstra wrote:
> > On Fri, Jul 11, 2014 at 01:56:19PM +0200, Jiri Olsa wrote:
> > > From: Jiri Olsa <jolsa@redhat.com>

> > > +static void perf_event_exit_children(struct perf_event *parent)
> > > +{
> > > +	struct perf_event *child, *tmp;
> > > +
> > > +	mutex_lock(&parent->child_mutex);
> > > +	list_for_each_entry_safe(child, tmp, &parent->child_list,
> > > +				 child_list) {
> > > +		struct perf_event_context *child_ctx =3D child->ctx;
> > > +
> > > +		/*
> > > +		 * Child events got removed from child_list under
> > > +		 * child_mutex and then freed. So it's safe to access
> > > +		 * childs context in here, because the child holds
> > > +		 * context ref.
> > > +		 */
> > > +		mutex_lock(&child_ctx->mutex);
> > > +		perf_remove_from_context(child, true);
> > > +		mutex_unlock(&child_ctx->mutex);
> > > +
> > > +		list_del_init(&child->child_list);
> > > +		put_event(parent);
> > > +		free_event(child);
> > > +	}
> > > +	mutex_unlock(&parent->child_mutex);
> > > +}

> > I don't think this is correct, perf_event_init_context() can come in
> > concurrently and the first place it runs into ->child_mutex is after its
> > already allocated and created the (first) child event.
>=20
> just noticed this.. I'm working on the other version we decide, but FWIW
> there's also mutex_lock(&child_ctx->mutex); before removing the context,
> that should protect it against perf_event_init_context call

Oh, more fail :-)

You have:

  perf_event::child_mutex
    perf_event_context::mutex

The existing code has:

  perf_event_context::mutex
    perf_event::child_context

See for example:

  perf_event_init_context()
    mutex_lock(&parent_ctx->mutex)
    inherit_task_group()
      inherit_group()
        inherit_event()
	  mutex_lock(&parent_event->child_mutex)

and

  perf_event_for_each()
    mutex_lock(&ctx->mutex)
    perf_event_for_each_child()
      mutex_lock(&event->child_mutex)

So the patch creates an AB-BA deadlock.

--2OFxhqPNSAodNyNc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxPAnAAoJEHZH4aRLwOS6jQEP/A66EzYKlmdKjvD1zZeKB+AU
2VrbSc3Ib6hlt/SoyELOirV9+VZ+kUmXr1985BDx+aEFfFEB+D14c8rGB/K96N8D
T2aeg9ENVPC+prwsMWczPrqGylQwn7ybWBZHqsOnosjD4WOb3zYlLqNfVYcG56NL
LY2DXEvqILpYklpdf1LrhSD1ea0b9rs4C3FVHatvrwV6wQvFl01rLme3lLzv4jyX
LoDTsJiUjd+GQ6AtNuNjPUFMHqAhzby4cXRd9A15oCmlXco41iLjx3+AsfUqcMpk
316x+9XryKDwXC2ZBCyUiM+l91T+zR7DfvojW+0+DbScCMn9m1draTWZf4NWO82Z
l/QwOdktbdkiEnbX7X8VWdoryfgRIvP7vdR9IdqfLCzh41gkIDUBufJ/oU7uKTNh
cdLQQaR8IsVblMNp//o2wTksAOXJupUbXOJvC9fk6mOvytHh1OT3pU1b4tDTs4tc
1ZrOOncu8kqSXk80DYON+R1qLHp/dVZZ/Z3JSsTQwx1WLRK4prsDKZJ+jkkrGfRh
9QwFLUAcCksr8VkyfSj/SwtFTq6GaJ1UKN8EpjAvCoGAB7eA/LUl3IMtMwyQ5F8v
LYskudPna+1Wyx0TcwJuEubRllch9o7cxkey5LO8UXZFwmk08HjMXLNi/2GRaEpJ
AsTI0o8fMnryI/jXjjef
=4uJ3
-----END PGP SIGNATURE-----

--2OFxhqPNSAodNyNc--
