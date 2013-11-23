Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3KWIwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 03:52:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:36829 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753299Ab3KWIwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 03:52:24 -0500
Date: Sat, 23 Nov 2013 03:52:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 04/22] tools lib traceevent: Add jbd2 plugin
Message-ID: <20131123035221.73f67ab7@gandalf.local.home>
In-Reply-To: <1385130477.1747.33.camel@leonhard>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-5-git-send-email-jolsa@redhat.com>
	<1385130477.1747.33.camel@leonhard>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013 23:27:57 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> [SNIP]
> > +#define MINORBITS	20
> > +#define MINORMASK	((1U << MINORBITS) - 1)
> > +
> > +#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
> > +#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
> > +
> > +unsigned long long process_jbd2_dev_to_name(struct trace_seq *s,
> > +					    unsigned long long *args)
> 
> Isn't it better to make these functions static?

Yeah, but that was my mistake. Lets keep the fix separate from the
backport though. Thanks!

> 
> 
> > +{
> > +	unsigned int dev = args[0];
> > +
> > +	trace_seq_printf(s, "%d:%d", MAJOR(dev), MINOR(dev));
> > +	return 0;
> > +}
> > +
> > +unsigned long long process_jiffies_to_msecs(struct trace_seq *s,
> > +					    unsigned long long *args)
> > +{
> > +	unsigned long long jiffies = args[0];
> > +
> > +	trace_seq_printf(s, "%lld", jiffies);
> > +	return jiffies;
> > +}
> > +
> > +int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
> > +{
> > +	pevent_register_print_function(pevent,
> > +				       process_jbd2_dev_to_name,
> > +				       PEVENT_FUNC_ARG_STRING,
> 
> Actually the function returns long long not string.  But it seems the
> current code doesn't care about the return type.

Actually it's not representing what process_jbd2_dev_to_name() returns
(which will always return unsigned long long), but what
"jbd2_dev_to_name()" returns that is (was) defined in the kernel. That
was:

	const char *jbd2_dev_to_name(dev_t device)

When registering a function to handle, you need to express the
prototype of that function (not the handler). The third argument is the
ret_type of that function.

But this is interesting, the ret_type doesn't seem to be used in
event_parse.c. The return value of the callback is only done in
eval_num_arg() where we could put a warning if the ret_type is not a
number.

Funny thing is, this patch is irrelevant with todays kernel due to this
commit:

commit 4862fd6047ed02e2726667c54d35f538eecc56aa
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Jul 10 22:05:08 2011 -0400

    jbd2: remove jbd2_dev_to_name() from jbd2 tracepoints
    
    Using function calls in TP_printk causes perf heartburn, so print the
    MAJOR/MINOR device numbers instead.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>



> 
> 
> > +				       "jbd2_dev_to_name",
> > +				       PEVENT_FUNC_ARG_INT,
> > +				       PEVENT_FUNC_ARG_VOID);
> > +
> > +	pevent_register_print_function(pevent,
> > +				       process_jiffies_to_msecs,
> > +				       PEVENT_FUNC_ARG_LONG,
> > +				       "jiffies_to_msecs",
> > +				       PEVENT_FUNC_ARG_LONG,
> > +				       PEVENT_FUNC_ARG_VOID);
> > +	return 0;
> > +}
> 
> Shouldn't it unregister these functions when unloaded?

Probably ;-)

-- Steve

> 
> Thanks,
> Namhyung
> 

