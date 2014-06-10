Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750846AbaFJOTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:19:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaFJOTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:19:45 -0400
Date: Tue, 10 Jun 2014 10:19:33 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Manfred Spraul <manfred@colorfullife.com>, davidlohr.bueso@hp.com
Subject: Re: ipc/sem.c: change perform_atomic_semop parameters
Message-ID: <20140610141933.GA16263@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>, davidlohr.bueso@hp.com
References: <20140606235006.342B5660FCD@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606235006.342B5660FCD@gitolite.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 11:50:06PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=d198cd6d6d02d0a335af2deacb60816ebb4719d1
 > Commit:     d198cd6d6d02d0a335af2deacb60816ebb4719d1
 > Parent:     2f2ed41dcaec34f2d6f224aa84efcc5a9dd8d5c3
 > Refname:    refs/heads/next
 > Author:     Manfred Spraul <manfred@colorfullife.com>
 > AuthorDate: Fri Jun 6 14:37:49 2014 -0700
 > Committer:  Linus Torvalds <torvalds@linux-foundation.org>
 > CommitDate: Fri Jun 6 16:08:15 2014 -0700
 > 
 >     ipc/sem.c: change perform_atomic_semop parameters
 >     
 >     Right now, perform_atomic_semop gets the content of sem_queue as
 >     individual fields.  Changes that, instead pass a pointer to sem_queue.
 >     
 >     This is a preparation for the next patch: it uses sem_queue to store the
 >     reason why a task must sleep.
 >     
 >     Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
 >     Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
 >     Cc: Michael Kerrisk <mtk.manpages@gmail.com>
 >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
 >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

After this patch, coverity started complaining about a potential deref
after null check. (It may have been a problem before, but the code motion
causes a new 'event')

    	33. var_compare_op: Comparing un to null implies that un might be null.
1878        if (un && un->semid == -1)
1879                goto out_unlock_free;
1880
1881        queue.sops = sops;
1882        queue.nsops = nsops;
    	34. alias_transfer: Assigning: queue.undo = un.
1883        queue.undo = un;
1884        queue.pid = task_tgid_vnr(current);
1885        queue.alter = alter;
1886
    	
CID 1222114 (#1 of 1): Dereference after null check (FORWARD_NULL)
35. var_deref_model: Passing &queue to perform_atomic_semop, which dereferences null queue.undo. [show details]
1887        error = perform_atomic_semop(sma, &queue);


	Dave

