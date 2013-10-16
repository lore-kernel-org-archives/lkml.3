Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523Ab3JPNvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:51:15 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60923 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934095Ab3JPNvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:51:09 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/5] pstore/ftrace: Don't increment initial data offset
Date: Wed, 16 Oct 2013 14:50:56 +0100
Message-Id: <1381931460-6999-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Delete the following expression,

	data->off = ps->size % REC_SIZE;

as it is not reasonable to expect users to allocate an exact multiple
of REC_SIZE because that constant isn't exported outside of
fs/pstore. There are already checks in the ftrace code to ensure that
no accesses happen beyond the bounds of the buffer, so there's no real
reason to skip the beginning of the data buffer.

It's likely this hasn't been caught before because this code mainly
runs under ARM where REC_SIZE is 8 bytes. On x86-64 REC_SIZE is 24
bytes and so it's more likely that ps->size isn't going to be a multiple.

Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 fs/pstore/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 71bf5f4..cc6ec0e 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -71,7 +71,6 @@ static void *pstore_ftrace_seq_start(struct seq_file *s, loff_t *pos)
 	if (!data)
 		return NULL;
 
-	data->off = ps->size % REC_SIZE;
 	data->off += *pos * REC_SIZE;
 	if (data->off + REC_SIZE > ps->size) {
 		kfree(data);
-- 
1.8.1.4

