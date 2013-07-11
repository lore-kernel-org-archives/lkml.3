Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab3GKPno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 11:43:44 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52016 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab3GKPnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 11:43:43 -0400
Message-ID: <51DED2AA.6030307@gmail.com>
Date: Thu, 11 Jul 2013 09:43:38 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V5 09/12] perf: make events stream always parsable
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com> <1373548341-24119-10-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1373548341-24119-10-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/13 7:12 AM, Adrian Hunter wrote:
> The event stream is not always parsable because the format of a sample
> is dependent on the sample_type of the selected event.  When there
> is more than one selected event and the sample_types are not the
> same then parsing becomes problematic.  A sample can be matched to its
> selected event using the ID that is allocated when the event is opened.
> Unfortunately, to get the ID from the sample means first parsing it.

Here's an alternative suggestion -- one that does not involve changing 
the kernel API or requiring a common denominator in sample_type options.

perf handles event streams through an mmap which can be directly tied to 
an evsel (a single event) when the mmap is created. ie., when events are 
read we know exactly which evsel they correspond to. (See 
perf_evlist__mmap_per_cpu and perf_evlist__mmap_per_thread and add 
struct perf_evsel *evsel entry to struct perf_mmap).

Commands like perf-record can inject a user event into the stream and 
hence the data file every time the evsel changes while walking all of 
the mmap's reading events -- very  similar to the way finished round is 
done. The event would only contain a perf_event_header which is 8 bytes 
so this does not add a lot to a data file. As an optimization the evsel 
event could only be injected if the sample_types differ.

Live commands would just use the evsel connected to the mmap -- no 
lookups needed which would simplify things a bit processing the events.

In short, the information to associate event streams to an event (evsel) 
is currently available -- it's just being discarded in the many layers.

I'll try to whip up some code that implements this in the next few days.

David

