Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbaCEAER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:04:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48658 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbaCEAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:04:13 -0500
Date: Wed, 5 Mar 2014 00:04:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140305000411.GV18016@ZenIV.linux.org.uk>
References: <CA+55aFyRJqb1HkVESdZDOcQ+20t-s-JWxZa15SHJpGU+k=6www@mail.gmail.com>
 <20140303232858.GO18016@ZenIV.linux.org.uk>
 <CA+55aFyEXgMh61P3cmjZzw3RxitiL0oymWSyUsiMp96iJ+98Og@mail.gmail.com>
 <20140303234207.GQ18016@ZenIV.linux.org.uk>
 <CA+55aFyWorcX0qYAcD2bj=bOqa-X6Gmb_Ph4g25nqwSPxo4XSg@mail.gmail.com>
 <20140304002342.GS18016@ZenIV.linux.org.uk>
 <CA+55aFzzt+BK3YQf08KGXapL-sXjL=LkQcBvwTYBAZosNgsSgw@mail.gmail.com>
 <20140304010517.GT18016@ZenIV.linux.org.uk>
 <20140304200027.GA11932@ZenIV.linux.org.uk>
 <CA+55aFy2G5e0oBNWwmEiA5VS9+bB37JRNV2=X161FKEeH_odwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy2G5e0oBNWwmEiA5VS9+bB37JRNV2=X161FKEeH_odwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 01:17:50PM -0800, Linus Torvalds wrote:
> On Tue, Mar 4, 2014 at 12:00 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > OK, with the attached set (the first one is essentially unchanged from
> > your first one), it seems to work and produce better code on all targets
> > I've tried.  Comments?
> 
> I'm certainly ok with it. You seem to have left the fput_light()
> function around, though, despite removing fget_[raw_]light(). That
> seems a bit silly, since there is no valid use any more apart from
> net/socket.c that now doesn't balance things properly.

There's also a pile of crap around sockfd_lookup/sockfd_put, related
to that.   Moreover, there's net/compat.c, which probably ought to
have the compat syscalls themselves moved to net/socket.c (under
ifdef CONFIG_COMPAT) and switched to sockfd_lookup_light().
There's l2tp_tunnel_sock_lookup(), which is simply broken - it assumes
that if tunnel->fd still resolves to a socket, that socket must
be l2tp one.  Trivial to drive into BUG_ON(), in queue_work() callback,
no less...  There's bluetooth, assuming that pretty much the same
(that if it got a file descriptor that resolves to a socket, it must
be a bluetooth one).  BTW, I wonder what will happen if one gives
iscsi_sw_tcp_conn_bind() descriptor of a socket of sufficiently
weird sort...

Then there's staging/usbip with its sockfd_to_socket(), which is more or
less parallel to sockfd_lookup().  And open-coded analogs in nbd and
ncpfs...

> > I've also pushed those (on top of old ocfs2 fix) into vfs.git#for-linus,
> > if you prefer to read it that way.  Should propagate in a few...
> 
> Should I pull?
> 
> I also get the feeling that the first patch should likely be marked
> for stable. Hmm?

It should; I'll mark it such when I send a pull request.  I really want
to sort the situation with sockfd_lookup() and friends out, though - at
least to the point where I would understand how painful the fixes
will be.
