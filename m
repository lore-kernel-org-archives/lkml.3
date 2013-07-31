Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939Ab3GaWmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:42:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab3GaWmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:42:31 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=0VS4G58IZu0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=laNjaRT52OkA:10 a=s8y34ZwZ8vPR3AqXq6EA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375310548.5418.21.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
 event files are open
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
Date: Wed, 31 Jul 2013 18:42:28 -0400
In-Reply-To: <20130731204003.GA30188@redhat.com>
References: <20130704033347.807661713@goodmis.org>
	 <20130704034038.819592356@goodmis.org>
	 <1375300192.5418.17.camel@gandalf.local.home>
	 <20130731204003.GA30188@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 22:40 +0200, Oleg Nesterov wrote:
> On 07/31, Steven Rostedt wrote:
> >
> > On Wed, 2013-07-03 at 23:33 -0400, Steven Rostedt wrote:
> > > The above will corrupt the kprobe system, as the write to the enable
> > > file will happen after the kprobe was deleted.
> >
> > Oleg,
> >
> > The above no longer triggers the bug due to your changes. The race is
> > much tighter now
> 
> Yes, the changelog should be updated...
> 
> > and requires a process with the enable file opened and
> > races with a write to enable it where the removal of the trace file
> > checks the trace disabled, sees that it is, continues, but then the
> > write enables it just as it gets deleted.
> 
> This should be fine. Either event_remove() path takes event_mutex
> first and then ->write() fails, or ftrace_event_enable_disable()
> actually disables this even successfully.

Actually I meant while in unregister_trace_probe(), it gets by the
trace_probe_is_enabled() part first, then the write succeeds (as the
event_mutex isn't taken till unregister_probe_event()). The the
unregister_probe_event fails, but the tp was freed. The event files
still reference the tp and this is where a crash can happen without this
patch set.

-- Steve


