Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab3GPQnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:43:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148Ab3GPQnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:43:21 -0400
Date: Tue, 16 Jul 2013 18:38:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/4] tracing/kprobes/uprobes: Fix race between
	opening probe event files and deleting probe
Message-ID: <20130716163804.GA30560@redhat.com>
References: <20130704033347.807661713@goodmis.org> <20130715180149.GA15821@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715180149.GA15821@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15, Oleg Nesterov wrote:
>
> So. As Masami pointed out, this is not enough. Probably we can add more
> hacks, but I'd like to discuss the alternative approach.
>
> Note also that this ref count has the unfortunate property, if someone
> keeps the file opened we can't remove an event.

And please correct me, but afaics there are similar problems with
rmdir instances/xxx.

> What this patch does:
>
> 	- add the new "topmost" rw_semaphore, file_sem.

probably unneeded...

> 	- trace_remove_event_call() takes this sem for writing and
> 	  cleares enable/id/format/filter->i_private
>
> 	- removes tracing_open_generic_file/tracing_release_generic_file,
> 	  we do not use file->f_private any longer
>
> 	- changes event_enable_read/event_enable_write to read
> 	  ftrace_event_file = i_private under read_lock(file_sem) and
> 	  abort if it is null.
>
> Question: why event_enable_write() needs trace_array_get() ?

probably it doesn't...

> Steven, Masami, do you think this can make any sense?

Oleg.

