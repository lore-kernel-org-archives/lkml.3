Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaGIJT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:19:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53008 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaGIJTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:19:25 -0400
Date: Wed, 9 Jul 2014 11:19:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Message-ID: <20140709091917.GC9918@twins.programming.kicks-ass.net>
References: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
In-Reply-To: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2014 at 09:49:40AM -0700, kan.liang@intel.com wrote:
> +	/*
> +	 * Access LBR MSR may cause #GP under certain circumstances.
> +	 * E.g. KVM doesn't support LBR MSR
> +	 * Check all LBT MSR here.
> +	 * Disable LBR access if any LBR MSRs can not be accessed.
> +	 */
> +	if (x86_pmu.lbr_nr) {
> +		access = check_msr(x86_pmu.lbr_tos);
> +		for (i = 0; i < x86_pmu.lbr_nr; i++) {
> +			access &= check_msr(x86_pmu.lbr_from + i);
> +			access &= check_msr(x86_pmu.lbr_to + i);
> +		}
> +		if (!access)
> +			x86_pmu.lbr_nr = 0;
> +	}

You _could_ write that as:

	if (x86_pmu.lbr_nr) {
		if (!check_msr(x86_pmu.lbr_tos))
			x86_pmu.lbr_nr = 0;
		for (i = 0; i < x86_pmu.lbr_nr; i++) {
			if (!(check_msr(x86_pmu.lbr_from + i) &&
			      check_msr(x86_pmu.lbr_to + i)))
			      x86_pmu.lbr_nr = 0;
		}
	}

There is no point in checking any more MSRs after the first fail after
all.

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvQkVAAoJEHZH4aRLwOS6XMMP/2pubbvOc4B03UMdcbE9Mh4O
gDQ8a+GXZEE5wGvUi9ota4xxQ8YHaSkRRHO4/5H8xD0QC648ivkd4JVviJEfy8WU
zsKgoSLq4IbVzmfRcH4gpA7T7EEdPYLhtzBuGhKdhiVk/vG6Ppeh3xOkI9wEd5sT
NeNdaIGbsxuhmrqb0ey2szdZtNThSVWz+AWPh3ws9dx1rSbJP6fWATSGAUGy2EBW
zsio10c7ilhQol4MSQUXWXEhoZtSRAX1HGNYUQ8LuTD6gzC8M/K+8Ps7gChJAZFO
FqI1V8rmWKyPDOIbOWOWdGZYStOOkJuPLmSr+gV8KUFKGfQJ8Bzc9PjCzj/ShHdE
Ki3cLn5dfneNiteu+CHEAa3LIlb8I7aA5jAzI8PX8uK9QOsq/9F2nd6YKNBgN6Wz
DVXd64dRuSPYstFXQ9D05fErQzXLzilciOyEqkMit5y6hdj+tfhfhpqAXYYFgDMV
6+M1TXjh9xpdNFRm+zYx8Y3g4A3e9sYFW5w7OS2dTXkzjTi3WQYdv9jyzteRQEHL
ljGo7P/qjgTXJpb29nxrl5/xBtXim1z398pXOxjM/dGUXklTZ89JQGaTdtGd77Wo
wg8W1CiFtjspQxPYn48Aeb3zfkccnTns+hm36UPqGizrQkht10mK7HrRO24FdX0b
WO0f6JKK11ZK9IcXYgHC
=jHP2
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
