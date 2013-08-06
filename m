Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3HFICt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:02:49 -0400
Received: from intranet.asianux.com ([58.214.24.6]:23046 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3HFICq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:02:46 -0400
X-Spam-Score: -100.8
Message-ID: <5200AD67.1030109@asianux.com>
Date: Tue, 06 Aug 2013 16:01:43 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, holt@sgi.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] kernel/sys.c: return the current gid when error occurs
References: <5200AD26.8070701@asianux.com>
In-Reply-To: <5200AD26.8070701@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the API definition, when error occurs, need return current
fsgid instead of the previous one.

The related informations ("man setfsgid"):

  RETURN VALUE
         On success, the previous value of fsgid is returned.  On error, the current value of fsgid is returned.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/sys.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 771129b..9356dc8 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -775,11 +775,11 @@ SYSCALL_DEFINE1(setfsgid, gid_t, gid)
 
 	kgid = make_kgid(old->user_ns, gid);
 	if (!gid_valid(kgid))
-		return old_fsgid;
+		return gid;
 
 	new = prepare_creds();
 	if (!new)
-		return old_fsgid;
+		return gid;
 
 	if (gid_eq(kgid, old->gid)  || gid_eq(kgid, old->egid)  ||
 	    gid_eq(kgid, old->sgid) || gid_eq(kgid, old->fsgid) ||
@@ -791,7 +791,7 @@ SYSCALL_DEFINE1(setfsgid, gid_t, gid)
 	}
 
 	abort_creds(new);
-	return old_fsgid;
+	return gid;
 
 change_okay:
 	commit_creds(new);
-- 
1.7.7.6
