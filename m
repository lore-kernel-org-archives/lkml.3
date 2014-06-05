Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaFENit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:38:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaFENis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:38:48 -0400
Date: Thu, 5 Jun 2014 15:38:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, zheng.z.yan@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug
 workaround
Message-ID: <20140605133839.GJ3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-6-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3bvv0EcKsvvYeex"
Content-Disposition: inline
In-Reply-To: <1401917658-26065-6-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3bvv0EcKsvvYeex
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2014 at 11:34:14PM +0200, Stephane Eranian wrote:
>  static void
> +intel_start_scheduling(struct cpu_hw_events *cpuc)
> +{

> +	/*
> +	 * lock shared state until we are done scheduling
> +	 * in stop_event_scheduling()
> +	 * makes scheduling appear as a transaction
> +	 */
> +	spin_lock_irqsave(&excl_cntrs->lock, excl_cntrs->lock_flags);
> +
> +	/*
> +	 * save initial state of sibling thread
> +	 */
> +	memcpy(xlo->init_state, xlo->state, sizeof(xlo->init_state));
> +}
> +
> +static void
> +intel_stop_scheduling(struct cpu_hw_events *cpuc)
> +{

> +	/*
> +	 * make new sibling thread state visible
> +	 */
> +	memcpy(xlo->state, xlo->init_state, sizeof(xlo->state));
> +
> +	xl->sched_started = false;
> +	/*
> +	 * release shared state lock (lock acquire in intel_start_scheduling())
> +	 */
> +	spin_unlock_irqrestore(&excl_cntrs->lock, excl_cntrs->lock_flags);
> +}

Do you really need the irqsave/irqrestore? From what I can tell this is
always called under perf_event_context::lock and that is already an
IRQ-safe lock, so interrupts should always be disabled here.

Also, it looks like xl->state is the effective state, and ->init_state
is the work state? Is init the right name for this?

--u3bvv0EcKsvvYeex
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkHLfAAoJEHZH4aRLwOS6p64P/iguTooxOLtrgJWx1CTjiAnY
PF1leVvBqjpDyL1EKWdw7crLTA3X4VA/SALXclCKLz+X1FIrJiLR9g997+FkBi/B
5LwdE+YlfRTjJgwdUfmg8++6C6aTtZHlpyUhsUDCrSlKzrhWUFPXX66es5YpDi90
TgHkxYX7pruC2KBAJCeiz2Qzi8ic76Je1fr8n7sbnC4+HMoVe/esrhq21jTPxExs
7kw4whyzxcdyMbQpy3A0uv+WYvDDq3lIAy2YMJE1sg0VU94LdDJEAEDhM6PK0Tm4
8WKDFWYtHcWVDud5uJPrQbWIjLiz/ea8jwAcQkQ7cO1jW9AgpX1rq6K4EPISd9nG
7D3Tf3aMkh/pkBUcAuNe3c8jT8YWwyundm//JeIHzpVE7ZRuxyeGQZdkrg+jOPhz
j+622ll3lCOEaglB23Rh1unl9rUkb3GC6XJ2ejbv+I/VULqe9qAabpFBeJZSTCVF
arShgs8GFK4FtOG3y5ggZSnCDesyLvsxuqyUf/swpAOMzyIpjTe2zJQ4nibk3IWV
JZXAsxd4ZBc5sHkUI4j76qqGlsQzstVrTmPMdwik/jTZjAOThUZh2xCt4qNs2QyT
X1Lh6VeaBmncmf93GxaslH4HS/VStBCjNapjbSdQLp+iQF0lhEDGtO2NaCYS4MIZ
+p1050TriAVxDxK4nwfW
=mGb2
-----END PGP SIGNATURE-----

--u3bvv0EcKsvvYeex--
