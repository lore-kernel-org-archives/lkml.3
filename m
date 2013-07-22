Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab3GVJ6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:58:04 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51664 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab3GVJ6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:58:01 -0400
Message-ID: <51ED0227.6020204@hitachi.com>
Date: Mon, 22 Jul 2013 18:57:59 +0900
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
Subject: Re: [RFC PATCH V2] tracing: Check f_dentry before accessing event_file/call
 in inode->i_private
References: <20130705003223.GA4981@redhat.com> <20130709075519.2583.96462.stgit@mhiramat-M0-7522> <20130715181659.GA18505@redhat.com> <51E5FD33.4040604@hitachi.com> <20130717145148.GB7358@redhat.com> <51E750F4.5070200@hitachi.com> <20130718145137.GA6014@redhat.com> <51E8CCC0.7030404@hitachi.com> <20130719133327.GA21278@redhat.com>
In-Reply-To: <20130719133327.GA21278@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/19 22:33), Oleg Nesterov wrote:
> On 07/19, Masami Hiramatsu wrote:
>>
>> (2013/07/18 23:51), Oleg Nesterov wrote:
>>> It removes trace_array_get/put from tracing_open_generic_file() and
>>> tracing_release_generic_file(). This assumes that "call->flags++" is
>>> enough, but it is not.
>>
>> No, it replaces trace_array_get/put with ftrace_event_file_get/put
>> which calls trace_array_get/put inside.
> 
> Ah, I didn't notice your patch adds "file->tr->ref++" into
> ftrace_event_file_get...
> 
> So I was wrong in any case, thanks for correcting me.
> 
> But,
> 
>> (Just one point, previous ftrace_event_file_get has a racy point
>> when it does tr->ref++, it should be fixed.)
> 
> Not sure what do you mean, but unless I missed something again this
> "tr->ref++" above still looks racy. instance_delete() checks tr->ref
> first, then it takes event_mutex and removes/kfrees event_files.
> 
> But this doesn't really matter even if I am right, surely this can
> be fixed. My only point, imho this is more complex than necessary.

I see, so I'd like to see the fix. However, I'm not sure
we have enough time to fix that cleanly. Note that except
for the timing bug, we still leave a kernel bug which can
easily be reproduced as Jovi reported.

> In particular,
> 
>>> IOW, I believe that either .open() should do trace_array_get(), or
>>> __trace_remove_event_dirs() needs another for-each-file loop which
>>> checks file->call->flags & TRACE_EVENT_FL_REF_MASK.
>>
>> Agreed :)
> 
> Yes ;) and this makes the ref-counting even more complex, we use
> different methods to avoid the races with rmdir and event_remove().
> 
>>> The same bugs which Steven's 1/4 tries to solve ;)
>>
>> OK, let me confirm that, would you mean we still need 2/4 - 4/4?
> 
> Yes, yes.

And those are depends on 1/4...

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


