Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaEOJGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:06:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:56935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaEOJGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:06:45 -0400
Date: Thu, 15 May 2014 11:06:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Message-ID: <20140515090638.GI30445@twins.programming.kicks-ass.net>
References: <537192D3.5030907@linux.vnet.ibm.com>
 <20140513094737.GU30445@twins.programming.kicks-ass.net>
 <53721FD4.6060300@redhat.com>
 <20140513142328.GE2485@laptop.programming.kicks-ass.net>
 <53731D12.7040804@linux.vnet.ibm.com>
 <20140514094426.GF30445@twins.programming.kicks-ass.net>
 <5374387E.4080802@linux.vnet.ibm.com>
 <20140515083531.GE30445@twins.programming.kicks-ass.net>
 <53747EE4.3020605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EbMW37mHYzw0qvy8"
Content-Disposition: inline
In-Reply-To: <53747EE4.3020605@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EbMW37mHYzw0qvy8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 04:46:28PM +0800, Michael wang wrote:
> On 05/15/2014 04:35 PM, Peter Zijlstra wrote:
> > On Thu, May 15, 2014 at 11:46:06AM +0800, Michael wang wrote:
> >> But for the dbench, stress combination, that's not spin-wasted, dbench
> >> throughput do dropped, how could we explain that one?
> >=20
> > I've no clue what dbench does.. At this point you'll have to
> > expose/trace the per-task runtime accounting for these tasks and ideally
> > also the things the cgroup code does with them to see if it still makes
> > sense.
>=20
> I see :)
>=20
> BTW, some interesting thing we found during the dbench/stress testing
> is, by doing:
>=20
> 	echo 240000000 > /proc/sys/kernel/sched_latency_ns
>         echo NO_GENTLE_FAIR_SLEEPERS > /sys/kernel/debug/sched_features
>=20
> that is sched_latency_ns increased around 10 times and
> GENTLE_FAIR_SLEEPERS was disabled, the dbench got it's CPU back.
>=20
> However, when the group level is too deep, that doesn't works any more...
>=20
> I'm not sure but seems like 'deep group level' and 'vruntime bonus for
> sleeper' is the keep points here, will try to list the root cause after
> more investigation, thanks for the hints and suggestions, really helpful =
;-)

How deep is deep? You run into numerical problems quite quickly, esp.
when you've got lots of CPUs. We've only got 64bit to play with, that
said there were some patches...

What happens if you do the below, Google has been running with that, and
nobody was ever able to reproduce the report that got it disabled.



diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b2cbe81308af..e40819d39c69 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -40,7 +40,7 @@ extern void update_cpu_load_active(struct rq *this_rq);
  * when BITS_PER_LONG <=3D 32 are pretty high and the returns do not justi=
fy the
  * increased costs.
  */
-#if 0 /* BITS_PER_LONG > 32 -- currently broken: it increases power usage =
under light load  */
+#if 1 /* BITS_PER_LONG > 32 -- currently broken: it increases power usage =
under light load  */
 # define SCHED_LOAD_RESOLUTION	10
 # define scale_load(w)		((w) << SCHED_LOAD_RESOLUTION)
 # define scale_load_down(w)	((w) >> SCHED_LOAD_RESOLUTION)

--EbMW37mHYzw0qvy8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdIOeAAoJEHZH4aRLwOS6LeMQAJHdZt2cQ6yOct2Vq5dVoGpC
xg29gvqWYkO6wTUntyvFCI56elrEcB197OtsebwZO50m5WL+RTmeJRVdksDMjd52
s/yNqOHjAl5GeNuDLRVP6ZdzIICg1KpWbUtkBjqMcPRzyeRDjlYku9FXD1HHeisw
5AXd30klSgSp2Nv//CwKk1J88cn8wCHQi+ioV77W6+PnWRGSfXsUWp0YFglQjY3D
8L+YMcsx/GW87FbJNIk2VLje/CrJvJFKp53BA1Wpu+oik/TcY/xkwlPMFUwo04bu
pamjzdisLp1kSy6egN/zM7UK59ODnQaHjzsGLQhj3svjv3TUBjgogsKXQEwSJNXY
Sl851gd/scNLHUPHS+uBVq7Y62lK/dON+0DJ2+0QHSIbIZBxvXGA10B9sJ1fF2us
xYl1/LmNz/dhFfT/k2rYmuXLv5vpkUd9Yjtd8g0X4CptNlmyHCTHY0mrdMgq4OV/
VFveJkW0E2f8jVXdge241NfDE71rUOeRPctbFMl6r/G28t9InsVl/t4ENtiBMjKN
BXd9lySvRW/+1g1ou69rbcQpPBE4DcCJa9Jl/VrNdMWWjLoslEzCF/4R2E4OSnjp
g/caJSRvch9vnXksJFPRIJMTDsnTWyEKui9g2kHfeLnou2tYegM66iesJ/U9NlPF
PUh44vdyGKTSZelT8MZa
=R4Z6
-----END PGP SIGNATURE-----

--EbMW37mHYzw0qvy8--
