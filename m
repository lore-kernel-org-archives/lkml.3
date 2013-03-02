Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3CBNuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:50:20 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46431 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab3CBNuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:50:19 -0500
Date: Sat, 2 Mar 2013 14:50:15 +0100
From: Marcin Jurkowski <marcin1j@gmail.com>
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] w1: fix oops when w1_search is called from netlink
 connector
Message-ID: <20130302135015.GA21448@gmail.com>
References: <20130116141627.GA23638@ioremap.net>
 <20130302001103.GB18026@gmail.com>
 <20130302094510.GA4695@geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130302094510.GA4695@geggus.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/w1/w1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 7994d933..7e2220d 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -924,7 +924,8 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 			tmp64 = (triplet_ret >> 2);
 			rn |= (tmp64 << i);
 
-			if (kthread_should_stop()) {
+			/* ensure we're called from kthread and not by netlink callback */
+			if (!dev->priv && kthread_should_stop()) {
 				mutex_unlock(&dev->bus_mutex);
 				dev_dbg(&dev->dev, "Abort w1_search\n");
 				return;
-- 
1.7.12.4

