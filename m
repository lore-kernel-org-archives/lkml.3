Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3F1Gli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 02:41:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:33648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab3F1Glh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 02:41:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,957,1363158000"; 
   d="scan'208";a="360915052"
Message-ID: <51CD3187.5050603@intel.com>
Date: Fri, 28 Jun 2013 09:47:35 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 15/15] perf tools: fix ppid in thread__fork()
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com> <1372319707-13892-16-git-send-email-adrian.hunter@intel.com> <51CC6F16.40004@gmail.com>
In-Reply-To: <51CC6F16.40004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/13 19:57, David Ahern wrote:
> On 6/27/13 1:55 AM, Adrian Hunter wrote:
>> ppid should be assigned to the parents pid.  Note
>> 'thread__fork()'s only caller 'machine__process_fork_event()'
>> ensures that the parents pid is set.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>   tools/perf/util/thread.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
>> index e3d4a55..93f3eab 100644
>> --- a/tools/perf/util/thread.c
>> +++ b/tools/perf/util/thread.c
>> @@ -85,7 +85,7 @@ int thread__fork(struct thread *self, struct thread
>> *parent)
>>           if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
>>               return -ENOMEM;
>>
>> -    self->ppid = parent->tid;
>> +    self->ppid = parent->pid_;
>>
> 
> knowledge of the specific thread within the parent that created the process
> can be valuable -- that's what we get now. This change drops that
> information. I'd prefer this stays at thread id -- or save the parent thread
> id in addition to the pid.

That means renaming ppid to ptid.  Do you want to do that?

Isn't it possible that the parent could exit and the pid or tid be re-used
for another process?  In that case, to reliable identify the parent a
pointer to its struct thread would be needed.  i.e.

diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -14,6 +14,7 @@ struct thread {
        struct map_groups       mg;
        pid_t                   pid_; /* Not all tools update this */
        pid_t                   tid;
-       pid_t                   ppid;
+       struct thread           *parent;
        char                    shortname[3];
        bool                    comm_set;

However that means tracking the lifetime of 'parent' to ensure that it is
not left dangling.

Do you want to do that?
