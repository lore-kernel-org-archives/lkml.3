Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452Ab3GSFVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:21:12 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34419 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab3GSFVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:21:10 -0400
Message-ID: <51E8CCC0.7030404@hitachi.com>
Date: Fri, 19 Jul 2013 14:21:04 +0900
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
Subject: Re: Re: [RFC PATCH V2] tracing: Check f_dentry before accessing
 event_file/call in inode->i_private
References: <20130705003223.GA4981@redhat.com> <20130709075519.2583.96462.stgit@mhiramat-M0-7522> <20130715181659.GA18505@redhat.com> <51E5FD33.4040604@hitachi.com> <20130717145148.GB7358@redhat.com> <51E750F4.5070200@hitachi.com> <20130718145137.GA6014@redhat.com>
In-Reply-To: <20130718145137.GA6014@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/18 23:51), Oleg Nesterov wrote:
> On 07/18, Masami Hiramatsu wrote:
>>
>> (2013/07/17 23:51), Oleg Nesterov wrote:
>>> Well, perhaps you are right... But this TRACE_EVENT_FL_REF_MASK code
>>> is new too, it is not that we only need a small fixlets to finish it.
>>
>> Would you mean that TRACE_EVENT_FL_REF_MASK may also have some problems?
> 
> It was you who initially pointed that it does have problems ;)
> 
> And, _afaics_ your patch which tries to fix this problem is not
> exactly correct.

Hm,

> It removes trace_array_get/put from tracing_open_generic_file() and
> tracing_release_generic_file(). This assumes that "call->flags++" is
> enough, but it is not.

No, it replaces trace_array_get/put with ftrace_event_file_get/put
which calls trace_array_get/put inside.
(Just one point, previous ftrace_event_file_get has a racy point
when it does tr->ref++, it should be fixed.)

> Yes, the next patch adds the "flags & TRACE_EVENT_FL_REF_MASK" check
> into trace_remove_event_call() path. But this is still racy wrt
> instance_delete() unless I missed something.
> 
> IOW, I believe that either .open() should do trace_array_get(), or
> __trace_remove_event_dirs() needs another for-each-file loop which
> checks file->call->flags & TRACE_EVENT_FL_REF_MASK.

Agreed :)

>>> So I think that it makes sense to discuss the alternatives before we
>>> decide what exactly we should do.
>>
>> Your approach is also interesting for me, indeed. However, it is so
>> different from current one. I think you should clarify what bug you
>> would like to solve and how.
> 
> The same bugs which Steven's 1/4 tries to solve ;)

OK, let me confirm that, would you mean we still need 2/4 - 4/4?

Thank you,
-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


