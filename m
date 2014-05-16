Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbaEPNwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:52:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480AbaEPNwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:52:43 -0400
Date: Fri, 16 May 2014 15:51:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/1] ptrace: task_clear_jobctl_trapping()->wake_up_bit()
	needs mb()
Message-ID: <20140516135137.GB19210@redhat.com>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de> <1399974350-11089-20-git-send-email-mgorman@suse.de> <20140513125313.GR23991@suse.de> <20140513141748.GD2485@laptop.programming.kicks-ass.net> <20140514161152.GA2615@redhat.com> <20140514161755.GQ30445@twins.programming.kicks-ass.net> <20140516135116.GA19210@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516135116.GA19210@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__wake_up_bit() checks waitqueue_active() and thus the caller needs
mb() as wake_up_bit() documents, fix task_clear_jobctl_trapping().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index c2a8542..f4c4119 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -277,6 +277,7 @@ void task_clear_jobctl_trapping(struct task_struct *task)
 {
 	if (unlikely(task->jobctl & JOBCTL_TRAPPING)) {
 		task->jobctl &= ~JOBCTL_TRAPPING;
+		smp_mb();	/* advised by wake_up_bit() */
 		wake_up_bit(&task->jobctl, JOBCTL_TRAPPING_BIT);
 	}
 }
-- 
1.5.5.1


