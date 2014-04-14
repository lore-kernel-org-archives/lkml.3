Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaDNHlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:41:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36073 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaDNHlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:41:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>, tytso@mit.edu
References: <87sipmbe8x.fsf@x220.int.ebiederm.org>
	<20140409175322.GZ18016@ZenIV.linux.org.uk>
	<20140409182830.GA18016@ZenIV.linux.org.uk>
	<87txa286fu.fsf@x220.int.ebiederm.org>
	<87fvlm860e.fsf_-_@x220.int.ebiederm.org>
	<20140409232423.GB18016@ZenIV.linux.org.uk>
	<87lhva5h4k.fsf@x220.int.ebiederm.org>
	<20140413053956.GM18016@ZenIV.linux.org.uk>
	<87zjjp3e7w.fsf@x220.int.ebiederm.org>
	<87ppkl1xb7.fsf@x220.int.ebiederm.org>
	<20140413215242.GP18016@ZenIV.linux.org.uk>
	<87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
Date: Mon, 14 Apr 2014 00:40:44 -0700
In-Reply-To: <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 14 Apr 2014 00:38:47 -0700")
Message-ID: <87mwfouznn.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX180awVdj7wDFg4ArSgZT3qY3WXvo8dm4hU=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4425]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 2/4] vfs: Move autoclose of BSD accounting into a work queue
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The autoclose of BSD accounting writes a record to the BSD accounting
file.  When mntput is called from moderaly deep within the stack the
(3KiB or so) generating I/O can be problemenatic as some I/O paths
require nearly 5KiB of stack on their own.

Avoid the possibility of stack overflow by moving the close of the BSD
accounting file into a work queue.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/acct.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 8d6e145138bb..1853dd4a1d01 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -93,6 +93,7 @@ struct bsd_acct_struct {
 
 static DEFINE_SPINLOCK(acct_lock);
 static LIST_HEAD(acct_list);
+static LIST_HEAD(acct_close_list);
 
 /*
  * Check the amount of free space and suspend/resume accordingly.
@@ -280,6 +281,20 @@ SYSCALL_DEFINE1(acct, const char __user *, name)
 	return error;
 }
 
+static void acct_close_mnts(struct work_struct *unused)
+{
+	struct bsd_acct_struct *acct;
+
+	spin_lock(&acct_lock);
+restart:
+	list_for_each_entry(acct, &acct_close_list, list) {
+		acct_file_reopen(acct, NULL, NULL);
+		goto restart;
+	}
+	spin_unlock(&acct_lock);
+}
+static DECLARE_WORK(acct_close_work, acct_close_mnts);
+
 /**
  * acct_auto_close - turn off a filesystem's accounting if it is on
  * @m: vfsmount being shut down
@@ -289,15 +304,15 @@ SYSCALL_DEFINE1(acct, const char __user *, name)
  */
 void acct_auto_close_mnt(struct vfsmount *m)
 {
-	struct bsd_acct_struct *acct;
+	struct bsd_acct_struct *acct, *tmp;
 
 	spin_lock(&acct_lock);
-restart:
-	list_for_each_entry(acct, &acct_list, list)
+	list_for_each_entry_safe(acct, tmp, &acct_list, list) {
 		if (acct->file && acct->file->f_path.mnt == m) {
-			acct_file_reopen(acct, NULL, NULL);
-			goto restart;
+			list_move_tail(&acct->list, &acct_close_list);
+			schedule_work(&acct_close_work);
 		}
+	}
 	spin_unlock(&acct_lock);
 }
 
-- 
1.9.1

