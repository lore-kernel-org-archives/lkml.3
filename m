Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3GQHzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:55:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:19411 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab3GQHzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:55:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,682,1367996400"; 
   d="scan'208";a="332530896"
Message-ID: <51E64F7C.4040307@intel.com>
Date: Wed, 17 Jul 2013 11:02:04 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V6 06/12] perf tools: remove unnecessary callchain validation
References: <1373956698-27540-1-git-send-email-adrian.hunter@intel.com> <1373956698-27540-7-git-send-email-adrian.hunter@intel.com> <20130716120549.GB9964@krava.brq.redhat.com>
In-Reply-To: <20130716120549.GB9964@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/13 15:05, Jiri Olsa wrote:
> On Tue, Jul 16, 2013 at 09:38:12AM +0300, Adrian Hunter wrote:
> 
> SNIP
> 
>>  	}
>>  }
>>  
>> -static int perf_session__preprocess_sample(struct perf_session *session,
>> -					   union perf_event *event, struct perf_sample *sample)
>> -{
>> -	if (event->header.type != PERF_RECORD_SAMPLE ||
>> -	    !sample->callchain)
>> -		return 0;
>> -
>> -	if (!ip_callchain__valid(sample->callchain, event)) {
>> -		pr_debug("call-chain problem with event, skipping it.\n");
>> -		++session->stats.nr_invalid_chains;
>> -		session->stats.total_invalid_chains += sample->period;
> 
> How about the '*invalid_chains' stats here? I dont see
> it incremented in the parsing routine.
> 
> Also the current behaviour is to increments stats for invalid
> callchains, but dont fail. With your changes we fail during the
> parsing.

It would fail during parsing sometimes anyway.  The code was:

	if (type & PERF_SAMPLE_CALLCHAIN) {
		if (sample_overlap(event, array, sizeof(data->callchain->nr)))
			return -EFAULT;

		data->callchain = (struct ip_callchain *)array;

		if (sample_overlap(event, array, data->callchain->nr))
			return -EFAULT;

		array += 1 + data->callchain->nr;
	}

But sample overlap did not handle size being effectively negative
i.e. 'offset + size' overflows

static bool sample_overlap(const union perf_event *event,
			   const void *offset, u64 size)
{
	const void *base = event;

	if (offset + size > base + event->header.size)
		return true;

	return false;
}


> 
> On the other hand.. maybe we should fail ;-) I think that
> invalid callchain data is serious enough to be overlooked
> by not seeing the nr_invalid_chains got incremented.
> 
> let's see other comments and then silently push it :-)
> 
> jirka
> 
> 

