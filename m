Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653Ab3GZVXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:23:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819Ab3GZUxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:53:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Bob Picco <bob.picco@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 17/59] sparc: tsb must be flushed before tlb
Date: Fri, 26 Jul 2013 13:52:41 -0700
Message-Id: <20130726205015.660475851@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205013.795696531@linuxfoundation.org>
References: <20130726205013.795696531@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

This fixes a race where a cpu may re-load a tlb from a stale tsb right
after it has been flushed by a remote function call.

I still see some instability when stressing the system with parallel
kernel builds while creating memory pressure by writing to
/proc/sys/vm/nr_hugepages, but this patch improves the stability
significantly.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Bob Picco <bob.picco@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/tlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -115,8 +115,8 @@ no_cache_flush:
 	}
 
 	if (!tb->active) {
-		global_flush_tlb_page(mm, vaddr);
 		flush_tsb_user_page(mm, vaddr);
+		global_flush_tlb_page(mm, vaddr);
 		goto out;
 	}
 


