Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3HFIRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:17:01 -0400
Received: from intranet.asianux.com ([58.214.24.6]:19164 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3HFIRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:17:00 -0400
X-Spam-Score: -100.8
Message-ID: <5200B0BD.4080809@asianux.com>
Date: Tue, 06 Aug 2013 16:15:57 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, holt@sgi.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2]  kernel/sys.c: return the current uid when error occurs
References: <5200AD26.8070701@asianux.com> <5200B017.7030401@asianux.com> <5200B088.9040305@asianux.com>
In-Reply-To: <5200B088.9040305@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the API definition, when error occurs, need return current
fsuid instead of the previous one.

The related informations ("man setfsuid"):

  RETURN VALUE
         On success, the previous value of fsuid is returned.  On error, the current value of fsuid is returned.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/sys.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 771129b..558ccdb 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -736,11 +736,11 @@ SYSCALL_DEFINE1(setfsuid, uid_t, uid)
 
 	kuid = make_kuid(old->user_ns, uid);
 	if (!uid_valid(kuid))
-		return old_fsuid;
+		return uid;
 
 	new = prepare_creds();
 	if (!new)
-		return old_fsuid;
+		return uid;
 
 	if (uid_eq(kuid, old->uid)  || uid_eq(kuid, old->euid)  ||
 	    uid_eq(kuid, old->suid) || uid_eq(kuid, old->fsuid) ||
@@ -753,7 +753,7 @@ SYSCALL_DEFINE1(setfsuid, uid_t, uid)
 	}
 
 	abort_creds(new);
-	return old_fsuid;
+	return uid;
 
 change_okay:
 	commit_creds(new);
-- 
1.7.7.6
