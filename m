Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3GATlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:41:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab3GATlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:41:16 -0400
Date: Mon, 1 Jul 2013 21:36:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] tracing/kprobes: Turn trace_probe->files into
	list_head
Message-ID: <20130701193637.GA31161@redhat.com>
References: <20130620173814.GA13165@redhat.com> <1372705721.22688.13.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372705721.22688.13.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Steven Rostedt wrote:
>
> On Thu, 2013-06-20 at 19:38 +0200, Oleg Nesterov wrote:
>
> > -static int
> > -trace_probe_file_index(struct trace_probe *tp, struct ftrace_event_file *file)
> > +static struct event_file_link *
> > +find_event_file_link(struct trace_probe *tp, struct ftrace_event_file *file)
> >  {
> > -	struct ftrace_event_file **files;
> > -	int i;
> > +	struct event_file_link *link;
> >
> > -	/*
> > -	 * Since all tp->files updater is protected by probe_enable_lock,
> > -	 * we don't need to lock an rcu_read_lock.
> > -	 */
> > -	files = rcu_dereference_raw(tp->files);
> > -	if (files) {
> > -		for (i = 0; files[i]; i++)
> > -			if (files[i] == file)
> > -				return i;
> > -	}
> > +	list_for_each_entry(link, &tp->files, list)
> > +		if (link->file == file)
> > +			return link;
>
> Shouldn't that be list_for_each_entry_rcu()?

No.

This is the writer which modifies the list. enable/disable_trace_probe
should be serialized wrt each other / itself anyway, otherwise they are
buggy in any case.

Oleg.

