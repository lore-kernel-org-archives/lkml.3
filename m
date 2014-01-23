Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaAWTGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:06:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaAWTGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.12 08/27] fork:  Allow CLONE_PARENT after setns(CLONE_NEWPID)
Date: Thu, 23 Jan 2014 11:06:45 -0800
Message-Id: <20140123190649.534378268@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 1f7f4dde5c945f41a7abc2285be43d918029ecc5 upstream.

Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> Hi Oleg,
>
> commit 40a0d32d1eaffe6aac7324ca92604b6b3977eb0e :
> "fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks"
> breaks lxc-attach in 3.12.  That code forks a child which does
> setns() and then does a clone(CLONE_PARENT).  That way the
> grandchild can be in the right namespaces (which the child was
> not) and be a child of the original task, which is the monitor.
>
> lxc-attach in 3.11 was working fine with no side effects that I
> could see.  Is there a real danger in allowing CLONE_PARENT
> when current->nsproxy->pidns_for_children is not our pidns,
> or was this done out of an "over-abundance of caution"?  Can we
> safely revert that new extra check?

The two fundamental things I know we can not allow are:
- A shared signal queue aka CLONE_THREAD.  Because we compute the pid
  and uid of the signal when we place it in the queue.

- Changing the pid and by extention pid_namespace of an existing
  process.

>From a parents perspective there is nothing special about the pid
namespace, to deny CLONE_PARENT, because the parent simply won't know or
care.

>From the childs perspective all that is special really are shared signal
queues.

User mode threading with CLONE_PARENT|CLONE_VM|CLONE_SIGHAND and tasks
in different pid namespaces is almost certainly going to break because
it is complicated.  But shared signal handlers can look at per thread
information to know which pid namespace a process is in, so I don't know
of any reason not to support CLONE_PARENT|CLONE_VM|CLONE_SIGHAND threads
at the kernel level.  It would be absolutely stupid to implement but
that is a different thing.

So hmm.

Because it can do no harm, and because it is a regression let's remove
the CLONE_PARENT check and send it stable.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1175,7 +1175,7 @@ static struct task_struct *copy_process(
 	 * do not allow it to share a thread group or signal handlers or
 	 * parent with the forking task.
 	 */
-	if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
+	if (clone_flags & CLONE_SIGHAND) {
 		if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
 		    (task_active_pid_ns(current) !=
 				current->nsproxy->pid_ns_for_children))


