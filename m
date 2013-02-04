Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3BDVtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:49:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab3BDVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:49:38 -0500
Date: Mon, 4 Feb 2013 16:49:29 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Jana Saout <jana@saout.de>
Subject: Re: [GIT PULL] Revert "dlm: check the maximum size of a request from
 user"
Message-ID: <20130204214929.GD20950@redhat.com>
References: <20130204170655.GA20950@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204170655.GA20950@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 12:06:55PM -0500, David Teigland wrote:
> Please pull the following fix from branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git for-linus
> 
> This reverts commit 2b75bc9121e54e22537207b47b71373bcb0be41c.

Hi Linus,

You can choose to pull that revert, or you can alternatively pull this fix
to the original patch from this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git fix-max-write

Thanks to Jana who reported the problem and was able to test this fix so
quickly.

Subject: [PATCH] dlm: check the write size from user

Return EINVAL from write if the size is larger than
allowed.  Do this before allocating kernel memory for
the bogus size, which could lead to OOM.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Tested-by: Jana Saout <jana@saout.de>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/user.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 7ff4985..911649a 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -503,11 +503,11 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 #endif
 		return -EINVAL;
 
-#ifdef CONFIG_COMPAT
-	if (count > sizeof(struct dlm_write_request32) + DLM_RESNAME_MAXLEN)
-#else
+	/*
+	 * can't compare against COMPAT/dlm_write_request32 because
+	 * we don't yet know if is64bit is zero
+	 */
 	if (count > sizeof(struct dlm_write_request) + DLM_RESNAME_MAXLEN)
-#endif
 		return -EINVAL;
 
 	kbuf = kzalloc(count + 1, GFP_NOFS);
-- 
1.8.1.rc1.5.g7e0651a

