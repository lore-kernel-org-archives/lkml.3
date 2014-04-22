Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbaDVMo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:44:57 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:48403 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaDVMov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:44:51 -0400
MIME-Version: 1.0
In-Reply-To: <430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
References: <cover.1398097304.git.luto@amacapital.net>
	<430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
Date: Tue, 22 Apr 2014 14:44:50 +0200
Message-ID: <CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
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

On Mon, Apr 21, 2014 at 6:22 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> This patch does this:

I can see _what_ the patch does, but your patch lacks any discussion
_why_ it is needed. Can you provide at least one real example where
this fixes a security issue?

> This may break userspace.  If so, I would guess that anything broken
> by it is either an actual exploit or is so broken that it doesn't
> deserve to continue working.  If it breaks something important, then
> maybe it will need a sysctl.

This patch breaks the following use-case:

fd = open("/run", O_RDWR | O_TMPFILE);
sprintf(path, "/proc/self/fd/%d", fd);
fd2 = open(buf, O_RDONLY);
sprintf(path, "/proc/self/fd/%d", fd2);
linkat(AT_FDCWD, path, AT_FDCWD, "/run/some_lock_file", AT_FOLLOW_SYMLINK);

I mean I explicitly create the object as _writable_ but then keep a
read-only descriptor for debugging purposes (to make sure that the
program no longer writes to the file). This is no security feature,
but only a safety feature in case something goes wrong. But I still
want to be able to create hard-links (I _do_ have write-permissions on
the object/inode).

Thanks
David
