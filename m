Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab3ANSmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:42:44 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:37846 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab3ANSmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:42:42 -0500
Date: Mon, 14 Jan 2013 10:42:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Colin Cross <ccross@google.com>, Mike Galbraith <efault@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/2] cgroup: remove synchronize_rcu() from
 cgroup_attach_{task|proc}()
Message-ID: <20130114184236.GF27942@mtj.dyndns.org>
References: <50F3CE8E.5000402@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F3CE8E.5000402@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Li.

On Mon, Jan 14, 2013 at 05:23:26PM +0800, Li Zefan wrote:
> These 2 syncronize_rcu()s make attaching a task to a cgroup
> quite slow, and it can't be ignored in some situations.
> 
> A real case from Colin Cross: Android uses cgroups heavily to
> manage thread priorities, putting threads in a background group
> with reduced cpu.shares when they are not visible to the user,
> and in a foreground group when they are. Some RPCs from foreground
> threads to background threads will temporarily move the background
> thread into the foreground group for the duration of the RPC.
> This results in many calls to cgroup_attach_task.
> 
> In cgroup_attach_task() it's task->cgroups that is protected by RCU,
> and put_css_set() calls kfree_rcu() to free it.
> 
> If we remove this synchronize_rcu(), there can be threads in RCU-read
> sections accessing their old cgroup via current->cgroups with
> concurrent rmdir operation, but this is safe.

Yeah, these synchronize_rcu()s are utterly confused.
synchornize_rcu() necessarily have to come between two operations to
guarantee that the changes made before it are visible to all rcu
readers before proceeding beyond it.  Here, synchornize_rcu() are at
the end of attach operations with nothing beyond it.  Duh.... its only
effect would be delaying completion of write(2) to sysfs tasks/procs
files until all rcu readers see the change, which is utterly
irrelevant.  It doesn't mean anything.

Applying to cgroup/for-3.9.

Thanks.

-- 
tejun
