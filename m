Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaKRGNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:13:53 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56612 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaKRGNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:13:52 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: "Liang\, Kan" <kan.liang@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, "acme\@kernel.org" <acme@kernel.org>,
        "a.p.zijlstra\@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian\@google.com" <eranian@google.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "paulus\@samba.org" <paulus@samba.org>,
        "ak\@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V3 3/3] perf tools: Construct LBR call chain
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
	<1415972652-17310-4-git-send-email-kan.liang@intel.com>
	<20141117155425.GA31042@krava.brq.redhat.com>
	<37D7C6CF3E00A74B8858931C1DB2F07701670BF9@SHSMSX103.ccr.corp.intel.com>
Date: Tue, 18 Nov 2014 15:13:50 +0900
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F07701670BF9@SHSMSX103.ccr.corp.intel.com>
	(Kan Liang's message of "Mon, 17 Nov 2014 17:41:32 +0000")
Message-ID: <87lhn9qbmp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014 17:41:32 +0000, Kan Liang wrote:
>> SNIP
>> 
>> > diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> > index f4478ce..335c3a9 100644
>> > --- a/tools/perf/util/session.c
>> > +++ b/tools/perf/util/session.c
>> > @@ -557,15 +557,63 @@ int perf_session_queue_event(struct
>> perf_session *s, union perf_event *event,
>> >  	return 0;
>> >  }
>> >
>> > -static void callchain__printf(struct perf_sample *sample)
>> > +static void callchain__printf(struct perf_evsel *evsel,
>> > +			      struct perf_sample *sample)
>> >  {
>> >  	unsigned int i;
>> > +	struct ip_callchain *callchain = sample->callchain;
>> > +	bool lbr = has_branch_callstack(evsel);
>> >
>> > -	printf("... chain: nr:%" PRIu64 "\n", sample->callchain->nr);
>> > +	if (lbr) {
>> > +		struct branch_stack *lbr_stack = sample->branch_stack;
>> > +		u64 kernel_callchain_nr = callchain->nr;
>> >
>> > -	for (i = 0; i < sample->callchain->nr; i++)
>> > +		for (i = 0; i < kernel_callchain_nr; i++) {
>> > +			if (callchain->ips[i] == PERF_CONTEXT_USER)
>> > +				break;
>> > +		}
>> > +
>> > +		if ((i != kernel_callchain_nr) && lbr_stack->nr) {
>> > +			u64 total_nr;
>> > +			/*
>> > +			 * LBR callstack can only get user call chain,
>> > +			 * i is kernel call chain number,
>> > +			 * 1 is PERF_CONTEXT_USER.
>> > +			 *
>> > +			 * The user call chain is stored in LBR registers.
>> > +			 * LBR are pair registers. The caller is stored
>> > +			 * in "from" register, while the callee is stored
>> > +			 * in "to" register.
>> > +			 * For example, there is a call stack
>> > +			 * "A"->"B"->"C"->"D".
>> > +			 * The LBR registers will recorde like
>> > +			 * "C"->"D", "B"->"C", "A"->"B".
>> > +			 * So only the first "to" register and all "from"
>> > +			 * registers are needed to construct the whole
>> stack.
>> > +			 */
>> 
>> Andi is using some sanity checks:
>> http://marc.info/?l=linux-kernel&m=141584447819894&w=2
>> I guess this could be applied in here, once his patch gets in.
>> 
>
> Are you suggesting me to remove the comments,
> or rebase the whole patch to Andi's patch once it's merged?
>
> The branch history in Andi's patch is different as the call stack,
> although they are both from LBR.
> Andi's branch history recording branch records for
> taken branches, interrupts, and exceptions.
> While the LBR call stack records for the call stack.

Right.  And branch history can overlap with normal callchains so
additional check in there is to remove duplication.  While LBR call
stack is separated to user only so there should be no overlap.

Thanks,
Namhyung
