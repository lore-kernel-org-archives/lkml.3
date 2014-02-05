Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbaBEUl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:41:56 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48328 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbaBEUG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:28 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Marcin Jurkowski <marcin1j@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 121/213] w1: fix oops when w1_search is called from netlink connector
Date: Wed, 5 Feb 2014 15:01:16 -0500
Message-ID: <1391630568-49251-122-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Jurkowski <marcin1j@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9d1817cab2f030f6af360e961cc69bb1da8ad765 upstream.

On Sat, Mar 02, 2013 at 10:45:10AM +0100, Sven Geggus wrote:
> This is the bad commit I found doing git bisect:
> 04f482faf50535229a5a5c8d629cf963899f857c is the first bad commit
> commit 04f482faf50535229a5a5c8d629cf963899f857c
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Mon Mar 28 08:39:36 2011 +0000

Good job. I was too lazy to bisect for bad commit;)

Reading the code I found problematic kthread_should_stop call from netlink
connector which causes the oops. After applying a patch, I've been testing
owfs+w1 setup for nearly two days and it seems to work very reliable (no
hangs, no memleaks etc).
More detailed description and possible fix is given below:

Function w1_search can be called from either kthread or netlink callback.
While the former works fine, the latter causes oops due to kthread_should_stop
invocation.

This patch adds a check if w1_search is serving netlink command, skipping
kthread_should_stop invocation if so.

Signed-off-by: Marcin Jurkowski <marcin1j@gmail.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Josh Boyer <jwboyer@gmail.com>
Tested-by: Sven Geggus <lists@fuchsschwanzdomain.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/w1/w1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index ad5897dc4495..cf05f4c82baa 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -918,7 +918,8 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 			tmp64 = (triplet_ret >> 2);
 			rn |= (tmp64 << i);
 
-			if (kthread_should_stop()) {
+			/* ensure we're called from kthread and not by netlink callback */
+			if (!dev->priv && kthread_should_stop()) {
 				dev_dbg(&dev->dev, "Abort w1_search\n");
 				return;
 			}
-- 
1.8.5.2

