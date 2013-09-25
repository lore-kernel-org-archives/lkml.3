Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab3IYVFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:05:10 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:39608 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab3IYVFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:05:05 -0400
Date: Wed, 25 Sep 2013 14:05:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: akpm@linux-foundation.org, oleg@redhat.com, security@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] kthread: Make kthread_create() killable.
In-Reply-To: <201309250017.HBG57846.VFOStOFFOLQJHM@I-love.SAKURA.ne.jp>
Message-ID: <alpine.DEB.2.02.1309251351001.27471@chino.kir.corp.google.com>
References: <20130914160515.GA8627@redhat.com> <201309150846.HED51521.tJOFOMVFSOHQFL@I-love.SAKURA.ne.jp> <20130915163919.GC13344@redhat.com> <201309160953.IGI12418.FOQHOFVJLOMFSt@I-love.SAKURA.ne.jp> <20130923160725.49093c565dcf6df7037dcc6b@linux-foundation.org>
 <201309250017.HBG57846.VFOStOFFOLQJHM@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, Tetsuo Handa wrote:

> Any users of wait_for_completion() might be chosen by the OOM killer while
> waiting for completion() call by some process which does memory
> allocation.  kthread_create() is one of such users.
> 

Any user process callers of wait_for_completion() you mean.

> When such users are chosen by the OOM killer when they are waiting for
> completion() in TASK_UNINTERRUPTIBLE, the system will be kept stressed
> due to memory starvation because the OOM killer cannot kill such users.
> 

Also results in a livelock if you're running in a memcg and have hit its 
limit.

> Fix this problem for kthreadd by making kthread_create() killable.
> 

There appear to be other potential callers of wait_for_completion() in the 
tree as well that could be holding lots of memory besides 
kthread_create().

Perhaps that's beyond the scope of this particular patch, though.

wait_for_completion() is scary if that completion requires memory that 
cannot be allocated because the caller is killed but uninterruptible.

> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: David Rientjes <rientjes@google.com>
