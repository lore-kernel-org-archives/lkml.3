Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbaDVNuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:50:25 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:57292 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbaDVNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:50:15 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
References: <cover.1398097304.git.luto@amacapital.net> <430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
 <CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Apr 2014 06:49:51 -0700
Message-ID: <CALCETrUZfSrBPZ0Fok5WrG2zM5h3LchEfqnWP4nK37-0sQ8=6g@mail.gmail.com>
Subject: Re: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening /proc/pid/fd/N
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 5:44 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Mon, Apr 21, 2014 at 6:22 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> This patch does this:
>
> I can see _what_ the patch does, but your patch lacks any discussion
> _why_ it is needed. Can you provide at least one real example where
> this fixes a security issue?

Anyone who opens a file read-only and sends it over SCM_RIGHTS is
likely broken.  They may think that it's read-only, so it can't be
written, but this /proc/fd issue means that whoever receives it can
reopen it.

It's true that, if the inode doesn't allow the recipient write access,
then the recipient can't reopen, but there are lots of cases where the
inode can't reliably be expected not to allow write.  For example, the
inode could be unlinked, an O_TMPFILE file, a memfd handle, or in a
non-world-executable directory, and the file mode should be respected.

>
>> This may break userspace.  If so, I would guess that anything broken
>> by it is either an actual exploit or is so broken that it doesn't
>> deserve to continue working.  If it breaks something important, then
>> maybe it will need a sysctl.
>
> This patch breaks the following use-case:

This is totally broken.

>
> fd = open("/run", O_RDWR | O_TMPFILE);

Did you mean fd = open("/run", O_RDWR | O_TMPFILE, 0666)?  0600?
Because currently you don't actually know that you have write access
to the inode unless you have CAP_DAC_OVERRIDE.

This should fail to compile.  It doesn't because POSIX is dumb.

> sprintf(path, "/proc/self/fd/%d", fd);
> fd2 = open(buf, O_RDONLY);

And this is the whole point of this patch.

> sprintf(path, "/proc/self/fd/%d", fd2);
> linkat(AT_FDCWD, path, AT_FDCWD, "/run/some_lock_file", AT_FOLLOW_SYMLINK);

Seriously?  fd2, not fd?  I didn't intend to change flink behavior in
this patch, but you shouldn't be able to bypass file descriptor modes
by flinking the fd either.

Imagine that you gave fd2 to someone else.  Do you really want them
flinking and then reopening for write?

>
> I mean I explicitly create the object as _writable_ but then keep a
> read-only descriptor for debugging purposes (to make sure that the
> program no longer writes to the file). This is no security feature,
> but only a safety feature in case something goes wrong. But I still
> want to be able to create hard-links (I _do_ have write-permissions on
> the object/inode).

Then use fd for the flink step.

IMO it's an accident that this code ever worked.  The "linkable"
attribute is an inode flag for no particularly good reason, and IMO
your example indicates that it should have been a struct file flag
from day one.

If you are doing this, can you please fix it so it will keep working
even if the current flink insanity goes away?  Your code is already
screwed on current kernels, because you might accidentally create a
world-writable file in /run depending on what's in your third argument
register.

--Andy
