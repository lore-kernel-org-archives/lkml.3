Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaIURkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 13:40:17 -0400
Received: from message.langara.bc.ca ([142.35.159.25]:35608 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaIURkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 13:40:15 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dbueso@suse.de
Message-id: <fabced99911c.541f0d7e@langara.bc.ca>
Date: Sun, 21 Sep 2014 17:40:14 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: Re: [PATCH] V1 1/2] ipc: let message queues use SIGEV_THREAD_ID with
 mq_notify
X-Accept-Language: en
In-reply-to: <541ED4C2.2050009@colorfullife.com>
References: <541ED4C2.2050009@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you explain what you mean with "only thread-safe way"?
> I'm a bit relunctant to extend mq_notify() without understanding 
> the reason.
> 
> What about:
> - use sigprocmask()
> - create one worker thread
> - then in a loop in that worker thread: use sigwaitinfo() or 
> signalfd() 
> to collect the signals.

Those all modify global state and are unusable by library
code. Hogging a signal for your own library is bad.

> And one point I don't like: Within timer_create():

> >  SIGEV_THREAD_ID (Linux-specific)
> >  [...]
> > The sigev_notify_thread_id field specifies a kernel thread ID,
> > that is, the value returned by clone(2) or gettid(2).
>
> Does that mean that SIGEV_THREAD_ID is guaranteed to remain
> Linux-specific, it's implicitely linked to the Linux
> clone()/gettid() threading model?
>
> > This flag is intended only for use by threading libraries.

Yes this is low-level Linux specific stuff.

Maybe GLibc could create a more abstract and portable interface on top
of SIGEV_THREAD_ID that other OS's and libraries could implement? This
is pretty much not relevant to Linux kernel code though except that
more features that use SIGEV_THREAD_ID would motivate GLibc developers
to create a wrapper over this and that maybe the Linux kernel could be
modified to make it easier to create a more abstract and portable
wrapper.

If you feel that the whole SIGEV_THREAD_ID line of functionality was a
mistake in the first place and that people should use signals less and
use functionality like epoll more that's also okay.

If you also feel that nobody would use the feature in the first place
that's okay too.

Personally, it just bugged me that SIGEV_THREAD_ID was only used by
timers and not in a few other places where it seems like an obvious
fit.

Thank you,
Steven Stewart-Gallus
