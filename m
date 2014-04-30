Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbaD3AYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:24:23 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:49407 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbaD3AYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:24:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140430002143.GB28969@ubuntumail>
References: <20140429220234.GC28410@ubuntumail> <536026B3.1020905@1h.com>
 <20140429222913.GD28410@ubuntumail> <53602B84.1020304@mit.edu>
 <536033A9.5070504@1h.com> <CALCETrVJY6SWjdbqSSCeOo9oid22TnL83v9oDVg06XLZfPkLCw@mail.gmail.com>
 <20140429234739.GB2997@dakara> <CALCETrXK6N8CLjPtnHVXB-BM_bxNU6e1xYGd=_UKcjKMrR3j0g@mail.gmail.com>
 <20140430000101.GC2997@dakara> <CALCETrWz2i1xE_t982yA8GG4a-rD4AnU_43YA8cNdC9NpSD4Sg@mail.gmail.com>
 <20140430002143.GB28969@ubuntumail>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 29 Apr 2014 17:23:57 -0700
Message-ID: <CALCETrVh0hCtiK=9fmEYfUWuz4C1dPq22kvyd=OWFMH5pXGaZw@mail.gmail.com>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 5:21 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> > It should be a nonissue so long as we make sure that a file owned by a
>> > uid outside the scope of the container may not be changed even though
>> > fs_owner_uid is set. Otherwise, it's just a matter of chmod +S on say
>> > a shell and anyone who can see the fs from the host will be getting a
>> > root shell (assuming said file is owned by the host's uid 0).
>>
>> I feel like that's too fragile.  I'd rather add a rule that one of
>
> yeah I don't wnat to rush something like that.  I'd rather stash
> the userns of the task which did the mounting and check against
> that.  Note that would make it worthless unless and until we allowed
> mounting from non-init userns, but then we can only claim "our fs
> superblock readers suck and therefore containers can't mount an fs"
> so long before we start to feel some shame and audit them...
>
>> these filesystems always acts like it's nosuid unless you're inside a
>> user namespace that matches fs_owner_uid.
>>
>> Maybe even that is too weird.  How about setuid, setgid, and fcaps
>> only work on mounts that are in mount namespaces that are owned by the
>> current user namespace or one of its parents?  IOW, a struct mount is
>> only trusted if mnt->mnt_ns->user_ns == current user ns or one of its
>> parents?
>>
>> Untrusted mounts would act like they are nosuid,nodev.  Someone can
>> try to figure out a safe way to relax nodev at some point.

Do you like this variant?  We could add a way for global root to mount
an fs on behalf of a userns.  I'd rather this be more explicit than
just mounting it in a mount ns owned by the user namespace, though.

--Andy
