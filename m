Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3ITACW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 20:02:22 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:39763 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3ITACV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 20:02:21 -0400
MIME-Version: 1.0
In-Reply-To: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
Date: Thu, 19 Sep 2013 19:02:20 -0500
X-Google-Sender-Auth: kTclKm-X-ofwVrC7GuoWROn431M
Message-ID: <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 2:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> It fixes stacks overruns reported by Benjamin Herrenschmidt:
> http://lkml.kernel.org/r/1378330796.4321.50.camel%40pasglop

So I don't really dislike this patch-series, but isn't "irq_exit()"
(which calls the new softirq_on_stack()) already running in the
context of the irq stack? And it's run at the very end of the irq
processing, so the irq stack should be empty too at that point.

So switching to *another* empty stack sounds really sad. No? Taking
more cache misses etc, instead of using the already empty - but
cache-hot - stack that we already have.

I'm assuming that the problem is that since we're already on the irq
stack, if *another* irq comes in, now that *other* irq doesn't get yet
another irq stack page. And I'm wondering whether we shouldn't just
fix that (hopefully unlikely) case instead? So instead of having a
softirq stack, we'd have just an extra irq stack for the case where
the original irq stack is already in use.

Hmm?

                   Linus
