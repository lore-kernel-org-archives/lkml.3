Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaCGPzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:55:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbaCGPz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:55:29 -0500
Date: Fri, 7 Mar 2014 10:54:15 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: peterz@infradead.org, paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com,
        akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
Message-ID: <20140307155415.GB16640@madcap2.tricolour.ca>
References: <201402102243.IEJ52676.JOFVMOQFOFSLtH@I-love.SAKURA.ne.jp>
 <201402172027.BFH81210.FJtOQOMLHFSVOF@I-love.SAKURA.ne.jp>
 <530BF6B4.3040206@cn.fujitsu.com>
 <201402252154.HAE13049.QFFSMVOFOOtLJH@I-love.SAKURA.ne.jp>
 <20140225144643.GU9987@twins.programming.kicks-ass.net>
 <201403072120.BJB73489.OFMSOFHQFtOJLV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201403072120.BJB73489.OFMSOFHQFtOJLV@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/07, Tetsuo Handa wrote:
> Peter Zijlstra wrote:
> >   https://lkml.org/lkml/2011/5/17/516

> Thank you for pointing that thread out. I found the following comment in that
> thread.
> 
> Linus Torvalds wrote:
> | What folks?
> | 
> | I don't think a new lock (or any lock) is at all appropriate.
> | 
> | There's just no point. Just guarantee that the last byte is always
> | zero, and you're done.
> | 
> | If you just guarantee that, THERE IS NO RACE. The last byte never
> | changes. You may get odd half-way strings, but you've trivially
> | guaranteed that they are C NUL-terminated, with no locking, no memory
> | ordering, no nothing.

> > >   Likewise, audit_log_untrustedstring(ab, current->comm) is racy.
> > >   If task->comm was "Hello Linux" until audit_string_contains_control() in
> > >   audit_log_n_untrustedstring() returns false, and becomes "Penguin" before
> > >   memcpy() in audit_log_n_string() is called, memcpy() will emit "Penguin\0nux"
> > >   into the audit log, which results in loss of information (e.g. SELinux
> > >   context) due to the unexpected '\0' byte.
> > 
> > I expect the audit people don't like this? Also, how do audit and the
> > LSM crap things interact? I thought they were both different piles of
> > ignorable goo?
> 
> I think the audit people do not like loss of information. Some of LSM modules
> are using audit subsystem for recording security related events. An example is
> shown later.

This is true, however since comm it untrusted because it can be modified
by the user audit doesn't trust it anyways, so who cares?

> > How about you do what you're supposed to do when you want a reliable
> > ->comm and use get_task_comm()?
> 
> I always want a reliable ->comm . But get_task_comm() is not for calling from
> vsnprintf(), for somebody might read task's commname from NMI context.
> I tried to use RCU for reading from vsnprintf() but Linus will not accept it.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
