Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbbADQLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 11:11:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbbADQLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 11:11:43 -0500
Date: Sun, 4 Jan 2015 17:10:49 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>,
        root <chenggang.qin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: =?utf-8?B?562U5aSN77yaW1BBVENIXSBwZXJm?= =?utf-8?Q?_core=3A_Us?=
 =?utf-8?Q?e?= KSTK_ESP() instead of pt_regs->sp while output user regs
Message-ID: <20150104161049.GB22707@krava.brq.redhat.com>
References: <1419315745-20767-1-git-send-email-user@chenggang-laptop>
 <c027bde0-5f4f-441f-8d45-3e7f6f702231@alibaba-inc.com>
 <CALCETrVVvbnO-7bnyPCYhPbDoEg-hqmvVbfXL9ONbQPBTJNUZg@mail.gmail.com>
 <20141230190327.GB23965@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141230190327.GB23965@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 08:03:27PM +0100, Peter Zijlstra wrote:
> On Thu, Dec 25, 2014 at 07:48:28AM -0800, Andy Lutomirski wrote:
> > On a quick look, there are plenty of other bugs in there besides just
> > the stack pointer issue.  The ABI check that uses TIF_IA32 in the perf
> > core is completely wrong.  TIF_IA32 may be equal to the actual
> > userspace bitness by luck, but, if so, that's more or less just luck.
> > And there's a user_mode test that should be user_mode_vm.
> > 
> > Also, it's not just sp that's wrong.  There are various places that
> > you can interrupt in which many of the registers have confusing
> > locations.  You could try using the cfi unwind data, but that's
> > unlikely to work for regs like cs and ss, and, during context switch,
> > this has very little chance of working.
> > 
> > What's the point of this feature?  Honestly, my suggestion would be to
> > delete it instead of trying to fix it.  It's also not clear to me that
> > there aren't serious security problems here -- it's entirely possible
> > for sensitive *kernel* values to and up in task_pt_regs at certain
> > times, and if you run during context switch and there's no code to
> > suppress this dump during context switch, then you could be showing
> > regs that belong to the wrong task.
> 
> Of course the people who actually wrote the code are not on CC :/
> 
> There's two users of this iirc;
> 
>  1) the dwarf stack unwinder thingy, which basically dumps the userspace
>  regs and the top of userspace stack on 'event'.

looks like this solves the issue I was trying to fix
long time ago:
  http://marc.info/?l=linux-kernel&m=134934717011451&w=2

this seems a lot simpler ;-) I'll test..

jirka
