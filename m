Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3JSOZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 10:25:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab3JSOZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 10:25:50 -0400
Date: Sat, 19 Oct 2013 16:18:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        kernel-br <kernel-br@googlegroups.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] tracing: fix referencing after memory freeing and
	refactors code
Message-ID: <20131019141859.GA30765@redhat.com>
References: <1382060696-30746-1-git-send-email-geyslan@gmail.com> <20131017224605.2e1d4bab@gandalf.local.home> <20131019124312.GA23872@redhat.com> <CAGG-pUSk-A=m=cXL85fY+nNgRGQVtG62GouPoANuXFUSrKK6BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGG-pUSk-A=m=cXL85fY+nNgRGQVtG62GouPoANuXFUSrKK6BA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19, Geyslan Gregório Bem wrote:
>
> 2013/10/19 Oleg Nesterov <oleg@redhat.com>:
> > On 10/17, Steven Rostedt wrote:
> >>
> >> I'm thinking of just nuking the tracing_open_generic() here. The only
> >> thing it does here is the tracing_disabled check. The assignment of
> >> inode->i_private to filp->private_data is pointless
> >
> > The same for ftrace_enable_fops() and ftrace_event_filter_fops() at
> > least. The users of event_file_data() do not use ->private_data.
> >
>
> Aren't "ftrace_enable_fops" and "ftrace_event_filter_fops" structures?

I meant, their ->open() methods.

> About event_file_data() I think that the callers uses the
> private_data. So, we have to analyze better.

No, event_file_data() uses ->i_private, filp->private_data is not used.
And it can't be used, it can point to the already destroyed/freed data.

but, as for seq_open() users,

> static int trace_format_open(struct inode *inode, struct file *file)
> {
>     struct seq_file *m;
>     int ret;
>
>     ret = seq_open(file, &trace_format_seq_ops);
>     if (ret < 0)
>         return ret;
>
>     m = file->private_data;
>     m->private = file;
>
>     return 0;
> }
>
> I really got confused here. The 'm' assignments are, to me, pointless.

I confused too... Why do you think it is pointless?

Just in case, not that after seq_open() ->private_data points to seq_file
but it is still "void *". And in this case ->private_data has nothing to
do with ->private_data  set by tracing_open_generic().

Oleg.

