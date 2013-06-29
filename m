Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3F2B1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 21:27:19 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55293 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3F2B1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 21:27:18 -0400
Date: Fri, 28 Jun 2013 18:22:55 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] power_supply: Add of_node_put to fix refcount
Message-ID: <20130629012255.GA20924@lizard>
References: <1370899602-22123-1-git-send-email-rklein@nvidia.com>
 <1370899602-22123-2-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1370899602-22123-2-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 05:26:39PM -0400, Rhyland Klein wrote:
> of_parse_phandle increments the refcount for a dt node before returning
> it. Add of_node_put where needed to properly decrement the refcount
> when we are done using a given node.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---

With CONFIG_OF=n I got this:

  CC      drivers/power/sbs-battery.o
  drivers/power/sbs-battery.c: In function ‘sbs_probe’:
  drivers/power/sbs-battery.c:707:20: error: ‘struct power_supply’ has no
  member named ‘of_node’
  make[1]: *** [drivers/power/sbs-battery.o] Error 1

I fixed this by the patch below and applied your 1-3 series.

Thanks!

Anton

commit b50df95c8f0703c95625181d2eaf53855c5ebee5
Author: Anton Vorontsov <anton@enomsg.org>
Date:   Fri Jun 28 18:17:22 2013 -0700

    power_supply: Move of_node out of the #ifdef CONFIG_OF
    
    Similar to linux/device.h, move of_node struct member out of the #ifdef
    CONFIG_OF so that the drivers won't have to mess with #ifdefs in .c files.
    
    Signed-off-by: Anton Vorontsov <anton@enomsg.org>

diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 3828cef..804b906 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -162,6 +162,8 @@ union power_supply_propval {
 	const char *strval;
 };
 
+struct device_node;
+
 struct power_supply {
 	const char *name;
 	enum power_supply_type type;
@@ -173,9 +175,7 @@ struct power_supply {
 
 	char **supplied_from;
 	size_t num_supplies;
-#ifdef CONFIG_OF
 	struct device_node *of_node;
-#endif
 
 	int (*get_property)(struct power_supply *psy,
 			    enum power_supply_property psp,
