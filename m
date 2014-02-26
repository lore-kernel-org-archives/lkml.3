Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaBZTiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:38:12 -0500
Received: from fieldses.org ([174.143.236.118]:56579 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbaBZTiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:38:09 -0500
Date: Wed, 26 Feb 2014 14:37:40 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH 08/11] vfs: Merge check_submounts_and_drop and
 d_invalidate
Message-ID: <20140226193740.GA24456@fieldses.org>
References: <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87ob28kqks.fsf_-_@xmission.com>
 <87eh34jbsl.fsf_-_@xmission.com>
 <20140218174053.GE4026@tucsk.piliscsaba.szeredi.hu>
 <87y510dpra.fsf@xmission.com>
 <20140225151349.GA19981@fieldses.org>
 <87mwhe26kn.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwhe26kn.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 02:03:36PM -0800, Eric W. Biederman wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> > On Mon, Feb 24, 2014 at 04:01:29PM -0800, Eric W. Biederman wrote:
> >> Miklos Szeredi <miklos@szeredi.hu> writes:
> >> 
> >> >
> >> > You can optimize this by including the negative check within the above d_locked
> >> > region and calling __d_drop() instead.
> >> 
> >> For this patch just moving the code and not changing it is the corret
> >> thing to do because it helps with review and understanding the code.
> >> 
> >> There are two ways I could see going with optimizing the preamble.
> >> Simply dropping the d_lock from around the d_unhashed test as a pointer
> >> dereference should be atomic, and the test is racy against
> >> d_materialise_unique.
> >
> > Could you explain?  What's the race, and what are the consequences?

Actually I was just confused as to whether the above was "is racy" was
claiming the existance of some bug.

I believe I should have read the above as more like "the test is already
racy against d_materialise_unique, but it's a harmless race, and
dropping the d_lock wouldn't make it any worse".

> >> (We don't always hold the parent directories inode mutex when d_invalidate is called).
> 
> d_unhashed is not a permanent condition because of d_materialise_unique,
> and d_splice_alias.
> 
> d_invalidate can be called on an unhashed dentry in one of two ways
> (either d_revalidate dropped the dentry or another routine that drops
> the dentry beat the current invocation of d_invalidate to the job).
> 
> 
> There are 3 places d_revalidate is called.
> 
> Once on the rcu path with with the appropriate flag set.
> 
> Once without out the parent i_mutex held, just off of the rcu path,
> on that path d_invalidate is when d_revalidate fails.
> 
> Once during lookup with the parent directory i_mutex held.
> 
> 
> Because the parent direcories i_mutex is not always held accross
> d_revalidate and the following d_invalidate it happens that d_invalidate
> is not always an atomic operation.
> 
> 
> At worst the race results in a dentry that is dropped when it could be
> hashed,

Because somebody not holding the i_mutex calls d_invalidate based on old
information and unhashes something that
d_materialise_unique/d_splice_alias just hashed?

> that we will resurrect next time someone attempts to look it
> up and d_materialise_unique/d_splice_alias is called.

OK.

> None of that really matters for optimizing d_invalidate, but it is part
> of the background in which d_invalidate lives. All that is significant
> in d_invalidate is knowing that d_materialise_unique, and possibly
> d_splice_alias may run concurrently with d_invalidate.  It is unlikely
> and essentially harmless.
> 
> 
> After my patchset (because I removed all of the d_drop's from
> .d_revalidate) the only race that should remain is between two parallel
> calls of d_invalidate.  Which probably means we can remove the test for
> d_unhashed altogether.
> 
> Right now I just want to make this first big step and make certain the
> code is solid.  After that optimization is easy.

Thanks for the explanation!

--b.
