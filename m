Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbaEPSzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:55:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:17983 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757402AbaEPSzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:55:36 -0400
Date: Fri, 16 May 2014 14:55:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140516145533.4ef7bc22@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1405161822050.16459@pobox.suse.cz>
References: <cover.1398958771.git.jpoimboe@redhat.com>
	<20140505085537.GA32196@gmail.com>
	<20140505132638.GA14432@treble.redhat.com>
	<20140505141038.GA27403@localhost.localdomain>
	<20140505184304.GA15137@gmail.com>
	<5368CB6E.3090105@hitachi.com>
	<20140506082604.31928cb9@gandalf.local.home>
	<alpine.LNX.2.00.1405161822050.16459@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 18:27:27 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:


> > ftrace did the stop_machine (and still does for some archs), and slowly
> > moved to a more efficient method. kpatch/kgraft should follow suit.
> 
> I don't really agree here.
> 
> I actually believe that "lazy" switching kgraft is doing provides a little 
> bit more in the sense of consistency than stop_machine()-based aproach.
> 
> Consider this scenario:
> 
> 	void foo()
> 	{
> 		for (i=0; i<10000; i++) {
> 			bar(i);
> 			something_else(i);
> 		}
> 	}
> 
> Let's say you want to live-patch bar(). With stop_machine()-based aproach, 
> you can easily end-up with old bar() and new bar() being called in two 
> consecutive iterations before the loop is even exited, right? (especially 
> on preemptible kernel, or if something_else() goes to sleep).

And bar() should still do the same result. Otherwise you would think
that foo should change too.

> 
> With lazy-switching implemented in kgraft, this can never happen.
> 
> So I'd like to ask for a little bit more explanation why you think the 
> stop_machine()-based patching provides more sanity/consistency assurance 
> than the lazy switching we're doing.

Here's what I'm more concerned with. With "lazy" switching you can have
two tasks running two different versions of bar(). What happens if the
locking of data within bar changes? Say the data was protected
incorrectly with mutex(X) and you now need to protect it with mutex(Y).

With stop machine, you can make sure everyone is out of bar() and all
tasks will use the same mutex to access the data. But with a lazy
approach, one task can be protecting the data with mutex(X) and the
other with mutex(Y) causing both tasks to be accessing the data at the
same time.

*That* is what I'm more concerned about.

I believe there are more issues with running the two different versions
of the same function at the same time than there are with iterations of
two different versions of the call. One would expect that the results
should stay the same and if not, then the callers would need to be
changed too.

-- Steve
