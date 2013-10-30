Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3J3Ci0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:38:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52265 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3J3CiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:38:24 -0400
Date: Tue, 29 Oct 2013 22:38:23 -0400 (EDT)
Message-Id: <20131029.223823.1852248673779937090.davem@davemloft.net>
To: changbinx.du@intel.com
Cc: oliver@neukum.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/cdc_ncm: fix null pointer panic at
 usbnet_link_change
From: David Miller <davem@davemloft.net>
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A019F450F@SHSMSX103.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A019F450F@SHSMSX103.ccr.corp.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 29 Oct 2013 19:38:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Du, ChangbinX" <changbinx.du@intel.com>
Date: Tue, 29 Oct 2013 03:30:42 +0000

> In cdc_ncm_bind() function, it call cdc_ncm_bind_common() to setup usb.
> But cdc_ncm_bind_common() may meet error and cause usbnet_disconnect()
> be called which calls free_netdev(net). Thus usbnet structure(alloced
> with net_device structure) will be freed,too.
> So we cannot call usbnet_link_change() if cdc_ncm_bind_common() return
> error.

This is not the bug.

The problem is in cdc_ncm_bind_common().

It seems to leave dangling interface data pointers in some cases, and
then branches just to "error" so that they don't get cleared back out.

This bypasses the protection present in cdc_ncm_disconnect() meant to
avoid this problem.
