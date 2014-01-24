Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaAXNy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:54:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40119 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaAXNy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:54:27 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-6b-52e270924271
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andy Whitcroft <apw@canonical.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] x86: dma-mapping: fix GFP_ATOMIC macro usage
Date: Fri, 24 Jan 2014 14:53:10 +0100
Message-id: <1390571590-14410-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389948399-26344-1-git-send-email-m.szyprowski@samsung.com>
References: <1389948399-26344-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t9jQd1JBY+CDNa+57D4sFbDYtpGcYvL
	u+awWaw9cpfd4tKBBUwWCzY+YrTYvGkqs8WPDY9ZHTg8ZjX0snlsWtXJ5vHu3Dl2j/f7rrJ5
	9G1ZxejxeZOcx4mWL6wB7FFcNimpOZllqUX6dglcGb8/5hRc4qiY3vGZtYGxj72LkZNDQsBE
	YuuuH8wQtpjEhXvr2boYuTiEBKYzSvy+sY8Jwmllkvg6rZMVpIpNwFCi620XG4gtImAgsfTM
	JLAiZoGbjBI/9/WDFQkLOEjc2DcFzGYRUJVYsq2BEcTmFfCQ2DOvBaiBA2idgsScSTYgYU4B
	T4nZX36xgNhCQCXTDv5knsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcLg9k9rB
	uLLB4hCjAAejEg/vjMCHQUKsiWXFlbmHGCU4mJVEeLcGPAoS4k1JrKxKLcqPLyrNSS0+xCjN
	waIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwLghbcfih8tYfu/cdYAj5CXvv+MBVmHxk1zN
	bhyTYt+/2zT6+Q1JmddzFn3y+boiQKY+MWWDt35S5O9E3+y1ixKPv38cYzsliYExLnfv76gN
	h35Gn7ObqejAG8Bz6Wjxq26e2CdHpv3LXndQ7xz/VIvn+/eXbN55qavAlzVPxinJ9mlnyYEf
	GxSUWIozEg21mIuKEwGxL5KbMwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
flags, where meaningful is the LACK of __GFP_WAIT flag. To check if caller
wants to perform anatomic allocation, the code must test for a lack of the
__GFP_WAIT flag. This patch fixes the issue introduced in v3.5-rc1.

CC: stable@vger.kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/x86/kernel/pci-dma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 872079a..3519a78 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -100,8 +100,10 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 	flag |= __GFP_ZERO;
 again:
 	page = NULL;
-	if (!(flag & GFP_ATOMIC))
+	/* CMA can be used only in the context which allows sleeping */
+	if (flag & __GFP_WAIT)
 		page = dma_alloc_from_contiguous(dev, count, get_order(size));
+	/* fallback */
 	if (!page)
 		page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
 	if (!page)
-- 
1.7.9.5

