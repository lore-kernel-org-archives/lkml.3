Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab3GLUCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:02:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36908 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab3GLUCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:02:07 -0400
Date: Fri, 12 Jul 2013 21:02:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs.git part 2
Message-ID: <20130712200205.GD4165@ZenIV.linux.org.uk>
References: <20130703122918.GK4165@ZenIV.linux.org.uk>
 <CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
 <20130712054817.GY4165@ZenIV.linux.org.uk>
 <8738rk9eai.fsf@rasmusvillemoes.dk>
 <20130712154833.GA4165@ZenIV.linux.org.uk>
 <87wqovviyy.fsf@rasmusvillemoes.dk>
 <20130712191321.GB4165@ZenIV.linux.org.uk>
 <CA+55aFyCa59PnK2GRCdFKOJRvF4HqAT6-euDtVb35ABKEmZbow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyCa59PnK2GRCdFKOJRvF4HqAT6-euDtVb35ABKEmZbow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 12:42:15PM -0700, Linus Torvalds wrote:

> As to the mode argument: we should encourage people to have it, since
> the inode *may* become visible afterwards. See above (can you do
> linkat() to just turn an fd into a name? I didn't really check, but I
> think you can do it as a "link(/proc/sef/fd/..)" thing regardless).

link() won't do it, linkat() with the right arguments will (link(2)
doesn't follow symlinks on the oldname).  It's a bit more complicated,
though:
	* vfs_link() will refuse to link with link count that went down to 0
(always had, and that's a damn good idea for security reasons)
	* with O_TMPFILE, vfs_link() will act as usual *if* you give open()
O_EXCL as well - files created that way cannot be linked in, ever.  They
stay with link count 0 and they die as soon as they are closed.  Again,
that's the behaviour we'd have with O_CREAT open + unlink.  tmpfile(3) ought
to call it that way.
	* O_TMPFILE _without_ O_EXCL == you may link it in once you've
decided that you've set it up enough.  In that case you are supposed to
open it, write whatever you want to write, fchmod/fchown/fsetxattr/etc.
and use linkat() to put it in place.  Or use vfs_link() if you are doing
that kernel-side.
