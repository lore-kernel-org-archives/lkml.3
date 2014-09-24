Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaIXWib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 18:38:31 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57098 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIXWi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 18:38:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Riya Khanna <riyakhanna1983@gmail.com>
Cc: LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Tejun Heo <tj@kernel.org>, Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@ubuntu.com>
References: <CALRD3qKmpzJCRszkG_S9Z3XgoTGWVMFd7FqeJh+W-9pZqPVhCg@mail.gmail.com>
	<87bnq5vcbl.fsf@x220.int.ebiederm.org>
	<CALRD3qKPJHmmY2DSNNfNKzmLihDLm9fgBQprCXNMHVOArV4iuw@mail.gmail.com>
	<20140924163740.GD3865@ubuntumail>
	<8738bglxsf.fsf_-_@x220.int.ebiederm.org>
	<E8CD8839-8FC9-4404-863B-38F36F7D4328@gmail.com>
Date: Wed, 24 Sep 2014 15:38:03 -0700
In-Reply-To: <E8CD8839-8FC9-4404-863B-38F36F7D4328@gmail.com> (Riya Khanna's
	message of "Wed, 24 Sep 2014 14:30:30 -0500")
Message-ID: <871tr0hcfo.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1/hUysR7T5Q2o5rAwSIxrWs4QfFruZE244=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.4 XM_Superlative01 Best-rated language
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4888]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Riya Khanna <riyakhanna1983@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: Using devices in Containers
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Riya Khanna <riyakhanna1983@gmail.com> writes:

> On Sep 24, 2014, at 12:43 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
>> 
>>> Isolation is provided by the devices cgroup.  You want something more
>>> than isolation.
>>> 
>>> Quoting riya khanna (riyakhanna1983@gmail.com):
>>>> My use case for having device namespaces is device isolation. Isn't what
>>>> namespaces are there for (as I understand)?
>> 
>> Namespaces fundamentally provide for using the same ``global'' name
>> in different contexts.  This allows them to be used for isolation
>> and process migration (because you can take the same name from
>> machine to machine).
>> 
>> Unless someone cares about device numbers at a namespace level
>> the work is done.
>> 
>> The mount namespace provides exsits to deal with file names.
>> The devices cgroup will limit which devices you can access (although
>> I can't ever imagine a case where the mout namespace would be
>> insufficient).
>> 
>>>> Not everything should be
>>>> accessible (or even visible) from a container all the time (we have seen
>>>> people come up with different use cases for this). However, bind-mounting
>>>> takes away this flexibility.
>> 
>> I don't see how.  If they are mounts that propogate into the container
>> and are controlled from outside you can do whatever you want.  (I am
>> imagining device by device bind mounts here).  It should be trivial
>> to have a a directory tree that propogates into a container and works.
>> 
>
> Device-by-device bind mounts can grant/revoke access to real
> individual devices as and when needed. However, revoking the access to
> real devices could break the applications if there’s no transparent
> mechanism to back up the propagated (but now revoked) device bind
> mounts that could fool the apps into believing that they are working
> with real devices. Frame buffer is one such example, where safe
> multiplexing could be applied. 
>
>>>> I agree that assigning fixed device numbers is
>>>> clearly not a long-term solution. Emulation for safe and flexible
>>>> multiplexing, like you suggested either using CUSE/FUSE or something like
>>>> devpts, is what I'm exploring.
>> 
>> Is the problem you actually care about multiplexing devices?
>> 
>
> The problem I care about is access to real devices, such as input, fb,
> loop, etc. as and when needed, thereby having native I/O performance -
> either through secure multiplexing or exclusive ownership, whatever
> makes sense according to the device type. 

Riya Khanna <riyakhanna1983@gmail.com> writes:

> I guess policy-based multiplexing (or exclusive ownership) is the
> usage. What kind of devices (loop, fb, etc.) this is needed for
> depends on the usage. If there are multiple FBs, then each container
> could potentially own one. One may want to provide exclusive ownership
> of input devices to one container at a time to avoid information
> leakage. Like we saw at LPC last year, this applies to sensors (gps,
> accelerometer, etc.) on mobile devices as well. 

Allowing mutiplexing of those devices seems reasonable.

Where the discussion ran into problems last time was that people did not
want to use any of the existing linux solutions for multiplexing those
kind of thing and wanted to invent something new.

Inventing something new is fine if it the extra code maintenance can be
justified, or if the invention just a better solution for all users and
new code can just start using that in general.

The old solution to your problem of multiplexing devices is by
allocating a virtual terminal nd sending signals to coordinate
cooperatively sharing those resources.

If you want some sort of preemtive multitasking that requires
something a bit more effort, and work in the device abstractions.
You may be able to share concepts and library code but I don't believe
there is something you can just pain on top of devices and make it
happen.  Certainly in the bad old days of X terminal switching the
cooperation was necessary so that when a video card was yanked from an
application writing directly to that video card the application would
need to restore the video card to a known state so the next application
would have a chance of making sense of it.   Furthermore most devices
are not safe to let unprivileged users to access their control registers
directly.

All of which boils down the simple fact that for each type of device you
would like to share it is necessary to update the subsystem to support
arbitrary numbers of virtual devices that you can talk to.

The macvlan driver in the networking stack is a rough example of what I
expect you would like.  Something that takes one real physical device
and turns it into N virtual devices each of which runs at effectively
full speed.  Along with some kind of new master interface for
controlling when the multiplexing takes place.

I think we do most of this is software today and arguably for a lot of
devices the overhead is small enough that a software solution is fine.
So perhaps all you need is a fuse interface to the existing software
multiplexers so that weird legacy code can be made to run.

Now I suspect part of doing this right will be getting proper video
drivers on Android.  I assume that Android is the platform you care
about.

Eric


