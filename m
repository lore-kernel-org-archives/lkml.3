Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbaGOWQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:16:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54258 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbaGOVex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:34:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin LaHaise <bcrl@kvack.org>, Mateusz Guzik <mguzik@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 185/198] aio: fix kernel memory disclosure in io_getevents() introduced in v3.10
Date: Tue, 15 Jul 2014 14:30:55 -0700
Message-Id: <1405459868-15089-186-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin LaHaise <bcrl@kvack.org>

commit edfbbf388f293d70bf4b7c0bc38774d05e6f711a upstream.

A kernel memory disclosure was introduced in aio_read_events_ring() in v3.10
by commit a31ad380bed817aa25f8830ad23e1a0480fef797.  The changes made to
aio_read_events_ring() failed to correctly limit the index into
ctx->ring_pages[], allowing an attacked to cause the subsequent kmap() of
an arbitrary page with a copy_to_user() to copy the contents into userspace.
This vulnerability has been assigned CVE-2014-0206.  Thanks to Mateusz and
Petr for disclosing this issue.

This patch applies to v3.12+.  A separate backport is needed for 3.10/3.11.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/aio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index e9566f2..19e7d95 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1049,6 +1049,9 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	if (head == tail)
 		goto out;
 
+	head %= ctx->nr_events;
+	tail %= ctx->nr_events;
+
 	while (ret < nr) {
 		long avail;
 		struct io_event *ev;
-- 
1.9.1

