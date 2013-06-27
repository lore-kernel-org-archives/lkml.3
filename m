Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3F0Hxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:53:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:28422 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab3F0Hxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:53:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="336253160"
Message-ID: <51CBF0ED.1060701@intel.com>
Date: Thu, 27 Jun 2013 10:59:41 +0300
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
Subject: Re: [PATCH 09/15] perf tools: validate perf event header size
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-10-git-send-email-adrian.hunter@intel.com> <20130625131826.GD23329@krava.brq.redhat.com>
In-Reply-To: <20130625131826.GD23329@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 16:18, Jiri Olsa wrote:
> On Mon, Jun 24, 2013 at 04:16:06PM +0300, Adrian Hunter wrote:
>> 'size' includes the header so must be at least
>> 'sizeof(struct perf_event_header)'.  Error out
>> immediately if that is not the case.  Also
>> don't byte-swap the header until it is actually
>> "fetched" from the mmap region.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/session.c | 14 ++++++++------
>>  1 file changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index 19ea888..7e0d605 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -1094,8 +1094,10 @@ more:
>>  		perf_event_header__bswap(&event->header);
>>  
>>  	size = event->header.size;
>> -	if (size == 0)
>> -		size = 8;
>> +	if (size < sizeof(struct perf_event_header)) {
>> +		pr_err("bad event header size\n");
>> +		goto out_err;
>> +	}
>>  
>>  	if (size > cur_size) {
>>  		void *new = realloc(buf, size);
>> @@ -1161,12 +1163,12 @@ fetch_mmaped_event(struct perf_session *session,
>>  
>>  	event = (union perf_event *)(buf + head);
>>  
>> -	if (session->header.needs_swap)
>> -		perf_event_header__bswap(&event->header);
>> -
>>  	if (head + event->header.size > mmap_size)
>>  		return NULL;
> 
> dont we need to swap first before using event->header.size?

Thanks for reviewing.  Fixed in V2.

