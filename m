Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbaKTSe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:34:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbaKTSeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:34:24 -0500
Date: Thu, 20 Nov 2014 19:34:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/3] exit: reparent: avoid find_new_reaper() if no
	children
Message-ID: <20141120183423.GA10270@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120183400.GA9622@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that pid_ns logic was isolated we can change forget_original_parent()
to return right after find_child_reaper() when father->children is empty,
there is nothing to reparent in this case.

In particular this avoids find_alive_thread() and this can help if the
whole process exits and it has a lot of PF_EXITING threads at the start
of the thread list, this can easily lead to O(nr_threads ** 2) iterations.

Trivial test case (tested under KVM, 2 CPUs):

	static void *tfunc(void *arg)
	{
		pause();
		return NULL;
	}

	static int child(unsigned int nt)
	{
		pthread_t pt;

		while (nt--)
			assert(pthread_create(&pt, NULL, tfunc, NULL) == 0);

		pthread_kill(pt, SIGTRAP);
		pause();
		return 0;
	}

	int main(int argc, const char *argv[])
	{
		int stat;
		unsigned int nf = atoi(argv[1]);
		unsigned int nt = atoi(argv[2]);

		while (nf--) {
			if (!fork())
				return child(nt);

			wait(&stat);
			assert(stat == SIGTRAP);
		}

		return 0;
	}

$ time ./test 16 16536 shows:

		real		user		sys
	-	5m37.628s	0m4.437s	8m5.560s
	+	0m50.032s	0m7.130s	1m4.927s

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 4e3475d..81b62f8 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -571,6 +571,8 @@ static void forget_original_parent(struct task_struct *father)
 
 	/* Can drop and reacquire tasklist_lock */
 	reaper = find_child_reaper(father);
+	if (list_empty(&father->children))
+		goto unlock;
 
 	reaper = find_new_reaper(father, reaper);
 	list_for_each_entry(p, &father->children, sibling) {
@@ -591,6 +593,7 @@ static void forget_original_parent(struct task_struct *father)
 			reparent_leader(father, p, &dead_children);
 	}
 	list_splice_tail_init(&father->children, &reaper->children);
+ unlock:
 	write_unlock_irq(&tasklist_lock);
 
 	list_for_each_entry_safe(p, n, &dead_children, ptrace_entry) {
-- 
1.5.5.1

