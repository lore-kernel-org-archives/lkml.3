Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbaGRQA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:00:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46331 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761906AbaGRQAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:00:24 -0400
Date: Fri, 18 Jul 2014 16:00:04 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Aditya Kali <adityakali@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com, containers@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] RFC: CGroup Namespaces
Message-ID: <20140718160004.GC20686@ubuntumail>
References: <adityakali-cgroupns>
 <1405626731-12220-1-git-send-email-adityakali@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405626731-12220-1-git-send-email-adityakali@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> Background
>   Cgroups and Namespaces are used together to create “virtual”
>   containers that isolates the host environment from the processes
>   running in container. But since cgroups themselves are not
>   “virtualized”, the task is always able to see global cgroups view
>   through cgroupfs mount and via /proc/self/cgroup file.
> 
>   $ cat /proc/self/cgroup 
>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_id1
> 
>   This exposure of cgroup names to the processes running inside a
>   container results in some problems:
>   (1) The container names are typically host-container-management-agent
>       (systemd, docker/libcontainer, etc.) data and leaking its name (or
>       leaking the hierarchy) reveals too much information about the host
>       system.
>   (2) It makes the container migration across machines (CRIU) more
>       difficult as the container names need to be unique across the
>       machines in the migration domain.
>   (3) It makes it difficult to run container management tools (like
>       docker/libcontainer, lmctfy, etc.) within virtual containers
>       without adding dependency on some state/agent present outside the
>       container.
> 
>   Note that the feature proposed here is completely different than the
>   “ns cgroup” feature which existed in the linux kernel until recently.
>   The ns cgroup also attempted to connect cgroups and namespaces by
>   creating a new cgroup every time a new namespace was created. It did
>   not solve any of the above mentioned problems and was later dropped
>   from the kernel.
> 
> Introducing CGroup Namespaces
>   With unified cgroup hierarchy
>   (Documentation/cgroups/unified-hierarchy.txt), the containers can now
>   have a much more coherent cgroup view and its easy to associate a
>   container with a single cgroup. This also allows us to virtualize the
>   cgroup view for tasks inside the container.

Hi,

So right now we basically do this in userspace using cgmanager.  Each
container/chroot/whatever that has a cgproxy is 'locked' under that
proxy's cgroup.  So if root in a container asks the cgproxy for the
cgroup of pid 2000, and cgproxy is in /lxc/u1 while pid 2000 in the
container is in /lxc/u1/service1, then the response will be '/service1'.
Same happens with creating cgroups, moving pids into cgroups, etc.

(Hoping to take a close look at this set early next week)

-serge
