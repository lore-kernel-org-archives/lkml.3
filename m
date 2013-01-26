Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3AZAVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:21:30 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:61381 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3AZAV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:21:27 -0500
Message-ID: <51032162.5080007@huawei.com>
Date: Sat, 26 Jan 2013 08:20:50 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix cgroup_path() vs rename() race
References: <51022FC7.5020607@huawei.com> <20130125164242.GA3081@htj.dyndns.org>
In-Reply-To: <20130125164242.GA3081@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/26 0:42, Tejun Heo wrote:
> On Fri, Jan 25, 2013 at 03:09:59PM +0800, Li Zefan wrote:
>> rename() will change dentry->d_name. The result of this race can
>> be worse than seeing partially rewritten name, but we might access
>> a stale pointer because rename() will re-allocate memory to hold
>> a longer name.
>>
>> Use dentry_path_raw(), and this vfs API will take care of lockings.
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Urgh... why do we even support rename?  :(
> 

Added in this commit many years ago:

commit 18a19cb3047e454ee5ecbc35d7acf3f8e09e0466
Author: Paul Jackson <pj@sgi.com>
Date:   Sun Oct 30 15:02:31 2005 -0800

    [PATCH] cpusets: simple rename

    Add support for renaming cpusets.  Only allow simple rename of cpuset
    directories in place.  Don't allow moving cpusets elsewhere in hierarchy or
    renaming the special cpuset files in each cpuset directory.

    The usefulness of this simple rename became apparent when developing task
    migration facilities.  It allows building a second cpuset hierarchy using
    new names and containing new CPUs and Memory Nodes, moving tasks from the
    old to the new cpusets, removing the old cpusets, and then renaming the new
    cpusets to be just like the old names, so that any knowledge that the tasks
    had of their cpuset names will still be valid.

    Leaf node cpusets can be migrated to other CPUs or Memory Nodes by just
    updating their 'cpus' and 'mems' files, but because no cpuset can contain
    CPUs or Nodes not in its parent cpuset, one cannot do this in a cpuset
    hierarchy without first expanding all the non-leaf cpusets to contain the
    union of both the old and new CPUs and Nodes, which would obfuscate the
    one-to-one migration of a task from one cpuset to another required to
    correctly migrate the physical page frames currently allocated to that
    task.

    Signed-off-by: Paul Jackson <pj@sgi.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>


