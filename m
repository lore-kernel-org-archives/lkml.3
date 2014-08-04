Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaHDXNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 19:13:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41462 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaHDXNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 19:13:02 -0400
Date: Mon, 4 Aug 2014 23:12:55 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Aditya Kali <adityakali@google.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 2/5] sched: new clone flag CLONE_NEWCGROUP for cgroup
 namespace
Message-ID: <20140804231255.GM12438@ubuntumail>
References: <1405626731-12220-1-git-send-email-adityakali@google.com>
 <1405626731-12220-3-git-send-email-adityakali@google.com>
 <20140724170119.GR26600@ubuntumail>
 <CAGr1F2FAiSFR_Y3t1=eBVoAtJvh4m=cNUi+vG146nDkgtBjisQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGr1F2FAiSFR_Y3t1=eBVoAtJvh4m=cNUi+vG146nDkgtBjisQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> On Thu, Jul 24, 2014 at 10:01 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> > Quoting Aditya Kali (adityakali@google.com):
> >> CLONE_NEWCGROUP will be used to create new cgroup namespace.
> >>
> >
> > This is fine and I'm not looking to bikeshed, but am wondering - did
> > you consider any other ways beside unshare (i.e. a new mount option
> > to cgroupfs)?  If so, do you have a list of the downsides of those?
> > (I mainly ask bc clone flags are still a scarce commodity)
> >
> 
> I did consider couple of other ways:
> 
> (1) having a cgroup.ns_root (or something) cgroup file. If this value
> is '1', it would mean that all processes it and its descendant cgroups
> will have their cgroup paths in /proc/self/cgroup terminated at this
> cgroup.
>  For ex:
> [A] --> [B] --> C
>     | --> [D] --> E
> 
> [A], [B] and [D] has cgroup.ns_root = 1.
> * all processes in cgroup C & E will see their cgroup path as /C and
> /E respectively
> * all processes in cgroup B & D will see their own cgroup path as /
> 
> In this model, its easy to know what to show if process is looking at
> its own cgroup paths (/proc/self/cgroup). It gets tricky when you are
> looking at other process's /proc/<pid>/cgroup. We may be able to come
> up with some hacky way read correct value, but depending on the
> cgroupfs mount, it may not make sense.
> One other major drawback of this approach is that "every" process in
> the cgroup will now get a restricted view. i.e., you cannot change
> cgroups without affecting your view. And this is undesirable for
> administrative processes.
> 
> (2) Another idea that I didn't pursue further (and is a bit hacky as
> above) was having cgroup.ns_procs (like cgroup.procs, but all the pids
> in cgroup.ns_procs will have their /proc/self/cgroup restricted).
> Writing a pid to cgroup.ns_procs implies that you are writing it to
> cgroup.procs too. But, not vise-versa. So, you could move yourself in
> another cgroup by writing your pid in cgroup.procs, but not in
> cgroup.ns_procs, thus preventing from getting "rooted". I This was to
> solve administrative process issue in the above appraoch. But I think
> this is very clunky too and I find semantics for this approach to be
> non-intuitive. It almost looks like moving towards a separate "ns"
> subsystem. But as we already know, its a path to failure.
> 
> I didn't think of using a mount option. I imagine the mount option
> (something like -o root=/bathjobs/container_1) could be used to
> restrict the visibility of cgroupfs inside the container's mount
> namespace. i.e., the value you read from /proc/<pid>/cgroup now
> depends on what mount namespace you are in. Its similar to cgroup
> namespace, but just that the cgroupns_root is now stored in the
> 'struct mnt_namespace' instead of a separate 'struct
> cgroup_namespace'. But, since mount namespace on creation inherits
> mounts from its parent, the first cgroupfs mount in a mount namespace
> is now treated specially. Also, its not possible to restrict cgroups
> without mount namespace now. This is interesting and may not be too
> bad. I am willing to give this a try. But I feel the cgroup namespace
> approach fits well in-line with other namespaces where it does one
> thing - virtualize the view of /proc/<pid>/cgroup file for processes
> inside the namespace. The semantics are more intuitive as they are
> similar to other namespaces.

Yeah, let's stick with what you have :)

thanks,
-serge

