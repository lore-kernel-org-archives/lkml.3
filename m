Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaCCVpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:45:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36101 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbaCCVpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:45:43 -0500
Date: Mon, 3 Mar 2014 21:45:36 +0000
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
Message-ID: <20140303214536.GK18016@ZenIV.linux.org.uk>
References: <53022DB1.4070805@gmail.com>
 <CA+55aFxjAp23=ySEe8e8bTPbVw8Uh8d03zirg4TdHXGYiyjmwA@mail.gmail.com>
 <CA+55aFy4GvpFcboBiKdreU_Zh1RzynPoLxhvC9hijn60hkEZ3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy4GvpFcboBiKdreU_Zh1RzynPoLxhvC9hijn60hkEZ3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 09:36:58AM -0800, Linus Torvalds wrote:
> +static struct fd fdget_pos(int fd)
> +{
> +	struct fd f = fdget(fd);
> +	struct file *file = f.file;
> +
> +	if (file && (file->f_mode & FMODE_ATOMIC_POS)) {
> +		if (f.need_put || file_count(file) > 1) {

Um...  That's odd - we *could* get there with f.need_put and
file_count(file) equal to 1, but why would we want to take
f_pos_lock in that case?

And it looks like you've missed compat counterparts.  Other than
that, it'd probably work...  Let me check if there are other
paths we might need to take care of, though.

PS: apologies for being pretty much MIA for the last two weeks; I'd been
ears-deep in interesting scalability crap around vfsmount handling ;-/
Will post the resulting patches for review shortly...
