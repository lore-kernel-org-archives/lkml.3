Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3EaQmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:42:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab3EaQma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:42:30 -0400
Date: Fri, 31 May 2013 18:38:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] proc: simplify proc_task_readdir/first_tid paths
Message-ID: <20130531163834.GA31086@redhat.com>
References: <20130527202822.GA19288@redhat.com> <87ppwa1jn0.fsf@xmission.com> <20130529133930.GB5741@redhat.com> <878v2xzfl7.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v2xzfl7.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric, sorry for delay.

On 05/29, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > Why the empty "." + ".." dir is bad if the task(s) has gone away after
> > opendir?
>
> Because the definition of a deleted directory that you are in is that
> getdents will return -ENOENT.
>
> You can reproduce this with any linux filesystem.
> mkdir foo
> cd foo
> rmdir ../foo
> strace -f ls .
>
>    open(".", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
>    getdents(3, 0x1851c88, 32768)           = -1 ENOENT (No such file or directory)
>    close(3)                                = 0

Heh. Indeed, vfs_readdir() checks IS_DEADDIR().

Thanks.

OK. But this means that even 1/3 is not 100% right, exactly because
leader can be unhashed right before first_tid() takes rcu lock. Easy
to fix, we should simply factor out the "nr != 0" check.

And this also means that 3/3 is not right by the same reason. I'll
make a simpler patch which only avoids the unnecessary get/put in
proc_task_readdir().

Unless we can tolerate this very unlikely rase when the leader goes
away after initial ENOENT check at the start, of course... Or unless
we add canceldir() which resets getdents_callback->previous so that
we could return ENOENT after filldir() was already called ;)

Thanks Eric. I'll send v2.

Oleg.

