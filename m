Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3FDXLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:11:11 -0400
Received: from 1wt.eu ([62.212.114.60]:35495 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab3FDWma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:30 -0400
Message-Id: <20130604172133.042602242@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Marcin Jurkowski <marcin1j@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
        Josh Boyer <jwboyer@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 066/184] w1: fix oops when w1_search is called from netlink
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 connector

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/w1/w1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index acc7e3b..74284bd 100644
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
1.7.12.2.21.g234cd45.dirty



