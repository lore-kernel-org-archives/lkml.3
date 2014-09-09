Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbaIIQKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:10:47 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:22360 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaIIQKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:10:45 -0400
X-AuditID: cbfec373-b7f9d6d00000479f-f5-540f26838460
Date: Tue, 09 Sep 2014 13:10:36 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCHv2 2/3] [media] s5p-jpeg: Fix compilation with COMPILE_TEST
Message-id: <20140909131036.7265121f.m.chehab@samsung.com>
In-reply-to: <540F1D11.9030400@samsung.com>
References: <20140909124306.2d5a0d76@canb.auug.org.au>
 <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <b7343e6296b5d1d68b7229b8307442fd4141bcb3.1410273306.git.m.chehab@samsung.com>
 <540F15B2.3000902@samsung.com> <20140909120936.527bd852.m.chehab@samsung.com>
 <540F1D11.9030400@samsung.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/hYN1mNf4Qg6/LDCx6rz5ntPjx+gKb
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFj0btrJaHFzYxmgx4/w+JosdpxYxWxx+085qsXXvVXYH
	Ho/GGzfYPDav0PLYvKTeo2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDL6N6xjK3jDXnHzzC+2
	Bsa3bF2MHBwSAiYSv79qdjFyApliEhfurQcKc3EICSxhlOg4/p4Rwmlmkvi5/y4rSBWLgKrE
	911fmEFsNgEjiVeNLWBxEQF9iSWrLoJ1MwscYZa4cmUbG0hCWMBL4vuLs+wg23gFrCRWz/EC
	MTkFtCXOLleHmH+SSWLPxXuMEFc4S/ycOQnM5hUQlPgx+R4LiM0soCWxeVsTK4QtL7F5zVvm
	CYwCs5CUzUJSNgtJ2QJG5lWMoqXFyQXFSem5RnrFibnFpXnpesn5uZsYITFRvIPxxQarQ4wC
	HIxKPLwnYvhChFgTy4orcw8xSnAwK4nwWr8ACvGmJFZWpRblxxeV5qQWH2Jk4uCUamCcxZfc
	tczqT8urzyL8B7v5/FflthpePjUnsWT/Uv8j3xrf9hvNZ59w3uk286kgpeYrvufjBNIUWZco
	5nAeUQhImLEramdIyKGi4lrV1KQPzRXuDAc979zZUblV8dKrdKULNnN5WpfXdl9uveT4z1V0
	xuYv3rLTr92f8ryZpVX9yPWsdw9WJqsosRRnJBpqMRcVJwIATrx2XGcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "__bad_ndelay" [drivers/media/platform/s5p-jpeg/s5p-jpeg.ko] undefined!

That happens because asm-generic doesn't like any ndelay time
bigger than 20us.

Currently, usleep_range() couldn't simply be used, since
exynos4_jpeg_sw_reset() is called with a spinlock held.

So, let's use ndelay() instead.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index e51c078360f5..ab6d6f43c96f 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -23,7 +23,7 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
 	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
 	writel(reg & ~EXYNOS4_SOFT_RESET_HI, base + EXYNOS4_JPEG_CNTL_REG);
 
-	ndelay(100000);
+	udelay(100);
 
 	writel(reg | EXYNOS4_SOFT_RESET_HI, base + EXYNOS4_JPEG_CNTL_REG);
 }
