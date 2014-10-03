Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbaJCWsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:48:22 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63731 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbaJCWsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:48:19 -0400
Date: Fri, 3 Oct 2014 17:48:14 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, luto@amacapital.net, dvlasenk@redhat.com,
        tglx@linutronix.de
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using
 THUNK helpers
Message-ID: <20141003174814.6829cf26@as>
In-Reply-To: <20141003214124.GA31614@redhat.com>
References: <20140921184153.GA23727@redhat.com>
	<tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org>
	<542E2B05.5080607@oracle.com>
	<20141003083954.10a13a24@as>
	<20141003214124.GA31614@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2014 23:41:24 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 10/03, Chuck Ebbert wrote:
> >
> > > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> > > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> > > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> > > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> > > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> > > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> > > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> > > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> > > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> > > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> >
> > <snip lots of repeats of this>
> >
> > I *think* this is because RBP isn't being saved across task switch
> > anymore?
> >
> > Without CONFIG_FRAME_POINTERS that night not be a problem...
> 
> Could you please spell?
> 
> I don't even understand "RBP isn't being saved", SAVE_CONTEXT/RESTORE_CONTEXT
> do push/pop %rbp?
> 

SAVE_ARGS/RESTORE_ARGS, which is what THUNK uses, doesn't push/pop %rbp

Before, SAVE_ALL/RESTORE_ALL were being used around the call to
preempt_schedule(). So from the symptoms I thought this was the problem.
