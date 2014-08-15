Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaHOT5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:57:03 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:53331 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaHOT5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:57:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140815193746.GE11476@ubuntumail>
References: <CALCETrWT_p1-5nkiAjWoeta19fkO3rDiJe9_mhRVqF8x1zXv2A@mail.gmail.com>
 <2686c32f00b14148379e8cfee9c028c794d4aa1a.1407974494.git.luto@amacapital.net>
 <20140815190552.GA11476@ubuntumail> <CALCETrVKq1Fxnsd9jKDi5_fcKfCJxBZ1w-zGXD3FR-pF-jLsmQ@mail.gmail.com>
 <20140815193746.GE11476@ubuntumail>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 15 Aug 2014 12:56:39 -0700
Message-ID: <CALCETrWB0qBiyfJbapFnjxoNyNvS+aHvgc_eob3fC1j=cv+v5w@mail.gmail.com>
Subject: Re: [PATCH] fs: Remove implicit nodev for new mounts in non-root userns
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Kenton Varda <kenton@sandstorm.io>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 12:37 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> On Fri, Aug 15, 2014 at 12:05 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
>> > Quoting Andy Lutomirski (luto@amacapital.net):
>> >> Currently, creating a new mount (as opposed to bindmount) in a
>> >> non-root userns will implicitly set nodev unless the fs is devpts.
>> >> Something like this will be necessary for file systems that allow
>> >> the mounter to create device nodes without using mknod (e.g. FUSE
>> >> if/when that is allowed), but none of the currently allowed
>> >> filesystems do this.
>> >
>> > Hi,
>> >
>> > Sorry, I'm probably thinking stupidly, but I don't see this restriction
>> > being the case
>> >
>> > serge@sl:~$ mount | grep tmp
>> > [...]
>> > tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=0755)
>> > serge@sl:~$ sudo mknod /run/kvm c 10 232
>> > [sudo] password for serge:
>> > serge@sl:~$ echo $?
>> > 0
>> > serge@sl:~$ ls -l /run/kvm
>> > crw-r--r-- 1 root root 10, 232 Aug 15 14:04 /run/kvm
>> >
>> > But you seem to be saying I shouldn't be allowed to create a device inside
>> > a tmpfs.  What am I overlooking?
>>
>> I assume you're in the root userns.  This patch is unnecessary, and
>> has no effect, if you're in the root userns.
>
> Right, but I thought you were justifying adding FS_USERNS_DEV_MOUNT by saying
> that you cannot mknod in those filesystems.  But I see you actually said
> "without using mknod".  I guess I don't understand that caveat.

IIUC, there are two ways that a user could put a device node into
their filesystem.

The obvious way is using mknod.  But mknod has its own perfectly valid
permission checks, and it doesn't need any special handling at mount
time.

The less obvious way is to mount a filesystem that already contains a
device node or to mount a filesystem that gives some other means of
inserting a device node (e.g. a network filesystem or FUSE).  Those
might allow inserting device nodes without passing a global capability
check, so unprivileged users in a userns must not be allowed to mount
such a filesystem without MNT_NODEV | MNT_LOCK_NODEV.

Fortunately, none of the existing FS_USERNS_MOUNT filesystems have
that property.  FUSE will, but we don't support FUSE in a userns yet
(unfortunately -- it would be a *very* useful feature.)

I think that, if we ever allow FUSE in a userns, we should return
-EPERM when trying to mount it unless the user specifies MS_NODEV,
which is what this patch does.  I don't think there's any reason to
play complicated games to allow programs to get away with omitting
MS_NODEV.

--Andy
