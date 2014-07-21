Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaGUJyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:54:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbaGUJyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:54:35 -0400
Date: Mon, 21 Jul 2014 11:54:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
Message-ID: <20140721095415.GB8865@krava.redhat.com>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
 <53CCB6AE.6020505@intel.com>
 <20140721080219.GA4183@krava.redhat.com>
 <53CCD3A7.5070002@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CCD3A7.5070002@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:47:35AM +0300, Adrian Hunter wrote:

SNIP

> >>> If PERF_RECORD_FINISHED_ROUND is missing the queue will
> >>
> >> Why is it missing?
> > 
> > it's stored only for tracepoints now patch 17 fixies that
> 
> Wouldn't that make a huge difference all by itself?
> 
> I would make that the first patch, and measure the difference
> that it makes by itself.

yes, that makes the difference.. still I think it's good to control
perf memory allocation and do not let it take gigabytes just because
this event is missing

> >> How do you know the results are still valid?  Wouldn't it
> >> be better to wait that extra 15% and know that the data has
> >> been processed correctly?
> > 
> > The HALF flush could cause the out of order message
> > (which I get occasionaly anyway). Patch 19 allows
> 
> Occasional out-of-order messages would be worth investigating
> IMHO.  Either there is a bug or there is some "interesting"
> data being recorded.

I've got it via 'perf timechart record -I' sometimes:

[jolsa@ibm-x3650m4-01 perf]$ sudo ./perf timechart record -I
^C[ perf record: Woken up 337 times to write data ]
[ perf record: Captured and wrote 290.256 MB perf.data (~12681486 samples) ]
Warning:
Processed 3365931 events and lost 1 chunks!

Check IO/CPU overload!

[jolsa@ibm-x3650m4-01 perf]$ sudo ./perf report --stdio
Timestamp below last timeslice flush
0x2276f58 [0x68]: failed to process type: 9
# To display the perf.data header info, please use --header/--header-only options.
#

I think the reaon might be that one of the CPU mmap buffer
is behind and got data after the round finishes for its
timestamp.. but I haven't checked deeply on this yet

> 
> > out of order events after HALF flush.
> > 
> > The main reason for me was to control the memory allocation,
> > which could get enormous without ROUND events being stored.
> 
> But now you are storing them...
> 
> > The 100MB queue limit seems to be enough not to hit out of
> > order event due to the HALF flush.
> 
> ...so is the 100MB limit needed at all if you have ROUND
> events?

for data files captured without the ROUND events fix

jirka
