Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaHDO5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:57:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:34192 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaHDO5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:57:04 -0400
Date: Mon, 4 Aug 2014 16:56:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140804145648.GE3588@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53DEE1CD.4000705@cn.fujitsu.com>
 <20140804074620.GH9918@twins.programming.kicks-ass.net>
 <53DF41ED.2020508@cn.fujitsu.com>
 <20140804115043.GA31903@linux.vnet.ibm.com>
 <20140804122515.GR19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5Y5y2FX8vnqwSxRu"
Content-Disposition: inline
In-Reply-To: <20140804122515.GR19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5Y5y2FX8vnqwSxRu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 04, 2014 at 02:25:15PM +0200, Peter Zijlstra wrote:
> On Mon, Aug 04, 2014 at 04:50:44AM -0700, Paul E. McKenney wrote:
> > OK, I will bite...
> >=20
> > What kinds of tasks are on a runqueue, but neither ->on_cpu nor
> > PREEMPT_ACTIVE?
>=20
> Userspace tasks, they don't necessarily get PREEMPT_ACTIVE when
> preempted. Now obviously you're not _that_ interested in userspace tasks
> for this, so that might be ok.
>=20
> But the main point was, you cannot use ->on_cpu or PREEMPT_ACTIVE
> without holding rq->lock.

Hmm, maybe you can, we have the context switch in between setting
->on_cpu and clearing PREEMPT_ACTIVE and vice-versa.

The context switch (obviously) provides a full barrier, so we might be
able to -- with careful consideration -- read these two separate values
and construct something usable from them.

Something like:

	task_preempt_count(tsk) & PREEMPT_ACTIVE
	smp_rmb();
	tsk->on_cpu

And because we set PREEMPT_ACTIVE before clearing on_cpu, this should
race the right way (err towards the inclusive side).

Obviously that wants a big fat comment...

--5Y5y2FX8vnqwSxRu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT358wAAoJEHZH4aRLwOS6TN8QAIYJHKLPUh4qWYbeosj52gEN
M3UxI+l+9vBslcXTCuL6XpJbfSvgJugYUD2x/QyYt0W9tTi8getNttUt1Mg1itTp
oK1H7PyMm0nJZXBWlPHsW2dIARB2rC79q4W1Ku3ce4HBQoWXljglGhmcbFFLZ9ls
IsG2MWfKdfRKmAhJIssH96Qvb6fCjmhblQ4bL8n5Ujy7pBErsFdXrNze9pBHmatU
k5dFBZPGVQAhHsCKfrgD8Vhn68/xNBeT02KC+OdzYunftGzDl40dzWAigamuizKB
YCRWjYYrk17lJEveU7Bh+FCr5HioSoosxmb3n2orRrFkZG2PHxdtURmLfb6wr+kF
ckSC93TrtFvKwWoDj6EBBeTqKb4YCu+gwQKOhc2EUsbpfeq/cz1tEOwjXfokvkYQ
6XDeO3pscWHFqEvP5nA7jqCFX/5BmDOdaQsoDEHN23q1TtSPPV4IrdKMVSDgcxKb
K4HzUPtVo1kvAOaYcYZOp7U5sbgC4wlmi1gz2ks3kTO1cevW7d8mKTTe9VrxoAPW
Zsrypu62bJuRAUS809YOpGJw/4vrlctxRRgh78vqO9UYCBf+PdWLUwHyTvj95D6I
q0I3168Tz49c+v08YtofT9NBt8Yauf3iDIWVsw/ZqwBt5WqqqKgY5dHsbV60OZG8
wv4GF4l+a+SVnsh7o39W
=sfcH
-----END PGP SIGNATURE-----

--5Y5y2FX8vnqwSxRu--
