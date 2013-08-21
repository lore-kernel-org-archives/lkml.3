Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3HUUYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:24:53 -0400
Received: from kanga.kvack.org ([205.233.56.17]:60018 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab3HUUYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:24:51 -0400
Date: Wed, 21 Aug 2013 16:24:48 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, linux-aio@kvack.org
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20130821202448.GJ13330@kvack.org>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com> <20130821130231.GG13330@kvack.org> <20130821123032.8d0668d34231aabeddff24ea@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821123032.8d0668d34231aabeddff24ea@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 12:30:32PM -0700, Andrew Morton wrote:
> On Wed, 21 Aug 2013 09:02:31 -0400 Benjamin LaHaise <bcrl@kvack.org> wrote:
> 
> > One of the major problems your changeset continues to carry is that your 
> > new read_iter/write_iter operations permit blocking (implicitely), which 
> > really isn't what we want for aio.  If you're going to introduce a new api, 
> > it should be made non-blocking, and enforce that non-blocking requirement 
> 
> It's been so incredibly long and I've forgotten everything AIO :(
> 
> In this context, "non-blocking" means no synchronous IO, yes?  Even for
> indirect blocks, etc.  What about accidental D-state blockage in page
> reclaim, or against random sleeping locks?

Those are all no-nos.  Blocking for memory allocation for short durations 
is okay, but not for wandering off into scan-the-world type ordeals (that 
is, it should be avoided).

> Also, why does this requirement exist?  "99% async" is not good enough?
> How come?

99% async is okay for the database folks, but not for all users.  Think 
unified event loops.  For example, the application I'm currently working 
on is using AIO to isolate disk access from blocking the main thread.  If 
things go off and block on random locks or on disk I/O, bad things happen, 
like watchdogs triggering.  One of the real world requirements we have is 
that the application has to keep running even if the disks we're running 
on go bad.  With SANs and multipath involved, sometimes I/O can take tens 
of seconds to complete.  You also don't want to block operations that can 
proceed by those that are presently blocked, as that reduces the available 
parallelism to devices and increases overall latency.

I'll admit there's a lot of work to be done in this area, hence why I've 
done some work on thread based AIO recently, but threads aren't great for 
all use-cases.  Ultimately something like Zach's schedulable stacks are 
needed to get the overhead down to something reasonable.

Still, we shouldn't keep on propagating broken APIs that don't reflect 
actual requirements.

		-ben
-- 
"Thought is the essence of where you are now."
