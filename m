Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3LLCMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 21:12:51 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:35801 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3LLCMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 21:12:44 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Sami Farin <sami.farin@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 0/1] Fix hang report
Date: Wed, 11 Dec 2013 21:11:57 -0500
Message-Id: <1386814318-5868-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20131124210539.3fclaxkopszlgkxh@m.safari.iki.fi>
References: <20131124210539.3fclaxkopszlgkxh@m.safari.iki.fi>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I know it's late in the -rc cycle but I'd like to get this fix into 3.13.
Although it's only likely to happen at shutdown/reboot, the hang frequency
could be as often as 1 in 10000.

The patch fixes the count value returned when the cmpxchg() has
successfully changed the count. Only one code path checks the
returned count when the cmpxchg() is successful; down_read_failed().
After failed down_read attempt is reversed but before the reader waits
for the lock, the new count is checked to ensure _someone_ has the lock:

	/* if there are no active locks, wake the new lock owner(s) */
	if ((count & LDSEM_ACTIVE_MASK) == 0)
		__ldsem_wake(sem);

Because ldsem_cmpxchg() was returning the _old_ value on success, this
was checking the wrong count value.

No other code paths are impacted by the patch. The equivalent diff below
also fixes the problem; however, I feel the intent is less clear.

| diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
| index 22fad8a..29d9e7c 100644
| --- a/drivers/tty/tty_ldsem.c
| +++ b/drivers/tty/tty_ldsem.c
| @@ -222,7 +222,7 @@ down_read_failed(struct ld_semaphore *sem, long count, long timeout)
|  	get_task_struct(tsk);
|  
|  	/* if there are no active locks, wake the new lock owner(s) */
| -	if ((count & LDSEM_ACTIVE_MASK) == 0)
| +	if ((count + adjust & LDSEM_ACTIVE_MASK) == 0)
|  		__ldsem_wake(sem);
|  
|  	raw_spin_unlock_irq(&sem->wait_lock);


Regards,

Peter Hurley (1):
  tty: Fix hang at ldsem_down_read()

 drivers/tty/tty_ldsem.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

-- 
1.8.1.2

