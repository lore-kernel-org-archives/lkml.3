Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab3HSIwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:52:03 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:12631 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922Ab3HSIwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:52:00 -0400
X-IronPort-AV: E=Sophos;i="4.89,912,1367964000"; 
   d="scan'208";a="29716856"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-mtd@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: [PATCH 0/6] simplify platform_get_resource_byname/devm_ioremap_resource
Date: Mon, 19 Aug 2013 10:51:50 +0200
Message-Id: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource often uses the result of a call to
platform_get_resource_byname as its last argument.  devm_ioremap_resource
does appropriate error handling on this argument, so error handling can be
removed from the call to platform_get_resource_byname.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,n,e,e1;
expression ret != 0;
identifier l,f;
expression list es;
@@

(
  res = f(...);
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  e = devm_ioremap_resource(e1, res);
|
- res = f(es);
  ... when != res
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  ... when != res
+ res = f(es);
  e = devm_ioremap_resource(e1, res);
)
// </smpl>

In practice, f is always platform_get_resource_byname (or
platform_get_resource, which was handled by a previous patch series).  And
the call to platform_get_resource_byname always immediately precedes the
call to devm_ioremap_resource.

