Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbaIEIoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:44:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:44120 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087AbaIEIoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,471,1406617200"; 
   d="scan'208";a="598403882"
Message-ID: <54097793.4050201@intel.com>
Date: Fri, 05 Sep 2014 11:42:59 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/10] perf record: Filter out POLLHUP'ed file descriptors
References: <1409781604-16778-1-git-send-email-acme@kernel.org> <1409781604-16778-5-git-send-email-acme@kernel.org> <54085BC8.40403@intel.com> <20140904151902.GE2997@kernel.org>
In-Reply-To: <20140904151902.GE2997@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 06:19 PM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Sep 04, 2014 at 03:32:08PM +0300, Adrian Hunter escreveu:
>> On 09/04/2014 12:59 AM, Arnaldo Carvalho de Melo wrote:
>>> So that we don't continue polling on vanished file descriptors, i.e.
>>> file descriptors for events monitoring threads that exited.
> 
>>> I.e. the following 'perf record' command now exits as expected, instead
>>> of staying in an eternal loop:
> 
>>>   $ sleep 5s &
>>>   $ perf record -p `pidof sleep`
> 
>>> Reported-by: Jiri Olsa <jolsa@redhat.com>
> <SNIP>
>>> +++ b/tools/perf/builtin-record.c
>>> @@ -467,6 +467,9 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
>>>  			if (err > 0 || (err < 0 && errno == EINTR))
>>>  				err = 0;
>>>  			waking++;
>>> +			if (perf_evlist__filter_pollfd(rec->evlist, POLLERR | POLLHUP) == 0)
>>
>> If the poll fds only include the ones mmapped, then mightn't it filter out
>> ones still in use? e.g. what if you record two processes and one exits?
> 
> Humm, without looking at the code, we would be needlessly looking at the
> mmaps for the threads that exited.
> 
> I.e. we need to associate at the fdarray level the mmaps for the
> descriptors, so that we can, at fdarray__filter() time, munmap the
> POLLHUPed descriptors, right?
> 
> I'll take a look at the code to see what is needed.
> 
> But then this makes the patch set good for a class of problems while
> maintaining existing behaviour for the case you outlined, i.e. this is a
> partial fix and should go now, with further patches on top of it?

No I was meaning something different. For example, 'perf record' opens an
event for 2 processes per-cpu and gets 4 file descriptors:

	task1	task2
cpu0	fd0	fd1
cpu1	fd2	fd3

Now, perf record will mmap fd0 and fd2 and set-output fd1->fd0
and fd3->fd2.

pollfds includes only fd0 and fd2.

But if task2 exits, the POLLHUP will appear on fd1 and fd3.

I think Jiri's patchset changed pollfds to include all fds for that reason.

