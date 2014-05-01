Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaEADMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:12:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49767 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaEADMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:12:54 -0400
Date: Thu, 1 May 2014 04:12:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140501031251.GZ18016@ZenIV.linux.org.uk>
References: <20140430203823.GT18016@ZenIV.linux.org.uk>
 <CA+55aFyqqwrtv7ifTYVK943qm2OJOF8aF1y6apMSwjG93T=ztA@mail.gmail.com>
 <20140430211206.GU18016@ZenIV.linux.org.uk>
 <20140430221238.GV18016@ZenIV.linux.org.uk>
 <CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
 <CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
 <20140430234341.GX18016@ZenIV.linux.org.uk>
 <CA+55aFyb7TPkOXmOiNQojnW-Fb-uunbqdMgiF13hE-o1t5rmcQ@mail.gmail.com>
 <20140501025105.GY18016@ZenIV.linux.org.uk>
 <CA+55aFzN=ERrtWUwAQv0ry-ZzX2k7dz3JZQT6q5zjp_ABwMg6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzN=ERrtWUwAQv0ry-ZzX2k7dz3JZQT6q5zjp_ABwMg6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 07:59:43PM -0700, Linus Torvalds wrote:
> On Wed, Apr 30, 2014 at 7:51 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> >       Help with profiling is needed; the loads to watch are
> > the ones where dentry_kill() + dentry_free() are sufficiently high in profiles
> > for the differences to matter.  Any takers?
> 
> I really hope there are no such loads, my "lock/unlock pairing"
> suggestion was mostly so that the pairing is clearer, not necessarily
> for performance.
> 
> That said, I'd assume that it migth be worth testing at least the
> "lots of concurrent lookups of 'simple_dentry_operations' dentries".
> So most of /proc, most uses of simple_lookup(). That at least triggers
> the dentry_kill() path in dput(), so it should be fairly easy to get
> profiles.
> 
> But real loads with real filesystems? That sounds harder.

Well, the simplest way to do that is a bunch of open/unlink/close.  Another
one is cp -rl / rm -rf of a large tree (rmdir(2) does shrink_dcache_parent()). 
For that matter, unmapping an anon shared mapping will trigger the same path.
