Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbaF1S74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:59:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbaF1Rsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 3.10 61/77] aio: fix kernel memory disclosure in io_getevents() introduced in v3.10
Date: Sat, 28 Jun 2014 10:46:54 -0700
Message-Id: <20140628174524.776028771@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -717,6 +717,8 @@ static long aio_read_events_ring(struct
 	if (head == ctx->tail)
 		goto out;
 
+	head %= ctx->nr_events;
+
 	while (ret < nr) {
 		long avail;
 		struct io_event *ev;


