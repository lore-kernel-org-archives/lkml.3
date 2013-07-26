Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648Ab3GZVar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:30:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759952Ab3GZUsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [ 48/79] bcache: Fix a dumb race
Date: Fri, 26 Jul 2013 13:47:38 -0700
Message-Id: <20130726204727.540501940@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 6aa8f1a6ca41c49721d2de4e048d3da8d06411f9 upstream.

In the far-too-complicated closure code - closures can have destructors,
for probably dubious reasons; they get run after the closure is no
longer waiting on anything but before dropping the parent ref, intended
just for freeing whatever memory the closure is embedded in.

Trouble is, when remaining goes to 0 and we've got nothing more to run -
we also have to unlock the closure, setting remaining to -1. If there's
a destructor, that unlock isn't doing anything - nobody could be trying
to lock it if we're about to free it - but if the unlock _is needed...
that check for a destructor was racy. Argh.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/closure.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -66,16 +66,18 @@ static inline void closure_put_after_sub
 		} else {
 			struct closure *parent = cl->parent;
 			struct closure_waitlist *wait = closure_waitlist(cl);
+			closure_fn *destructor = cl->fn;
 
 			closure_debug_destroy(cl);
 
+			smp_mb();
 			atomic_set(&cl->remaining, -1);
 
 			if (wait)
 				closure_wake_up(wait);
 
-			if (cl->fn)
-				cl->fn(cl);
+			if (destructor)
+				destructor(cl);
 
 			if (parent)
 				closure_put(parent);


