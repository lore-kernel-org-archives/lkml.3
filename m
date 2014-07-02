Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaGBKuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:50:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56587 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaGBKuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:50:08 -0400
Date: Wed, 2 Jul 2014 12:49:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 09/16] perf, x86: Save/resotre LBR stack during
 context switch
Message-ID: <20140702104958.GB6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-10-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7HcxP2Wm84z5MHiD"
Content-Disposition: inline
In-Reply-To: <1404118253-19532-10-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7HcxP2Wm84z5MHiD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 04:50:46PM +0800, Yan, Zheng wrote:
>  void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched=
_in)
>  {
>  	struct cpu_hw_events *cpuc =3D &__get_cpu_var(cpu_hw_events);
> +	struct x86_perf_task_context *task_ctx;
> =20
>  	if (!x86_pmu.lbr_nr)
>  		return;
> =20
>  	/*
> +	 * If LBR callstack feature is enabled and the stack was saved when
> +	 * the task was scheduled out, restore the stack. Otherwise flush
> +	 * the LBR stack.
>  	 */
> +	task_ctx =3D ctx ? ctx->task_ctx_data : NULL;
>  	if (sched_in) {
> +		if (task_ctx &&
> +		    task_ctx->lbr_callstack_users > 0 &&
> +		    task_ctx->lbr_stack_state =3D=3D LBR_VALID)
> +			__intel_pmu_lbr_restore(task_ctx);
> +		else
> +			intel_pmu_lbr_reset();
> +
>  		cpuc->lbr_context =3D ctx;
> +		return;
> +	}
> +
> +	/* schedule out */
> +	if (task_ctx) {
> +		if (task_ctx->lbr_callstack_users)
> +			__intel_pmu_lbr_save(task_ctx);
> +		else
> +			task_ctx->lbr_stack_state =3D LBR_NONE;
>  	}
>  }

I can't say that's pretty..

How about something like:

	task_ctx =3D ctx->task_ctx_data; /* XXX I don't think ctx can ever be NULL=
 here */
	if (task_ctx) {
		if (sched_in)
			intel_pmu_lbr_restore(task_ctx);
		else
			intel_pmu_lbr_save(task_ctx);
		return;
	}

	if (sched_in)
		intel_pmu_lbr_reset();


And then push all the callstack_users and state nonsense into the
save/restore functions.

--7HcxP2Wm84z5MHiD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs+PWAAoJEHZH4aRLwOS6XLMQAIPhMpZx+WUqYkzLXgqStL3r
bb5bcCFSichfhELGpezorcA3R2yYxhiq6s+3yY0bJxNjQZG2pu0fB8LZFCWtFnTA
jqo0sRuAt97BXgPcrQYxyzIrQknSZaa+/NgqC6xVWNf8Jlir61GUDmfUeNpSRQQv
OjUlyFnmuByPi3y+Qmz2XkFLbgaA+pszvHBTdx7eKft0gr299UB1ngb3wBWr4ddd
QQZ40wO4ObRlPpxx3IqhNwA/xSXiYaz43GhgXZDu7+EzJarfH/Vz65Wr/HSq6huQ
QYFZMBXfj82WBTYyS69Kmj69N0VuRgyGM76a3uAUBxWl3cqnfJINSSlzCz4zfp0Z
wEpKHOzKnkiUCvuE+hEDlrBhBRegjVz0JOZ2R7EwJrpwMj5OAfzm4mFWygd7CqMz
5wHxQjpArOzePXBW4eORmWWKaY/4GTdzdB2XqI13awsB5+El4f+kMS/cjxwiCO0A
622EwQDiCnip8MbTWh/kGFIJse+QtosOz6IlH87gBGpEAU4v4xsiaPnsPHx3cVtY
gxUAZ1cdg/8NKBQucjxEYZ0lLjgHG1WKj5Eacn6Ns1wEL+79pWypAxCH9Occ1KaB
9yLnYCOmVgeKeo+lNO9973bsHk7YVfLqpliUCBj4O4apMyo9dY/iVISjKNCdemk1
vfODkPAgnhOM3IQndp+U
=5Wfz
-----END PGP SIGNATURE-----

--7HcxP2Wm84z5MHiD--
