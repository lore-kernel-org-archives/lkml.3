Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab3HMLeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:34:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18526 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3HMLeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:34:00 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=lGRwBxRWGKEA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jE_6hgDtenQA:10 a=pGLkceISAAAA:8 a=wdhA_4ul7SN5c7GK3XsA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 13 Aug 2013 07:33:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Shailaja Neelam <neelamshaila@gmail.com>,
        =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, james.hogan@imgtec.com,
        linux-kernel-mail <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] fix a Sparse warning in the arch/x86/kernel/irq_work.c
 file
Message-ID: <20130813073357.3099e8d4@gandalf.local.home>
In-Reply-To: <CAK7N6vp0jw+fxYHF-i-BrCCKGND5vGqvn-A7oX=+iZnTJ=w9Ww@mail.gmail.com>
References: <CAOUhrBGcH4Oe32cDFs++a1UyKaGNfCm1sCG6UC4an_fO5vDjjQ@mail.gmail.com>
	<20130812202909.373bc152@gandalf.local.home>
	<CAK7N6vp0jw+fxYHF-i-BrCCKGND5vGqvn-A7oX=+iZnTJ=w9Ww@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 11:09:34 +0530
anish singh <anish198519851985@gmail.com> wrote:


> > Instead, it calls irq_work() to do the event within a normal interrupt
> > context. Some architectures have the ability to trigger an interrupt on
> 
> irq_work processes event in normal interrupt context as you said but
> why interrupt context ? Is it because of the fast processing which is
> needed? Can we use softirq as anyways we have interrupt
> disabled(functions which calls irq_work makes sure of that right?).
> Hope I am not asking something very obvious.
>

We just need to make sure the work gets done outside of problem areas.
Usually, outside of locks, and specifically locks that disable
interrupts. Now, if irq_work() is needed outside of a lock that
only disables softirq, then you are correct, this would not be enough.
But really, because it's called "irq_work()" and not "softirq_work()",
you shouldn't be using locks that don't disable interrupts with a
irq_work handler.

Making it happen in softirq will just complicate the process. Real
interrupts are just easier to implement and suits the job well.

-- Steve
