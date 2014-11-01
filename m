Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaKAWlB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:41:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60344 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbaKAWjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Benjamin LaHaise" <bcrl@kvack.org>,
        "Jeff Moyer" <jmoyer@redhat.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.758645106@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 022/102] aio: add missing smp_rmb() in read_events_ring
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Moyer <jmoyer@redhat.com>

commit 2ff396be602f10b5eab8e73b24f20348fa2de159 upstream.

We ran into a case on ppc64 running mariadb where io_getevents would
return zeroed out I/O events.  After adding instrumentation, it became
clear that there was some missing synchronization between reading the
tail pointer and the events themselves.  This small patch fixes the
problem in testing.

Thanks to Zach for helping to look into this, and suggesting the fix.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/aio.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1102,6 +1102,13 @@ static int aio_read_evt(struct kioctx *i
 	head = ring->head % info->nr;
 	if (head != ring->tail) {
 		struct io_event *evp = aio_ring_event(info, head, KM_USER1);
+
+		/*
+		 * Ensure that once we've read the current tail pointer, that
+		 * we also see the events that were stored up to the tail.
+		 */
+		smp_rmb();
+
 		*ent = *evp;
 		head = (head + 1) % info->nr;
 		smp_mb(); /* finish reading the event before updatng the head */

