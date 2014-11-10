Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaKJS6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:58:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaKJS6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:58:54 -0500
Date: Mon, 10 Nov 2014 19:58:48 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 12/12 v3] x86/nmi: Perform a safe NMI stack trace on
 all CPUs
Message-ID: <20141110185847.GC2552@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160223.310714394@goodmis.org>
 <20141106184155.GB28294@dhcp128.suse.cz>
 <20141107135609.7ccdd3ce@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107135609.7ccdd3ce@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-07 13:56:09, Steven Rostedt wrote:
> On Thu, 6 Nov 2014 19:41:55 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
>  
> > >  /* "in progress" flag of arch_trigger_all_cpu_backtrace */
> > >  static unsigned long backtrace_flag;
> > >  
> > > +static void print_seq_line(struct nmi_seq_buf *s, int last, int pos)
> > 
> > I would rename the arguments:
> > 
> > 	"last -> first"
> > 	"pos -> last"
> > 
> > or maybe better would be to pass first positon and len.
> 
> I switched it to "start" and "end" to not be confused by the last_i
> that is being passed in.

I like it.

> > 
> > > +{
> > > +	const char *buf = s->buffer + last;
> > > +
> > > +	printk("%.*s", (pos - last) + 1, buf);
> > > +}
> > 
> 
> 
> 
> > >  
> > > +	/*
> > > +	 * Now that all the NMIs have triggered, we can dump out their
> > > +	 * back traces safely to the console.
> > > +	 */
> > > +	for_each_cpu(cpu, printtrace_mask) {
> > > +		int last_i = 0;
> > > +
> > > +		s = &per_cpu(nmi_print_seq, cpu);
> > > +		len = s->seq.len;
> > 
> > If there is an seq_buf overflow, the len might be size + 1, so we need to do:
> > 
> > 		len = min(s->seq.len, s->size);
> > 
> > Well, we should create a function for this in seq_buf.h.
> > Alternatively, we might reconsider the overflow state,
> > use len == size and extra "overflow" flag in the seq_buf struct.
> > 
> > 
> > > +		if (!len)
> > > +			continue;
> > > +
> > > +		/* Print line by line. */
> > > +		for (i = 0; i < len; i++) {
> > > +			if (s->buffer[i] == '\n') {
> > > +				print_seq_line(s, last_i, i);
> > > +				last_i = i + 1;
> > > +			}
> > > +		}
> > >
> > > +		if (last_i < i - 1) {
> > 
> > IMHO, this should be:
> > 
> > 		if (last_i < i)
> > 
> > because last_i = i + 1. Otherwise, we would ignore state when there is
> > one character after a new line. For example, imagine the following:
> > 
> > 	buffer = "a\nb";
> > 	len = 3;
> > 
> > it will end with:
> > 
> > 	last_i = 2;
> > 	i = 3;
> > 
> > and we still need to print the "b".
> 
> Well, we really don't *need* to ;-)
> 
> But for correctness sake, I agree, it should be last_i < i.

I agree that one more character does not make much difference but
it might save someones day :-)

> > 
> > > +			print_seq_line(s, last_i, i);
> > 
> > If I get it correctly, (i == len) here and "printk_seq_line"
> > print_seq_line() prints the characters including "pos" value.
> > So, we should call:
> > 
> > 			print_seq_line(s, last_i, i - 1)
> 
> Right that was wrong. Actually, I think the best answer would be:
> 
> 	print_seq_line(s, last_i, len - 1);

Yup

> This removes the variable 'i'. Probably should add a comment here too
> that reminds the reviewer that print_seq_line() prints up to and
> including the last index.

Yes, the comment is worth having.

> Note, my current code also has:
> 
> 	len = seq_buf_used(&s->seq);
> 
> where we don't need to worry about the semantics of seq_buf internals.

Perfect

Thanks a lot for working on it. Please, resend this patch once you are
happy with it.

Best Regards,
Petr
