Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaKSOdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:33:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:54829 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbaKSOdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:33:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,417,1413270000"; 
   d="scan'208";a="639721933"
From: "Liang, Kan" <kan.liang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: "acme@kernel.org" <acme@kernel.org>, "jolsa@redhat.com" <jolsa@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V4 1/3] perf tools: enable LBR call stack support
Thread-Topic: [PATCH V4 1/3] perf tools: enable LBR call stack support
Thread-Index: AQHQA8c7ODa7l2FB7kKmHK6r8bJvrpxn/6hg
Date: Wed, 19 Nov 2014 14:32:08 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701671D25@SHSMSX103.ccr.corp.intel.com>
References: <1416346617-3577-1-git-send-email-kan.liang@intel.com>
	<1416346617-3577-2-git-send-email-kan.liang@intel.com>
 <87r3wzpt4o.fsf@sejong.aot.lge.com>
In-Reply-To: <87r3wzpt4o.fsf@sejong.aot.lge.com>
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



> On Tue, 18 Nov 2014 16:36:55 -0500, kan liang wrote:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > Currently, there are two call chain recording options, fp and dwarf.
> > Haswell has a new feature that utilizes the existing LBR facility to
> > record call chains. So it provides the third options to record call
> > chain. This patch enables the lbr call stack support.
> >
> > LBR call stack has some limitations. It reuses current LBR facility,
> > so LBR call stack and branch record can not be enabled at the same
> > time. It is only available for user callchain.
> > However, LBR call stack can work on the user app which doesn't have
> > frame-pointer or dwarf debug info compiled. It is a good alternative
> > when nothing else works.
> 
> 
> [SNIP]
> >  static void
> > -perf_evsel__config_callgraph(struct perf_evsel *evsel)
> > +perf_evsel__config_callgraph(struct perf_evsel *evsel,
> > +			     struct record_opts *opts)
> >  {
> >  	bool function = perf_evsel__is_function_event(evsel);
> >  	struct perf_event_attr *attr = &evsel->attr;
> >
> >  	perf_evsel__set_sample_bit(evsel, CALLCHAIN);
> >
> > +	if (callchain_param.record_mode == CALLCHAIN_LBR) {
> > +		if (!opts->branch_stack) {
> > +			perf_evsel__set_sample_bit(evsel,
> BRANCH_STACK);
> > +			attr->branch_sample_type =
> PERF_SAMPLE_BRANCH_USER |
> > +
> 	PERF_SAMPLE_BRANCH_CALL_STACK;
> > +			if (attr->exclude_user) {
> > +				attr->exclude_user = 0;
> > +
> > +				pr_warning("LBR callstack option is only
> available"
> > +					   " to get user callchain
> information."
> > +					   " Force exclude_user to 0.\n");
> > +			}
> 
> I'm not sure what's in a higher priority - maybe I missed earlier discussion.
> IOW what about this?
> 
> 			if (attr->exclude_user) {
> 				pr_warning("LBR callstack option is only
> available"
> 					   " to get user callchain
> information.\n");

I think either is fine. I'd like to add more info "Falling back to framepointers."
based on your changes.
So the user know what they will get then.

What do you think?

pr_warning("LBR callstack option is only available"
	         " to get user callchain information."
	          " Falling back to framepointers.\n");

pr_ warning ("Cannot use LBR callstack with branch stack"
                " Falling back to framepointers.\n");

Thanks,
Kan
> 			} else {
> 				perf_evsel__set_sample_bit(evsel,
> BRANCH_STACK);
> 				attr->branch_sample_type =
> PERF_SAMPLE_BRANCH_USER |
> 
> 	PERF_SAMPLE_BRANCH_CALL_STACK;
> 			}
> 
> > +		} else
> > +			 pr_info("Cannot use LBR callstack with branch
> stack\n");
> 
> It seems pr_warning is more appropriate here.
> 
> Thanks,
> Namhyung
> 
> 
> > +	}
> > +
> >  	if (callchain_param.record_mode == CALLCHAIN_DWARF) {
> >  		if (!function) {
> >  			perf_evsel__set_sample_bit(evsel, REGS_USER);
> @@ -659,7 +676,7 @@
> > void perf_evsel__config(struct perf_evsel *evsel, struct record_opts
> *opts)
> >  	}
> >
> >  	if (callchain_param.enabled && !evsel->no_aux_samples)
> > -		perf_evsel__config_callgraph(evsel);
> > +		perf_evsel__config_callgraph(evsel, opts);
> >
> >  	if (target__has_cpu(&opts->target))
> >  		perf_evsel__set_sample_bit(evsel, CPU);
