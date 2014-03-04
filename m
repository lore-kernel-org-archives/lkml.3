Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaCDPwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:52:33 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51547 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754596AbaCDPux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:50:53 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v5 1/3] Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
Date: Tue,  4 Mar 2014 15:50:14 +0000
Message-Id: <1393948216-11599-2-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393948216-11599-1-git-send-email-Liviu.Dudau@arm.com>
References: <1393948216-11599-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inline version of ioport_map() that gets used when !CONFIG_GENERIC_IOMAP
is wrong. It returns a mapped (i.e. virtual) address that can start from
zero and completely ignores the PCI_IOBASE and IO_SPACE_LIMIT that most
architectures that use !CONFIG_GENERIC_MAP define.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index d5afe96..df72051 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -331,7 +331,7 @@ static inline void iounmap(void __iomem *addr)
 #ifndef CONFIG_GENERIC_IOMAP
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
-	return (void __iomem *) port;
+	return (void __iomem *)(PCI_IOBASE + (port & IO_SPACE_LIMIT));
 }
 
 static inline void ioport_unmap(void __iomem *p)
-- 
1.9.0

