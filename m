Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3HBTdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:33:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891Ab3HBTdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:33:07 -0400
Date: Fri, 2 Aug 2013 21:27:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] exec: don't retry if request_module() fails
Message-ID: <20130802192741.GA9579@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802192713.GA9543@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A separate one-liner for better documentation.

It doesn't make sense to retry if request_module() fails to exec
/sbin/modprobe, add the addition "request_module() < 0" check.

However, this logic still doesn't look exactly right:

1. It would be better to check "request_module() != 0", the user
   space modprobe process should report the correct exit code.
   But I didn't dare to add the user-visible change.

2. The whole ENOEXEC logic looks suboptimal. Suppose that we try
   to exec a "#!path-to-unsupported-binary" script. In this case
   request_module() + "retry" will be done twice: first by the
   "depth == 1" code, and then again by the "depth == 0" caller
   which doesn't make sense.

3. And note that in the case above bprm->buf was already changed
   by load_script()->prepare_binprm(), so this looks even more
   ugly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 48344a2..d9fd32c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1418,7 +1418,8 @@ int search_binary_handler(struct linux_binprm *bprm)
 		if (printable(bprm->buf[0]) && printable(bprm->buf[1]) &&
 		    printable(bprm->buf[2]) && printable(bprm->buf[3]))
 			return retval;
-		request_module("binfmt-%04x", *(ushort *)(bprm->buf + 2));
+		if (request_module("binfmt-%04x", *(ushort *)(bprm->buf + 2)) < 0)
+			return retval;
 		need_retry = false;
 		goto retry;
 	}
-- 
1.5.5.1

