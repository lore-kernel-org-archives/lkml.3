Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3LBPX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:23:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab3LBPXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:23:22 -0500
Date: Mon, 2 Dec 2013 16:24:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] initial while_each_thread() fixes
Message-ID: <20131202152423.GA10878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This was reported several times, I believe the first report is
http://marc.info/?l=linux-kernel&m=127688978121665. Hmm, 3 years
ago. The lockless while_each_thread() is racy and broken, almost
every user can loop forever.

Recently people started to report they actually hit this problem in
oom_kill.c. This doesn't really matter and I can be wrong, but in
fact I do not think they really hit this race, it is very unlikely.
Another problem with while_each_thread() is that it is very easy
to use it wrongly, and oom_kill.c is the good example.

I came to conclusion that it is practically impossible to send a
single series which fixes all problems, too many different users.

So 1/2 adds the new for_each_thread() interface, and 2/2 fixes oom
kill as an example.

We obviously need a lot more changes like 2/2 before we can kill
while_each_thread() and task_struct->thread_group, but I hope they
will be straighforward. And in fact I hope that task->thread_group
can go away before we change all users of while_each_thread().

David, et al, I din't actually test 2/2, I do not know how. Please
review, although it looks simple.

Oleg.

 include/linux/init_task.h |    2 ++
 include/linux/sched.h     |   12 ++++++++++++
 kernel/exit.c             |    1 +
 kernel/fork.c             |    7 +++++++
 mm/oom_kill.c             |   37 ++++++++++++++++++++-----------------
 5 files changed, 42 insertions(+), 17 deletions(-)

