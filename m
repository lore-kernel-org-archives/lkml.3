Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539Ab3HNJSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:18:54 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:4384 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759633Ab3HNJLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:42 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908309"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: dri-devel@lists.freedesktop.org
Cc: kernel-janitors@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-media@vger.kernel.org,
        linux-input@vger.kernel.org, linux-tegra@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-pwm@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 0/29] simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:04 +0200
Message-Id: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource often uses the result of a call to
platform_get_resource as its last argument.  devm_ioremap_resource does
appropriate error handling on this argument, so error handling can be
removed from the call site.  To make the connection between the call to
platform_get_resource and the call to devm_ioremap_resource more clear, the
former is also moved down to be adjacent to the latter.

In many cases, this patch changes the specific error value that is
returned on failure of platform_get_resource.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,n,e,e1;
expression ret != 0;
identifier l;
@@

(
  res = platform_get_resource(pdev, IORESOURCE_MEM, n);
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  e = devm_ioremap_resource(e1, res);
|
- res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  ... when != res
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  ... when != res
+ res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  e = devm_ioremap_resource(e1, res);
)
// </smpl>

