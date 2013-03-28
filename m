Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3C1Mj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:39:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54382 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3C1Mjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:39:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] clocksource: Fix build in non-OF case
Date: Thu, 28 Mar 2013 12:39:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Axel Lin <axel.lin@ingics.com>
References: <1364473805-773-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1364473805-773-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303281239.46639.arnd@arndb.de>
X-Provags-ID: V02:K0:nU/gI+SkWXKQ54UdF2SWHV8cELVnFQ6xcWdLp9ARn+L
 5lGtXHOsBdX8ZS0k0JIBN05bWvclmYMRl+nmFa6Dhf/kt4dabq
 rHecoaPAg+EqmMk5oBbUVuMdZ0PM2DTCBX/7tqIpxlyRc1otit
 WrQnlRp5K84viOpcqBIjcrZkPEWJNhnnTmty1kjdopufQPsevR
 6tb5Y5KcM31HHlQTSzq/rycIGk+wdK1dwURr3Xc2Rie1CkOi2j
 RfUa10szLfCSbUvppPgzOzejGAFQr88KF7s0pJxcWOkbecnZFD
 /c4ynRNzQfCB7/0I81Pxx7uP2mvLzAgTDrYPUIlTSzSVUuT4ye
 N6TIh/sioTasDW/YtSUM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 March 2013, Mark Brown wrote:
> Commit 4d10f054 (clocksource: make CLOCKSOURCE_OF_DECLARE type safe)
> made CLOCKSOURCE_OF_DECLARE reference the function pointer in both the
> OF and non-OF cases. In the non-OF case this is likely to introduce
> build failures as users may reasonably conditionally compile the OF
> specific code, either the macro ought to be used within CONFIG_OF and
> not have a !CONFIG_OF case or the macro ought not to reference its
> arguments in that case.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Hi Mark,

Axel Lin reported the same problem and I fixed the below code earlier
today by using the correct __attribute__((unused)) and dropping the
section magic for the non-OF case. My patch now looks contains the
change below. I also proposed a fix for the clocksource driver
at http://lkml.org/lkml/2013/3/26/103.

	Arnd

----
@@ -332,16 +332,23 @@ extern int clocksource_mmio_init(void __iomem *, const char *,
 
 extern int clocksource_i8253_init(void);
 
+struct device_node;
+typedef void(*clocksource_of_init_fn)(struct device_node *);
 #ifdef CONFIG_CLKSRC_OF
 extern void clocksource_of_init(void);
 
 #define CLOCKSOURCE_OF_DECLARE(name, compat, fn)                       \
        static const struct of_device_id __clksrc_of_table_##name       \
                __used __section(__clksrc_of_table)                     \
-                = { .compatible = compat, .data = fn };
+                = { .compatible = compat,                              \
+                    .data = (fn == (clocksource_of_init_fn)NULL) ? fn : fn }
 #else
 static inline void clocksource_of_init(void) {}
-#define CLOCKSOURCE_OF_DECLARE(name, compat, fn)
+#define CLOCKSOURCE_OF_DECLARE(name, compat, fn)                       \
+       static const struct of_device_id __clksrc_of_table_##name       \
+               __attribute__((unused))                                 \
+                = { .compatible = compat,                              \
+                    .data = (fn == (clocksource_of_init_fn)NULL) ? fn : fn }
 #endif
 
 #endif /* _LINUX_CLOCKSOURCE_H */
