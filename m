Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3FMTEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:04:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3FMTEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:04:41 -0400
Date: Thu, 13 Jun 2013 12:04:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-Id: <20130613120439.fe56d178a1143089136fdacc@linux-foundation.org>
In-Reply-To: <20130613185318.GB12075@mtj.dyndns.org>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
	<20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
	<20130613020536.GA10979@localhost>
	<20130612200311.7f9d938a.akpm@linux-foundation.org>
	<20130613185318.GB12075@mtj.dyndns.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013 11:53:18 -0700 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew, Kent.
> 
> (cc'ing NFS folks for id[r|a] discussion)
> 
> On Wed, Jun 12, 2013 at 08:03:11PM -0700, Andrew Morton wrote:
> > They all sound like pretty crappy reasons ;) If the idr/ida interface
> > is nasty then it can be wrapped to provide the same interface as the
> > percpu tag allocator.
> > 
> > I could understand performance being an issue, but diligence demands
> > that we test that, or at least provide a convincing argument.
> 
> The thing is that id[r|a] guarantee that the lowest available slot is
> allocated

That isn't the case for ida_get_new_above() - the caller gets to
control the starting index.

> and this is important because it's used to name things which
> are visible to userland - things like block device minor number,
> device indicies and so on.  That alone pretty much ensures that
> alloc/free paths can't be very scalable which usually is fine for most
> id[r|a] use cases as long as lookup is fast.  I'm doubtful that it's a
> good idea to push per-cpu tag allocation into id[r|a].  The use cases
> are quite different.

You aren't thinking right.

The worst outcome here is that idr.c remains unimproved and we merge a
new allocator which does basically the same thing.

The best outcome is that idr.c gets improved and we don't have to merge
duplicative code.

So please, let's put aside the shiny new thing for now and work out how
we can use the existing tag allocator for these applications.  If we
make a genuine effort to do this and decide that it's fundamentally
hopeless then this is the time to start looking at new implementations.

(I can think of at least two ways of making ida_get_new_above() an
order of magnitude faster for this application and I'm sure you guys
can as well.)
