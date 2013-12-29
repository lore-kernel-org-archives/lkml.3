Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3L2DBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:01:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54985 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959Ab3L2CJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steven Rostedt" <srostedt@redhat.com>,
        "Steven Rostedt" <rostedt@goodmis.org>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.249755651@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 181/185] ftrace: Fix ftrace hash record update with
 notrace
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit c842e975520f8ab09e293cc92f51a1f396251fd5 upstream.

When disabling the "notrace" records, that means we want to trace them.
If the notrace_hash is zero, it means that we want to trace all
records. But to disable a zero notrace_hash means nothing.

The check for the notrace_hash count was incorrect with:

	if (hash && !hash->count)
		return

With the correct comment above it that states that we do nothing
if the notrace_hash has zero count. But !hash also means that
the notrace hash has zero count. I think this was done to
protect against dereferencing NULL. But if !hash is true, then
we go through the following loop without doing a single thing.

Fix it to:

	if (!hash || !hash->count)
		return;

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1358,7 +1358,7 @@ static void __ftrace_hash_rec_update(str
 		 * If the notrace hash has no items,
 		 * then there's nothing to do.
 		 */
-		if (hash && !hash->count)
+		if (!hash || !hash->count)
 			return;
 	}
 

