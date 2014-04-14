Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaDNHki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:40:38 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:55105 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaDNHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:40:28 -0400
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
Date: Mon, 14 Apr 2014 00:40:03 -0700
In-Reply-To: <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 14 Apr 2014 00:38:47 -0700")
Message-ID: <87sipguzos.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/2q90DK/WvHvuDpFJiiFzggVAOeJdPst0=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4919]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 1/4] vfs: Remove useless loop in mntput_no_expire
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the extra reference added to mnt_count by the mnt_pinned code,
and stop jumping to the top of mntput_no_expire.

When fput synchronously called mntput that extra reference count and
the loop ensured that after acct_auto_close_mnt closed all of the
pinned references mntput_no_expire would then proceed actually
unmount the filesystem.

As fput is asynchronous today there is no point in looping.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namespace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 9d0eb6b4e7d5..2abd5a2416d0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -985,7 +985,6 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 
 static void mntput_no_expire(struct mount *mnt)
 {
-put_again:
 	rcu_read_lock();
 	mnt_add_count(mnt, -1);
 	if (likely(mnt->mnt_ns)) { /* shouldn't be the last one */
@@ -999,12 +998,12 @@ put_again:
 		return;
 	}
 	if (unlikely(mnt->mnt_pinned)) {
-		mnt_add_count(mnt, mnt->mnt_pinned + 1);
+		mnt_add_count(mnt, mnt->mnt_pinned);
 		mnt->mnt_pinned = 0;
 		rcu_read_unlock();
 		unlock_mount_hash();
 		acct_auto_close_mnt(&mnt->mnt);
-		goto put_again;
+		return;
 	}
 	if (unlikely(mnt->mnt.mnt_flags & MNT_DOOMED)) {
 		rcu_read_unlock();
-- 
1.9.1

