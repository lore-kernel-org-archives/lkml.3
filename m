Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbaJDApl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:45:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbaJCVcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 3.16 036/357] aio: add missing smp_rmb() in read_events_ring
Date: Fri,  3 Oct 2014 14:27:02 -0700
Message-Id: <20141003212934.551081686@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1134,6 +1134,12 @@ static long aio_read_events_ring(struct
 	tail = ring->tail;
 	kunmap_atomic(ring);
 
+	/*
+	 * Ensure that once we've read the current tail pointer, that
+	 * we also see the events that were stored up to the tail.
+	 */
+	smp_rmb();
+
 	pr_debug("h%u t%u m%u\n", head, tail, ctx->nr_events);
 
 	if (head == tail)


