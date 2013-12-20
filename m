Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3LTAMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 19:12:22 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:48097 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab3LTAMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 19:12:20 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyay84UKWEbAZ=8bT-KV5gq-+1fWgS52gRQv=qZJzMSOQ@mail.gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	<1387478746-5436-5-git-send-email-davidlohr@hp.com>
	<CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
	<1387496569.8363.12.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFyay84UKWEbAZ=8bT-KV5gq-+1fWgS52gRQv=qZJzMSOQ@mail.gmail.com>
Date: Thu, 19 Dec 2013 16:12:19 -0800
X-Google-Sender-Auth: RsQeEkODo0noCGBInqB3kkuR0m0
Message-ID: <CA+55aFwH4jkVRug-iuz85Hk8k=ct3dkbiOphQigrsc5bH3EYNQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 3:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So how could we miss this? Explain to me what the separate counter
> does that isn't done by the spinlock head counter.

Hmm. Trying to answer this myself by looking at the code. And I just
realized that I described things wrong ("spin_contended()" rather than
"spin_is_locked()"). So that was a bug in my description.

One difference is that by avoiding the counter, the "do we have
waiters" is two values rather than one ("is spin locked" + "node list
head is empty"). So there are possible memory ordering issues wrt
reading those two fields, but I don't see it mattering: since you'd
need to read both "not locked" _and_ "list empty", any re-ordering
that shows both of those cases should be able to show the "waiters ==
0" case in the explicit separate counter model.

I don't know why I care, though. For some reason that extra counter
just makes me go "I'm convinced it's not needed", even though I can't
really explain why I should care about it.

        Linus
