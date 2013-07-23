Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935234Ab3GWWjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:39:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934750Ab3GWW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 069/103] virtio_balloon: leak_balloon(): only tell host if we got pages deflated
Date: Tue, 23 Jul 2013 15:26:20 -0700
Message-Id: <20130723220427.037760581@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Capitulino <lcapitulino@redhat.com>

commit 8c6bab4f3874d31804a00782c48a8f244a0d3cc0 upstream.

balloon_page_dequeue() can return NULL.  If it does for the first page
being freed then leak_balloon() will create a scatter list with len=0.
Which in turn seems to generate an invalid virtio request.

I didn't get this in practice, I found it by code review.  On the other
hand, such an invalid virtio request will cause errors in QEMU and
fill_balloon() also performs the same check implemented by this commit.

This bug was introduced in e2250429.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio_balloon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -191,7 +191,8 @@ static void leak_balloon(struct virtio_b
 	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
 	 * is true, we *have* to do it in this order
 	 */
-	tell_host(vb, vb->deflate_vq);
+	if (vb->num_pfns != 0)
+		tell_host(vb, vb->deflate_vq);
 	mutex_unlock(&vb->balloon_lock);
 	release_pages_by_pfn(vb->pfns, vb->num_pfns);
 }


