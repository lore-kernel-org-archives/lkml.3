Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaCCWJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:09:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36219 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbaCCWJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:09:08 -0500
Date: Mon, 3 Mar 2014 22:09:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, "Theodore T'so" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Dave Chinner <david@fromorbit.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        Yongzhi Pan <panyongzhi@gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140303220905.GM18016@ZenIV.linux.org.uk>
References: <53022DB1.4070805@gmail.com>
 <CA+55aFxjAp23=ySEe8e8bTPbVw8Uh8d03zirg4TdHXGYiyjmwA@mail.gmail.com>
 <CA+55aFy4GvpFcboBiKdreU_Zh1RzynPoLxhvC9hijn60hkEZ3g@mail.gmail.com>
 <20140303214536.GK18016@ZenIV.linux.org.uk>
 <CA+55aFwGzNdCfENDr0A7EqwkqQ7W8Oc5UzBrZ5Wr_V9LRVcwew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwGzNdCfENDr0A7EqwkqQ7W8Oc5UzBrZ5Wr_V9LRVcwew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 01:56:31PM -0800, Linus Torvalds wrote:
> On Mon, Mar 3, 2014 at 1:45 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Um...  That's odd - we *could* get there with f.need_put and
> > file_count(file) equal to 1, but why would we want to take
> > f_pos_lock in that case?
> 
> Because that means that the file table is shared among threads. So
> another thread can access the struct file pointer and do a concurrent
> read() or write() on it, and so we need to lock f_pos.

Yes, but in that case fdget() has grabbed a reference to that sucker,
so the only way to end with refcount 1 is to have the damn thing gone
from descriptor table in between.  And AFAICS in that case we are just
fine without f_pos_lock.

>  - concurrent access due to duplicated "struct file_table" pointers.
> This is the "need_put" test, since __fget_light() will have tested the
> proper files->count already.

Shared descriptor table means that we'd better have a reference grabbed
already...

I agree that file_count(file) > 1 for any reason requires locking it;
it's just that need_put means exactly that we have grabbed a reference
ourselves.  So having need_put && file_count <= 1 means that we have
grabbed it and then somebody dropped all other references.  Including
the ones in descriptor table(s), shared or not, etc.  In that case they'd
better not touch that struct file anymore - after all, once we are done
with whatever we are doing, we'll do fput() and it will be ripped from
under them with no warning.
