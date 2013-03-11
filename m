Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3CKBvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 21:51:46 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:52899 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3CKBvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 21:51:45 -0400
Message-ID: <513D387F.6060101@huawei.com>
Date: Mon, 11 Mar 2013 09:50:55 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/1] do not abuse ->cred_guard_mutex in threadgroup_lock()
References: <20130306223657.GA7392@redhat.com> <20130307172545.GA10353@redhat.com> <20130307180139.GD29601@htj.dyndns.org> <20130307180332.GE29601@htj.dyndns.org> <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org> <513A9A67.60909@huawei.com> <20130309032936.GT14556@mtj.dyndns.org> <513AE918.7020704@huawei.com> <20130309200046.GA8149@redhat.com> <20130309200106.GB8149@redhat.com>
In-Reply-To: <20130309200106.GB8149@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/10 4:01, Oleg Nesterov wrote:
> threadgroup_lock() takes signal->cred_guard_mutex to ensure that
> thread_group_leader() is stable. This doesn't look nice, the scope
> of this lock in do_execve() is huge.
> 
> And as Dave pointed out this can lead to deadlock, we have the
> following dependencies:
> 
> 	do_execve:		cred_guard_mutex -> i_mutex
> 	cgroup_mount:		i_mutex -> cgroup_mutex
> 	attach_task_by_pid:	cgroup_mutex -> cred_guard_mutex
> 
> Change de_thread() to take threadgroup_change_begin() around the
> switch-the-leader code and change threadgroup_lock() to avoid
> ->cred_guard_mutex.
> 
> Note that de_thread() can't sleep with ->group_rwsem held, this
> can obviously deadlock with the exiting leader if the writer is
> active, so it does threadgroup_change_end() before schedule().
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Li Zefan <lizefan@huawei.com>

