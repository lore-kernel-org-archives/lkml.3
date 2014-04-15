Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaDOA6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:58:00 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:28162 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaDOA56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:57:58 -0400
Message-ID: <534C83F1.9020106@huawei.com>
Date: Tue, 15 Apr 2014 08:57:21 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <john@johnmccutchan.com>,
        <rlove@rlove.org>, <eparis@parisplace.org>,
        <gregkh@linuxfoundation.org>, <serge.hallyn@ubuntu.com>,
        <lennart@poettering.net>, <kay@vrfy.org>
Subject: Re: [PATCH 3/3] cgroup: implement cgroup.subtree_populated for the
 default hierarchy
References: <1397511846-2904-1-git-send-email-tj@kernel.org> <1397511846-2904-4-git-send-email-tj@kernel.org>
In-Reply-To: <1397511846-2904-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/15 5:44, Tejun Heo wrote:
> cgroup users often need a way to determine when a cgroup's
> subhierarchy becomes empty so that it can be cleaned up.  cgroup
> currently provides release_agent for it; unfortunately, this mechanism
> is riddled with issues.
> 
> * It delivers events by forking and execing a userland binary
>   specified as the release_agent.  This is a long deprecated method of
>   notification delivery.  It's extremely heavy, slow and cumbersome to
>   integrate with larger infrastructure.
> 
> * There is single monitoring point at the root.  There's no way to
>   delegate management of subtree.
> 
> * The event isn't recursive.  It triggers when a cgroup doesn't have
>   any tasks or child cgroups.  Events for internal nodes trigger only
>   after all children are removed.  This again makes it impossible to
>   delegate management of subtree.
> 
> * Events are filtered from the kernel side.  "notify_on_release" file
>   is used to subscribe to or suppress release event.  This is
>   unnecessarily complicated and probably done this way because event
>   delivery itself was expensive.
> 
> This patch implements interface file "cgroup.subtree_populated" which
> can be used to monitor whether the cgroup's subhierarchy has tasks in
> it or not.  Its value is 0 if there is no task in the cgroup and its
> descendants; otherwise, 1, 

Is cgroup.tree_populated a better name?

cgroup.subtree_control controls child cgroups only, but .subtree_populated
shows 1 if there're tasks in the cgroup or its children, so the two
are a bit inconsistent to me.

> and kernfs_notify() notificaiton is
> triggers when the value changes, which can be monitored through poll
> and [di]notify.
> 
> This is a lot ligther and simpler and trivially allows delegating
> management of subhierarchy - subhierarchy monitoring can block further
> propgation simply by putting itself or another process in the root of
> the subhierarchy and monitor events that it's interested in from there
> without interfering with monitoring higher in the tree.
> 
> v2: Patch description updated as per Serge.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
> Cc: Lennart Poettering <lennart@poettering.net>

