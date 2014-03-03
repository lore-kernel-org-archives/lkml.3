Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaCCV4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:56:33 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:40109 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbaCCV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:56:32 -0500
MIME-Version: 1.0
In-Reply-To: <20140303214536.GK18016@ZenIV.linux.org.uk>
References: <53022DB1.4070805@gmail.com>
	<CA+55aFxjAp23=ySEe8e8bTPbVw8Uh8d03zirg4TdHXGYiyjmwA@mail.gmail.com>
	<CA+55aFy4GvpFcboBiKdreU_Zh1RzynPoLxhvC9hijn60hkEZ3g@mail.gmail.com>
	<20140303214536.GK18016@ZenIV.linux.org.uk>
Date: Mon, 3 Mar 2014 13:56:31 -0800
X-Google-Sender-Auth: fSDggB6GSoCgxtTiaDrDUfBWl9Y
Message-ID: <CA+55aFwGzNdCfENDr0A7EqwkqQ7W8Oc5UzBrZ5Wr_V9LRVcwew@mail.gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, "Theodore T'so" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Dave Chinner <david@fromorbit.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        Yongzhi Pan <panyongzhi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 1:45 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Um...  That's odd - we *could* get there with f.need_put and
> file_count(file) equal to 1, but why would we want to take
> f_pos_lock in that case?

Because that means that the file table is shared among threads. So
another thread can access the struct file pointer and do a concurrent
read() or write() on it, and so we need to lock f_pos.

Basically, there are two cases:

 - duplicated file pointers due to fork(). That's the "file_count()" test.

   Yes, this will trigger even if they didn't fork, just dup'ed the
file descriptor. We have no way of telling the difference, though.

 - concurrent access due to duplicated "struct file_table" pointers.
This is the "need_put" test, since __fget_light() will have tested the
proper files->count already.

Both need f_pos_lock.

               Linus
