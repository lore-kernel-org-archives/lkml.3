Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab3B0TyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:54:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab3B0TyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:54:00 -0500
Message-ID: <512E6443.9050603@redhat.com>
Date: Wed, 27 Feb 2013 14:53:39 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, aquini@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org> <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com> <511BE4A3.8050607@redhat.com> <CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com> <511C1204.9040608@redhat.com> <CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com> <511C24A6.8020409@redhat.com> <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com> <512E376D.70105@redhat.com> <CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com>
In-Reply-To: <CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 12:10 PM, Linus Torvalds wrote:

> Ugh. That really is rather random. "short" and fserver seems to
> improve a lot (including the "new" version), the others look like they
> are either unchanged or huge regressions.
>
> Is there any way to get profiles for the improved versions vs the
> regressed ones? It might well be that we have two different classes of
> spinlocks. Maybe we could make the back-off version be *explicit* (ie
> not part of the normal "spin_lock()", but you'd use a special
> "spin_lock_backoff()" function for it) because it works well for some
> cases but not for others?

If we have two classes of spinlocks, I suspect we would be better
off making those high-demand spinlocks MCS or LCH locks, which have
the property that having N+1 CPUs contend on the lock will never
result in slower aggregate throughput than having N CPUs contend.

Both the current spinlock code and the spinlock code with backoff
has the annoying property that adding more waiters to the lock can
slow down aggregate throughput.

The backoff code seems to push that point a little further out.
It appears that that may result in "lesser bottlenecks" disappearing,
which in turn triggers amplification of the worst bottlenecks.

> Hmm? At the very least, it would give us an idea of *which* spinlock
> it is that causes the most pain. I think your earlier indications was
> that it's the mutex->wait_lock or something?

I can certainly take profiles of various workloads, but there is
absolutely no guarantee that I will see the same bottlenecks that
eg. the people at HP have seen. The largest test system I currently
have access to has 40 cores, vs. the 80 cores in the (much more
interesting) HP results I pasted.

Would you also be interested in performance numbers (and profiles)
of a kernel that has bottleneck spinlocks replaced with MCS locks?

That could make for an interesting comparison...

-- 
All rights reversed
