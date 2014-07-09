Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaGISp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:45:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:60799 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaGISpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:45:54 -0400
Date: Wed, 9 Jul 2014 20:45:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: bsegall@google.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140709184543.GI9918@twins.programming.kicks-ass.net>
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
 <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
 <20140707104646.GK6758@twins.programming.kicks-ass.net>
 <xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140708000840.GB25653@intel.com>
 <xm26k37nye7d.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140709010753.GD25653@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4BlIp4fARb6QCoOq"
Content-Disposition: inline
In-Reply-To: <20140709010753.GD25653@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4BlIp4fARb6QCoOq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 09:07:53AM +0800, Yuyang Du wrote:
> That is chalenging... Can someone (Peter) grant us a lock of the remote r=
q? :)

Nope :-).. we got rid of that lock for a good reason.

Also, this is one area where I feel performance really trumps
correctness, we can fudge the blocked load a little. So the
sched_clock_cpu() difference is a strict upper bound on the
rq_clock_task() difference (and under 'normal' circumstances shouldn't
be much off).

So we could simply use a timestamps from dequeue and one from enqueue,
and use that.

As to the remote subtraction, a RMW on another cacheline than the
rq->lock one should be good; esp since we don't actually observe the
per-rq total often (once per tick or so) I think, no?

The thing is, we do not want to disturb scheduling on whatever cpu the
task last ran on if we wake it to another cpu. Taking rq->lock wrecks
that for sure.=20

--4BlIp4fARb6QCoOq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvY3SAAoJEHZH4aRLwOS6v5AP/16aNrJ7e8aBhKTe7cKzlYpJ
DQjBj9acnApaUiTYn1HWtPk1r2VU+p2+lYhTfv/fB2Rs4IN1x40tKdIZ7a19Yuw8
4+gcOZ5MxLKWLzksgC+eLykarx1ztr/39Bm5j6AdIbrnW7NWTQnM/9RjXt5Nfrj6
vnzm5ErwlchOY/eSxuGcLDzlOUEuCde9GPIYXzXRyl7dJcmicfDpKIm/7dVycHkJ
dsVfbbJdQ5KdA4F542CzTL4R03FYQvRsn74U4hGxGOhGcK8YabmEBtpInrxaqqCJ
Arl8vx1rFHHrngcicSnUOBLu5/iYlmsk7DT4KNbdPGZp1ZkrihfBfQKXS7UFEV1u
U9FbKtKx4g5mX/XEv8hGdoreIs0GglMgl+A/HHB4ZVWVvhjdjm5j5NIy2wK9dOb1
8kGDxSMa5wvg5U5QnaSplw5cMZL8EXYUyFqNKN5z+wX9bsgzGmPAVTOPoXk3PKP2
ljOcigK3kKqMvFIkioJgFSTXxHRQ8A3zzDY/Jd+mhc6ueIsRf6rrL40eXIFj6MT2
ENtkREpjPTFyqQlkiKkaJkHQJtMhAF58tQzs8NnEMbJsySbm5JJYnNjXIJ6s8iqK
jZla9d2XV5/SJzpXGwagbZw9u1Di73Ggkrdfo0xL84Vztical2xgKoy9IPKlPxXy
1HB7SyCxPHy8kaFHWlEZ
=ma36
-----END PGP SIGNATURE-----

--4BlIp4fARb6QCoOq--
