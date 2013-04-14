Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3DNTql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 15:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab3DNTqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 15:46:40 -0400
Date: Sun, 14 Apr 2013 21:40:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ptrace/x86: simplify ptrace_write_dr7()
Message-ID: <20130414194049.GA29540@redhat.com>
References: <20130414191205.GA28791@redhat.com> <20130414193021.GA20962@host2.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414193021.GA20962@host2.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Jan Kratochvil wrote:
>
> On Sun, 14 Apr 2013 21:12:05 +0200, Oleg Nesterov wrote:
> > Jan, Frederic, et all. What do you think we should do?
> >
> > 	1. Change ptrace_write_dr7() to do register_user_hw_breakpoint()
> > 	   if necessary.
> >
> > 	   This is what I was going to do, but I am no longer sure
> > 	   we want this. For what? Unlikely it is very useful to use
> > 	   the "default" addr == 0 for debugging.
>
> I do not understand how these functions map to the PTRACE_* syscall.
>
> But this was a regression from the application point of view as some
> application did/do:
> 	* waitpid - get the process to: t (tracing stop)
> 	* PTRACE_POKEUSER DR7, enableDR0
> 	* PTRACE_POKEUSER DR0, address
> 	* PTRACE_CONT
>
> This was perfectly valid before, there is no "default" addr == 0 used for any
> debugging.  Just the applications did not care about PTRACE_POKEUSER ordering.
> This is also how the bug was found.

Yes, exactly.

Except 'there is no "default" addr == 0', the first
"PTRACE_POKEUSER DR7, enableDR0" used addr == 0 and then it was
changed by "PTRACE_POKEUSER DR0".

And once again, I am ready to make the patch, it should be simple.
Just I am not sure it worth the trouble, so I decided to ask first.
Nobody noticed this problem(?) except you, and this was broken a
long ago.

	PTRACE_POKEUSER DR0, address
	PTRACE_POKEUSER DR7, enableDR0

should work and this looks better, we do not enable bp until it
has the correct address set.  Of course this doesn't really matter
if the tracee doesn't not run in between, but still...

Oleg.

