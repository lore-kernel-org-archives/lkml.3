Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab3CREbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33522 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab3CREab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:31 -0400
Message-Id: <20130318042150.324816467@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:47 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Marcin Jurkowski <marcin1j@gmail.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, Josh Boyer <jwboyer@gmail.com>,
        Sven Geggus <lists@fuchsschwanzdomain.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 63/82] w1: fix oops when w1_search is called from netlink connector
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/w1/w1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -918,7 +918,8 @@ void w1_search(struct w1_master *dev, u8
 			tmp64 = (triplet_ret >> 2);
 			rn |= (tmp64 << i);
 
-			if (kthread_should_stop()) {
+			/* ensure we're called from kthread and not by netlink callback */
+			if (!dev->priv && kthread_should_stop()) {
 				dev_dbg(&dev->dev, "Abort w1_search\n");
 				return;
 			}


