Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaFEAMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:12:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaFDXWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianyu Zhan <nasa4836@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.14 162/228] percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()
Date: Wed,  4 Jun 2014 16:23:11 -0700
Message-Id: <20140604232353.219024219@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyu Zhan <nasa4836@gmail.com>

commit 5a838c3b60e3a36ade764cf7751b8f17d7c9c2da upstream.

pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
	BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long)

It hardly could be ever bigger than PAGE_SIZE even for large-scale machine,
but for consistency with its couterpart pcpu_mem_zalloc(),
use pcpu_mem_free() instead.

Commit b4916cb17c26 ("percpu: make pcpu_free_chunk() use
pcpu_mem_free() instead of kfree()") addressed this problem, but
missed this one.

tj: commit message updated

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 099a19d91ca4 ("percpu: allow limited allocation before slab is online)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -612,7 +612,7 @@ static struct pcpu_chunk *pcpu_alloc_chu
 	chunk->map = pcpu_mem_zalloc(PCPU_DFL_MAP_ALLOC *
 						sizeof(chunk->map[0]));
 	if (!chunk->map) {
-		kfree(chunk);
+		pcpu_mem_free(chunk, pcpu_chunk_struct_size);
 		return NULL;
 	}
 


