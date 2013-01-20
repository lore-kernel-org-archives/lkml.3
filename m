Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3ATWOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 17:14:46 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:49804 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3ATWOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 17:14:45 -0500
Date: Sun, 20 Jan 2013 23:14:43 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-pcmcia@lists.infradead.org, Eric Miao <eric.y.miao@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, trivial@kernel.org
Subject: [PATCH][trivial] pcmcia: avoid static analysis complaint about
 use-after-free
Message-ID: <alpine.LNX.2.00.1301202312420.8225@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity complains about a use after free for 'res1' and 'res2' since
we use the value of the pointers in a 'dev_dbg()' after they have been
freed. That's not really a problem, but it still seems cleaner to
defer freeing until we are completely done with the pointers.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/pcmcia/rsrc_nonstatic.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 430a9ac..065704c 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -369,12 +369,12 @@ static int do_validate_mem(struct pcmcia_socket *s,
 		}
 	}
 
-	free_region(res2);
-	free_region(res1);
-
 	dev_dbg(&s->dev, "cs: memory probe 0x%06lx-0x%06lx: %p %p %u %u %u",
 		base, base+size-1, res1, res2, ret, info1, info2);
 
+	free_region(res2);
+	free_region(res1);
+
 	if ((ret) || (info1 != info2) || (info1 == 0))
 		return -EINVAL;
 
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

