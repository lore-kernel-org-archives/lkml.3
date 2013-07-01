Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3GATzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:55:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18830 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3GATzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:55:32 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=HX8G_2-wykQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zUhFYUDDBhMA:10 a=hm_YLqyMcDtHRUhL0f4A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372708530.22688.19.camel@gandalf.local.home>
Subject: Re: [PATCH v2 4/4] tracing/kprobes: Turn trace_probe->files into
 list_head
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 01 Jul 2013 15:55:30 -0400
In-Reply-To: <20130701193637.GA31161@redhat.com>
References: <20130620173814.GA13165@redhat.com>
	 <1372705721.22688.13.camel@gandalf.local.home>
	 <20130701193637.GA31161@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 21:36 +0200, Oleg Nesterov wrote:
> On 07/01, Steven Rostedt wrote:
> >
> > On Thu, 2013-06-20 at 19:38 +0200, Oleg Nesterov wrote:
> >
> > > -static int
> > > -trace_probe_file_index(struct trace_probe *tp, struct ftrace_event_file *file)
> > > +static struct event_file_link *
> > > +find_event_file_link(struct trace_probe *tp, struct ftrace_event_file *file)
> > >  {
> > > -	struct ftrace_event_file **files;
> > > -	int i;
> > > +	struct event_file_link *link;
> > >
> > > -	/*
> > > -	 * Since all tp->files updater is protected by probe_enable_lock,
> > > -	 * we don't need to lock an rcu_read_lock.
> > > -	 */
> > > -	files = rcu_dereference_raw(tp->files);
> > > -	if (files) {
> > > -		for (i = 0; files[i]; i++)
> > > -			if (files[i] == file)
> > > -				return i;
> > > -	}
> > > +	list_for_each_entry(link, &tp->files, list)
> > > +		if (link->file == file)
> > > +			return link;
> >
> > Shouldn't that be list_for_each_entry_rcu()?
> 
> No.
> 
> This is the writer which modifies the list. enable/disable_trace_probe
> should be serialized wrt each other / itself anyway, otherwise they are
> buggy in any case.

Ah OK, I missed the readers of kprobe*_trace_func() and was confused by
the other rcu usage. Nevermind.

-- Steve


