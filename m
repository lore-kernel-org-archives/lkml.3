Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3IRTQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:16:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34997 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3IRTQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:16:09 -0400
Date: Wed, 18 Sep 2013 20:16:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Savchenko <bircoph@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        suspend-devel@lists.sourceforge.net
Subject: Re: [BUG] 3.7-rc regression bisected: s2disk fails to resume image:
 Processes could not be frozen, cannot continue resuming
Message-ID: <20130918191607.GO13318@ZenIV.linux.org.uk>
References: <20130812234415.7db639bb0d664e56b6ab2ab2@gmail.com>
 <20130827074843.ba1b6f62cc0a6dca8e47c06c@gmail.com>
 <20130918135239.GL13318@ZenIV.linux.org.uk>
 <20130918224032.84e09e0c1372dbc51c86ab1e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918224032.84e09e0c1372dbc51c86ab1e@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 10:40:32PM +0400, Andrew Savchenko wrote:

> And from suspend_ioctls.h:
> #define SNAPSHOT_IOC_MAGIC      '3'
> #define SNAPSHOT_FREEZE                 _IO(SNAPSHOT_IOC_MAGIC, 1)
> 
> My mistake, should be '3' instead of 3.

OK...  The thing to test, then, is what does __usermodehelper_disable()
return to freeze_processes().  If that's where this -EAGAIN comes from,
we at least have a plausible theory re what's going on.

freeze_processes() uses __usermodehelper_disable() to stop any new userland
processes spawned by UMH (modprobe, etc.) and waits for ones it might be
waiting for to complete.  Then it does try_to_freeze_tasks(), which
freezes remaining userland, carefully skipping the current thread.
However, it misses the possibility that current thread might have been
spawned by something that had been launched by UMH, with UMH waiting
for it.  Which is the case of everything spawned by linuxrc.

I'd try something like diff below, but I'm *NOT* familiar with swsusp at
all; it's not for mainline until ACKed by swsusp folks.

diff --git a/kernel/kmod.c b/kernel/kmod.c
index fb32636..d968882 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -571,7 +571,8 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
-	helper_lock();
+	if (!(current->flags & PF_FREEZER_SKIP))
+		helper_lock();
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
 		goto out;
@@ -611,7 +612,8 @@ wait_done:
 out:
 	call_usermodehelper_freeinfo(sub_info);
 unlock:
-	helper_unlock();
+	if (!(current->flags & PF_FREEZER_SKIP))
+		helper_unlock();
 	return retval;
 }
 EXPORT_SYMBOL(call_usermodehelper_exec);
