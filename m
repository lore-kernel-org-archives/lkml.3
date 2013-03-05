Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3CEPkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:40:55 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:56400 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab3CEPkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:40:53 -0500
MIME-Version: 1.0
In-Reply-To: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
Date: Tue, 5 Mar 2013 07:40:51 -0800
X-Google-Sender-Auth: 8WDoHVFlALGVpYrRmS50QKo6qwM
Message-ID: <CA+55aFx5pAsC9Ej2h9mniEU89oD=1mq6iPA+R2MBX-z74J0B5Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@redhat.com>, Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 1:35 AM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>
> The following set of patches are based on the discussion of holding the
> ipc lock unnecessarily, such as for permissions and security checks:

Ok, looks fine from a quick look (but then, so did your previous patch-set ;)

You still open-code the spinlock in at least a few places (I saw
sem_getref), but I still don't care deeply.

>> 2) While on an Oracle swingbench DSS (data mining) workload the
> improvements are not as exciting as with Rik's benchmark, we can see
> some positive numbers. For an 8 socket machine the following are the
> percentages of %sys time incurred in the ipc lock:

Ok, I hoped for it being more noticeable. Since that benchmark is less
trivial than Rik's, can you do a perf record -fg of it and give a more
complete picture of what the kernel footprint is - and in particular
who now gets that ipc lock function? Is it purely semtimedop, or what?
Look out for inlining - ipc_rcu_getref() looks like it would be
inlined, for example.

It would be good to get a "top twenty kernel functions" from the
profile, along with some call data on where the lock callers are.. I
know that Rik's benchmark *only* had that one call-site, I'm wondering
if the swingbench one has slightly more complex behavior...

                 Linus
