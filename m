Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaJLWv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 18:51:27 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:51413 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaJLWvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 18:51:25 -0400
X-Originating-IP: 212.144.255.202
Date: Mon, 13 Oct 2014 00:51:19 +0200
From: Josh Triplett <josh@joshtriplett.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] fs/anon_inodes.c: Simplify control flow in
 anon_inode_getfd()
Message-ID: <20141012225119.GB5424@thin>
References: <1413146562-18147-1-git-send-email-ebiggers3@gmail.com>
 <1413146562-18147-2-git-send-email-ebiggers3@gmail.com>
 <20141012210712.GT7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012210712.GT7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 10:07:13PM +0100, Al Viro wrote:
> On Sun, Oct 12, 2014 at 03:42:39PM -0500, Eric Biggers wrote:
> >  	file = anon_inode_getfile(name, fops, priv, flags);
> >  	if (IS_ERR(file)) {
> > -		error = PTR_ERR(file);
> > -		goto err_put_unused_fd;
> > +		put_unused_fd(fd);
> > +		return PTR_ERR(file);
> >  	}
> >  	fd_install(fd, file);
> 
> at least slap unlikely() on that if (IS_ERR(...))...

That shouldn't be necessary, as far as I can tell; linux/err.h has:

#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
...
static inline bool __must_check IS_ERR(__force const void *ptr)
{
	return IS_ERR_VALUE((unsigned long)ptr);
}

So unless GCC fails to propagate expected-value handling through static
inline functions, you should never need to write unlikely(IS_ERR(...)).

- Josh Triplett
