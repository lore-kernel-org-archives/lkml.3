Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbaGYGZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:25:09 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34693 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaGYGZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <1406264818-2296-1-git-send-email-bobby.prani@gmail.com>
References: <1406264818-2296-1-git-send-email-bobby.prani@gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 25 Jul 2014 02:24:34 -0400
Message-ID: <CAJhHMCDQe5tSs7576uy8fRBW0txXoyUa6RiQdpg48UJs5TPsog@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] rcu: Use rcu_gp_kthread_wake() to wake up kthreads
To: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 1:06 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:

>
> In rcu_report_qs_rsp(), I added a pr_info() call testing if any of the above
> conditions is true, in which case we can avoid calling wake_up(). It turns out
> that quite a few actually are. Most of the cases where we can avoid is condition 2
> above and condition 1 also occurs quite often. Condition 3 never happens.
>

A little more data. On an idle system there are about 2000 unnecessary
wake_up() calls every 5 minutes with the most common trace being the
follows:

[Fri Jul 25 02:05:49 2014]  [<ffffffff8109f7c5>] rcu_report_qs_rnp+0x285/0x2c0
[Fri Jul 25 02:05:49 2014]  [<ffffffff81838c09>] ? schedule_timeout+0x159/0x270
[Fri Jul 25 02:05:49 2014]  [<ffffffff8109fa21>] force_qs_rnp+0x111/0x190
[Fri Jul 25 02:05:49 2014]  [<ffffffff810a02c0>] ? synchronize_rcu_bh+0x50/0x50
[Fri Jul 25 02:05:49 2014]  [<ffffffff810a2e5f>] rcu_gp_kthread+0x85f/0xa70
[Fri Jul 25 02:05:49 2014]  [<ffffffff81086060>] ? __wake_up_sync+0x20/0x20
[Fri Jul 25 02:05:49 2014]  [<ffffffff810a2600>] ? rcu_barrier+0x20/0x20
[Fri Jul 25 02:05:49 2014]  [<ffffffff8106b4fb>] kthread+0xdb/0x100
                  [<ffffffff8106b420>]?kthread_create_on_node+0x180/0x180
[Fri Jul 25 02:05:49 2014]  [<ffffffff81839dac>] ret_from_fork+0x7c/0xb0
                  [<ffffffff8106b420>] ?kthread_create_on_node+0x180/0x180

With rcutorture, there are about 2000 unnecessary wake_ups() every 3
minutes with the most common trace being:

[Fri Jul 25 02:18:30 2014]  [<ffffffff8109f7c5>] rcu_report_qs_rnp+0x285/0x2c0
[Fri Jul 25 02:18:30 2014]  [<ffffffff81078b15>] ? __update_cpu_load+0xe5/0x140
                 [<ffffffffa09dc230>] ?rcu_read_delay+0x50/0x80 [rcutorture]
                 [<ffffffff810a3728>]rcu_process_callbacks+0x6b8/0x7e0


-- 
Pranith
