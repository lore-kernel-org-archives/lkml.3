Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaBYJh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:37:57 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:35210 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaBYJhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:37:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<874n3n7czm.fsf_-_@xmission.com>
Date: Tue, 25 Feb 2014 01:37:44 -0800
In-Reply-To: <874n3n7czm.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Tue, 25 Feb 2014 01:33:49 -0800")
Message-ID: <87bnxv5y8n.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/qAM5SiMHgjDSiMS8e54+UTNQX+EGWDGs=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.1 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0389]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 05/12] vfs: factor out lookup_mountpoint from new_mountpoint
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am shortly going to add a new user of struct mountpoint that
needs to look up existing entries but does not want to create
a struct mountpoint if one does not exist.  Therefore to keep
the code simple and easy to read split out lookup_mountpoint
from new_mountpoint.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namespace.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 32d380eabdac..f2f03082fe70 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -667,11 +667,10 @@ out:
 	return is_covered;
 }
 
-static struct mountpoint *new_mountpoint(struct dentry *dentry)
+static struct mountpoint *lookup_mountpoint(struct dentry *dentry)
 {
 	struct list_head *chain = mountpoint_hashtable + hash(NULL, dentry);
 	struct mountpoint *mp;
-	int ret;
 
 	list_for_each_entry(mp, chain, m_hash) {
 		if (mp->m_dentry == dentry) {
@@ -682,6 +681,14 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
 			return mp;
 		}
 	}
+	return NULL;
+}
+
+static struct mountpoint *new_mountpoint(struct dentry *dentry)
+{
+	struct list_head *chain = mountpoint_hashtable + hash(NULL, dentry);
+	struct mountpoint *mp;
+	int ret;
 
 	mp = kmalloc(sizeof(struct mountpoint), GFP_KERNEL);
 	if (!mp)
@@ -1702,7 +1709,9 @@ retry:
 	namespace_lock();
 	mnt = lookup_mnt(path);
 	if (likely(!mnt)) {
-		struct mountpoint *mp = new_mountpoint(dentry);
+		struct mountpoint *mp = lookup_mountpoint(dentry);
+		if (!mp)
+			mp = new_mountpoint(dentry);
 		if (IS_ERR(mp)) {
 			namespace_unlock();
 			mutex_unlock(&dentry->d_inode->i_mutex);
-- 
1.7.5.4

