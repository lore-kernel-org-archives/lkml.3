Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaFENmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:42:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:52419 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaFENmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:42:39 -0400
Date: Thu, 5 Jun 2014 15:42:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, zheng.z.yan@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug
 workaround
Message-ID: <20140605134235.GK3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-6-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9RxwyT9MtfFuvYYZ"
Content-Disposition: inline
In-Reply-To: <1401917658-26065-6-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9RxwyT9MtfFuvYYZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2014 at 11:34:14PM +0200, Stephane Eranian wrote:
> +static void intel_commit_scheduling(struct cpu_hw_events *cpuc,
> +				    struct perf_event *event, int cntr)
> +{
> +	struct intel_excl_cntrs *excl_cntrs = cpuc->excl_cntrs;
> +	struct event_constraint *c = event->hw.constraint;
> +	struct intel_excl_states *xlo, *xl;
> +	int tid = cpuc->excl_thread_id;
> +	int o_tid = 1 - tid;
> +	int is_excl;
> +
> +	if (cpuc->is_fake || !c)
> +		return;
> +
> +	is_excl = c->flags & PERF_X86_EVENT_EXCL;
> +
> +	if (!(c->flags & PERF_X86_EVENT_DYNAMIC))
> +		return;
> +
> +	WARN_ON_ONCE(!excl_cntrs);
> +
> +	if (!excl_cntrs)
> +		return;
> +
> +	xl = &excl_cntrs->states[tid];
> +	xlo = &excl_cntrs->states[o_tid];
> +
> +	WARN_ON_ONCE(!spin_is_locked(&excl_cntrs->lock));

Use:
	lockdep_assert_held(&excl_cntrs->lock);

It also checks to see the current context is actually the lock holder,
and it doesn't generate any code when !lockdep.

> +
> +	if (cntr >= 0) {
> +		if (is_excl)
> +			xlo->init_state[cntr] = INTEL_EXCL_EXCLUSIVE;
> +		else
> +			xlo->init_state[cntr] = INTEL_EXCL_SHARED;
> +	}
>  }

--9RxwyT9MtfFuvYYZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkHPLAAoJEHZH4aRLwOS6LvYP/3/bhVXzWfflA42gqQe3i+Tz
x7pnTOfsL0KEzq0bWSizsGXMYXOvlFUs1hLbeJpc94kdJjV/J1bIVchJPWCVHz1I
ms8PBSqQ+L0i6K2/l/JqeQOfGVK6Vp7Ddw3zVGJrH6rVn8j+utcN7xTZ5VwsdJNd
EiD1E+wzlWgrDg0IouQmkkn0S6ne3Yo6PPmzKEKPNOAVegdl1G8Pmx2rL1N6dQC5
tOl1CsqohS12eyMfvFVsOY6cuvLJzgZObu5UlynnlhRlqyNRFCyjgT8VpJclBvld
0mOalOkSz5wG1SPmn7YeZx8Fak1/PGvqOy9uwTI8qEnq1SXrjZHQ++zUn/iZtQW9
ooq6nKsCHB11j/v4vxxcASShP2J4udl+x9NLTkEPpMz5bnme2SjFqmU9OEmPITLt
wjjVF0XTBSE3h0AlLaDazfNQ9CVhMAB7Czp8lPlT7LRstHDdIcPf9AMiH8MQjvxk
VcOOI46DTSIaM09q0APmGTYxUQNQJ/eYJxoQszHywbvvdtpiTam8OMTLd1RoIxvB
dFp/zrMEYnp303zHeO5YzjIVgH/TpQiDxA6W9q8FS0Dqvn4311+13i/My1wLgYos
wY2KQD4XcwA2o0iipljRa8JKaBdFW6gVROvRntMMpA6jxiNHEEPLSZS7LYjwJOIW
EDZ0fJCWB8Z9YtiZ2jgR
=2gqq
-----END PGP SIGNATURE-----

--9RxwyT9MtfFuvYYZ--
