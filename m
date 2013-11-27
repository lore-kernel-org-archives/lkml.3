Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab3K0BYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:24:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717Ab3K0A7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>, Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 3.12 065/116] nfs: fix inverted test for delegation in nfs4_reclaim_open_state
Date: Tue, 26 Nov 2013 16:57:18 -0800
Message-Id: <20131127005741.439649855@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 1acd1c301f4faae80f4d2c7bbd9a4553b131c0e3 upstream.

commit 6686390bab6a0e0 (NFS: remove incorrect "Lock reclaim failed!"
warning.) added a test for a delegation before checking to see if any
reclaimed locks failed. The test however is backward and is only doing
that check when a delegation is held instead of when one isn't.

Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Fixes: 6686390bab6a: NFS: remove incorrect "Lock reclaim failed!" warning.
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1422,7 +1422,7 @@ restart:
 		if (status >= 0) {
 			status = nfs4_reclaim_locks(state, ops);
 			if (status >= 0) {
-				if (test_bit(NFS_DELEGATED_STATE, &state->flags) != 0) {
+				if (!test_bit(NFS_DELEGATED_STATE, &state->flags)) {
 					spin_lock(&state->state_lock);
 					list_for_each_entry(lock, &state->lock_states, ls_locks) {
 						if (!test_bit(NFS_LOCK_INITIALIZED, &lock->ls_flags))


