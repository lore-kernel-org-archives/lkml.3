Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3LCPqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:46:42 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:62178 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3LCPqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:46:39 -0500
Date: Tue, 3 Dec 2013 19:46:35 +0400
From: Sergey Dyasly <dserrg@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] initial while_each_thread() fixes
Message-Id: <20131203194635.7be1c07ae042ee395bc83527@gmail.com>
In-Reply-To: <20131202152423.GA10878@redhat.com>
References: <20131202152423.GA10878@redhat.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

I was waiting for this one!

On Mon, 2 Dec 2013 16:24:23 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> Hello.
> 
> This was reported several times, I believe the first report is
> http://marc.info/?l=linux-kernel&m=127688978121665. Hmm, 3 years
> ago. The lockless while_each_thread() is racy and broken, almost
> every user can loop forever.
> 
> Recently people started to report they actually hit this problem in
> oom_kill.c. This doesn't really matter and I can be wrong, but in
> fact I do not think they really hit this race, it is very unlikely.

The race is very easy to catch if you have a process with several threads,
all of which allocates memory simultaneously. This leads to:

  1) OOMk selects and sends SIGKILL to one of the threads

  2) another thread invokes OOMk and the first thread gets selected,
     but it gets unhashed before while_each_thread...

> Another problem with while_each_thread() is that it is very easy
> to use it wrongly, and oom_kill.c is the good example.
> 
> I came to conclusion that it is practically impossible to send a
> single series which fixes all problems, too many different users.
> 
> So 1/2 adds the new for_each_thread() interface, and 2/2 fixes oom
> kill as an example.
> 
> We obviously need a lot more changes like 2/2 before we can kill
> while_each_thread() and task_struct->thread_group, but I hope they
> will be straighforward. And in fact I hope that task->thread_group
> can go away before we change all users of while_each_thread().
> 
> David, et al, I din't actually test 2/2, I do not know how. Please
> review, although it looks simple.

The patches look correct and my test case no longer hangs, so

Reviewed-and-Tested-by: Sergey Dyasly <dserrg@gmail.com>

> 
> Oleg.
> 
>  include/linux/init_task.h |    2 ++
>  include/linux/sched.h     |   12 ++++++++++++
>  kernel/exit.c             |    1 +
>  kernel/fork.c             |    7 +++++++
>  mm/oom_kill.c             |   37 ++++++++++++++++++++-----------------
>  5 files changed, 42 insertions(+), 17 deletions(-)
> 

-- 
Sergey Dyasly <dserrg@gmail.com>
