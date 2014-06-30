Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbaF3Mrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:47:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361AbaF3Mao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 161/181] aio: fix kernel memory disclosure in io_getevents() introduced in v3.10
Date: Mon, 30 Jun 2014 13:53:02 +0200
Message-Id: <d1360ea460be9cda7eafcfec67fd0b8f77dc191c.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin LaHaise <bcrl@kvack.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/aio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index e609e15f36b9..0abde33de70e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1066,6 +1066,9 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	head %= ctx->nr_events;
 	tail %= ctx->nr_events;
 
+	head %= ctx->nr_events;
+	tail %= ctx->nr_events;
+
 	while (ret < nr) {
 		long avail;
 		struct io_event *ev;
-- 
2.0.0

