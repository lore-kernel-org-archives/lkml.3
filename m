Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaKZXyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:54:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbaKZXyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:54:43 -0500
Date: Thu, 27 Nov 2014 00:54:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Aaron Tomlin <atomlin@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] exit: pidns: alloc_pid() leaks pid_namespace if
	child_reaper is exiting
Message-ID: <20141126235434.GA378@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126235416.GA32688@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_pid() does get_pid_ns() beforehand but forgets to put_pid_ns()
if it fails because disable_pid_allocation() was called by the exiting
child_reaper.

We could simply move get_pid_ns() down to successful return, but this
fix tries to be as trivial as possible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/pid.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 9b9a266..82430c8 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -341,6 +341,8 @@ out:
 
 out_unlock:
 	spin_unlock_irq(&pidmap_lock);
+	put_pid_ns(ns);
+
 out_free:
 	while (++i <= ns->level)
 		free_pidmap(pid->numbers + i);
-- 
1.5.5.1

