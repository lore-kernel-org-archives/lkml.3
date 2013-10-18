Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3JRMey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:34:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:4016 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752930Ab3JRMew convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:34:52 -0400
Date: Fri, 18 Oct 2013 08:34:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Geyslan =?UTF-8?B?R3JlZ8Ozcmlv?= Bem <geyslan@gmail.com>
Cc: kernel-br <kernel-br@googlegroups.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] tracing: fix referencing after memory freeing and
 refactors code
Message-ID: <20131018083448.4d65ef78@gandalf.local.home>
In-Reply-To: <CAGG-pUSSeuaSMiOiTxQtgy84UZXq-VqOhSYyusi0XHJDbt=wJg@mail.gmail.com>
References: <1382060696-30746-1-git-send-email-geyslan@gmail.com>
	<20131017224605.2e1d4bab@gandalf.local.home>
	<CAGG-pURzhHWMHN8u4YKCNsc1UKyGJQC5tBfFhWNkrOC_o6zsJg@mail.gmail.com>
	<CAGG-pUSSeuaSMiOiTxQtgy84UZXq-VqOhSYyusi0XHJDbt=wJg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013 08:02:32 -0300
Geyslan Gregório Bem <geyslan@gmail.com> wrote:

> >>
> >> I'm thinking of just nuking the tracing_open_generic() here. The only
> >> thing it does here is the tracing_disabled check. The assignment of
> >> inode->i_private to filp->private_data is pointless as it just
> >> reassigns it anyway.
> >>
> >> We could add a tracing_is_disabled() function to test instead.
> >
> > Nice, I can do it.
> >
> > Questions:
> 
> I realized that here not:

Right, tracing_is_disabled() should not be called as a fops method.

> >
> > 1267 static const struct file_operations ftrace_enable_fops = {
> > 1268         .open = tracing_open_generic,
> > ...
> > 1286 static const struct file_operations ftrace_event_filter_fops = {
> > 1287         .open = tracing_open_generic,
> > ...
> > 1317 static const struct file_operations ftrace_show_header_fops = {
> > 1318         .open = tracing_open_generic,
> 
> Tell me about this other case:
> >
> > Are that structures in same case? Their 'open' can be replaced to the
> > new 'tracing_is_disabled()?
> >
> > I think that 'subsystem_open()' can be also refactored to use the
> > about to rise 'tracing_is_disabled()'. Am I right?
> > 1096         ret = tracing_open_generic(inode, filp);

Hmm, no, it needs the assignment too. But perhaps we could just open
code it. The tracing_open_generic() is more for fops then to be a
helper for functions that don't use it for their .open routine.

Thus, for subsystem_open() you could have at the start:

	if (tracing_is_disabled())
		return -ENODEV;


Then have:

-       ret = tracing_open_generic(inode, filp);
-       if (ret < 0) {
-               trace_array_put(tr);
-               put_system(dir);
-       }
+       filp->private_data = dir;


-- Steve


> 
> Regards,
> -- Geyslan

