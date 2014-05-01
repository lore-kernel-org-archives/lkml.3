Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaEAVju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:39:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbaEAVjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:39:48 -0400
Date: Thu, 1 May 2014 16:39:29 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140501213929.GE3907@treble.redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <87ppjxcjo2.fsf@tassilo.jf.intel.com>
 <20140501210154.GC3907@treble.redhat.com>
 <20140501210601.GG2382@two.firstfloor.org>
 <20140501212746.GD3907@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140501212746.GD3907@treble.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 04:27:46PM -0500, Josh Poimboeuf wrote:
> On Thu, May 01, 2014 at 11:06:01PM +0200, Andi Kleen wrote:
> > > When bar returns, would it skip foo and go straight back to foo's
> > > caller?  If so, then it should be safe to patch foo after it jumps to
> > > bar.
> > 
> > foo is no problem, you see it in the backtrace.
> > But you don't see bar.
> 
> Sorry, I missed your point the first time.  Good question.
> 
> stop_machine schedules a high priority thread on each CPU, which means
> every other task will be waiting in a schedule() call (assuming a
> non-preemptible kernel).  In my local kernel, a quick grep of the
> disassembly doesn't show any jumps to schedule:
> 
>   $ egrep 'j.*<.*>' vmlinux.asm |grep -v '\+' |grep schedule
>   ffffffff816b89b5:	e9 e2 fe ff ff       	jmpq   ffffffff816b889c <retint_with_reschedule>
>   ffffffff816b8cec:	75 1e                	jne    ffffffff816b8d0c <paranoid_schedule>
> 
> But yes, that would be a problem if any tail call jumps to schedule()
> ever showed up.  We may need to detect that case in our patch generation
> tooling and fail to create the patch module binary if the patch affects
> a function which does this.

Thinking more about this... Even if it jumps to schedule(), I think
there's no problem, since the function is basically done, and we already
know not to patch schedule().

-- 
Josh
