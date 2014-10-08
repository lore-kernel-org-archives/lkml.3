Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbaJHVXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:23:24 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:58380 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbaJHVXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:23:20 -0400
Message-ID: <5435AB3D.3040407@landley.net>
Date: Wed, 08 Oct 2014 16:23:09 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: Andrew Vagin <avagin@parallels.com>, Andrey Vagin <avagin@openvz.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>	<87mw97wqvx.fsf@x220.int.ebiederm.org>	<20141008110829.GC24908@paralelels.com>	<CALCETrX4XrgbQNZZa7=1009KqhJ2gT+VBUkC15+59K9yEiTSbQ@mail.gmail.com> <87vbnue56f.fsf@x220.int.ebiederm.org>
In-Reply-To: <87vbnue56f.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/14 14:23, Eric W. Biederman wrote:
>> Could we have an extra rootfs-like fs that is always completely empty,
>> doesn't allow any writes, and can sit at the bottom of container
>> namespace hierarchies?  If so, and if we add a new syscall that's like
>> pivot_root (or unshare) but prunes the hierarchy, then we could switch
>> to that rootfs then.
> 
> Or equally have something that guarantees that rootfs is empty and
> read-only at the time the normal root filesystem is mounted.  That is
> certainly a much more localized change if we want to go there.

What do you mean "normal" root filesystem? It is entirely possible (and
in fact common in the embedded world) to run from rootfs. I pushed my
old inittmpfs patches (at the request of cray) last year because being
able to take down the system with "cat /dev/zero > /blah" (as rootfs
allows and tmpfs doesn't) is a bad thing.

Rootfs is about as special as PID 1 is. We don't filter out PID 1 from
"ps" to avoid confusing people, but for some reason whoever did
/proc/$PID/mountinfo decided that rootfs shouldn't show up because magic
magic specialness.

We show /run, which is a tmpfs instance. If I mount two different
filesystems on top of each other on /mnt, it shows both. (Overmounts
were not invented by rootfs.) But no, mountinfo filters out rootfs
because magic magic specialness.

It makes me sad that this kind of special-case thinking is allowed in
the kernel.

> I am half tempted to suggest that mount --move /some/path / be updated
> to make the old / just go away (perhaps to be replaced with a read-only
> empty rootfs).  That gets us into figuring out if we break userspace
> which is a big challenge.

My concern was that chroot() moving a magic "/" pointer that you can
trivially escape from with x=open("."); chroot("sub"); fdchdir(".");
chdir("../../../../../../../../.."); is having extra code in the kernel
to do it _wrong_.

We have per-process namespaces now. We can actually adjust the mount
tree (inserting a new bind mount if the directory we're changing to is
not already a mount point). If a per-process namespace needs to be
anchored by a tmpfs, fine. But requiring that to be teh SAME instance
globally for the entire system is not what containers is _about_. It's
not true for PID 1 and it shouldn't be true for rootfs.

By all means, if a filesystem is no longer accessable in a namespace,
decrement its reference count. (Keeping in mind that a bind mount should
count as a reference, and rootfs should always have a nonzero reference
count.) But "/" is not special in this regard. If you want to make all
overmounts vanish (which seems like a really bad idea and breaks 40
years of unix semantics), argue for that. Please stop treating rootfs
like it isn't potentialy usable as a full-fledged filesystem.

(Pet peeve of mine.)

> Eric

Rob
