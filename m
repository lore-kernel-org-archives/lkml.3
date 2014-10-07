Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaJGVDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:03:17 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:61530 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaJGVDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:03:15 -0400
MIME-Version: 1.0
In-Reply-To: <87r3yjy64e.fsf@x220.int.ebiederm.org>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <20141007133039.GG7996@ZenIV.linux.org.uk> <20141007133339.GH7996@ZenIV.linux.org.uk>
 <87r3yjy64e.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 7 Oct 2014 14:02:53 -0700
Message-ID: <CALCETrXgssZfi3BirQ=K7-vrPyEh5AzFX2pF+yj76Ngi0sf7Yw@mail.gmail.com>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 1:30 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
>
> 2> On Tue, Oct 07, 2014 at 02:30:40PM +0100, Al Viro wrote:
>>> On Tue, Oct 07, 2014 at 04:12:57PM +0400, Andrey Vagin wrote:
>>> > Another problem is that rootfs can't be hidden from a container, because
>>> > rootfs can't be moved or umounted.
>>>
>>> ... which is a bug in mntns_install(), AFAICS.
>>
>> Ability to get to exposed rootfs, that is.
>
> The container side of this argument is pretty bogus.  It only applies
> if user namespaces are not used for the container.
>
> So it is only root (and not root in a container) who can get to the
> exposed rootfs.
>
> I have a vague memory someone actually had a real use in miminal systems
> for being able to get back to the rootfs and being able to use rootfs as
> the rootfs.  There was even a patch at that time that Andrew Morton was
> carrying for a time to allow unmounting root and get at rootfs, and to
> prevent the oops on rootfs unmount in some way.
>
> So not only do I not think it is a bug to get back too rootfs, I think
> it is a feature that some people have expressed at least half-way sane
> uses for.
>
>>> > Here is an example how to get access to rootfs:
>>> > fd = open("/proc/self/ns/mnt", O_RDONLY)
>>> > umount2("/", MNT_DETACH);
>>> > setns(fd, CLONE_NEWNS)
>>> >
>>> > rootfs may contain data, which should not be avaliable in CT-s.
>>>
>>> Indeed.
>>
>> ... and it looks like the above is what your mangled reproducer in previous
>> patch had been made of -
>>       fd = open("/proc/self/ns/mnt", O_RDONLY)
>>       umount2("/", MNT_DETACH);
>>       setns(fd, CLONE_NEWNS)
>>       umount2("/", MNT_DETACH);
>>
>> IMO what it shows is setns() bug.  This "switch root/cwd, no matter what"
>> is wrong.
>
> IMO the bug is allowing us to unmount things that should never be unmounted.
>
> In a mount namespace created with just user namespace permissions we
> can't get at rootfs because MNT_LOCKED is set on the root directory
> and thus it can not be mounted.
>
> Further if anyone has permission to call chroot and chdir on any mount
> in a mount namespace (that isn't currently covered) they can get at all
> of them that are not currently covered.  A mount namespace where no one
> can get at any uncovered filesystem seems to be the definition of
> useless and ridiculous.
>
>
> Now there is a bug in that MNT_DETACH today does not currently enforce
> MNT_LOCKED on submounts of the mount point that is detached. I am
> currently looking at how to construct the appropriate permission check
> to prevent that.  Unfortunately I can not disallow MNT_DETACH with
> submounts all together as that breaks too many legitimate uses.

Why should MNT_LOCKED on submounts be enforced?

Is it because, if you retain a reference to the detached tree, then
you can see under the submounts?  If so, let's fix *that*.  Because
otherwise the whole model of pivot_root + detach will break.

Also, damn it, we need change_the_ns_root instead of pivot_root.  I
doubt that any container programs actually want to keep the old root
attached after pivot_root.

--Andy
