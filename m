Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab3ATTZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 14:25:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab3ATTZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 14:25:37 -0500
Date: Sun, 20 Jan 2013 20:24:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Kernel Security <security@kernel.org>,
        Michael Davidson <md@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Julien Tinnes <jln@google.com>,
        Aaron Durbin <adurbin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@hack.frob.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/4] (Was: ptrace: prevent PTRACE_SETREGS from corrupting
	stack)
Message-ID: <20130120192448.GA6771@redhat.com>
References: <20130115172613.GA3011@redhat.com> <20130116181830.GA6469@redhat.com> <CA+55aFzkWqSEzw9oa5JodrM2NWE0H_AF7xyzRhd+DQ=PB=ZT2A@mail.gmail.com> <20130118153700.GA27915@redhat.com> <CA+55aFxEow_-PoX0xFa07yOi6az=6uVx8zeOsfToErmzh7dB8A@mail.gmail.com> <20130118172854.GA29753@redhat.com> <20130118175224.GA520@redhat.com> <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com> <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add lkml/cc's.

On 01/18, Linus Torvalds wrote:
>
> On Fri, Jan 18, 2013 at 10:55 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Or we can do this after wait_task_inactive() but then we need to take
> > ->siglock again.
>
> Yes. We absolutely need siglock, since that would be exactly what
> would protect us against signal_wake_up() (which is, I *think* the
> only thing that can ever wake up the TASK_TRACED/WAKEKILL cases).

Yes. And thus 4/4 probably should be 1/4.

> And we'd need to make sure to re-set the WAKEKILL flag not just in all
> the callers of ptrace_check_attach(), but also in the failure case of
> wait_task_inactive(). I'm not sure it can actually fail if we cleared
> WAKEKILL, but it's all pretty subtle.

Afaics it can't fail if we clear WAKEKILL... So 2/4 assumes it should
always succeed and adds the warning.

> And when we *do* set the WAKEKILL bit again, we should make sure to
> wake the task in case the killable signal happened while it was clear.

Yes, yes, this is clear. And we need to ensure we can not race with
attach-after-detach...

> And I agree that this is all pretty scary and generally playing with
> another process' 'flags' field is some really nasty business. So I'm a
> bit worried about it.

Oh yes. And I was going to argue that (a much simpler) change which
doesn't allow the tracee to return from ptrace_stop() is better. But
then I recalled about set_task_blockstep() and changed my mind (see
the changelog in 2/4).

Greg, this doesn't look like -stable material. But please let me know
if you think 2/4 should be backported. With a couple of simple hacks
in PTRACE_DETACH/LISTEN paths we can do this without 1/4 and without
changes outside of ptrace.c. But again, probably we shouldn't do this.

Please review.

Oleg.

