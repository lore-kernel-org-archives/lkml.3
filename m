Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbaIVSZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:25:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:38624 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753592AbaIVSZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:25:36 -0400
Date: Mon, 22 Sep 2014 14:25:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-mips@linux-mips.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MIPS: ftrace.h: Fix the MCOUNT_INSN_SIZE definition
Message-ID: <20140922142534.4087a0a9@gandalf.local.home>
In-Reply-To: <5420546D.6050102@gmail.com>
References: <1411392779-9554-1-git-send-email-markos.chandras@imgtec.com>
	<1411392779-9554-2-git-send-email-markos.chandras@imgtec.com>
	<5420546D.6050102@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 09:55:09 -0700
David Daney <ddaney.cavm@gmail.com> wrote:

> On 09/22/2014 06:32 AM, Markos Chandras wrote:
> > The MCOUNT_INSN_SIZE is meant to be used to denote the overall
> > size of the mcount() call. Since a jal instruction is used to
> > call mcount() the delay slot should be taken into consideration
> > as well.
> > This also replaces the MCOUNT_INSN_SIZE usage with the real size
> > of a single MIPS instruction since, as described above, the
> > MCOUNT_INSN_SIZE is used to denote the total overhead of the
> > mcount() call.
> 
> Are you seeing errors with the existing code?  If so please state what 
> they are.
> 
> By changing this, we can no longer atomically replace the instruction. 
> So I think shouldn't be changing this stuff unless there is a real bug 
> we are fixing.

Actually, it looks like the code still works the same, as it uses the
old size of 4 (FTRACE_MIPS_INSN_SIZE) to do the update.

> 
> In conclusion: NAK unless the patch fixes a bug, in which case the 
> change log *must* state what the bug is, and how the patch addresses the 
> problem.
> 

I agree that the change log needs to explicitly state what is being
fixed. The only thing I can think of is if MIPS has kprobes, and
kprobes does different logic or may reject completely changes to ftrace
mcount call locations. This change will have kprobes flag the delay
slot as owned by ftrace.

It may also fix the stack tracer, as it searches for the ip saved in
the return address to find where the true stack is (skipping the stack
part that calls the strack tracer itself). If the link register holds
the location after the delay slot, then this would require
MCOUNT_INSN_SIZE to include the delay slot as well. Or I could add
another macro called MCOUNT_DELAY_SLOT_SIZE that can be defined by an
arch (and keep it zero for all other archs). That wouldn't be too much
of an issue to implement.

But again, the change log needs to express what is being fixed, which I
don't see.

I'm willing to update the generic code to express different ways of
implementation to keep the archs from doing hacks like this.

-- Steve
