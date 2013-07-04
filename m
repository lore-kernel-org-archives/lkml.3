Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab3GDMf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:35:27 -0400
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:34240 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752011Ab3GDMfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:35:25 -0400
X-Greylist: delayed 684 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jul 2013 08:35:25 EDT
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Panda: scanned!
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::,RULES_HIT:2:69:152:355:379:599:800:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:1801:1981:2194:2196:2199:2200:2393:2551:2553:2559:2562:2901:2903:2911:2918:3138:3139:3140:3141:3142:3865:3866:3867:3868:3871:3872:3873:4117:4250:4321:4385:4425:4605:5007:6120:7652:7875:7903:8660:9121:10004:10848:11026:11233:11473:11658:11914:12043:12050:12291:12295:12296:12438:12517:12519:12555:12683:12740:
X-HE-Tag: loaf92_5d12e70fc3954
X-Filterd-Recvd-Size: 6630
User-Agent: K-9 Mail for Android
In-Reply-To: <51D566A9.5090406@hitachi.com>
References: <51D4F885.3040105@hitachi.com> <20130704115554.21507.60284.stgit@mhiramat-M0-7522> <51D566A9.5090406@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH] tracing: Atomically get refcounts of event_call and trace_array
From: Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 04 Jul 2013 08:23:52 -0400
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Message-ID: <49439e9b-f738-46d9-ae47-14b45c135cd5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the top post. FYI today is a US holiday and tomorrow I'll probably only work a half day. I may not get a chance to look it till Monday.

-- Steve


Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

>Steven, Oleg,
>
>I think your patches are OK, but not enough.
>Here is an additional patch to fix the unsafe case which I found.
>Could you review this too?
>
>(2013/07/04 20:55), Masami Hiramatsu wrote:
>> Currently ftrace_open_generic_file gets an event_file from
>> inode->i_private, and then locks event_mutex and gets refcount.
>> However, this can cause a race as below scenario;
>> 
>> CPU0                              CPU1
>> open(kprobe_events)
>>   trace_remove_event_call()    open(enable)
>>     lock event_mutex             get event_file from inode->i_private
>>       event_remove()             wait for unlock event_mutex
>>         ...
>>         free event_file
>>     unlock event_mutex
>>                                  lock event_mutex
>>                                  add refcount of event_file->call (*)
>> 
>> So, at (*) point, the event_file is already freed and we
>> may access the corrupted object.
>> The same thing could happen on trace_array because it is also
>> directly accessed from event_file.
>> 
>> To avoid this, when opening events/*/*/enable, we must atomically
>> do; ensure the ftrace_event_file object still exists on a
>trace_array,
>> and get refcounts of event_file->call and the trace_array.
>> 
>> 
>> CPU0                              CPU1
>> open(kprobe_events)
>>   trace_remove_event_call()    open(enable)
>>     lock event_mutex             get event_file from inode->i_private
>>       event_remove()             wait for unlock event_mutex
>>         ...
>>         free event_file
>>     unlock event_mutex
>>                                  lock event_mutex
>>                                  search the event_file and failed
>>                                  unlock event_mutex
>>                                  return -ENODEV
>> 
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>  kernel/trace/trace_events.c |   58
>+++++++++++++++++++++++++++++++++----------
>>  1 file changed, 45 insertions(+), 13 deletions(-)
>> 
>> diff --git a/kernel/trace/trace_events.c
>b/kernel/trace/trace_events.c
>> index 1a5547e..db6b107 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -391,15 +391,24 @@ static void __get_system_dir(struct
>ftrace_subsystem_dir *dir)
>>  	__get_system(dir->subsystem);
>>  }
>>  
>> -static int ftrace_event_call_get(struct ftrace_event_call *call)
>> +static int __ftrace_event_call_get(struct ftrace_event_call *call)
>>  {
>>  	int ret = 0;
>>  
>> -	mutex_lock(&event_mutex);
>>  	if ((call->flags & TRACE_EVENT_FL_REF_MASK) ==
>TRACE_EVENT_FL_REF_MAX - 1)
>>  		ret = -EBUSY;
>>  	else
>>  		call->flags++;
>> +
>> +	return ret;
>> +}
>> +
>> +static int ftrace_event_call_get(struct ftrace_event_call *call)
>> +{
>> +	int ret = 0;
>> +
>> +	mutex_lock(&event_mutex);
>> +	ret = __ftrace_event_call_get(call);
>>  	mutex_unlock(&event_mutex);
>>  
>>  	return ret;
>> @@ -413,6 +422,35 @@ static void ftrace_event_call_put(struct
>ftrace_event_call *call)
>>  	mutex_unlock(&event_mutex);
>>  }
>>  
>> +static int ftrace_event_file_get(struct ftrace_event_file
>*this_file)
>> +{
>> +	struct ftrace_event_file *file;
>> +	struct trace_array *tr;
>> +	int ret = -ENODEV;
>> +
>> +	mutex_lock(&event_mutex);
>> +	do_for_each_event_file(tr, file) {
>> +		if (file == this_file) {
>> +			ret = __ftrace_event_call_get(file->event_call);
>> +			if (!ret)
>> +				tr->ref++;
>> +			goto out_unlock;
>> +		}
>> +	} while_for_each_event_file();
>> + out_unlock:
>> +	mutex_unlock(&event_mutex);
>> +
>> +	return ret;
>> +}
>> +
>> +static void ftrace_event_file_put(struct ftrace_event_file *file)
>> +{
>> +	struct trace_array *tr = file->tr;
>> +
>> +	ftrace_event_call_put(file->event_call);
>> +	trace_array_put(tr);
>> +}
>> +
>>  static void __put_system_dir(struct ftrace_subsystem_dir *dir)
>>  {
>>  	WARN_ON_ONCE(dir->ref_count == 0);
>> @@ -438,33 +476,27 @@ static void put_system(struct
>ftrace_subsystem_dir *dir)
>>  static int tracing_open_generic_file(struct inode *inode, struct
>file *filp)
>>  {
>>  	struct ftrace_event_file *file = inode->i_private;
>> -	struct trace_array *tr = file->tr;
>>  	int ret;
>>  
>> -	if (trace_array_get(tr) < 0)
>> -		return -ENODEV;
>> -
>> -	ret = tracing_open_generic(inode, filp);
>> +	ret = ftrace_event_file_get(file);
>>  	if (ret < 0)
>> -		goto fail;
>> +		return ret;
>>  
>> -	ret = ftrace_event_call_get(file->event_call);
>> +	ret = tracing_open_generic(inode, filp);
>>  	if (ret < 0)
>>  		goto fail;
>>  
>>  	return 0;
>>   fail:
>> -	trace_array_put(tr);
>> +	ftrace_event_file_put(file);
>>  	return ret;
>>  }
>>  
>>  static int tracing_release_generic_file(struct inode *inode, struct
>file *filp)
>>  {
>>  	struct ftrace_event_file *file = inode->i_private;
>> -	struct trace_array *tr = file->tr;
>>  
>> -	ftrace_event_call_put(file->event_call);
>> -	trace_array_put(tr);
>> +	ftrace_event_file_put(file);
>>  
>>  	return 0;
>>  }

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
