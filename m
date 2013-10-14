Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3JNSqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:46:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064Ab3JNSqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:46:31 -0400
Message-ID: <525C3C03.3080400@canonical.com>
Date: Mon, 14 Oct 2013 11:46:27 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>
CC: SECURITY SUBSYSTEM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] apparmor: fix bad lock balance when introspecting policy
References: <525906EE.90409@canonical.com> <alpine.LRH.2.02.1310150220160.6053@tundra.namei.org> <525C39E2.4030507@canonical.com>
In-Reply-To: <525C39E2.4030507@canonical.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1235977

The profile introspection seq file has a locking bug when policy is viewed
from a virtual root (task in a policy namespace), introspection from the
real root is not affected.

The test for root
    while (parent) {
is correct for the real root, but incorrect for tasks in a policy namespace.
This allows the task to walk backup the policy tree past its virtual root
causing it to be unlocked before the virtual root should be in the p_stop
fn.

This results in the following lockdep back trace:
[   78.479744] [ BUG: bad unlock balance detected! ]
[   78.479792] 3.11.0-11-generic #17 Not tainted
[   78.479838] -------------------------------------
[   78.479885] grep/2223 is trying to release lock (&ns->lock) at:
[   78.479952] [<ffffffff817bf3be>] mutex_unlock+0xe/0x10
[   78.480002] but there are no more locks to release!
[   78.480037]
[   78.480037] other info that might help us debug this:
[   78.480037] 1 lock held by grep/2223:
[   78.480037]  #0:  (&p->lock){+.+.+.}, at: [<ffffffff812111bd>] seq_read+0x3d/0x3d0
[   78.480037]
[   78.480037] stack backtrace:
[   78.480037] CPU: 0 PID: 2223 Comm: grep Not tainted 3.11.0-11-generic #17
[   78.480037] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   78.480037]  ffffffff817bf3be ffff880007763d60 ffffffff817b97ef ffff8800189d2190
[   78.480037]  ffff880007763d88 ffffffff810e1c6e ffff88001f044730 ffff8800189d2190
[   78.480037]  ffffffff817bf3be ffff880007763e00 ffffffff810e5bd6 0000000724fe56b7
[   78.480037] Call Trace:
[   78.480037]  [<ffffffff817bf3be>] ? mutex_unlock+0xe/0x10
[   78.480037]  [<ffffffff817b97ef>] dump_stack+0x54/0x74
[   78.480037]  [<ffffffff810e1c6e>] print_unlock_imbalance_bug+0xee/0x100
[   78.480037]  [<ffffffff817bf3be>] ? mutex_unlock+0xe/0x10
[   78.480037]  [<ffffffff810e5bd6>] lock_release_non_nested+0x226/0x300
[   78.480037]  [<ffffffff817bf2fe>] ? __mutex_unlock_slowpath+0xce/0x180
[   78.480037]  [<ffffffff817bf3be>] ? mutex_unlock+0xe/0x10
[   78.480037]  [<ffffffff810e5d5c>] lock_release+0xac/0x310
[   78.480037]  [<ffffffff817bf2b3>] __mutex_unlock_slowpath+0x83/0x180
[   78.480037]  [<ffffffff817bf3be>] mutex_unlock+0xe/0x10
[   78.480037]  [<ffffffff81376c91>] p_stop+0x51/0x90
[   78.480037]  [<ffffffff81211408>] seq_read+0x288/0x3d0
[   78.480037]  [<ffffffff811e9d9e>] vfs_read+0x9e/0x170
[   78.480037]  [<ffffffff811ea8cc>] SyS_read+0x4c/0xa0
[   78.480037]  [<ffffffff817ccc9d>] system_call_fastpath+0x1a/0x1f

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/apparmorfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 95c2b26..7db9954 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -580,15 +580,13 @@ static struct aa_namespace *__next_namespace(struct aa_namespace *root,
 
 	/* check if the next ns is a sibling, parent, gp, .. */
 	parent = ns->parent;
-	while (parent) {
+	while (ns != root) {
 		mutex_unlock(&ns->lock);
 		next = list_entry_next(ns, base.list);
 		if (!list_entry_is_head(next, &parent->sub_ns, base.list)) {
 			mutex_lock(&next->lock);
 			return next;
 		}
-		if (parent == root)
-			return NULL;
 		ns = parent;
 		parent = parent->parent;
 	}
-- 
1.8.3.2

