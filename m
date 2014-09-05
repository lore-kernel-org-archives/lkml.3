Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaIEA3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 20:29:31 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:55032 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaIEA33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 20:29:29 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Thu, 4 Sep 2014 20:29:26 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/17] locks: generic_delete_lease doesn't need a
 file_lock at all
Message-ID: <20140904202926.74c76ee2@tlielax.poochiereds.net>
In-Reply-To: <20140904201424.GB26054@infradead.org>
References: <1409834323-7171-1-git-send-email-jlayton@primarydata.com>
	<1409834323-7171-6-git-send-email-jlayton@primarydata.com>
	<20140904201424.GB26054@infradead.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014 13:14:24 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Sep 04, 2014 at 08:38:31AM -0400, Jeff Layton wrote:
> > Ensure that it's OK to pass in a NULL file_lock double pointer on
> > a F_UNLCK request and convert the vfs_setlease F_UNLCK callers to
> > do just that.
> > 
> > Finally, turn the BUG_ON in generic_setlease into a WARN_ON_ONCE
> > with an error return. That's a problem we can handle without
> > crashing the box if it occurs.
> 
> Can we just make generic_delete_lease (maye renamed to vfs_delete_lease)
> the interface for deleting leases instead of going through a useless
> multiplex and file operation?
> 

I'm not sure that change really makes sense to me at this point.

Suppose we have an exportable filesystem with a ->setlease
implementation [1]. We end up calling into it to set up a lease and it
calls generic_add_lease. If we make the change you're suggesting, then
we'll have no parallel to a ->setlease op when removing that lease.

We could of course make a ->dellease op or something, but I'd rather
not introduce that change until I've had a chance to do some other
cleanup to the file locking infrastructure.

So...I'm not opposed to doing what you suggest, but I'd rather not do it
just yet until I've gotten a little farther with some other cleanup of
how we deal with locks in general. I think it'll be easier to do that
once some other changes have gone in.

I'll post a draft patchset based on those changes "real soon now" as an
RFC. Hopefully at that point my rationale will make a bit more sense...

[1]: of course, only cifs has a non-trivial one for now and it's pretty
half-assed...

-- 
Jeff Layton <jlayton@primarydata.com>
