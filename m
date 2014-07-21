Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaGUICl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:02:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbaGUICj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:02:39 -0400
Date: Mon, 21 Jul 2014 10:02:19 +0200
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
Message-ID: <20140721080219.GA4183@krava.redhat.com>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
 <53CCB6AE.6020505@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CCB6AE.6020505@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 09:43:58AM +0300, Adrian Hunter wrote:
> On 07/21/2014 12:55 AM, Jiri Olsa wrote:
> > hi,
> > this patchset factors session's ordered samples queue,
> > and allows to limit the size of this queue.
> > 
> > v3 changes:
> >   - rebased to latest tip/perf/core
> >   - add comment for WARN in patch 8 (David)
> >   - added ordered-events debug variable (David)
> >   - renamed ordered_events_(get|put) to ordered_events_(new|delete)
> >   - renamed struct ordered_events_queue to struct ordered_events
> > 
> > v2 changes:
> >   - several small changes for review comments (Namhyung)
> > 
> > 
> > The report command queues events till any of following
> > conditions is reached:
> >   - PERF_RECORD_FINISHED_ROUND event is processed
> >   - end of the file is reached
> > 
> > Any of above conditions will force the queue to flush some
> > events while keeping all allocated memory for next events.
> > 
> > If PERF_RECORD_FINISHED_ROUND is missing the queue will
> 
> Why is it missing?

it's stored only for tracepoints now patch 17 fixies that

> 
> > allocate memory for every single event in the perf.data.
> > This could lead to enormous memory consuption and speed
> > degradation of report command for huge perf.data files.
> > 
> > With the quue allocation limit of 100 MB, I've got around
> > 15% speedup on reporting of ~10GB perf.data file.
> 
> How do you know the results are still valid?  Wouldn't it
> be better to wait that extra 15% and know that the data has
> been processed correctly?

The HALF flush could cause the out of order message
(which I get occasionaly anyway). Patch 19 allows
out of order events after HALF flush.

The main reason for me was to control the memory allocation,
which could get enormous without ROUND events being stored.
The 100MB queue limit seems to be enough not to hit out of
order event due to the HALF flush.

jirka
