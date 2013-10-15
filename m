Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab3JORoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:44:44 -0400
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:39946 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab3JORon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:44:43 -0400
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2013 13:44:43 EDT
From: "Guillaume Gaudonville" <gaudonville@6wind.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, serge.hallyn@canonical.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, cmetcalf@tilera.com,
        Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
Subject: [RFC PATCH linux-next] ns: do not allocate a new nsproxy at each call
Date: Tue, 15 Oct 2013 19:35:22 +0200
Message-Id: <1381858522-21341-1-git-send-email-guillaume.gaudonville@6wind.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, at each call of setns system call a new nsproxy is allocated,
the old nsproxy namespaces are copied into the new one and the old nsproxy
is freed if the task was the only one to use it.

It can creates large delays on hardware with large number of cpus since
to free a nsproxy a synchronize_rcu() call is done.

When a task is the only one to use a nsproxy, only the task can do an action
that will make this nsproxy to be shared by another task or thread (fork,...).
So when the refcount of the nsproxy is equal to 1, we can simply update the
current nsproxy field without allocating a new one and freeing the old one.

The install operations of each kind of namespace cannot fails, so there's no
need to check for an error and calling ops->install().

Tested on TileGX (36 cores) and Intel (32 cores).

Reported-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
---
 kernel/nsproxy.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index afc0456..afc04ac 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -255,6 +255,18 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
 	if (nstype && (ops->type != nstype))
 		goto out;
 
+	/*
+	 * If count == 1, only the current task can increment it,
+	 * by doing a fork for example so we can safely update the
+	 * current nsproxy pointers without allocate a new one,
+	 * update it and destroy the old one
+	 */
+	if (atomic_read(&tsk->nsproxy->count) == 1) {
+		err = ops->install(tsk->nsproxy, ei->ns);
+		fput(file);
+		return err;
+	}
+
 	new_nsproxy = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
 	if (IS_ERR(new_nsproxy)) {
 		err = PTR_ERR(new_nsproxy);
-- 
1.7.2.5

