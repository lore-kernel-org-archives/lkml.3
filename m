Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbaKRUTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:19:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbaKRUTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:19:38 -0500
Date: Tue, 18 Nov 2014 12:19:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Tim Hartrick <tim@edgecast.com>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] Repeated fork() causes SLAB to grow without bound
Message-Id: <20141118121936.07b02545a0684b2cc839a10c@linux-foundation.org>
In-Reply-To: <546AB1F5.6030306@redhat.com>
References: <502D42E5.7090403@redhat.com>
	<20120818000312.GA4262@evergreen.ssec.wisc.edu>
	<502F100A.1080401@redhat.com>
	<alpine.LSU.2.00.1208200032450.24855@eggly.anvils>
	<CANN689Ej7XLh8VKuaPrTttDrtDGQbXuYJgS2uKnZL2EYVTM3Dg@mail.gmail.com>
	<20120822032057.GA30871@google.com>
	<50345232.4090002@redhat.com>
	<20130603195003.GA31275@evergreen.ssec.wisc.edu>
	<20141114163053.GA6547@cosmos.ssec.wisc.edu>
	<20141117160212.b86d031e1870601240b0131d@linux-foundation.org>
	<20141118014135.GA17252@cosmos.ssec.wisc.edu>
	<546AB1F5.6030306@redhat.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014 21:41:57 -0500 Rik van Riel <riel@redhat.com> wrote:

> > Because of the serial forking there does indeed end up being an
> > infinite number of vmas.  The initial vma can never be deleted
> > (even though the initial parent process has long since terminated)
> > because the initial vma is referenced by the children.
> 
> There is a finite number of VMAs, but an infite number of
> anon_vmas.
> 
> Subtle, yet deadly...

Well, we clearly have the data structures screwed up.  I've forgotten
enough about this code for me to be unable to work out what the fixed
up data structures would look like :( But surely there is some proper
solution here.  Help?

> > I can't say, but it only affects users who fork more than five
> > levels deep without doing an exec.  On the other hand, there are at
> > least three users (Tim Hartrick, Michal Hocko, and myself) who have
> > real world applications where the consequence of no patch is a
> > crashed system.
> > 
> > I would suggest reading the thread starting with my initial bug
> > report for what others have had to say about this.
> 
> I suspect what Andrew is hinting at is that the
> changelog for the patch should contain a detailed
> description of exactly what the bug is, how it is
> triggered, what the symptoms are, and how the
> patch avoids it.
>
> That way people can understand what the code does
> simply by looking at the changelog - no need to go
> find old linux-kernel mailing list threads.

Yes please, there's a ton of stuff here which we should attempt to
capture.

https://lkml.org/lkml/2012/8/15/765 is useful.

I'm assuming that with the "foo < 5" hack, an application which forked
5 times then did a lot of work would still trigger the "catastrophic
issue at page reclaim time" issue which Rik identified at
https://lkml.org/lkml/2012/8/20/265?

There are real-world workloads which are triggering this slab growth
problem, yes?  (Detail them in the changelog, please).

This bug snuck under my radar last time - we're permitting unprivileged
userspace to exhaust memory and that's bad.  I'm OK with the foo<5
thing for -stable kernels, as it is simple.  But I'm reluctant to merge
(or at least to retain) it in mainline because then everyone will run
away and think about other stuff and this bug will never get fixed
properly.
