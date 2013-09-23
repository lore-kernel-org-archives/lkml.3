Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3IWVnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:43:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40771 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab3IWVnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:43:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        James Hogan <james.hogan@imgtec.com>
References: <878uzmhkqg.fsf@xmission.com> <874naahkng.fsf@xmission.com>
	<524018EA.9070202@imgtec.com>
Date: Mon, 23 Sep 2013 14:41:17 -0700
In-Reply-To: <524018EA.9070202@imgtec.com> (James Hogan's message of "Mon, 23
	Sep 2013 11:33:14 +0100")
Message-ID: <87ioxrrzb6.fsf_-_@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+PvmxKWjSZom8l5drB3Y6wMMq+/FLf/hw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH] sysfs: Allow mounting without CONFIG_NET
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In kobj_ns_current_may_mount the default should be to allow the
mount.  The test is only for a single kobj_ns_type at a time, and unless
there is a reason to prevent it the mounting sysfs should be allowed.
Subsystems that are not registered can't have are not involved so can't
have a reason to prevent mounting sysfs.

This is a bug-fix to:
    commit 7dc5dbc879bd0779924b5132a48b731a0bc04a1e
    Author: Eric W. Biederman <ebiederm@xmission.com>
    Date:   Mon Mar 25 20:07:01 2013 -0700
    
        sysfs: Restrict mounting sysfs
        
        Don't allow mounting sysfs unless the caller has CAP_SYS_ADMIN rights
        over the net namespace.  The principle here is if you create or have
        capabilities over it you can mount it, otherwise you get to live with
        what other people have mounted.
        
        Instead of testing this with a straight forward ns_capable call,
        perform this check the long and torturous way with kobject helpers,
        this keeps direct knowledge of namespaces out of sysfs, and preserves
        the existing sysfs abstractions.
        
        Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
        Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

That came in via the userns tree during the 3.12 merge window.
    
Reported-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

 lib/kobject.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 9621751..669bf19 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -933,10 +933,7 @@ const struct kobj_ns_type_operations *kobj_ns_ops(struct kobject *kobj)
 
 bool kobj_ns_current_may_mount(enum kobj_ns_type type)
 {
-	bool may_mount = false;
-
-	if (type == KOBJ_NS_TYPE_NONE)
-		return true;
+	bool may_mount = true;
 
 	spin_lock(&kobj_ns_type_lock);
 	if ((type > KOBJ_NS_TYPE_NONE) && (type < KOBJ_NS_TYPES) &&
-- 
1.7.10.4

