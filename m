Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992461AbaEQA1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 20:27:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:63686 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755929AbaEQA1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 20:27:12 -0400
Date: Fri, 16 May 2014 20:27:09 -0400
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
Message-ID: <20140516202709.6e345117@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1405170002180.1615@pobox.suse.cz>
References: <cover.1398958771.git.jpoimboe@redhat.com>
	<20140505085537.GA32196@gmail.com>
	<20140505132638.GA14432@treble.redhat.com>
	<20140505141038.GA27403@localhost.localdomain>
	<20140505184304.GA15137@gmail.com>
	<5368CB6E.3090105@hitachi.com>
	<20140506082604.31928cb9@gandalf.local.home>
	<alpine.LNX.2.00.1405161822050.16459@pobox.suse.cz>
	<20140516145533.4ef7bc22@gandalf.local.home>
	<alpine.LNX.2.00.1405170002180.1615@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2014 00:32:10 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:


> That's true, and we come back to what has been said at the very beginning 
> for both aproaches -- you can't really get away without manual human 
> inspection of the patches that are being applied.
> 
> The case you have outlined is indeed problematic for the "lazy switching" 
> aproach, and can be worked around (interim function, which takes both 
> mutexes in well defined order, for example).
> 
> You can construct a broken locking scenario for stop_machine() aproach as 
> well -- consider a case when you are exchaing a function which changes the 
> locking order of two locks/mutexes. How do you deal with the rest of the 
> code where the locks are being acquired, but not through the functions 
> you've exchanged?

I'm a bit confused by this. If you change locking order and there's
other functions that acquire it in reverse order that's not in the
patch, that sounds like you just introduced a new bug.

> 
> So again -- there is no disagreement, I believe, about the fact that "live 
> patches" can't be reliably auto-generated, and human inspection will 
> always be necessary. Given the intended use-case (serious CVEs mostly, 
> handled by distro vendors), this is fine.
> 

Right, I absolutely agree that the real use case is to fix off by one
errors and buffer overflows. Anything that is more complex really needs
a reboot (at a minimum, a kexec reboot). I know our customers would love
to see this upgrading entire kernels, but that's rather unrealistic.

Why I still favor the stop_machine approach, is because the method of
patching is a bit simpler that way. A "lazy" approach will be more
complex and more likely to be buggy. The thing I'm arguing here is not
the end result being a problem, but the implementation of the patching
itself causing bugs.

I rather have a "lazy" approach, but like ftrace and its breakpoint
method, the stop_machine approach is the simpler way to make sure the
patching works before we try to optimize it.

-- Steve
