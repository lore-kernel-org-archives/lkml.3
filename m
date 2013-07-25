Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3GYObj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:31:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab3GYObh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:31:37 -0400
Date: Thu, 25 Jul 2013 16:26:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] tracing: Turn event/id->i_private into
	call->event.type
Message-ID: <20130725142613.GB15965@redhat.com>
References: <20130723205909.GA9055@redhat.com> <1374696796.3356.162.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374696796.3356.162.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24, Steven Rostedt wrote:
>
> On Tue, 2013-07-23 at 22:59 +0200, Oleg Nesterov wrote:
> > event_id_read() is racy, ftrace_event_call can be already freed
> > by trace_remove_event_call() callers.
> >
> > Change event_create_dir() to pass "data = call->event.type", this
> > is all event_id_read() needs. ftrace_event_id_fops no longer needs
> > tracing_open_generic().
> >
> > We add the new helper, event_file_data(), to read ->i_private, it
> > will have more users.
> >
> > Note: currently ACCESS_ONCE() and "id != 0" check are not needed,
> > but we are going to change event_remove/rmdir to clear ->i_mutex.
>
> We are changing i_mutex or i_private?

i_private, yes, will fix.

Steven, I agree with all your comments, thanks. Except this one.

> Anyway, this still looks too complex for the id. Just pass the id number
> to the filp->private_data, and use that. It should never be cleared, and
> as we are not using any pointers it will always return what the id
> is/was.
>
> Keep tracing_open_generic() and have:
>
> event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t
> *ppos)
> {
> 	int id = (int)(unsigned long)filp->private_data;
> 	char buf[32];
> 	int len;
>
> 	if (*ppos)
> 		return 0;
>
> 	len = sprintf(buf, "%d\n", id);
> 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
> }
>
> No need for accessing the inode->i_private.

Unless you strongly object, I'd prefer to avoid filp->private_data
and use event_file_data(). Also, I'd like to keep "if (!id) ENODEV".

The main reason is the consistency with other f_op's, and this allows
us to change event_file_data/remove_event_file_dir without breaking
event_id_read().

Also. Even if we use filp->private_data, it can be NULL/0, ->open()
can race with rmdir. Of course we could update remove_event_file_dir()
to skip this file, but I am sure we should not do this.

Oleg.

