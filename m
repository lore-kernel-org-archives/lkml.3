Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaE1PC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:02:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:43218 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaE1PCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:02:24 -0400
Date: Wed, 28 May 2014 17:02:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528150215.GV11096@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <CABPqkBTwU8mqHimfUnn0WEonL_reCcBED+tQx3XgwJh7gnFEsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPyQn7mfIBXOql8K"
Content-Disposition: inline
In-Reply-To: <CABPqkBTwU8mqHimfUnn0WEonL_reCcBED+tQx3XgwJh7gnFEsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPyQn7mfIBXOql8K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 02:54:25PM +0200, Stephane Eranian wrote:
> On Wed, May 28, 2014 at 10:10 AM, Peter Zijlstra <peterz@infradead.org> w=
rote:
> > On Wed, May 28, 2014 at 02:18:09PM +0800, Yan, Zheng wrote:
> >> PEBS always had the capability to log samples to its buffers without
> >> an interrupt. Traditionally perf has not used this but always set the
> >> PEBS threshold to one.
> >>
> >> For the common cases we still need to use the PMI because the PEBS
> >> hardware has various limitations. The biggest one is that it can not
> >> supply a callgraph. It also requires setting a fixed period, as the
> >> hardware does not support adaptive period. Another issue is that it
> >> cannot supply a time stamp and some other options.
> >
> > So the reason I've never done this is because Intel has never fully
> > explained the demuxing of pebs events.
> >
> > In particular, the 0x90 offset (IA32_PERF_GLOBAL_STATUS). Intel once
> > confirmed to me that that is a direct copy of the similarly named MSR at
> > the time of the PEBS assist.
> >
> > This is a problem, since if multiple counters overflow multiple bits
> > will be set and its (afaict) ambiguous which event is for which counter.
> >
> I am not sure how having only one entry in the PEBS buffer solves this.
> I think PEBS will create only one entry if multiple counters overflow
> simultaneously.=20

For the not exact simultaneous events it narrows the window in which
we can have another event overflow and raise the bit because it will
immediately raise the PMI and disable the PMU.

Remember, that status bit gets raised when the counter overflows, but
the PEBS assist, and therefore the hardware reset, can take a long while
to actually happen. So there's fairly large windows here there's
multiple bits set.

And if you have the auto-refresh; does that clear the status bit again?
Supposing it does (its the sane thing to do), you can actually have 3
bits set, one for an event that hasn't even had a pebs assist yet.

So while the problem still exists for a single event, its much worse if
you just let the thing run.

> That OVFL_STATUS bitmask will have multiple bits
> set. I understand the problem in perf_events because you need to
> assign a sample to an event and not all events may record the same
> info in the sampling buffer.

Right, so you raise the issue that a pebs assist trigger of two events
on the exact cycle will only create one record with two bits set, that's
worse because its indistinguishable from the case where there's two
separate but near events recorded one of which also has two bits set
(because the second counter did overflow but no assist triggered yet).

So here we have to distinct scenarios in which multiple bits are set and
no way to disambiguate.

All in all, its a complete and utter trainwreck, and the worst part is
that I've raised this issue multiple times, starting some 5 years ago,
and nothing has happened afaik.

--ZPyQn7mfIBXOql8K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThfp3AAoJEHZH4aRLwOS6KLcP/30olEPfxUPRnU30KZnnBlRc
KUVHityP0Lr1wOMXnfM3gDFM5KASfKDwWP1l/w7SiKQUcEEPSJvJWxjn23veK/hq
yu17ZwQ6lZdkarwxN7mwy70cHEXuQ701XCZXfZeAAPB0EOkwYtULyshoSHkCh7q3
2AIsEdyla4lRTSkZ4q+QQl2KEuB+PpqhaOwFMB7fTX+1xsziLqb0n+aB7/gRN/B8
EUzXrcb72lwuH4z6ZFiTuddMBZTTyv7iXTzTl1VAwudqC7r47uImEBueuKjKcbbH
umyXlGbFOTImiySJ15d5lXyOx9JKHg7uGwW7MaVjhp+reTro5vAo2b9ru+nqZfjI
To+XQz3N6kmF6nFktatit72A9ol9e6YKVQi2SIj21LEVPK6XK4oPWfjXdRBCs70H
KlKtnoGhiPmbZWoj3t+V6v2nTrG6F92JDq+SurV6aQDQagn7kiHDsKv13qUFIQHp
fWVhd8MknTRmN3esJmq9BXrJDIIEpQhroV0eIsO2jYzdk/g9HirlAu9H0M7ymdlj
FXhZMIwgRqc0eLbT3Sabc59XQG9CDFF7ZpK7TIxPleBxggGZlfxs7tduwv8IXP7U
8p5mW12Wi0j+IijfNcp7GSVagVM+CSePoML/+FRAGwhnzRl2cuyWN6KIbOrllh1q
CZ64HTL9Mhl8k0whGO8s
=vzH9
-----END PGP SIGNATURE-----

--ZPyQn7mfIBXOql8K--
