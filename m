Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbaCSDLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 23:11:05 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:46574 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbaCSDLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 23:11:01 -0400
Date: Tue, 18 Mar 2014 20:10:56 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, mcgrof@suse.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH 1/3] bridge: preserve random init MAC address
Message-ID: <20140318201056.7b876394@nehalam.linuxnetplumber.net>
In-Reply-To: <1394680527-28970-2-git-send-email-mcgrof@do-not-panic.com>
References: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com>
	<1394680527-28970-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 20:15:25 -0700
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:

> As it is now if you add create a bridge it gets started
> with a random MAC address and if you then add a net_device
> as a slave but later kick it out you end up with a zero
> MAC address. Instead preserve the original random MAC
> address and use it.

What is supposed to happen is that the recalculate chooses
the lowest MAC address of the slaves. If there are no slaves
it might as well just calculate a new random value. There is
not great merit in preserving the original defunct address.

Or something like this that just keeps the old value.
The bridge is in a meaningless state when there are no ports,
and when the first port is added back it will be used as the
new bridge id.

--- a/net/bridge/br_stp_if.c	2014-02-12 08:21:56.733857356 -0800
+++ b/net/bridge/br_stp_if.c	2014-03-18 20:09:09.334388826 -0700
@@ -235,6 +235,9 @@ bool br_stp_recalculate_bridge_id(struct
 			addr = p->dev->dev_addr;
 
 	}
+
+	if (addr == br_mac_zero)
+		return false;  /* keep original address */
 
 	if (ether_addr_equal(br->bridge_id.addr, addr))
 		return false;	/* no change */
