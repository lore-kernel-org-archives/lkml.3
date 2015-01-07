Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbbAGS5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:57:25 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:56875 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbbAGS5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:57:22 -0500
MIME-Version: 1.0
In-Reply-To: <54ACFC38.5070007@nod.at>
References: <1417744550-6461-1-git-send-email-adityakali@google.com>
 <1417744550-6461-9-git-send-email-adityakali@google.com> <548E17CE.8010704@nod.at>
 <CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com>
 <54AB15BD.8020007@nod.at> <87lhlgpyxk.fsf@x220.int.ebiederm.org>
 <CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
 <54AB2992.6060707@nod.at> <CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
 <54ACFC38.5070007@nod.at>
From: Aditya Kali <adityakali@google.com>
Date: Wed, 7 Jan 2015 10:57:01 -0800
Message-ID: <CAGr1F2H8wYtniAhd_DWCZc9RqmJspT6YKOuoQhU-f7WWWSRT6Q@mail.gmail.com>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
To: Richard Weinberger <richard@nod.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 1:28 AM, Richard Weinberger <richard@nod.at> wrote:
> Am 07.01.2015 um 00:20 schrieb Aditya Kali:
>> I understand your point. But it will add some complexity to the code.
>>
>> Before trying to make it work for non-unified hierarchy cases, I would
>> like to get a clearer idea.
>> What do you expect to be mounted when you run:
>>   container:/ # mount -t cgroup none /sys/fs/cgroup/
>> from inside the container?
>>
>> Note that cgroup-namespace wont be able to change the way cgroups are
>> mounted .. i.e., if say cpu and cpuacct subsystems are mounted
>> together at a single mount-point, then we cannot mount them any other
>> way (inside a container or outside). This restriction exists today and
>> cgroup-namespaces won't change that.
>
> I wondered why cgroup namespaces won't change that and looked at your patches
> in more detail.
> What you propose as cgroup namespace is much more a cgroup chroot() than
> a namespace.
> As you pass relative paths into the namespace you depend on the mount structure
> of the host side.
> Hence, the abstraction between namespaces happens on the mount paths of the initial
> cgroupfs. But we really want a new cgroupfs instance within a container and not just
> a cut out of the initial cgroupfs mount.
>

What you describe will be useful at Google too, just that I found it
difficult/infeasible to include it in the scope of cgroup namespaces.
The scope of cgroup namespace was deliberately limited to virtualize
/proc/<pid>/cgroup file. That too in a way that doesn't need major
changes to cgroup code itself. (It was also limited to unified
hierarchy to keep things simple, but that can be changed).

Many of the cgroup subsystems (memory, cpu, etc) rely on the fact that
they can see entire cgroup view. For example, in a memcg-OOM scenario,
the memory controller would need to look at all sub-cgroups inside the
OOMing cgroup. A per namespace cgroupfs instance (if I understand
correctly) would mean that sub-cgroups created inside the namespace
won't be visible outside. I expect this will break the functionality
of the subsystem.

Illustration: memcg A is under OOM; [B] and [C] are cgroup namespace
roots with possibly namespace-private sub-cgroups.
              ------ [B]
A --------|
              ------ [C]

Cgroups are heavily used inside the kernel for various purposes which
need any namespace-agnostic view. Inherent limitation of running
containers running on a machine is that they share the same kernel.
Perhaps what you need is something like kexec to be supported inside a
container.

> I fear you approach is over simplified and won't work for all cases. It may work
> for your specific use case at Google but we really want something generic.
> Eric, what do you think?
>
> Thanks,
> //richard


-- 
Aditya
