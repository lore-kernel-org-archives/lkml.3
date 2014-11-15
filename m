Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaKOVWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 16:22:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbaKOVWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 16:22:38 -0500
Message-ID: <1416086539.12597.15.camel@linux-t7sj.site>
Subject: Re: [PATCH 1/1] ipc/mqueue.c: Drag unneeded code out of locks
From: Davidlohr Bueso <dave@stgolabs.net>
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Doug Ledford <dledford@redhat.com>, linux-newbie@vger.kernel.org
Date: Sat, 15 Nov 2014 13:22:19 -0800
In-Reply-To: <fbb3e8aa49d6.5466da38@langara.bc.ca>
References: <fae396b9bc15.545c5b55@langara.bc.ca>
	 <1415780201.24725.2.camel@linux-t7sj.site>
	 <fbb3e8aa49d6.5466da38@langara.bc.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-15 at 04:44 +0000, Steven Stewart-Gallus wrote:
> > What's the benefit here? Seems very risky at very little gain.
> >
> > The juice ain't worth the squeeze. NAK
> 
> Hello,
> 
> It is fair to argue that these changes are too tiny to be very
> meaningful for performance but the other goal of this patch was also
> to make the code look cleaner and easier for me and other people to
> understand. I hope that is a reasonable desire.

I don't see how on earth you consider your patch makes things easier to
understand. For instance, adding local variables from structures passed
to a function does *not* make things more clearer:

+                       bool too_many_open_files;
+                       long msgqueue_lim;
+                       unsigned long u_bytes;
+
+                       msgqueue_lim = rlimit(RLIMIT_MSGQUEUE);
+
+                       spin_lock(&mq_lock);
+
+                       u_bytes = u->mq_bytes;
+                       too_many_open_files = u_bytes + mq_bytes < u_bytes ||
+                               u_bytes + mq_bytes > msgqueue_lim;
+                       if (!too_many_open_files)

Plus you add context specific regions within the function (code around
{ }), ugly and something we've been removing!

In fact it makes it *harder* to read: Now you have to keep in mind where
each variable came from, ie: u_bytes.

> It is not fair to argue that these changes are risky. 

Oh no? Andrew already found issues with the patch. But you claim there
is no risk. But hey, not getting the patch right the first time is fine,
except that the patch (i) has no tangible effects on performance, (ii)
as a cleanup, it does not make it any easier to read, (iii) can
potentially introduce bugs (yes, extra risk in subtleties when changing
critical regions and goto statements... we have had similar regressions
in ipc in the past).

Thanks,
Davidlohr

