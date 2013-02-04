Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab3BDUgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:36:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab3BDUga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:36:30 -0500
Date: Mon, 4 Feb 2013 15:36:25 -0500
From: David Teigland <teigland@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Revert "dlm: check the maximum size of a request from
 user"
Message-ID: <20130204203625.GB20950@redhat.com>
References: <20130204170655.GA20950@redhat.com>
 <CA+1xoqdDoKxU4L6u4XRXVMCSiMG174_y9kwoEO6i9rXS2AfUig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqdDoKxU4L6u4XRXVMCSiMG174_y9kwoEO6i9rXS2AfUig@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 03:19:44PM -0500, Sasha Levin wrote:
> Hi David,
> 
> This opens up a hole for userspace to force the kernel to allocate
> huge chunks of memory, triggering oom killing spree and such.
> 
> It should probably be fixed instead of just reverted.
> 
> I'll look into it.

Here is the patch I'm planning to put in the queue for the next
merge window, once it's been tested.

Subject: [PATCH] dlm: check the write size from user

Return EINVAL from write if the size is larger than
allowed.  Do this before allocating kernel memory for
the bogus size, which could lead to OOM.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/user.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index eb4ed9b..911649a 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -503,6 +503,13 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 #endif
 		return -EINVAL;
 
+	/*
+	 * can't compare against COMPAT/dlm_write_request32 because
+	 * we don't yet know if is64bit is zero
+	 */
+	if (count > sizeof(struct dlm_write_request) + DLM_RESNAME_MAXLEN)
+		return -EINVAL;
+
 	kbuf = kzalloc(count + 1, GFP_NOFS);
 	if (!kbuf)
 		return -ENOMEM;
-- 
1.8.1.rc1.5.g7e0651a

