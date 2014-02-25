Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaBYDfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:35:06 -0500
Received: from ozlabs.org ([203.10.76.45]:52051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaBYDd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:33:29 -0500
In-Reply-To: <1392415338-16288-8-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 07/11] powerpc: add a shared interface to get gpci version and capabilities
Message-Id: <20140225033328.C5A9E2C0324@ozlabs.org>
Date: Tue, 25 Feb 2014 14:33:28 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH v2 07/11] powerpc: add a shared interface to get gpci version and capabilities

All the patches that touch perf should be "powerpc/perf: foo"

On Fri, 2014-14-02 at 22:02:11 UTC, Cody P Schafer wrote:
> ...

I realise this is a fairly small patch but a changelog is still nice. You could
for example mention that we don't currently use .ga, .expanded or .lab but
we're adding the logic anyway because ...


> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  arch/powerpc/perf/hv-common.c | 39 +++++++++++++++++++++++++++++++++++++++
>  arch/powerpc/perf/hv-common.h | 17 +++++++++++++++++
>  2 files changed, 56 insertions(+)
>  create mode 100644 arch/powerpc/perf/hv-common.c
>  create mode 100644 arch/powerpc/perf/hv-common.h
> 
> diff --git a/arch/powerpc/perf/hv-common.c b/arch/powerpc/perf/hv-common.c
> new file mode 100644
> index 0000000..47e02b3
> --- /dev/null
> +++ b/arch/powerpc/perf/hv-common.c
> @@ -0,0 +1,39 @@
> +#include <asm/io.h>
> +#include <asm/hvcall.h>
> +
> +#include "hv-gpci.h"
> +#include "hv-common.h"
> +
> +unsigned long hv_perf_caps_get(struct hv_perf_caps *caps)
> +{
> +	unsigned long r;
> +	struct p {
> +		struct hv_get_perf_counter_info_params params;
> +		struct cv_system_performance_capabilities caps;
> +	} __packed __aligned(sizeof(uint64_t));
> +
> +	struct p arg = {
> +		.params = {
> +			.counter_request = cpu_to_be32(
> +					CIR_SYSTEM_PERFORMANCE_CAPABILITIES),
> +			.starting_index = cpu_to_be32(-1),
> +			.counter_info_version_in = 0,
> +		}
> +	};
> +
> +	r = plpar_hcall_norets(H_GET_PERF_COUNTER_INFO,
> +			       virt_to_phys(&arg), sizeof(arg));
> +
> +	if (r)
> +		return r;
> +
> +	pr_devel("capability_mask: 0x%x\n", arg.caps.capability_mask);
> +
> +	caps->version = arg.params.counter_info_version_out;
> +	caps->collect_privileged = !!arg.caps.perf_collect_privileged;
> +	caps->ga = !!(arg.caps.capability_mask & CV_CM_GA);
> +	caps->expanded = !!(arg.caps.capability_mask & CV_CM_EXPANDED);
> +	caps->lab = !!(arg.caps.capability_mask & CV_CM_LAB);
> +
> +	return r;
> +}
> diff --git a/arch/powerpc/perf/hv-common.h b/arch/powerpc/perf/hv-common.h
> new file mode 100644
> index 0000000..7e615bd
> --- /dev/null
> +++ b/arch/powerpc/perf/hv-common.h
> @@ -0,0 +1,17 @@
> +#ifndef LINUX_POWERPC_PERF_HV_COMMON_H_
> +#define LINUX_POWERPC_PERF_HV_COMMON_H_
> +
> +#include <linux/types.h>
> +
> +struct hv_perf_caps {
> +	u16 version;
> +	u16 collect_privileged:1,
> +	    ga:1,
> +	    expanded:1,
> +	    lab:1,
> +	    unused:12;
> +};
> +
> +unsigned long hv_perf_caps_get(struct hv_perf_caps *caps);
> +
> +#endif
> -- 
> 1.8.5.4
> 
> 
