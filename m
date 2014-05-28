Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaE1QKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:10:33 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:53363 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaE1QKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:10:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140528073220.GA19433@ubuntu-mba51>
References: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
 <CALCETrUZO42qk7GFcNOT8+aMRXvPLiAUOv6FH33Fx6o1XrNVxg@mail.gmail.com> <20140528073220.GA19433@ubuntu-mba51>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 May 2014 09:10:10 -0700
Message-ID: <CALCETrX1vGeCCoJaq4Mket7sR5T17GgvNj5tS9GL3FVDOoYZew@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Loop device psuedo filesystem
To: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>, Marian Marinov <mm@1h.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Michael J Coss <michael.coss@alcatel-lucent.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 12:32 AM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Tue, May 27, 2014 at 03:19:15PM -0700, Andy Lutomirski wrote:
>> On Tue, May 27, 2014 at 2:58 PM, Seth Forshee
>> <seth.forshee@canonical.com> wrote:
>> > I'm posting these patches in response to the ongoing discussion of loop
>> > devices in containers at [1].
>> >
>> > The patches implement a psuedo filesystem for loop devices, which will
>> > allow use of loop devices in containters using standard utilities. Under
>> > normal use a loopfs mount will initially contain a single device node
>> > for loop-control which can be used to request and release loop devices.
>> > Any devices allocated via this node will automatically appear in that
>> > loopfs mount (and in devtmpfs) but not in any other loopfs mounts.
>> > CAP_SYS_ADMIN in the userns of the process which performed the mount is
>> > allowed to perform privileged loop ioctls on these devices.
>> >
>> > Alternately loopfs can be mounted with the hostmount option, intended
>> > for mounting /dev/loop in the host. This is the default mount for any
>> > devices not created via loop-control in a loopfs mount (e.g. devices
>> > created during driver init, devices created via /dev/loop-control, etc).
>> > This is only available to system-wide CAP_SYS_ADMIN.
>> >
>> > I still have some testing to do on these patches, but they work at
>> > minimum for simple use cases. It's possible to use an unmodified losetup
>> > if it's new enough to know about loop-control, with a couple of caveats:
>> >
>> >  * /dev/loop-control must be symlinked to /dev/loop/loop-control
>> >  * In some cases losetup attempts to use /dev/loopN when the device node
>> >    is at /dev/loop/N. For example, 'losetup -f disk.img' fails.
>> >
>> > Device nodes for loop partitions are not created in loopfs. These
>> > devices are created by the generic block layer, and the loop driver has
>> > no way of knowing when they are created, so some kind of hook into the
>> > driver will be needed to support this.
>>
>> This is entertaining and a bit terrifying :)
>>
>> ISTM that what you've done is to create a way for per-userns devices
>> to live in a special filesystem and for userns containers to
>> instantiate those devices by offloading all the hard work to the
>> kernel.
>>
>> What if we generalized this?
>>
>> For example, we could add a concept of ephemeral devices.  An
>> ephemeral device is a device that can be referenced by an inode with a
>> guarantee that the inode will *never* accidentally point to a
>> different device [1].  Then we add a concept of the userns that owns a
>> struct device.
>>
>> To make this safe, we'll need to make sure that old host udev will not
>> see non-init-userns devices, ever.  This is easy enough to do, but
>> doing it elegantly might take some design work.
>
> To do this wouldn't we need a generic way to know which namespace a
> device goes with? Greg has clearly stated that he doesn't want to do
> this.

This is IMO silly.  If Greg doesn't want any kind of namespaces in the
device core, then sticking considerably more complicated namespaces
into the *loop* driver is just absurd.



>
>> To make this useful, we'll need a way for things inside user
>> namespaces to create the device nodes.  I can imagine at least three
>> ways to make this work.
>>
>> a) Allow mknod on a tmpfs created by a particular userns to succeed if
>> the targetting struct device is owned by that userns or a child and if
>> the caller is ns_capable(CAP_MKNOD).
>> b) Create a new filesystem that has some special ioctl or whatever to do it.
>> c) Have real per-user-ns devtmpfs.
>>
>> Now, to get loop working in a userns, we need a way for the userns (or
>> the host!) to create a new loop-control device owned by that userns
>> and we need to tweak the loop driver to make the created loop devices
>> be owned by the userns.
>
> The patches I posted previously more or less did this using per-ns
> devtmpfs, aside from the ephimeral part. The feedback was "just do it in
> loop," so I sent these to facilitate discussing this option with
> something concrete. I personally still like the per-ns devtmpfs
> approach, but that's been nacked.

The ephemeral part might not be needed using devtmpfs if devtmpfs can
guarantee that the device nodes go away if the device goes away.  I
don't know whether it can make that guarantee.

>
> (a) might be interesting, but I'd expect the same objections to be
> raised as for (c). And it seems to me that (b) is just a alternate
> interface for (a).
>

True.

>> (Note: I'm deliberately ignoring the fact that just doing this for
>> loop seems to be almost entirely useless right now: you still can't
>> mount the things.)
>
> You could also argue that it's useless to be able to mount things if you
> have no block device on which to mount them. We have to start somewhere.
>

True.

But if we take this particular route, then I can imagine a real mess
when someone wants to mount a non-loop device, and we get stuck on how
to expose the device node.  Sigh.

--Andy
