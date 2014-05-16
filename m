Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbaEPWcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:32:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbaEPWcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:32:17 -0400
Date: Sat, 17 May 2014 00:32:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
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
In-Reply-To: <20140516145533.4ef7bc22@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1405170002180.1615@pobox.suse.cz>
References: <cover.1398958771.git.jpoimboe@redhat.com> <20140505085537.GA32196@gmail.com> <20140505132638.GA14432@treble.redhat.com> <20140505141038.GA27403@localhost.localdomain> <20140505184304.GA15137@gmail.com> <5368CB6E.3090105@hitachi.com>
 <20140506082604.31928cb9@gandalf.local.home> <alpine.LNX.2.00.1405161822050.16459@pobox.suse.cz> <20140516145533.4ef7bc22@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Steven Rostedt wrote:

> > With lazy-switching implemented in kgraft, this can never happen.
> > 
> > So I'd like to ask for a little bit more explanation why you think the 
> > stop_machine()-based patching provides more sanity/consistency assurance 
> > than the lazy switching we're doing.
> 
> Here's what I'm more concerned with. With "lazy" switching you can have
> two tasks running two different versions of bar(). What happens if the
> locking of data within bar changes? Say the data was protected
> incorrectly with mutex(X) and you now need to protect it with mutex(Y).
> 
> With stop machine, you can make sure everyone is out of bar() and all
> tasks will use the same mutex to access the data. But with a lazy
> approach, one task can be protecting the data with mutex(X) and the
> other with mutex(Y) causing both tasks to be accessing the data at the
> same time.
> 
> *That* is what I'm more concerned about.

That's true, and we come back to what has been said at the very beginning 
for both aproaches -- you can't really get away without manual human 
inspection of the patches that are being applied.

The case you have outlined is indeed problematic for the "lazy switching" 
aproach, and can be worked around (interim function, which takes both 
mutexes in well defined order, for example).

You can construct a broken locking scenario for stop_machine() aproach as 
well -- consider a case when you are exchaing a function which changes the 
locking order of two locks/mutexes. How do you deal with the rest of the 
code where the locks are being acquired, but not through the functions 
you've exchanged?

So again -- there is no disagreement, I believe, about the fact that "live 
patches" can't be reliably auto-generated, and human inspection will 
always be necessary. Given the intended use-case (serious CVEs mostly, 
handled by distro vendors), this is fine.

-- 
Jiri Kosina
SUSE Labs
