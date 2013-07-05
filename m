Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab3GECcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 22:32:51 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47223 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3GECcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 22:32:50 -0400
Message-ID: <51D63047.7060409@hitachi.com>
Date: Fri, 05 Jul 2013 11:32:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] tracing: Atomically get refcounts of event_call and
 trace_array
References: <51D4F885.3040105@hitachi.com> <20130704115554.21507.60284.stgit@mhiramat-M0-7522> <20130705003223.GA4981@redhat.com>
In-Reply-To: <20130705003223.GA4981@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/05 9:32), Oleg Nesterov wrote:
> On 07/04, Masami Hiramatsu wrote:
>>
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
> 
> Yes, but the same can happen with event_call, so it seems that
> this patch is not enough too.

Oops, right!

> Say, open(id) can take event_mutex when the caller of
> trace_remove_event_call() has already freed ftrace_event_call.
> 
> Or I missed something...
> 
> Perhaps we can rely on d_unlinked() ? IOW, the caller of
> __ftrace_event_call_get() should take event_mutex, check
> d_unhashed(f_dentry) and only then do _get().

It sounds a good idea! :)

Thank you!

> 
> Nasty, I agree.
> 
> Oleg.
> 
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


