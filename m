Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3GQTmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:42:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab3GQTmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:42:20 -0400
Date: Wed, 17 Jul 2013 21:37:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/4] tracing: Simplify the ftrace_event_field
	iteration in f_next/f_show
Message-ID: <20130717193710.GC15312@redhat.com>
References: <20130716185658.GA21167@redhat.com> <20130717193017.GA15312@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717193017.GA15312@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17, Oleg Nesterov wrote:
>
> f_next() looks overcomplicated, and it is not strictly correct
> even if this doesn't matter.

Honestly, I do not know what the changelog can say to explain
this patch except "make the code simpler/cleaner".

To simplify the review, please see f_next/f_start with this patch
applied below. f_show() does field = list_entry(v, ...).

Probably makes sense anyway, I even tried to test it. So I would
not mind if you apply it as a separate cleanup ;)

Oleg.

static void *f_next(struct seq_file *m, void *v, loff_t *pos)
{
	struct ftrace_event_call *call = m->private;
	struct list_head *common_head = &ftrace_common_fields;
	struct list_head *head = trace_get_fields(call);
	struct list_head *node = v;

	(*pos)++;

	switch ((unsigned long)v) {
	case FORMAT_HEADER:
		node = common_head;
		break;

	case FORMAT_FIELD_SEPERATOR:
		node = head;
		break;

	case FORMAT_PRINTFMT:
		/* all done */
		return NULL;
	}

	node = node->prev;
	if (node == common_head)
		return (void *)FORMAT_FIELD_SEPERATOR;
	else if (node == head)
		return (void *)FORMAT_PRINTFMT;
	else
		return node;
}

static void *f_start(struct seq_file *m, loff_t *pos)
{
	void *p = (void *)FORMAT_HEADER;
	loff_t l = 0;

	while (p && l < *pos)
		p = f_next(m, p, &l);

	return p;
}

