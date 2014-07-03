Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030644AbaGCJZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:25:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52695 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030595AbaGCJZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin LaHaise <bcrl@kvack.org>, Mateusz Guzik <mguzik@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 195/198] aio: fix kernel memory disclosure in io_getevents() introduced in v3.10
Date: Thu,  3 Jul 2014 10:20:38 +0100
Message-Id: <1404379241-8590-196-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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

[jmoyer@redhat.com: backported to 3.10]
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/aio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 48f02745b876..618021906aa9 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -719,6 +719,8 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	if (head == ctx->tail)
 		goto out;
 
+	head %= ctx->nr_events;
+
 	while (ret < nr) {
 		long avail;
 		struct io_event *ev;
-- 
1.9.1

