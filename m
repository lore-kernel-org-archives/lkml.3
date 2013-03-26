Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934744Ab3CZPVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:21:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53519 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934671Ab3CZPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcin Jurkowski <marcin1j@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 014/150] w1: fix oops when w1_search is called from netlink connector
Date: Tue, 26 Mar 2013 15:18:33 +0000
Message-Id: <1364311249-14454-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Jurkowski <marcin1j@gmail.com>

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
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/w1/w1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 2f2e894..2b48bd2 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -928,7 +928,8 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 			tmp64 = (triplet_ret >> 2);
 			rn |= (tmp64 << i);
 
-			if (kthread_should_stop()) {
+			/* ensure we're called from kthread and not by netlink callback */
+			if (!dev->priv && kthread_should_stop()) {
 				dev_dbg(&dev->dev, "Abort w1_search\n");
 				return;
 			}
-- 
1.8.1.2

