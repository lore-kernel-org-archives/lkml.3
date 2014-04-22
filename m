Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbaDVOkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:40:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43490 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbaDVOkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:40:41 -0400
Date: Tue, 22 Apr 2014 16:40:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening
 /proc/pid/fd/N
Message-ID: <20140422144039.GB23716@amd.pavel.ucw.cz>
References: <cover.1398097304.git.luto@amacapital.net>
 <430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
 <CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
 <CALCETrUZfSrBPZ0Fok5WrG2zM5h3LchEfqnWP4nK37-0sQ8=6g@mail.gmail.com>
 <CANq1E4T+5Yekm1CpzM40D3C-4XDr+5PYU8d6ud3Zw7k5dcrmUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4T+5Yekm1CpzM40D3C-4XDr+5PYU8d6ud3Zw7k5dcrmUA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-04-22 16:17:57, David Herrmann wrote:
> Hi
> 
> On Tue, Apr 22, 2014 at 3:49 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > Anyone who opens a file read-only and sends it over SCM_RIGHTS is
> > likely broken.  They may think that it's read-only, so it can't be
> > written, but this /proc/fd issue means that whoever receives it can
> > reopen it.
> >
> > It's true that, if the inode doesn't allow the recipient write access,
> > then the recipient can't reopen, but there are lots of cases where the
> > inode can't reliably be expected not to allow write.  For example, the
> > inode could be unlinked, an O_TMPFILE file, a memfd handle, or in a
> > non-world-executable directory, and the file mode should be respected.
> 
> I think it's safe to assume that any object you create is never
> world-accessible. So the worst you can get is 0600. So if we now take
> your example, your patch doesn't fix the problem at all. Imagine two
> processes, $sender and $receiver. If the receiver runs as a different
> user as the sender, it cannot open /proc/self/fd/ writable due to
> 0600. So the only problematic case is if both run as the same user.
> However, in that case, the receiver can _always_ access
> /proc/$sender/fd/ and thus still gain writable access to the object,
> even if its own fd is read-only and your patch was applied. (ignoring
> the fact that they can kill() and ptrace each other..)
> 
> Protecting world-accessible objects by hiding them is imho wrong. And
> protecting users against themselves is even worse.

See the link for example where this matters in multi-user setting.

Agreed, protecting file using its directory's permissions is not
practice to be recommended, but we should not be breaking it. (And we
are not breaking it if /proc is not mounted...)

Enforcing read-only on file descriptor is IMO useful, and being able
to work around it using /proc/self/fd is a security problem...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
