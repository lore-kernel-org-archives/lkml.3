Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3EARLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:11:21 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:46921 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3EARLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:11:15 -0400
MIME-Version: 1.0
In-Reply-To: <1367420537.30667.91.camel@gandalf.local.home>
References: <1367420537.30667.91.camel@gandalf.local.home>
Date: Wed, 1 May 2013 10:11:14 -0700
X-Google-Sender-Auth: ztXTx9BjEqqg-qOjBXBVlIfP8GE
Message-ID: <CA+55aFzaBC5SFi7=F2mfm+KWY5qTsBmOqgbbs8E+LUS8JK-sBg@mail.gmail.com>
Subject: Re: [PATCH] init: Do not warn on non-zero initcall return
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 8:02 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Commit f91eb62f71 "init: scream bloody murder if interrupts are enabled
> too early" added three new warnings. The first two seemed reasonable,
> but the third included a warning when an initcall returned non-zero.
> Although, the third WARN() does include an imbalanced preempt disabled,
> or irqs disable, it shouldn't warn if it only had an initcall that just
> returns non-zero.

Ugh. Sorry, but this patch just looks stupid.

It seems that the right thing to do is to just remove the whole crappy

        if (ret && ret != -ENODEV && initcall_debug)
                sprintf(msgbuf, "error code %d ", ret);

thing entirely, since it's moronic to add that error code printout
anyway, since if initcall_debug is set, we already do a much *better*
job earlier with the whole

        pr_debug("initcall %pF returned %d after %lld usecs\n",
                 fn, ret, duration);

printout in do_one_initcall_debug().  That will then fix the WARN()
issue automatically.

Hmm?

              Linus
