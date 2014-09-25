Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaIYPkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:40:13 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:58583 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaIYPkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <CALRD3qLYAc+K8e1xYb27ipi4KyGRmTxokPCHN0L_zta=Cy9sCQ@mail.gmail.com>
References: <CALRD3qKmpzJCRszkG_S9Z3XgoTGWVMFd7FqeJh+W-9pZqPVhCg@mail.gmail.com>
	<87bnq5vcbl.fsf@x220.int.ebiederm.org>
	<CALRD3qKPJHmmY2DSNNfNKzmLihDLm9fgBQprCXNMHVOArV4iuw@mail.gmail.com>
	<20140924163740.GD3865@ubuntumail>
	<8738bglxsf.fsf_-_@x220.int.ebiederm.org>
	<E8CD8839-8FC9-4404-863B-38F36F7D4328@gmail.com>
	<871tr0hcfo.fsf@x220.int.ebiederm.org>
	<CALRD3qLYAc+K8e1xYb27ipi4KyGRmTxokPCHN0L_zta=Cy9sCQ@mail.gmail.com>
Date: Thu, 25 Sep 2014 10:40:10 -0500
Message-ID: <CALRD3qKU5gOi5K53ysOgF9Re+MjMLfcTYEK_3gq3ns2HNLkUFw@mail.gmail.com>
Subject: Re: Using devices in Containers
From: riya khanna <riyakhanna1983@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Tejun Heo <tj@kernel.org>, Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a plan or work-in-progress to add namespace tags to other
classes in sysfs similar to net? Does it make sense to add namespace
tags to kobjects?

-Riya

On Wed, Sep 24, 2014 at 7:25 PM, riya khanna <riyakhanna1983@gmail.com> wrote:
> On Wed, Sep 24, 2014 at 5:38 PM, Eric W. Biederman <ebiederm@xmission.com>
> wrote:
>>
>> Riya Khanna <riyakhanna1983@gmail.com> writes:
>>
>> > On Sep 24, 2014, at 12:43 PM, Eric W. Biederman <ebiederm@xmission.com>
>> > wrote:
>> >
>> >> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
>> >>
>> >>> Isolation is provided by the devices cgroup.  You want something more
>> >>> than isolation.
>> >>>
>> >>> Quoting riya khanna (riyakhanna1983@gmail.com):
>> >>>> My use case for having device namespaces is device isolation. Isn't
>> >>>> what
>> >>>> namespaces are there for (as I understand)?
>> >>
>> >> Namespaces fundamentally provide for using the same ``global'' name
>> >> in different contexts.  This allows them to be used for isolation
>> >> and process migration (because you can take the same name from
>> >> machine to machine).
>> >>
>> >> Unless someone cares about device numbers at a namespace level
>> >> the work is done.
>> >>
>> >> The mount namespace provides exsits to deal with file names.
>> >> The devices cgroup will limit which devices you can access (although
>> >> I can't ever imagine a case where the mout namespace would be
>> >> insufficient).
>> >>
>> >>>> Not everything should be
>> >>>> accessible (or even visible) from a container all the time (we have
>> >>>> seen
>> >>>> people come up with different use cases for this). However,
>> >>>> bind-mounting
>> >>>> takes away this flexibility.
>> >>
>> >> I don't see how.  If they are mounts that propogate into the container
>> >> and are controlled from outside you can do whatever you want.  (I am
>> >> imagining device by device bind mounts here).  It should be trivial
>> >> to have a a directory tree that propogates into a container and works.
>> >>
>> >
>> > Device-by-device bind mounts can grant/revoke access to real
>> > individual devices as and when needed. However, revoking the access to
>> > real devices could break the applications if there’s no transparent
>> > mechanism to back up the propagated (but now revoked) device bind
>> > mounts that could fool the apps into believing that they are working
>> > with real devices. Frame buffer is one such example, where safe
>> > multiplexing could be applied.
>> >
>> >>>> I agree that assigning fixed device numbers is
>> >>>> clearly not a long-term solution. Emulation for safe and flexible
>> >>>> multiplexing, like you suggested either using CUSE/FUSE or something
>> >>>> like
>> >>>> devpts, is what I'm exploring.
>> >>
>> >> Is the problem you actually care about multiplexing devices?
>> >>
>> >
>> > The problem I care about is access to real devices, such as input, fb,
>> > loop, etc. as and when needed, thereby having native I/O performance -
>> > either through secure multiplexing or exclusive ownership, whatever
>> > makes sense according to the device type.
>>
>> Riya Khanna <riyakhanna1983@gmail.com> writes:
>>
>> > I guess policy-based multiplexing (or exclusive ownership) is the
>> > usage. What kind of devices (loop, fb, etc.) this is needed for
>> > depends on the usage. If there are multiple FBs, then each container
>> > could potentially own one. One may want to provide exclusive ownership
>> > of input devices to one container at a time to avoid information
>> > leakage. Like we saw at LPC last year, this applies to sensors (gps,
>> > accelerometer, etc.) on mobile devices as well.
>>
>> Allowing mutiplexing of those devices seems reasonable.
>>
>> Where the discussion ran into problems last time was that people did not
>> want to use any of the existing linux solutions for multiplexing those
>> kind of thing and wanted to invent something new.
>>
>> Inventing something new is fine if it the extra code maintenance can be
>> justified, or if the invention just a better solution for all users and
>> new code can just start using that in general.
>>
>> The old solution to your problem of multiplexing devices is by
>> allocating a virtual terminal nd sending signals to coordinate
>> cooperatively sharing those resources.
>>
>> If you want some sort of preemtive multitasking that requires
>> something a bit more effort, and work in the device abstractions.
>> You may be able to share concepts and library code but I don't believe
>> there is something you can just pain on top of devices and make it
>> happen.  Certainly in the bad old days of X terminal switching the
>> cooperation was necessary so that when a video card was yanked from an
>> application writing directly to that video card the application would
>> need to restore the video card to a known state so the next application
>> would have a chance of making sense of it.   Furthermore most devices
>> are not safe to let unprivileged users to access their control registers
>> directly.
>>
>> All of which boils down the simple fact that for each type of device you
>> would like to share it is necessary to update the subsystem to support
>> arbitrary numbers of virtual devices that you can talk to.
>>
>> The macvlan driver in the networking stack is a rough example of what I
>> expect you would like.  Something that takes one real physical device
>> and turns it into N virtual devices each of which runs at effectively
>> full speed.  Along with some kind of new master interface for
>> controlling when the multiplexing takes place.
>>
>> I think we do most of this is software today and arguably for a lot of
>> devices the overhead is small enough that a software solution is fine.
>> So perhaps all you need is a fuse interface to the existing software
>> multiplexers so that weird legacy code can be made to run.
>>
>
> What kind of existing multiplexers could be used? Is there one for fb? We
> have evdev abstractions for input in place already.
>
>> Now I suspect part of doing this right will be getting proper video
>> drivers on Android.  I assume that Android is the platform you care
>> about.
>>
>> Eric
>>
>>
>
