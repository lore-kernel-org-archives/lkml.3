Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaCZGcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 02:32:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaCZGcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 02:32:05 -0400
Date: Tue, 25 Mar 2014 23:32:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tytso@mit.edu
Cc: David Rientjes <rientjes@google.com>, Dave Jones <davej@redhat.com>,
        Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
Message-Id: <20140325233209.31756c92.akpm@linux-foundation.org>
In-Reply-To: <20140326061904.GA4907@thunk.org>
References: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be>
	<20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
	<20140322170322.GA23583@thunk.org>
	<20140322101512.eaeb542b.akpm@linux-foundation.org>
	<20140322172606.GB23583@thunk.org>
	<20140322173207.GC23583@thunk.org>
	<20140322105524.7baec73a.akpm@linux-foundation.org>
	<20140322192423.GA10176@redhat.com>
	<alpine.DEB.2.02.1403251800320.21733@chino.kir.corp.google.com>
	<20140326061904.GA4907@thunk.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014 02:19:04 -0400 tytso@mit.edu wrote:

> On Tue, Mar 25, 2014 at 06:06:17PM -0700, David Rientjes wrote:
> > 
> > The point is not to add new callers and new code should handle NULL 
> > correctly, not that we should run around changing current users to just do 
> > infinite retries.  Checkpatch should have nothing to do with that.
> 
> My problem with this doctrinaire "there should never be any new users"
> is that sometiems there *are* worse things than infinite retries.  If
> the alternative is bringing the entire system down, or livelocking the
> entire system, or corrupting user data, __GFP_NOFAIL *is* the more
> appropriate option.

Well, there are always alternatives.  For example ext3 could
preallocate a single transaction_t and a single IO page and fall back
to synchronous page-at-a-time journal writes.  But I can totally see
that such things are unattractive: heaps of new code which is never
tested in real life.  The page allocator works so damn well that it
doesn't make sense to implement it.

> If you try to tell those of us outside of the mm layer, "thou shalt
> never use __GFP_NOFAIL in new code", and we have some new code where
> the alternative is worse, we can either open-code the loop, or have
> some mm hackers and/or checkpatch whine at us.
> 
> Andrew has declared that he'd prefer that we not open code the retry
> loop; if you want to disagree with Andrew, feel free to pursuade him
> otherwise.  If you want to tell me that I should accept user data
> corruption, I'm going to ignore you (and/or checkpatch).

Please use NOFAIL ;) The core page allocator will always be able to
implement this better than callers.
