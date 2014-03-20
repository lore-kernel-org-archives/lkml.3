Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbaCTQiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:38:23 -0400
Received: from imap.thunk.org ([74.207.234.97]:44131 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbaCTQiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:38:21 -0400
Date: Thu, 20 Mar 2014 12:38:06 -0400
From: tytso@mit.edu
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
Message-ID: <20140320163806.GA10440@thunk.org>
Mail-Followup-To: tytso@mit.edu, David Herrmann <dh.herrmann@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Karol Lewandowski <k.lewandowsk@samsung.com>,
	Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
	Lennart Poettering <lennart@poettering.net>,
	John Stultz <john.stultz@linaro.org>,
	Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ryan Lortie <desrt@desrt.ca>,
	"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
 <20140320153250.GC20618@thunk.org>
 <CANq1E4SUXrzAV8FS8HVYxnRVb1oOR6HSTyucJzyFs5PuS5Y88A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4SUXrzAV8FS8HVYxnRVb1oOR6HSTyucJzyFs5PuS5Y88A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 04:48:30PM +0100, David Herrmann wrote:
> On Thu, Mar 20, 2014 at 4:32 PM,  <tytso@mit.edu> wrote:
> > Why not make sealing an attribute of the "struct file", and enforce it
> > at the VFS layer?  That way all file system objects would have access
> > to sealing interface, and for memfd_shmem, you can't get another
> > struct file pointing at the object, the security properties would be
> > identical.
> 
> Sealing as introduced here is an inode-attribute, not "struct file".
> This is intentional. For instance, a gfx-client can get a read-only FD
> via /proc/self/fd/ and pass it to the compositor so it can never
> overwrite the contents (unless the compositor has write-access to the
> inode itself, in which case it can just re-open it read-write).

Hmm, good point.  I had forgotten about the /proc/self/fd hole.
Hmm... what if we have a SEAL_PROC which forces the permissions of
/proc/self/fd to be 000?

So if it is a property of the attribute, SEAL_WRITE and SEAL_GROW is
basically equivalent to using chattr to set the immutable and
append-only attribute, except for the "you can't undo the seal unless
you have exclusive access to the inode" magic.

That does make it pretty memfd_create specific and not a very general
API, which is a little unfortunate; hence why I'm trying to explore
ways of making a bit more generic and hopefully useful for more use
cases.

Cheers,

					- Ted
