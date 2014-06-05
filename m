Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaFEOEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:04:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaFEOEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:04:12 -0400
Date: Thu, 5 Jun 2014 16:04:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, zheng.z.yan@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug
 workaround
Message-ID: <20140605140400.GM3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-6-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z/kiM2A+9acXa48/"
Content-Disposition: inline
In-Reply-To: <1401917658-26065-6-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z/kiM2A+9acXa48/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2014 at 11:34:14PM +0200, Stephane Eranian wrote:
> +
> +	/*
> +	 * Modify static constraint with current dynamic
> +	 * state of thread
> +	 *
> +	 * EXCLUSIVE: sibling counter measuring exclusive event
> +	 * SHARED   : sibling counter measuring non-exclusive event
> +	 * UNUSED   : sibling counter unused
> +	 */
> +	for_each_set_bit(i, cx->idxmsk, X86_PMC_IDX_MAX) {
> +		/*
> +		 * exclusive event in sibling counter
> +		 * our corresponding counter cannot be used
> +		 * regardless of our event
> +		 */
> +		if (xl->state[i] == INTEL_EXCL_EXCLUSIVE)
> +			__clear_bit(i, cx->idxmsk);
> +		/*
> +		 * if measuring an exclusive event, sibling
> +		 * measuring non-exclusive, then counter cannot
> +		 * be used
> +		 */
> +		if (is_excl && xl->state[i] == INTEL_EXCL_SHARED)
> +			__clear_bit(i, cx->idxmsk);
> +	}
> +
> +	/*
> +	 * recompute actual bit weight for scheduling algorithm
> +	 */
> +	cx->weight = hweight64(cx->idxmsk64);

So I think we talked about this a bit; what happens if CPU0 (taking your
4 core HSW-client) is first to program its counters and takes all 4 in
exclusive mode?

Then there's none left for CPU4.

Did I miss where we avoid that problem, or is that an actual issue?

--Z/kiM2A+9acXa48/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkHjQAAoJEHZH4aRLwOS6rz4P/1/mMOSGZivDcVwKv4Tuv7Xd
Jfpx2XWxo59tfdAuPcz7Oj8+yUUaf7jXdNlXeoz7117C3WcfOTll+lZmo5/hD31a
WZKjWJ8CpdypLkHLBukAVmpw08YNEHymiiAswMh5CSBWGBBlh8rbmDG+H/M3NWy+
wlTvRWSF5NewZWxMl1IXKutfuIbW/6RKAbHMOybu6+XpW65n93RsF78Vps/HFAKL
v4cIUayQvisGZ10+W0ZC2XK5yz2zpwNbM/sAfWSofxtcO+g2Ar5HatsB3oXMOIu5
jqn25wyFszZhPV8zqnfQ6TIyxiZDhpPQXEpbHP0Qe8RyUpiybGoNH+Arr8QkreWz
G8NqccVmb1o7kbPsi7sNuC71lnG4kPuk4DWUksgeAG0twgjeOO0hd05XhKUChCOm
QSXbFOoXmitpjcGzEuARiOydnP+lAWWA4+yGLjbQqWrizUX2LM2WVLytYxIJ8PHq
vWXsDuSZZhVlTBkUIuUOF5IQqDHJO6ZfRv0Soqp94lHYMkdQ+/EwS9J5Uj5ARWUm
s3bWh5AiTvq4Ge+YqIuJaAG+iiU0yW7F8VPXHMFJD4MthLerlUrfhKn1QbCN/JGh
+k7Desz5j65KYITwjhMTUQBFs00VY2C+pWJTMMMqfKcE/GadMCdDb1rKYkCPBST6
MwUX00sbRzF8i56qYudL
=7StL
-----END PGP SIGNATURE-----

--Z/kiM2A+9acXa48/--
