Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaF1RxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:53:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaF1RxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Dietrich <marvin24@gmx.de>, Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: [PATCH 3.15 101/139] f2fs: submit bio at the reclaim path
Date: Sat, 28 Jun 2014 10:47:42 -0700
Message-Id: <20140628174610.022204457@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk.kim@samsung.com>

commit 2aea39eca6b68d6ae7eb545332df0695f56a3d3f upstream.

If f2fs_write_data_page is called through the reclaim path, we should submit
the bio right away.

This patch resolves the following issue that Marc Dietrich reported.
"It took me a while to bisect a problem which causes my ARM (tegra2) netbook to
frequently stall for 5-10 seconds when I enable EXA acceleration (opentegra
experimental ddx)."
And this patch fixes that.

Reported-by: Marc Dietrich <marvin24@gmx.de>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/data.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -835,6 +835,8 @@ out:
 	unlock_page(page);
 	if (need_balance_fs)
 		f2fs_balance_fs(sbi);
+	if (wbc->for_reclaim)
+		f2fs_submit_merged_bio(sbi, DATA, WRITE);
 	return 0;
 
 redirty_out:


