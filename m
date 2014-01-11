Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaAKCAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 21:00:43 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64701 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaAKCAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 21:00:40 -0500
X-Nat-Received: from [202.181.97.72]:59490 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389405596.21361
To: akpm@linux-foundation.org
Cc: pavel@ucw.cz, joe@perches.com, keescook@chromium.org, geert@linux-m68k.org,
        jkosina@suse.cz, viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
	<20140110155952.b376106ab7b76403af99111b@linux-foundation.org>
In-Reply-To: <20140110155952.b376106ab7b76403af99111b@linux-foundation.org>
Message-Id: <201401111059.HCH39012.MFtVHFOFQOLOJS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 11 Jan 2014 10:59:54 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10012014 #7296163, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > This patch introduces %pT format specifier for printing task_struct->comm.
> > Currently %pT does not provide consistency. I'm planning to change to use RCU
> > in the future. By using RCU, the comm name read from task_struct->comm will be
> > guaranteed to be consistent.
> 
> Not completely accurate - RCU won't protect code which accesses ->comm
> from interrupts.  Printing current->comm from irq is quite daft, but I
> bet there's code that does it :(
> 
> As long as the kernel doesn't crash or otherwise misbehave when this
> happens, I think we're OK.
> 
> (And I guess there's also non-daft code which accesses current->comm
> from interrupt context: oops, panic, etc).

Excuse me, but are interrupts relevant?

I think that readers that do

  rcu_read_lock();
  use p->comm here
  rcu_read_unlock();

will be protected from writers that wait freeing p->comm using
synchronize_rcu() or call_rcu().

Is synchronize_rcu() or call_rcu() insufficient for protecting readers that do

  rcu_read_lock();
  use p->comm here
  rcu_read_unlock();

 from interrupts?

> > --- a/lib/vsprintf.c
> > +++ b/lib/vsprintf.c
> > @@ -1179,6 +1179,21 @@ char *address_val(char *buf, char *end, const void *addr,
> >  	return number(buf, end, num, spec);
> >  }
> >  
> > +static noinline_for_stack
> 
> hm, does noinline_for_stack actually do anything useful here?  I
> suspect it *increases* stack depth in the way comm_name() is used here.
> 
I just added noinline_for_stack as with other functions does.
But indeed, stack used by name[] is only 16 bytes but stack used by function
arguments are larger than 16 bytes. We should remove noinline_for_stack ?

> > +char *comm_name(char *buf, char *end, struct task_struct *tsk,
> > +		struct printf_spec spec, const char *fmt)
> > +{
> > +	char name[TASK_COMM_LEN];
> > +
> > +	/* Caller can pass NULL instead of current. */
> > +	if (!tsk)
> > +		tsk = current;
> > +	/* Not using get_task_comm() in case I'm in IRQ context. */
> > +	memcpy(name, tsk->comm, TASK_COMM_LEN);
> > +	name[sizeof(name) - 1] = '\0';
> 
> get_task_comm() uses strncpy()?

I think unconditionally copying 16 bytes using memcpy() is faster than
conditionally copying until '\0'.

> 
> > +	return string(buf, end, name, spec);
> > +}
> > +
