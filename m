Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3ILR0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:26:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3ILR0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:26:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 01/19] htb: fix sign extension bug
Date: Thu, 12 Sep 2013 10:26:10 -0700
Message-Id: <20130912172524.329560363@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912172524.135620246@linuxfoundation.org>
References: <20130912172524.135620246@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

[ Upstream commit cbd375567f7e4811b1c721f75ec519828ac6583f ]

When userspace passes a large priority value
the assignment of the unsigned value hopt->prio
to  signed int cl->prio causes cl->prio to become negative and the
comparison is with TC_HTB_NUMPRIO is always false.

The result is that HTB crashes by referencing outside
the array when processing packets. With this patch the large value
wraps around like other values outside the normal range.

See: https://bugzilla.kernel.org/show_bug.cgi?id=60669

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_htb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -86,7 +86,7 @@ struct htb_class {
 	unsigned int children;
 	struct htb_class *parent;	/* parent class */
 
-	int prio;		/* these two are used only by leaves... */
+	u32 prio;		/* these two are used only by leaves... */
 	int quantum;		/* but stored for parent-to-leaf return */
 
 	union {


