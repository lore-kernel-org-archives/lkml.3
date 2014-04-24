Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaDXAyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 20:54:54 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:46983 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaDXAyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 20:54:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyn4q3VfRrAcjO6meZ1UJwRZ5-yeaMExGX5ogtnuAkPBQ@mail.gmail.com>
References: <CALCETrXE_T-3eKmVKZNkAfoyvC0CcUATDK7fGPvQrR9H=RHQag@mail.gmail.com>
 <CAFLxGvyn4q3VfRrAcjO6meZ1UJwRZ5-yeaMExGX5ogtnuAkPBQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 23 Apr 2014 17:54:31 -0700
Message-ID: <CALCETrUOEFwnYqKNtB3XKqsM1HNnOR9x-MXV8mjdR6ErUL3jGg@mail.gmail.com>
Subject: Re: How do I make a clean mount namespace?
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 1:01 PM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> On Wed, Apr 23, 2014 at 12:12 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> I want to set up a little container.  So I unshare the mount namespace
>> and mount something somewhere (say /mnt) that I want to be my new
>> root.  Now what?
>>
>> pivot_root("/mnt", "/mnt/garbage") seems to frequently return -EBUSY.
>>
>> mounting /mnt onto / using MS_MOVE seems to succeed, but / still
>> points at the old root.
>>
>> Am I missing a clean way to do this?  I want a way to say "make this
>> mountpoint be the root of the whole mount namespace and lazy-unmount
>> everything outside it".  If there is no straightforward way to do
>> that, can we add one?
>
> I fear you have to read /proc/mounts and umount() everything in the
> correct order.
> If you find a better way, please tell. :-)
>

How about adding a new syscall:

int change_root_mount(const char *path, unsigned long flags);

This requires CAP_SYS_ADMIN and it requires that the caller is not
chrooted.  path must be a mountpoint and flags must be zero.

It lazy-unmounts everything outside path, and it moves path to /.
When it's done, the current process's root is '/'.  If you want to
retain temporary access to outside things, you can keep an fd open.
If the old root is shared, it is made private.  It's okay for path to
be shared (I think).

If other things are already running in the current mount namespace,
then their root directory stays the same, so they keep working, but
they may be a little confused.

I think this could replace pivot_root for most use cases, and it could
simplify programs like switch_root.

Thoughts?

--Andy
