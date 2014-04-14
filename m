Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaDNHmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:42:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36392 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbaDNHmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:42:32 -0400
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
Date: Mon, 14 Apr 2014 00:42:09 -0700
In-Reply-To: <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 14 Apr 2014 00:38:47 -0700")
Message-ID: <87bnw4uzla.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/saHASO1ROiuc5QX8hTD5U+XMr/Kd+iic=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2900]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 4/4] vfs: Block intuitively in the case of BSD accounting files
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Have the mntput that started the BSD accounting files closing block
until the superblock has been succesfully freed.  This is what used to
happen until fput started calling mntput assynchronously, and is arguably
the right thing to do in the case of umount.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namespace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ac589ad9f22d..b10db3d69943 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1015,11 +1015,14 @@ static void mntput_no_expire(struct mount *mnt)
 		return;
 	}
 	if (unlikely(mnt->mnt_pinned)) {
+		init_completion(&undone);
+		mnt->mnt_undone = &undone;
 		mnt_add_count(mnt, mnt->mnt_pinned);
 		mnt->mnt_pinned = 0;
 		rcu_read_unlock();
 		unlock_mount_hash();
 		acct_auto_close_mnt(&mnt->mnt);
+		wait_for_completion(&undone);
 		return;
 	}
 	if (unlikely(mnt->mnt.mnt_flags & MNT_DOOMED)) {
@@ -1048,7 +1051,10 @@ static void mntput_no_expire(struct mount *mnt)
 	 * queue where the stack is guaranteed to be shallow.
 	 */
 	init_completion(&undone);
-	mnt->mnt_undone = &undone;
+	if (!mnt->mnt_undone)
+		mnt->mnt_undone = &undone;
+	else
+		complete(&undone);
 
 	INIT_WORK(&mnt->mnt_cleanup_work, cleanup_mnt_work);
 	schedule_work(&mnt->mnt_cleanup_work);
-- 
1.9.1

