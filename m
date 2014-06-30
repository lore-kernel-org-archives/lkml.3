Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaF3NhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:37:17 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5605 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaF3NhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:37:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 30 Jun 2014 06:30:48 -0700
Date: Mon, 30 Jun 2014 16:37:12 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Sachin Kamat <sachin.kamat@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "spk.linux@gmail.com" <spk.linux@gmail.com>
Subject: Re: [PATCH 1/1] clk: Fix build warnings
Message-ID: <20140630133712.GU3679@tbergstrom-lnx.Nvidia.com>
References: <1404121254-23823-1-git-send-email-sachin.kamat@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1404121254-23823-1-git-send-email-sachin.kamat@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 11:40:54AM +0200, Sachin Kamat wrote:
> ‘all_lists’ and ‘orphan_list’ is accessed only when DEBUG_FS is defined.
> Thus, make their compilation conditional to fix the below warnings introduced
> by commit 27b8d5f723 ("clk: flatten clk tree in debugfs"):
> drivers/clk/clk.c:40:27: warning: ‘all_lists’ defined but not used [-Wunused-variable]
> drivers/clk/clk.c:46:27: warning: ‘orphan_list’ defined but not used [-Wunused-variable]
> 

Maybe just move them inside the existing #ifdef CONFIG_DEBUG_FS / #endif?

Like:

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 7dfb2f3..3b735de 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -36,17 +36,6 @@ static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
 
-static struct hlist_head *all_lists[] = {
-	&clk_root_list,
-	&clk_orphan_list,
-	NULL,
-};
-
-static struct hlist_head *orphan_list[] = {
-	&clk_orphan_list,
-	NULL,
-};
-
 /***           locking             ***/
 static void clk_prepare_lock(void)
 {
@@ -108,6 +97,17 @@ static void clk_enable_unlock(unsigned long flags)
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 
+static struct hlist_head *all_lists[] = {
+	&clk_root_list,
+	&clk_orphan_list,
+	NULL,
+};
+
+static struct hlist_head *orphan_list[] = {
+	&clk_orphan_list,
+	NULL,
+};
+
 static struct dentry *rootdir;
 static int inited = 0;
 
Thanks for finding this.

Cheers,

Peter.
