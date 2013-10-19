Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3JSN6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 09:58:18 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49298 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3JSN6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 09:58:17 -0400
MIME-Version: 1.0
In-Reply-To: <20131019124312.GA23872@redhat.com>
References: <1382060696-30746-1-git-send-email-geyslan@gmail.com>
	<20131017224605.2e1d4bab@gandalf.local.home>
	<20131019124312.GA23872@redhat.com>
Date: Sat, 19 Oct 2013 10:58:15 -0300
Message-ID: <CAGG-pUSk-A=m=cXL85fY+nNgRGQVtG62GouPoANuXFUSrKK6BA@mail.gmail.com>
Subject: Re: [PATCH] tracing: fix referencing after memory freeing and
 refactors code
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        kernel-br <kernel-br@googlegroups.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/19 Oleg Nesterov <oleg@redhat.com>:
> On 10/17, Steven Rostedt wrote:
>>
>> On Thu, 17 Oct 2013 22:44:56 -0300
>> "Geyslan G. Bem" <geyslan@gmail.com> wrote:
>>
>> > and fix the possible 'dir'
>> > assignment after freeing it.
>
> This should be safe afaics, nobody will use it anyway. Even
> subsystem_release() won't be called if .open() fails. But I agree
> this doesn't look good.

Right.
>
>> I'm thinking of just nuking the tracing_open_generic() here. The only
>> thing it does here is the tracing_disabled check. The assignment of
>> inode->i_private to filp->private_data is pointless
>
> The same for ftrace_enable_fops() and ftrace_event_filter_fops() at
> least. The users of event_file_data() do not use ->private_data.
>

Aren't "ftrace_enable_fops" and "ftrace_event_filter_fops" structures?
About event_file_data() I think that the callers uses the
private_data. So, we have to analyze better.

> OTOH, say, trace_format_open() doesn't check tracing_disabled, so
>
>> We could add a tracing_is_disabled() function to test instead.
>
> perhaps it can have more callers.
>

static int trace_format_open(struct inode *inode, struct file *file)
{
    struct seq_file *m;
    int ret;

    ret = seq_open(file, &trace_format_seq_ops);
    if (ret < 0)
        return ret;

    m = file->private_data;
    m->private = file;

    return 0;
}

I really got confused here. The 'm' assignments are, to me, pointless.

> Oleg.
>
