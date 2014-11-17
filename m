Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaKQRlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:41:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:8991 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaKQRll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:41:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,404,1413270000"; 
   d="scan'208";a="633299342"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "acme@kernel.org" <acme@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V3 3/3] perf tools: Construct LBR call chain
Thread-Topic: [PATCH V3 3/3] perf tools: Construct LBR call chain
Thread-Index: AQHQABNGcQ1rb+Jn4kS+6OT1ok92KZxkd0KAgACfPbA=
Date: Mon, 17 Nov 2014 17:41:32 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701670BF9@SHSMSX103.ccr.corp.intel.com>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
 <1415972652-17310-4-git-send-email-kan.liang@intel.com>
 <20141117155425.GA31042@krava.brq.redhat.com>
In-Reply-To: <20141117155425.GA31042@krava.brq.redhat.com>
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



> SNIP
> 
> > diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> > index f4478ce..335c3a9 100644
> > --- a/tools/perf/util/session.c
> > +++ b/tools/perf/util/session.c
> > @@ -557,15 +557,63 @@ int perf_session_queue_event(struct
> perf_session *s, union perf_event *event,
> >  	return 0;
> >  }
> >
> > -static void callchain__printf(struct perf_sample *sample)
> > +static void callchain__printf(struct perf_evsel *evsel,
> > +			      struct perf_sample *sample)
> >  {
> >  	unsigned int i;
> > +	struct ip_callchain *callchain = sample->callchain;
> > +	bool lbr = has_branch_callstack(evsel);
> >
> > -	printf("... chain: nr:%" PRIu64 "\n", sample->callchain->nr);
> > +	if (lbr) {
> > +		struct branch_stack *lbr_stack = sample->branch_stack;
> > +		u64 kernel_callchain_nr = callchain->nr;
> >
> > -	for (i = 0; i < sample->callchain->nr; i++)
> > +		for (i = 0; i < kernel_callchain_nr; i++) {
> > +			if (callchain->ips[i] == PERF_CONTEXT_USER)
> > +				break;
> > +		}
> > +
> > +		if ((i != kernel_callchain_nr) && lbr_stack->nr) {
> > +			u64 total_nr;
> > +			/*
> > +			 * LBR callstack can only get user call chain,
> > +			 * i is kernel call chain number,
> > +			 * 1 is PERF_CONTEXT_USER.
> > +			 *
> > +			 * The user call chain is stored in LBR registers.
> > +			 * LBR are pair registers. The caller is stored
> > +			 * in "from" register, while the callee is stored
> > +			 * in "to" register.
> > +			 * For example, there is a call stack
> > +			 * "A"->"B"->"C"->"D".
> > +			 * The LBR registers will recorde like
> > +			 * "C"->"D", "B"->"C", "A"->"B".
> > +			 * So only the first "to" register and all "from"
> > +			 * registers are needed to construct the whole
> stack.
> > +			 */
> 
> Andi is using some sanity checks:
> http://marc.info/?l=linux-kernel&m=141584447819894&w=2
> I guess this could be applied in here, once his patch gets in.
> 

Are you suggesting me to remove the comments,
or rebase the whole patch to Andi's patch once it's merged?

The branch history in Andi's patch is different as the call stack,
although they are both from LBR.
Andi's branch history recording branch records for
taken branches, interrupts, and exceptions.
While the LBR call stack records for the call stack.

Thanks,
Kan

