Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab3EBPR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:17:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3EBPRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:17:55 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=qVwF2erAZtkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Zh7nNSpF_ucA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=l1vHjWl1OCTzCJgS4TgA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=jbrJJM5MRmoA:10 a=7DSvI1NPTFQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367507873.30667.136.camel@gandalf.local.home>
Subject: Re: [PATCH v2] init: Do not warn on non-zero initcall return
From: Steven Rostedt <rostedt@goodmis.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 02 May 2013 11:17:53 -0400
In-Reply-To: <CAMuHMdXguZknoR=A6Cpqoz4VYX6wuPtUWfV4yGhkBiGMQOdaYg@mail.gmail.com>
References: <1367429751.30667.99.camel@gandalf.local.home>
	 <CAMuHMdXguZknoR=A6Cpqoz4VYX6wuPtUWfV4yGhkBiGMQOdaYg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 09:43 +0200, Geert Uytterhoeven wrote:
> On Wed, May 1, 2013 at 7:35 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Commit f91eb62f71 "init: scream bloody murder if interrupts are enabled
> > too early" added three new warnings. The first two seemed reasonable,
> > but the third included a warning when an initcall returned non-zero.
> > Although, the third WARN() does include an imbalanced preempt disabled,
> > or irqs disable, it shouldn't warn if it only had an initcall that just
> > returns non-zero.
> >
> > In fact, according to Linus, it shouldn't print at all. As it only
> > prints with initcall_debug set, and that already shows enough
> > information to fix things.
> >
> > Link: http://lkml.kernel.org/r/CA+55aFzaBC5SFi7=F2mfm+KWY5qTsBmOqgbbs8E+LUS8JK-sBg@mail.gmail.com
> >
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> >
> > diff --git a/init/main.c b/init/main.c
> > index bea1287..ceed17a 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -686,11 +686,8 @@ int __init_or_module do_one_initcall(initcall_t fn)
> >
> >         msgbuf[0] = 0;
> >
> > -       if (ret && ret != -ENODEV && initcall_debug)
> > -               sprintf(msgbuf, "error code %d ", ret);
> > -
> >         if (preempt_count() != count) {
> > -               strlcat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
> > +               sprintf(msgbuf, "preemption imbalance ");
> 
> snprintf(), please?

Why? The msgbuf is 64 bytes, this is the first occurrence and
"preemption imbalance " is much less than 64 bytes.

> 
> JFYI, the v3.9 version already used up all of msgbuf[] in the
> worst-case scenario,
> and it did have the strlcat() as a parachute:

Right, the other users had strlcat as they were not the first user and
add onto the string.

-- Steve

> 
> $ echo -n "error code 1234567890 preemption imbalance disabled
> interrupts " | wc -c
> 63
> $


