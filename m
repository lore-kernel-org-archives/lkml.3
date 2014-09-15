Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaIOQiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:38:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33675 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaIOQiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:38:01 -0400
Date: Mon, 15 Sep 2014 12:37:55 -0400 (EDT)
Message-Id: <20140915.123755.1868053059646672094.davem@davemloft.net>
To: santosh.shilimkar@ti.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org, sandeep_n@ti.com,
        jhs@mojatatu.com
Subject: Re: [PATCH v3 2/3] net: Add Keystone NetCP ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410638839-14792-3-git-send-email-santosh.shilimkar@ti.com>
References: <1410638839-14792-1-git-send-email-santosh.shilimkar@ti.com>
	<1410638839-14792-3-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Sep 2014 09:38:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Sat, 13 Sep 2014 16:07:18 -0400

> +	/* Find this module in the sub-tree for this device */
> +	devices = of_get_child_by_name(node, "netcp-devices");
> +	if (!devices) {
> +		dev_err(dev, "could not find netcp-devices node\n");
> +		return NETCP_MOD_PROBE_SKIPPED;
> +	}
> +
> +	for_each_available_child_of_node(devices, child) {
> +		const char *name = netcp_node_name(child);
> +
> +		if (!strcasecmp(module->name, name))
> +			break;
> +	}
> +
> +	/* If module not used for this device, skip it */
> +	if (child == NULL) {
> +		dev_warn(dev, "module(%s) not used for device\n", module->name);
> +		return NETCP_MOD_PROBE_SKIPPED;
> +	}

of_get_child_by_name() takes a reference to an OF node, you must release
it in the error path.

> +	inst_modpriv = devm_kzalloc(dev, sizeof(*inst_modpriv), GFP_KERNEL);
> +	if (!inst_modpriv) {
> +		dev_err(dev, "Failed to allocate instance for %s\n",
> +			module->name);
> +		return -ENOMEM;
> +	}

Likewise, but here you have to release both "devices" and "child".

You're going to have to fix this OF node refcount problem for this
entire probe routine.
