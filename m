Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745Ab3D2TeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:34:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759563Ab3D2TCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 38/42] net: fix incorrect credentials passing
Date: Mon, 29 Apr 2013 12:02:20 -0700
Message-Id: <20130429184756.700158878@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 83f1b4ba917db5dc5a061a44b3403ddb6e783494 ]

Commit 257b5358b32f ("scm: Capture the full credentials of the scm
sender") changed the credentials passing code to pass in the effective
uid/gid instead of the real uid/gid.

Obviously this doesn't matter most of the time (since normally they are
the same), but it results in differences for suid binaries when the wrong
uid/gid ends up being used.

This just undoes that (presumably unintentional) part of the commit.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/scm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -56,8 +56,8 @@ static __inline__ void scm_set_cred(stru
 	scm->pid  = get_pid(pid);
 	scm->cred = cred ? get_cred(cred) : NULL;
 	scm->creds.pid = pid_vnr(pid);
-	scm->creds.uid = cred ? cred->euid : INVALID_UID;
-	scm->creds.gid = cred ? cred->egid : INVALID_GID;
+	scm->creds.uid = cred ? cred->uid : INVALID_UID;
+	scm->creds.gid = cred ? cred->gid : INVALID_GID;
 }
 
 static __inline__ void scm_destroy_cred(struct scm_cookie *scm)


