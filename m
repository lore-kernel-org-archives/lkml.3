Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3F0Hwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:52:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:8562 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab3F0Hwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:52:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="336252797"
Message-ID: <51CBF0AF.7060608@intel.com>
Date: Thu, 27 Jun 2013 10:58:39 +0300
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
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/15] perf tools: fix missing tool parameter
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-3-git-send-email-adrian.hunter@intel.com> <20130625130434.GB23329@krava.brq.redhat.com>
In-Reply-To: <20130625130434.GB23329@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 16:04, Jiri Olsa wrote:
> On Mon, Jun 24, 2013 at 04:15:59PM +0300, Adrian Hunter wrote:
>> perf inject expects to get a reference to 'struct perf_inject'
>> from its 'tool' member.  For that to work, 'tool' needs to be
>> a parameter of all tool callbacks.  Make it so.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/builtin-inject.c | 24 ++++++++++--------------
>>  tools/perf/util/header.c    |  6 ++++--
>>  tools/perf/util/header.h    |  6 ++++--
>>  tools/perf/util/session.c   | 11 +++++++----
>>  tools/perf/util/tool.h      |  9 ++++-----
>>  5 files changed, 29 insertions(+), 27 deletions(-)
>>
>> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
>> index f299ddf..fb341f1 100644
>> --- a/tools/perf/builtin-inject.c
>> +++ b/tools/perf/builtin-inject.c
>> @@ -73,22 +73,17 @@ static int perf_event__repipe_event_type_synth(struct perf_tool *tool,
>>  	return perf_event__repipe_synth(tool, event);
>>  }
>>  
>> -static int perf_event__repipe_tracing_data_synth(union perf_event *event,
>> -						 struct perf_session *session
>> -						 __maybe_unused)
>> -{
>> -	return perf_event__repipe_synth(NULL, event);
>> -}
>> -
>> -static int perf_event__repipe_attr(union perf_event *event,
>> -				   struct perf_evlist **pevlist __maybe_unused)
>> +static int perf_event__repipe_attr(struct perf_tool *tool,
>> +				   union perf_event *event,
>> +				   struct perf_evlist **pevlist)
>>  {
>>  	int ret;
>> -	ret = perf_event__process_attr(event, pevlist);
>> +
>> +	ret = perf_event__process_attr(tool, event, pevlist);
>>  	if (ret)
>>  		return ret;
>>  
>> -	return perf_event__repipe_synth(NULL, event);
>> +	return perf_event__repipe_synth(tool, event);
>>  }
>>  
>>  static int perf_event__repipe(struct perf_tool *tool,
>> @@ -147,13 +142,14 @@ static int perf_event__repipe_fork(struct perf_tool *tool,
>>  	return err;
>>  }
>>  
>> -static int perf_event__repipe_tracing_data(union perf_event *event,
>> +static int perf_event__repipe_tracing_data(struct perf_tool *tool,
>> +					   union perf_event *event,
>>  					   struct perf_session *session)
>>  {
>>  	int err;
>>  
>>  	perf_event__repipe_synth(NULL, event);
> 
> wouldn't this one cause segfault?

Thanks for reviewing.  Fixed in V2.
