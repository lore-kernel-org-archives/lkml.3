Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaDURtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:49:13 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40027 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaDURtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:49:07 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVbGZWvF=2X8zoejEGZTGyai_HjVoozXV6f39YTdG4i-A@mail.gmail.com>
References: <cover.1398097304.git.luto@amacapital.net> <430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
 <20140421163058.GS18016@ZenIV.linux.org.uk> <CALCETrUJNv48UXPNSXcdnsFZSLwhRtA0s03bJHamXQmr6vs3fQ@mail.gmail.com>
 <CALCETrVbGZWvF=2X8zoejEGZTGyai_HjVoozXV6f39YTdG4i-A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 21 Apr 2014 10:48:45 -0700
Message-ID: <CALCETrUOBrz7pqwX4rz6Vc8pr4sUPUBSB_cs1qai=J2qbkZSfg@mail.gmail.com>
Subject: Re: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening /proc/pid/fd/N
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        David Herrmann <dh.herrmann@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 10:04 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Apr 21, 2014 at 10:00 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Mon, Apr 21, 2014 at 9:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>> On Mon, Apr 21, 2014 at 09:22:48AM -0700, Andy Lutomirski wrote:
>>>
>>>> +static int proc_may_follow(struct nameidata *nd, struct file *f)
>>>> +{
>>>> +     if (!nd)
>>>> +             return 0;  /* This is readlink, */
>>>> +
>>>> +     if ((nd->flags & LOOKUP_WRITE) && !(f->f_mode & FMODE_WRITE))
>>>> +             return -EACCES;
>>>> +
>>>> +     return 0;
>>>> +}
>>>
>>> And this is just plain wrong.  WTF are you making the traversal of symlink
>>> in the middle of pathname dependent on the open flags?
>>
>> Can you give me a hint?  There are three cases that I need to
>> distinguish, I think:
>>
>> 1. readlink.  Currently handled by nd == NULL.  It's ugly, and I'll clean it up.
>>
>> 2. Traversal in the middle of a path.  This can be either literally in
>> the middle (e.g. "/proc/self/fd/3/something_else") or in a symlink
>> that's the last component of the literal path (e.g. "fd3null" where
>> "fd3null" is a symlink to "/proc/self/fd/3/null" and "null" is either
>> a file or a symlink to /dev/null).  I have the latter type wrong in
>> this patch.
>>
>> 3. Actually opening /proc/self/fd/N.  This can be direct or by opening
>> a symlink to /proc/self/fd/N.  I think I have this case correct.
>>
>> What's the best way to fix this?  Should I be checking nd->depth?
>
> No, I think that's wrong, too.  I think that will cause me to screw up
> symlinks to /proc/self/fd/3.  What's the right way to tell that
> follow_link is happening on the very last pathname component?
>
> Hmm.  I wonder what happens, or even what should happen, if the file
> descriptor is a symlink opened with O_PATH | O_NOFOLLOW.

Here's a test case:

https://github.com/amluto/procfd_test

It doesn't cover O_PATH yet.

Both my code and current kernels fail.

--Andy
