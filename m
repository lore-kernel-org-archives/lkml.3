Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaBQTgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:36:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50520 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbaBQTgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:36:09 -0500
Date: Mon, 17 Feb 2014 14:36:06 -0500 (EST)
Message-Id: <20140217.143606.1431722446347147819.davem@davemloft.net>
To: emilgoode@gmail.com
Cc: steve.glendinning@shawell.net, oneukum@suse.de, bjorn@mork.no,
        freddy@asix.com.tw, edumazet@google.com, ming.lei@canonical.com,
        paul.gortmaker@windriver.com, jeffrey.t.kirsher@intel.com,
        liujunliang_ljl@163.com, octavian.purdila@intel.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usbnet: remove generic hard_header_len check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392310219-5719-1-git-send-email-emilgoode@gmail.com>
References: <1392310219-5719-1-git-send-email-emilgoode@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2014 11:36:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emil Goode <emilgoode@gmail.com>
Date: Thu, 13 Feb 2014 17:50:19 +0100

> This patch removes a generic hard_header_len check from the usbnet
> module that is causing dropped packages under certain circumstances
> for devices that send rx packets that cross urb boundaries.
> 
> One example is the AX88772B which occasionally send rx packets that
> cross urb boundaries where the remaining partial packet is sent with
> no hardware header. When the buffer with a partial packet is of less
> number of octets than the value of hard_header_len the buffer is
> discarded by the usbnet module.
> 
> With AX88772B this can be reproduced by using ping with a packet
> size between 1965-1976.
> 
> The bug has been reported here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=29082
> 
> This patch introduces the following changes:
> - Removes the generic hard_header_len check in the rx_complete
>   function in the usbnet module.
> - Introduces a ETH_HLEN check for skbs that are not cloned from
>   within a rx_fixup callback.
> - For safety a hard_header_len check is added to each rx_fixup
>   callback function that could be affected by this change.
>   These extra checks could possibly be removed by someone
>   who has the hardware to test.
> - Removes a call to dev_kfree_skb_any() and instead utilizes the
>   dev->done list to queue skbs for cleanup.
> 
> The changes place full responsibility on the rx_fixup callback
> functions that clone skbs to only pass valid skbs to the
> usbnet_skb_return function.
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> Reported-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>

Applied and queued up for -stable, thanks.
