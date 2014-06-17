Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965973AbaFQVrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:47:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53874 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945AbaFQVrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 053/212] net: filter: s390: fix JIT address randomization
Date: Tue, 17 Jun 2014 14:42:27 -0700
Message-Id: <1403041506-13646-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[ Upstream commit e84d2f8d2ae33c8215429824e1ecf24cbca9645e ]

This is the s390 variant of Alexei's JIT bug fix.
(patch description below stolen from Alexei's patch)

bpf_alloc_binary() adds 128 bytes of room to JITed program image
and rounds it up to the nearest page size. If image size is close
to page size (like 4000), it is rounded to two pages:
round_up(4000 + 4 + 128) == 8192
then 'hole' is computed as 8192 - (4000 + 4) = 4188
If prandom_u32() % hole selects a number >= PAGE_SIZE - sizeof(*header)
then kernel will crash during bpf_jit_free():

kernel BUG at arch/x86/mm/pageattr.c:887!
Call Trace:
 [<ffffffff81037285>] change_page_attr_set_clr+0x135/0x460
 [<ffffffff81694cc0>] ? _raw_spin_unlock_irq+0x30/0x50
 [<ffffffff810378ff>] set_memory_rw+0x2f/0x40
 [<ffffffffa01a0d8d>] bpf_jit_free_deferred+0x2d/0x60
 [<ffffffff8106bf98>] process_one_work+0x1d8/0x6a0
 [<ffffffff8106bf38>] ? process_one_work+0x178/0x6a0
 [<ffffffff8106c90c>] worker_thread+0x11c/0x370

since bpf_jit_free() does:
  unsigned long addr = (unsigned long)fp->bpf_func & PAGE_MASK;
  struct bpf_binary_header *header = (void *)addr;
to compute start address of 'bpf_binary_header'
and header->pages will pass junk to:
  set_memory_rw(addr, header->pages);

Fix it by making sure that &header->image[prandom_u32() % hole] and &header
are in the same page.

Fixes: aa2d2c73c21f2 ("s390/bpf,jit: address randomize and write protect jit code")

Reported-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index a778ee2..8e08c67 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -811,7 +811,7 @@ static struct bpf_binary_header *bpf_alloc_binary(unsigned int bpfsize,
 		return NULL;
 	memset(header, 0, sz);
 	header->pages = sz / PAGE_SIZE;
-	hole = sz - (bpfsize + sizeof(*header));
+	hole = min(sz - (bpfsize + sizeof(*header)), PAGE_SIZE - sizeof(*header));
 	/* Insert random number of illegal instructions before BPF code
 	 * and make sure the first instruction starts at an even address.
 	 */
-- 
1.9.1

