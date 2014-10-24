Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbaJXOu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:50:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:21223 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768AbaJXOuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:50:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,780,1406617200"; 
   d="scan'208";a="595297521"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: RE: [PATCH V6 13/17] perf, x86: enable LBR callstack when recording
 callchain
Thread-Topic: [PATCH V6 13/17] perf, x86: enable LBR callstack when
 recording callchain
Thread-Index: AQHP6+jUbbj6arIphUytjgnH1ldUtZw+wfgAgACMtIA=
Date: Fri, 24 Oct 2014 14:49:52 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770164929D@SHSMSX103.ccr.corp.intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
 <1413755712-8259-14-git-send-email-kan.liang@intel.com>
 <20141024133936.GD1036@krava.brq.redhat.com>
In-Reply-To: <20141024133936.GD1036@krava.brq.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> On Sun, Oct 19, 2014 at 05:55:08PM -0400, Kan Liang wrote:
> > Only enable LBR callstack when user requires fp callgraph. The feature
> > is not available when PERF_SAMPLE_BRANCH_STACK or
> > PERF_SAMPLE_STACK_USER is required.
> > Also, this feature only affects how to get user callchain. The kernel
> > callchain is always got by frame pointers.
> >
> > Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> > Signed-off-by: Kan Liang <kan.liang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event.c | 18 ++++++++++++++++--
> >  1 file changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/perf_event.c
> > b/arch/x86/kernel/cpu/perf_event.c
> > index 9656b9e..b3256a3 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -424,10 +424,24 @@ int x86_pmu_hw_config(struct perf_event
> *event)
> >  			if (!event->attr.exclude_kernel)
> >  				*br_type |=
> PERF_SAMPLE_BRANCH_KERNEL;
> >  		}
> > -	}
> > +	} else if (x86_pmu_has_lbr_callstack() &&
> > +		   (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
> &&
> > +		   !(event->attr.sample_type & PERF_SAMPLE_STACK_USER)
> &&
> > +		   !has_branch_stack(event) &&
> > +		   !event->attr.exclude_user &&
> > +		   (event->attach_state & PERF_ATTACH_TASK)) {
> > +		/*
> > +		 * user did not specify branch_sample_type,
> > +		 * try using the LBR call stack facility to
> > +		 * record call chains of user program.
> > +		 */
> > +		event->attr.branch_sample_type =
> > +			PERF_SAMPLE_BRANCH_USER |
> > +			PERF_SAMPLE_BRANCH_CALL_STACK;
> >
> 
> I dont see PERF_SAMPLE_BRANCH_CALL_STACK being defind in uapi.. any
> reason why I cant enable this feature explicitly?


The LBR call stack has some limitations. E.g. the feature is only for HSW+.
It is only available for user callchain. We cannot collect branch information
and call chain by LBR at the same time.. So the feature is designed as
an alternative way to get callgraph, and it isn't exposed to enable.
Otherwise, it may confuse the user. He enables the BRANCH_CALL_STACK, 
but the data is only partly or even not at all from hardware.

We have an option for perf report, the user can choose the preferred data
source. User can set it to LBR. So it tries LBR data first. If not available, it
tries FP then. The user cannot lose any callchain data. 

Thanks,
Kan

> 
> thanks,
> jirka
