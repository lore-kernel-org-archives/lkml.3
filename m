Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaLWKsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:48:52 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61112 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbaLWKss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:48:48 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-7c-5499488fedcc
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        khilman@linaro.org
Subject: [PATCH v10 3/8] ARM: l2c: Add interface to ask hypervisor to configure
 L2C
Date: Tue, 23 Dec 2014 11:48:31 +0100
Message-id: <1419331716-8972-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xa7r9HjNDDK5NY7H4O+kYu8Wj+Y+Z
	LXoXXGWz+Hp4BaPF2aY37BbbO2ewW0z5s5zJYtPja6wWl3fNYbOYvaSfxWLG+X1MFrcv81qc
	276FxWLtkbvsFkuvX2SyePPjLJPFqeuf2SxW7frDaLH/ipeDsMeaeWsYPVqae9g8fv+axOjx
	7eskFo/Lfb1MHou+Z3nsnHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx/Eb25k8Pm+SC+CN4rJJ
	Sc3JLEst0rdL4MqYO7WdpeAxf8X07ROYGxj7eLsYOTkkBEwk2levYYWwxSQu3FvPBmILCSxl
	lLi0QriLkQvI7mOSaL8+hRkkwSZgKNH1tgusSETATeLfukNsIEXMAtNYJDYdOQ9WJCwQKvH9
	/Ur2LkYODhYBVYkVV0pBwrwC7hJnXzSwQCyTk/j/cgUTiM0p4CFxctFmJojF7hLbnh5kmcDI
	u4CRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSFR83cG49JjVIUYBDkYlHt6L32aECLEm
	lhVX5h5ilOBgVhLhfSk+M0SINyWxsiq1KD++qDQntfgQIxMHp1QD48E51YfmaXQ9DJ4a+vPC
	Xj2LhVffnNdgK9++ceYjHrXr72t8zR+wbEnY53LwmvLbErl3wsIvtrOKO3DXzSv9O1fo/sGQ
	grpvyetE7yb7Xj6csVbDnuGW3vR77oct7D71XOC+sJzjgt79O/OWOcY/3HiGsZPn26qyqqx7
	Kz+fefW179DCkIImoVQlluKMREMt5qLiRABs+3kfaAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Because certain secure hypervisor do not allow writes to individual L2C
registers, but rather expect set of parameters to be passed as argument
to secure monitor calls, there is a need to provide an interface for the
L2C driver to ask the firmware to configure the hardware according to
specified parameters. This patch adds such.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/include/asm/outercache.h | 3 +++
 arch/arm/mm/cache-l2x0.c          | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
index 891a56b35bcf..563b92fc2f41 100644
--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -23,6 +23,8 @@
 
 #include <linux/types.h>
 
+struct l2x0_regs;
+
 struct outer_cache_fns {
 	void (*inv_range)(unsigned long, unsigned long);
 	void (*clean_range)(unsigned long, unsigned long);
@@ -36,6 +38,7 @@ struct outer_cache_fns {
 
 	/* This is an ARM L2C thing */
 	void (*write_sec)(unsigned long, unsigned);
+	void (*configure)(const struct l2x0_regs *);
 };
 
 extern struct outer_cache_fns outer_cache;
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index e5948c5adaa7..d214be207517 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -110,6 +110,11 @@ static inline void l2c_unlock(void __iomem *base, unsigned num)
 
 static void l2c_configure(void __iomem *base)
 {
+	if (outer_cache.configure) {
+		outer_cache.configure(&l2x0_saved_regs);
+		return;
+	}
+
 	if (l2x0_data->configure)
 		l2x0_data->configure(base);
 
@@ -910,6 +915,7 @@ static int __init __l2c_init(const struct l2c_init_data *data,
 
 	fns = data->outer_cache;
 	fns.write_sec = outer_cache.write_sec;
+	fns.configure = outer_cache.configure;
 	if (data->fixup)
 		data->fixup(l2x0_base, cache_id, &fns);
 
-- 
1.9.2

