Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbaDVOSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:18:43 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36268 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbaDVOR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:17:57 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUZfSrBPZ0Fok5WrG2zM5h3LchEfqnWP4nK37-0sQ8=6g@mail.gmail.com>
References: <cover.1398097304.git.luto@amacapital.net>
	<430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
	<CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
	<CALCETrUZfSrBPZ0Fok5WrG2zM5h3LchEfqnWP4nK37-0sQ8=6g@mail.gmail.com>
Date: Tue, 22 Apr 2014 16:17:57 +0200
Message-ID: <CANq1E4T+5Yekm1CpzM40D3C-4XDr+5PYU8d6ud3Zw7k5dcrmUA@mail.gmail.com>
Subject: Re: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening /proc/pid/fd/N
From: David Herrmann <dh.herrmann@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Apr 22, 2014 at 3:49 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Anyone who opens a file read-only and sends it over SCM_RIGHTS is
> likely broken.  They may think that it's read-only, so it can't be
> written, but this /proc/fd issue means that whoever receives it can
> reopen it.
>
> It's true that, if the inode doesn't allow the recipient write access,
> then the recipient can't reopen, but there are lots of cases where the
> inode can't reliably be expected not to allow write.  For example, the
> inode could be unlinked, an O_TMPFILE file, a memfd handle, or in a
> non-world-executable directory, and the file mode should be respected.

I think it's safe to assume that any object you create is never
world-accessible. So the worst you can get is 0600. So if we now take
your example, your patch doesn't fix the problem at all. Imagine two
processes, $sender and $receiver. If the receiver runs as a different
user as the sender, it cannot open /proc/self/fd/ writable due to
0600. So the only problematic case is if both run as the same user.
However, in that case, the receiver can _always_ access
/proc/$sender/fd/ and thus still gain writable access to the object,
even if its own fd is read-only and your patch was applied. (ignoring
the fact that they can kill() and ptrace each other..)

Protecting world-accessible objects by hiding them is imho wrong. And
protecting users against themselves is even worse.

>>
>> fd = open("/run", O_RDWR | O_TMPFILE);
>
> Did you mean fd = open("/run", O_RDWR | O_TMPFILE, 0666)?  0600?

Sorry, I meant S_IWUSR | S_IRUSR (0600).

Thanks
David
