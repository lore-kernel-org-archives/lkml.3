Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3CIUPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 15:15:55 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:58239 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3CIUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 15:15:54 -0500
MIME-Version: 1.0
In-Reply-To: <20130309200106.GB8149@redhat.com>
References: <20130306223657.GA7392@redhat.com>
	<20130307172545.GA10353@redhat.com>
	<20130307180139.GD29601@htj.dyndns.org>
	<20130307180332.GE29601@htj.dyndns.org>
	<20130307191242.GA18265@redhat.com>
	<20130307193820.GB3209@htj.dyndns.org>
	<513A9A67.60909@huawei.com>
	<20130309032936.GT14556@mtj.dyndns.org>
	<513AE918.7020704@huawei.com>
	<20130309200046.GA8149@redhat.com>
	<20130309200106.GB8149@redhat.com>
Date: Sat, 9 Mar 2013 12:15:50 -0800
X-Google-Sender-Auth: IcCz29al0XH490tj99RqNFxhH-c
Message-ID: <CAOS58YOT3yhmekrLPN30-bozrtNKrqEZEu7MR0se9Gv+DQ+CvA@mail.gmail.com>
Subject: Re: [PATCH 1/1] do not abuse ->cred_guard_mutex in threadgroup_lock()
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 9, 2013 at 12:01 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> threadgroup_lock() takes signal->cred_guard_mutex to ensure that
> thread_group_leader() is stable. This doesn't look nice, the scope
> of this lock in do_execve() is huge.
>
> And as Dave pointed out this can lead to deadlock, we have the
> following dependencies:
>
>         do_execve:              cred_guard_mutex -> i_mutex
>         cgroup_mount:           i_mutex -> cgroup_mutex
>         attach_task_by_pid:     cgroup_mutex -> cred_guard_mutex
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

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
