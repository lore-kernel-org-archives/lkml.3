Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3KNOQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:16:15 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:57463 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146Ab3KNOQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:16:06 -0500
Message-ID: <1384438551.3388.78.camel@linaro1.home>
Subject: Re: Re: [PATCH v2 10/13] kprobes: Remove uneeded kernel dependency
 on struct arch_specific_insn
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Long <dave.long@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 14 Nov 2013 14:15:51 +0000
In-Reply-To: <52842F2C.1030701@hitachi.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
	  <1381871068-27660-11-git-send-email-dave.long@linaro.org>
	 <1384362833.3392.42.camel@linaro1.home> <52842F2C.1030701@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-14 at 11:02 +0900, Masami Hiramatsu wrote:
> (2013/11/14 2:13), Jon Medhurst (Tixy) wrote:
> > On Tue, 2013-10-15 at 17:04 -0400, David Long wrote:
> >> From: "David A. Long" <dave.long@linaro.org>
> >>
> >> Instead of depending on include/asm/kprobes.h to provide a dummy definition
> >> for struct arch_specific_insn, do so in include/linux/kprobes.h.
> > 
> > That change description doesn't quite seem to quite make sense to me.
> > 
> > Anyway, what we're trying to do with this patch is to allow us to use
> > arch_specific_insn for purposes additional to implementing kprobes. This
> > patch enables that but I'm wary that the kprobes code assumes that ainsn
> > is a struct arch_specific_insn, e.g. in linux/kernel/kprobes.c we have:
> > 
> > 	memcpy(&p->ainsn, &ap->ainsn, sizeof(struct arch_specific_insn));
> > 
> > Now, that code isn't compiled when kprobes isn't configured, but it
> > seams to me to be safer if that was also changed to 
> > 
> > 	memcpy(&p->ainsn, &ap->ainsn, sizeof(p->ainsn));
> 
> This kind of cleanup looks good for me, but I don't agree to change
> the type of the member (removing is OK) by Kconfig.

Wouldn't that still require an #ifdef CONFIG_KPROBES around ainsn?
Admittedly a less ugly one than one to change its type to an int.

>  If you want to
> change the framework of kprobes and uprobes itself (unification),
> I'm appreciate to discuss with you and uprobes people, because it
> will involve all arch dependent code change, *NOT ONLY* the ARM issue.

Well, I don't think the goal wasn't unification as such. For kprobes on
ARM we have to decode and simulate pretty much the entire instruction
set(s) and the attempt to implement uprobes on ARM have tried to make
use of as much of that as possible. The tricky bit has been as to where
to try and draw the level of abstraction, and it seems this may well be
leaking out of the arch specific arena.

Bit of background, Dave Long has been working on ARM uprobes based on
Rabin Vincent's earlier work, and I, as author of a large part of the
current ARM kprobes code, have been reviewing (not very satisfactorily I
admit) the bits that impact that. One of my motivations has been to push
the kprobes instruction decoding to be more generic, rather than special
casing things to cope with uprobes. This is because I'm aware of the
reoccurring theme on the ARM lists that it would be good to not have all
the different methods of instruction decoding, for probes, debug and
simulation, etc. (I'm sceptical that a one-size-fits-all is possible,
but consolidation where practical is good).

> 
> > However, I also wonder if we should instead leave arch_specific_insn as
> > a kprobes specific structure and on ARM define it in terms of a new more
> > generic 'struct probe_insn'? The drawback with that is that we'd
> > probably end up with a struct just containing a single member which
> > seems a bit redundant:
> >
> > struct arch_specific_insn {
> > 	struct probe_insn pinsn;
> > };
> 
> I also disagree it. If you have a plan to integrate uprobes and kprobes
> arch specific code, please share it with us.

There's not really a 'plan', just an attempt to reuse the instruction
decoding code used by kprobes in the implementation of uprobes, i.e. the
patch series [1] which this mail thread is in reply to.

[1] http://thread.gmane.org/gmane.linux.kernel/1579985

>  I'm happy to work with you.
> There are already many maintainers on each feature who is responsible for
> it (even it is a piece of code), and scripts/get_maintainers.pl gives you
> who are.
>
> 
> Srikar, Oleg, I think it's a good time to merge such arch_specific mechanism
> of uprobes and kprobes. Would you think we can do similar thing on x86 too?

-- 
Tixy

