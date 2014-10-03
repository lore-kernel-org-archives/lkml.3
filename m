Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbaJCWC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:02:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbaJCVxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.16 260/357] percpu: perform tlb flush after pcpu_map_pages() failure
Date: Fri,  3 Oct 2014 14:30:46 -0700
Message-Id: <20141003212941.312620018@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

commit 849f5169097e1ba35b90ac9df76b5bb6f9c0aabd upstream.

If pcpu_map_pages() fails midway, it unmaps the already mapped pages.
Currently, it doesn't flush tlb after the partial unmapping.  This may
be okay in most cases as the established mapping hasn't been used at
that point but it can go wrong and when it goes wrong it'd be
extremely difficult to track down.

Flush tlb after the partial unmapping.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/percpu-vm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -272,6 +272,7 @@ err:
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
 				   page_end - page_start);
 	}
+	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;
 }
 


