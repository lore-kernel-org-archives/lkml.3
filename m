Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554AbaLLIzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:55:06 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:4958 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbaLLIzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:55:03 -0500
Message-ID: <548AAD42.5010002@huawei.com>
Date: Fri, 12 Dec 2014 16:54:26 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Aditya Kali <adityakali@google.com>
CC: <tj@kernel.org>, <serge.hallyn@ubuntu.com>, <luto@amacapital.net>,
        <ebiederm@xmission.com>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <mingo@redhat.com>, <containers@lists.linux-foundation.org>,
        <jnagal@google.com>, <vgoyal@redhat.com>,
        <richard.weinberger@gmail.com>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
References: <adityakali-cgroupns> <1417744550-6461-1-git-send-email-adityakali@google.com> <1417744550-6461-9-git-send-email-adityakali@google.com>
In-Reply-To: <1417744550-6461-9-git-send-email-adityakali@google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +In its current form, the cgroup namespaces patcheset provides following
> +behavior:
> +
> +(1) The 'cgroupns-root' for a cgroup namespace is the cgroup in which
> +    the process calling unshare is running.
> +    For ex. if a process in /batchjobs/container_id1 cgroup calls unshare,
> +    cgroup /batchjobs/container_id1 becomes the cgroupns-root.
> +    For the init_cgroup_ns, this is the real root ('/') cgroup
> +    (identified in code as cgrp_dfl_root.cgrp).
> +
> +(2) The cgroupns-root cgroup does not change even if the namespace
> +    creator process later moves to a different cgroup.
> +    $ ~/unshare -c # unshare cgroupns in some cgroup
> +    [ns]$ cat /proc/self/cgroup
> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
> +    [ns]$ mkdir sub_cgrp_1
> +    [ns]$ echo 0 > sub_cgrp_1/cgroup.procs
> +    [ns]$ cat /proc/self/cgroup
> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
> +
> +(3) Each process gets its CGROUPNS specific view of /proc/<pid>/cgroup
> +(a) Processes running inside the cgroup namespace will be able to see
> +    cgroup paths (in /proc/self/cgroup) only inside their root cgroup
> +    [ns]$ sleep 100000 &  # From within unshared cgroupns
> +    [1] 7353
> +    [ns]$ echo 7353 > sub_cgrp_1/cgroup.procs
> +    [ns]$ cat /proc/7353/cgroup
> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
> +
> +(b) From global cgroupns, the real cgroup path will be visible:
> +    $ cat /proc/7353/cgroup
> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1/sub_cgrp_1
> +
> +(c) From a sibling cgroupns (cgroupns root-ed at a different cgroup), cgroup
> +    path relative to its own cgroupns-root will be shown:
> +    # ns2's cgroupns-root is at '/batchjobs/container_id2'
> +    [ns2]$ cat /proc/7353/cgroup
> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/../container_id2/sub_cgrp_1

Should be ../container_id1/sub_cgrp_1 ?

> +
> +    Note that the relative path always starts with '/' to indicate that its
> +    relative to the cgroupns-root of the caller.

If a path doesn't start with '/', then it's a relative path, so why make it start with '/'?

> +
> +(4) Processes inside a cgroupns can move in-and-out of the cgroupns-root
> +    (if they have proper access to external cgroups).
> +    # From inside cgroupns (with cgroupns-root at /batchjobs/container_id1), and
> +    # assuming that the global hierarchy is still accessible inside cgroupns:
> +    $ cat /proc/7353/cgroup
> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
> +    $ echo 7353 > batchjobs/container_id2/cgroup.procs
> +    $ cat /proc/7353/cgroup
> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/../container_id2
> +
> +    Note that this kind of setup is not encouraged. A task inside cgroupns
> +    should only be exposed to its own cgroupns hierarchy. Otherwise it makes
> +    the virtualization of /proc/<pid>/cgroup less useful.
> +
> +(5) Setns to another cgroup namespace is allowed when:
> +    (a) the process has CAP_SYS_ADMIN in its current userns
> +    (b) the process has CAP_SYS_ADMIN in the target cgroupns' userns
> +    No implicit cgroup changes happen with attaching to another cgroupns. It
> +    is expected that the somone moves the attaching process under the target
> +    cgroupns-root.
> +

s/the somone/someone

> +(6) When some thread from a multi-threaded process unshares its
> +    cgroup-namespace, the new cgroupns gets applied to the entire
> +    process (all the threads). This should be OK since
> +    unified-hierarchy only allows process-level containerization. So
> +    all the threads in the process will have the same cgroup.
> +
> +(7) The cgroup namespace is alive as long as there is atleast 1

s/atelast/at least

> +    process inside it. When the last process exits, the cgroup
> +    namespace is destroyed. The cgroupns-root and the actual cgroups
> +    remain though.
> +
> +(8) Namespace specific cgroup hierarchy can be mounted by a process running
> +    inside cgroupns:
> +    $ mount -t cgroup -o __DEVEL__sane_behavior cgroup $MOUNT_POINT
> +
> +    This will mount the unified cgroup hierarchy with cgroupns-root as the
> +    filesystem root. The process needs CAP_SYS_ADMIN in its userns and mntns.
> +
> 

