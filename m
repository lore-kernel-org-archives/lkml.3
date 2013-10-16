Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473Ab3JPRtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:49:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715Ab3JPRqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Mike Galbraith <efault@gmx.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 48/50] ipc/sem.c: synchronize the proc interface
Date: Wed, 16 Oct 2013 10:45:34 -0700
Message-Id: <20131016174404.249606640@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manfred Spraul <manfred@colorfullife.com>

commit d8c633766ad88527f25d9f81a5c2f083d78a2b39 upstream.

The proc interface is not aware of sem_lock(), it instead calls
ipc_lock_object() directly.  This means that simple semop() operations
can run in parallel with the proc interface.  Right now, this is
uncritical, because the implementation doesn't do anything that requires
a proper synchronization.

But it is dangerous and therefore should be fixed.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/sem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -2103,6 +2103,14 @@ static int sysvipc_sem_proc_show(struct
 	struct sem_array *sma = it;
 	time_t sem_otime;
 
+	/*
+	 * The proc interface isn't aware of sem_lock(), it calls
+	 * ipc_lock_object() directly (in sysvipc_find_ipc).
+	 * In order to stay compatible with sem_lock(), we must wait until
+	 * all simple semop() calls have left their critical regions.
+	 */
+	sem_wait_array(sma);
+
 	sem_otime = get_semotime(sma);
 
 	return seq_printf(s,


