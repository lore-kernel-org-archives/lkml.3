Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaJGXkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:40:46 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57325 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbaJGXkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:40:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Vagin <avagin@parallels.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
References: <1412683212-28077-1-git-send-email-avagin@openvz.org>
	<20141007132431.GF7996@ZenIV.linux.org.uk>
	<20141007134011.GA569@paralelels.com>
	<87vbnv3cl1.fsf_-_@x220.int.ebiederm.org>
	<20141007195307.GA23694@paralelels.com>
	<87iojvvbqe.fsf@x220.int.ebiederm.org>
	<20141007215959.GA4622@paralelels.com>
	<878ukrmp1t.fsf@x220.int.ebiederm.org>
Date: Tue, 07 Oct 2014 16:40:10 -0700
In-Reply-To: <878ukrmp1t.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 07 Oct 2014 16:35:10 -0700")
Message-ID: <87zjd7la91.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+CPiudOHHaY0MmC8aGeYffiZmoymfoAik=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4810]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Vagin <avagin@parallels.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 239 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 6 (2.7%), b_tie_ro: 4.0 (1.7%), parse: 0.97 (0.4%),
	extract_message_metadata: 15 (6.3%), get_uri_detail_list: 1.51 (0.6%),
	tests_pri_-1000: 6 (2.4%), tests_pri_-950: 1.31 (0.5%), tests_pri_-900: 1.10
	(0.5%), tests_pri_-400: 20 (8.4%), check_bayes: 19 (7.9%), b_tokenize: 4.9
	(2.0%), b_tok_get_all: 6 (2.4%), b_comp_prob: 1.58 (0.7%), b_tok_touch_all:
	3.8 (1.6%), b_finish: 0.80 (0.3%), tests_pri_0: 180 (75.5%), tests_pri_500: 5
	(2.1%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH] mnt: Move the clear of MNT_LOCKED from copy_tree to it's
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Clear MNT_LOCKED in the callers of copy_tree except copy_mnt_ns, and
collect_mounts.  In copy_mnt_nswe want an exact copy of a mount tree,
so not clearing MNT_LOCKED is important.  Similarly collect_mounts
is used to take a snapshot of the mount tree for audit logging purposes
and auditing using a faithful copy of the tree is important.

This becomes particularly significant when we start setting MNT_LOCKED
on rootfs to prevent it from being unmounted.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namespace.c | 1 -
 fs/pnode.c     | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 9c6ee037bef7..5a11e273541c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1498,7 +1498,6 @@ struct mount *copy_tree(struct mount *mnt, struct dentry *dentry,
 	if (IS_ERR(q))
 		return q;
 
-	q->mnt.mnt_flags &= ~MNT_LOCKED;
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
 
 	p = mnt;
diff --git a/fs/pnode.c b/fs/pnode.c
index aae331a5d03b..260ac8f898a4 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -242,6 +242,7 @@ static int propagate_one(struct mount *m)
 	child = copy_tree(last_source, last_source->mnt.mnt_root, type);
 	if (IS_ERR(child))
 		return PTR_ERR(child);
+	child->mnt.mnt_flags &= ~MNT_LOCKED;
 	mnt_set_mountpoint(m, mp, child);
 	last_dest = m;
 	last_source = child;
-- 
1.9.1

