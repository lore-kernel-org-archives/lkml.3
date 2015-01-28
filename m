Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761784AbbA2DiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:38:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:51066 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbbA2Bl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:41:29 -0500
Date: Wed, 28 Jan 2015 16:37:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
        riel@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [tip:sched/urgent] sched/fair:  Avoid using uninitialized
 variable in preferred_group_nid()
Message-ID: <20150128153754.GG23038@twins.programming.kicks-ass.net>
References: <54C2139202000078000588F7@mail.emea.novell.com>
 <tip-81907478c4311a679849216abf723999184ab984@git.kernel.org>
 <54C9044B020000780005A5E6@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C9044B020000780005A5E6@mail.emea.novell.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 02:46:19PM +0000, Jan Beulich wrote:
> >>> On 28.01.15 at 15:29, <tipbot@zytor.com> wrote:
> > Commit-ID:  81907478c4311a679849216abf723999184ab984
> > Gitweb:     
> > http://git.kernel.org/tip/81907478c4311a679849216abf723999184ab984 
> > Author:     Jan Beulich <JBeulich@suse.com>
> > AuthorDate: Fri, 23 Jan 2015 08:25:38 +0000
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 28 Jan 2015 13:14:12 +0100
> > 
> > sched/fair: Avoid using uninitialized variable in preferred_group_nid()
> > 
> > At least some gcc versions - validly afaict - warn about potentially
> > using max_group uninitialized: There's no way the compiler can prove
> > that the body of the conditional where it and max_faults get set/
> > updated gets executed; in fact, without knowing all the details of
> > other scheduler code, I can't prove this either.
> > 
> > Generally the necessary change would appear to be to clear max_group
> > prior to entering the inner loop, and break out of the outer loop when
> > it ends up being all clear after the inner one. This, however, seems
> > inefficient, and afaict the same effect can be achieved by exiting the
> > outer loop when max_faults is still zero after the inner loop.
> > 
> > [ mingo: changed the solution to zero initialization: uninitialized_var()
> >   needs to die, as it's an actively dangerous construct: if in the future
> >   a known-proven-good piece of code is changed to have a true, buggy
> >   uninitialized variable, the compiler warning is then supressed...
> 
> But you went farther than that: You also dropped the breaking
> out of the outer loop. Yet that has - beyond the fixing of the bug
> here - the desirable effect of not continuing for perhaps many
> iterations when nothing new can ever be found anymore.

That break is indeed desired. The 'problem' it fixes is that when
group_faults() returns 0, faults will be 0, which will not > max_faults,
and therefore we will not set max_group.

Without that break, we'll now set nodes to NODE_MASK_NONE, which will
mean the for_each_node(a, nodes) loop will NOP and our dist loop will
iterate pointlessly.
