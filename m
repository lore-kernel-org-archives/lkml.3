Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab3GRISd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:18:33 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55364 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab3GRIS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:18:29 -0400
Message-ID: <51E7A4CF.2050404@hitachi.com>
Date: Thu, 18 Jul 2013 17:18:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] tracing: fix open/delete fixes
References: <20130716185658.GA21167@redhat.com> <51E6032B.7070907@hitachi.com> <20130717144357.GA7358@redhat.com>
In-Reply-To: <20130717144357.GA7358@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/17 23:43), Oleg Nesterov wrote:
> On 07/17, Masami Hiramatsu wrote:
>>
>> At a glance, you're trying to change which operation will be
>> failed. Currently, user can not remove an event while someone
>> opens files which related to the event. And this approach
>> changes that the someone can remove the event even if the
>> files are opened (and read/write operation will be failed).
>> Am I understand correctly?
> 
> Yes.
> 
> Once again, I am still not sure and I am asking for your review.

OK,

> But to me this looks much better. To simplify the discussion, lets
> consider ftrace_enable_fops in particular.
> 
> 	- Why should .open() block rmdir or unregister_uprobe_event?

Because it is opened and under preparing for use. :)
But, yeah, if we expect there is only one user using
ftrace, accessing the removing event file is meaningless.
It should be failed.

> 	- Why do we need .open() at all? Whatever it can do to
> 	  validate file/call/etc, .read/write can do the same.

Currently, just for preparing and reserving.

> 	- If we kill .open/release, we do not need the nontrivial
> 	  refcounting. Everything becomes simple, no need to keep
> 	  the state "in between".

That also means to refrain checking existence under locking mutex
in all operations. And we have to check it, which I actually concern.
refcounting is not so small and itself is complex, but it just
needs to inc/dec on open/close.


> 	  We need event_mutex anyway (and note that other f_op's can
> 	  also rely on other locks taken by trace_remove_event_call),
> 	  the validation degrades to the trivial != NULL check.
> 
> 	- This also simplifies trace_remove_event_call() paths, we
> 	  know that once it takes event_mutex nobody can play with
> 	  ftrace_event_file/ftrace_event_call we are going to free.

Hmm, it seems that we can remove only refcount check, or more?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


