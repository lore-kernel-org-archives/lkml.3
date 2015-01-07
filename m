Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbbAGDGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:06:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830AbbAGBvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:51:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.18 21/84] dcache: fix kmemcheck warning in switch_names
Date: Tue,  6 Jan 2015 17:49:24 -0800
Message-Id: <20150107014029.697054973@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 08d4f7722268755ee34ed1c9e8afee7dfff022bb upstream.

This patch fixes kmemcheck warning in switch_names. The function
switch_names swaps inline names of two dentries. It swaps full arrays
d_iname, no matter how many bytes are really used by the strings. Reading
data beyond string ends results in kmemcheck warning.

We fix the bug by marking both arrays as fully initialized.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2393,6 +2393,8 @@ static void swap_names(struct dentry *de
 			 */
 			unsigned int i;
 			BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
+			kmemcheck_mark_initialized(dentry->d_iname, DNAME_INLINE_LEN);
+			kmemcheck_mark_initialized(target->d_iname, DNAME_INLINE_LEN);
 			for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
 				swap(((long *) &dentry->d_iname)[i],
 				     ((long *) &target->d_iname)[i]);


