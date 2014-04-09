Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714AbaDIPMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:12:43 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:42149 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148AbaDIPMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:12:41 -0400
MIME-Version: 1.0
In-Reply-To: <1096300004.2306764.1397043990013.JavaMail.zimbra@redhat.com>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
	<CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
	<CA+55aFyfKOv59hptv9rEcf31X5O8s26z+S8f-MchM1C0WtXx3A@mail.gmail.com>
	<20140408181305.GT10526@twins.programming.kicks-ass.net>
	<CA+55aFz+yMdXfsb-t3JzDhj6=M=-ggjDDGAQSbtfEcNhgyoopA@mail.gmail.com>
	<1860555101.1890107.1396990941681.JavaMail.zimbra@redhat.com>
	<CA+55aFzYwNde4ZyKgy_raRx9nz4+8he1-Fk9+_DDhWs-7fBbjw@mail.gmail.com>
	<1096300004.2306764.1397043990013.JavaMail.zimbra@redhat.com>
Date: Wed, 9 Apr 2014 08:12:41 -0700
X-Google-Sender-Auth: DN1grVgfQ3TNT5grwbNvSDHNh5I
Message-ID: <CA+55aFx3vx+A1nmbUikDv1ddy-wJNGYzGDjSaiQz0BoXjLEEzA@mail.gmail.com>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Stancek <jstancek@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 4:46 AM, Jan Stancek <jstancek@redhat.com> wrote:
>
>
> I'm running reproducer with this patch applied on 3 systems:
> - two s390x systems where this can be reproduced within seconds
> - x86_64 Intel(R) Xeon(R) CPU E5240 @ 3.00GHz, where I could
>   reproduce it on average in ~3 minutes.
>
> It's running without failure over 4 hours now.

Ok. I committed my second patch.

It might be possible to avoid the two extra atomics by simply not
incrementing the target hash queue waiters count (again) in
requeue_futex() the first time we hit that case, and then avoiding the
final decrement too. But that is actually fairly complicated because
we might be requeuing multiple entries (or fail to requeue any at
all). We do have all that "drop_count" logic, so it's certainly quite
possible, but it gets complex and we'd need to be crazy careful and
pass in the state to everybody involved. So it isn't something I'm
personally willing to do. But if somebody cares, there's a slight
optimization opportunity in this whole futex_requeue() situation wrt
the waiter count increment/decrement thing.

               Linus
