Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaFXSCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:02:20 -0400
Received: from kanga.kvack.org ([205.233.56.17]:35070 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbaFXSCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:02:17 -0400
Date: Tue, 24 Jun 2014 14:02:17 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] aio: fix kernel memory disclosure in io_getevents() introduced in v3.10
Message-ID: <edfbbf388f293d70bf4b7c0bc38774d05e6f711a.1403632276.git.bcrl@kvack.org>
References: <cover.1403632276.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1403632276.git.bcrl@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org
---
 fs/aio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 6a9c7e4..955947e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1063,6 +1063,9 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	if (head == tail)
 		goto out;
 
+	head %= ctx->nr_events;
+	tail %= ctx->nr_events;
+
 	while (ret < nr) {
 		long avail;
 		struct io_event *ev;
-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
