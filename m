Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3BBGvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 01:51:33 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:55649 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3BBGv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 01:51:29 -0500
Message-ID: <510CB733.2080904@huawei.com>
Date: Sat, 2 Feb 2013 14:50:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>
Subject: [PATCH 0/4] cgroup: bug fixes for eventfd
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There're three bugs.

- If thread A is removing a cgroup, while thread B is closing an eventfd, the
two threads might free the same cgroup event and thus crash the kernel.

This is fixed by patch #1 and patch #2.

- If there're multiple threads are blocking in read() on the same eventfd,
and someone removes the cgroup, only one thread will be notified and unblocked,
and others won't be unblocked until those threads are killed.

- If thread A is removing a cgroup, while thread B is registering a cgroup event
and then read the eventfd, it might block until the thread is killed.

These two are fixed by patch #3.

0001-eventfd-Introduce-eventfd_signal_hangup.patch
0002-cgroup-fix-cgroup_rmdir-vs-close-eventfd-race.patch
0003-eventfd-make-operations-on-eventfd-return-EIDRM-if-i.patch
0004-cgroup-adapt-to-the-new-way-of-detecting-cgroup-remo.patch

--
 fs/eventfd.c                         | 30 ++++++++++++++++++++++++++++++
 include/linux/eventfd.h              |  5 +++++
 kernel/cgroup.c                      | 30 ++++++++++++++++++------------
 tools/cgroup/cgroup_event_listener.c | 12 +++++-------
 4 files changed, 58 insertions(+), 19 deletions(-)

