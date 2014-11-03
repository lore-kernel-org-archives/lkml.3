Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaKCW5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:57:14 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:41017 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaKCW5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:57:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-8-git-send-email-adityakali@google.com> <87y4rvrakn.fsf@x220.int.ebiederm.org>
 <CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 14:56:47 -0800
Message-ID: <CALCETrXB1CwASpTNSAE5_hOHGdAsJkZ1cmRpB2JTMdJQt+Dj9A@mail.gmail.com>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init cgroupns
To: Aditya Kali <adityakali@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 2:43 PM, Aditya Kali <adityakali@google.com> wrote:
>
>
> On Fri, Oct 31, 2014 at 6:09 PM, Eric W. Biederman <ebiederm@xmission.com>
> wrote:
>>
>> Aditya Kali <adityakali@google.com> writes:
>>
>> > This patch enables cgroup mounting inside userns when a process
>> > as appropriate privileges. The cgroup filesystem mounted is
>> > rooted at the cgroupns-root. Thus, in a container-setup, only
>> > the hierarchy under the cgroupns-root is exposed inside the container.
>> > This allows container management tools to run inside the containers
>> > without depending on any global state.
>> > In order to support this, a new kernfs api is added to lookup the
>> > dentry for the cgroupns-root.
>>
>> There is a misdesign in this.  Because files already exist we need the
>> protections that are present in proc and sysfs that only allow you to
>> mount the filesystem if it is already mounted.  Otherwise you can wind
>> up mounting this cgroupfs in a chroot jail when the global root would
>> not like you to see it.  cgroupfs isn't as bad as proc and sys but there
>> is at the very least an information leak in mounting it.
>>
>
> I think simply mounting the cgroupfs doesn't give you any more information
> than what you don't already know about the system ; specially if the
> visibility is restricted within the process's cgroupns-root. The cgroups
> still wont be writable by the user, so I think it should be fine to allow
> mounting?
>

Can we try to figure out a better way to do this than checking at
mount time for a fully-visible procfs/sysfs/cgroupfs?  The current
approach is unpleasant to deal with.

For example, we could check the equivalent conditions when the userns
is created and store then in a per-userns flags field.

>
>>
>> Given that we are effectively performing a bind mount in this patch, and
>> that we need to require cgroupfs be mounted anyway (to be safe).
>>
>> I don't see the point of this change.
>>
>> If we could change the set of cgroups or visible in cgroupfs I could
>> probably see the point.  But as it is this change seems to be pointless.
>>
>
> I agree that this is effectively bind-mounting, but doing this in kernel
> makes it really convenient for the userspace. The process that sets up the
> container doesn't need to care whether it should bind-mount cgroupfs inside
> the container or not. The tasks inside the container can mount cgroupfs on
> as-needed basis. The root container manager can simply unshare cgroupns and
> forget about the internal setup. I think this is useful just for the reason
> that it makes life much simpler for userspace.
>

If we add the fully-visible check at mount time, then I almost agree
with Eric.  I say almost because fs_fully_visible isn't checking
whether the superblock root is the thing that's mounted, and, if we
fix that, then bind-mounting like this becomes impossible and we'd
have to refine the check.

But if we come up with something less gross than checking for fs
visibility at mount time, then I agree with Aditya: let's let mount do
the right thing, since there may be nothing there to bind mount.  If
we go that route, then I think we might want to make it explicit:
require a mount flag like root=. to indicate that we want to be rooted
at our cgroupns's root cgroup.

--Andy
