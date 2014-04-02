Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbaDBQpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbaDBQpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:45:51 -0400
Date: Wed, 2 Apr 2014 17:45:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matthew Dempsky <mdempsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] pid_namespace: pidns_get() should check
	task_active_pid_ns() != NULL
Message-ID: <20140402154505.GB29857@redhat.com>
References: <CAF52+S6Y40K-sRPf4YAb8ceAmtgBzZ9OUbyhPTOc_AcOWuQ=Ng@mail.gmail.com> <1396391358-22367-1-git-send-email-mdempsky@chromium.org> <20140402145850.GB7332@redhat.com> <20140402154447.GA29857@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402154447.GA29857@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pidns_get()->get_pid_ns() can hit ns == NULL. This task_struct can't
go away, but task_active_pid_ns(task) is NULL if release_task(task)
was already called. Alternatively we could change get_pid_ns(ns) to
check ns != NULL, but it seems that other callers are fine.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- x/kernel/pid_namespace.c
+++ x/kernel/pid_namespace.c
@@ -318,7 +318,9 @@ static void *pidns_get(struct task_struct *task)
 	struct pid_namespace *ns;
 
 	rcu_read_lock();
-	ns = get_pid_ns(task_active_pid_ns(task));
+	ns = task_active_pid_ns(task);
+	if (ns)
+		get_pid_ns(ns);
 	rcu_read_unlock();
 
 	return ns;

