Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab3GPTK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:10:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18818 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253Ab3GPTK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:10:27 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=sAMN5JoDUTkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=MM5Jvx6deYgA:10 a=vNvZf7x32KLVIsxfbcQA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374001825.6458.44.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 0/4] tracing/kprobes/uprobes: Fix race between
 opening probe event files and deleting probe
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 16 Jul 2013 15:10:25 -0400
In-Reply-To: <20130716163804.GA30560@redhat.com>
References: <20130704033347.807661713@goodmis.org>
	 <20130715180149.GA15821@redhat.com> <20130716163804.GA30560@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 18:38 +0200, Oleg Nesterov wrote:
> On 07/15, Oleg Nesterov wrote:
> >
> > So. As Masami pointed out, this is not enough. Probably we can add more
> > hacks, but I'd like to discuss the alternative approach.
> >
> > Note also that this ref count has the unfortunate property, if someone
> > keeps the file opened we can't remove an event.
> 
> And please correct me, but afaics there are similar problems with
> rmdir instances/xxx.

The instances have their own refcount. And if a file is open, it wont
remove the directory. Just try it...


# cd /sys/kernel/debug/tracing/instances
# mkdir foo
# sleep 10 < foo/events/ext3/enable &
[1] 2087
# rmdir foo
rmdir: failed to remove `foo': Device or resource busy
# 
[1]+  Done                    sleep 10 < foo/events/ext3/enable
# rmdir foo
# 

> 
> > What this patch does:
> >
> > 	- add the new "topmost" rw_semaphore, file_sem.
> 
> probably unneeded...
> 
> > 	- trace_remove_event_call() takes this sem for writing and
> > 	  cleares enable/id/format/filter->i_private
> >
> > 	- removes tracing_open_generic_file/tracing_release_generic_file,
> > 	  we do not use file->f_private any longer
> >
> > 	- changes event_enable_read/event_enable_write to read
> > 	  ftrace_event_file = i_private under read_lock(file_sem) and
> > 	  abort if it is null.
> >
> > Question: why event_enable_write() needs trace_array_get() ?
> 
> probably it doesn't...

I'm confused. Which code has event_enable_write doing a
trace_array_get()?

> 
> > Steven, Masami, do you think this can make any sense?

I need to sort these patches out. They are all over the place. What
exactly do we have for a solution here. Did we figure out which patches
are needed?

I'll have to go back and re-read the entire thread. I've been all over
the place lately with different topics, and don't remember all that has
been said here.

-- Steve


