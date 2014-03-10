Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaCJUXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:23:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47151 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaCJUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:23:52 -0400
Date: Mon, 10 Mar 2014 16:23:49 -0400 (EDT)
Message-Id: <20140310.162349.2007153760780671206.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: ben@decadent.org.uk, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: fix uninitalized WOL parameters in
 phy_ethtool_get_wol
From: David Miller <davem@davemloft.net>
In-Reply-To: <531D98D1.4000707@gmail.com>
References: <1394413270-7169-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1394419893.15968.88.camel@deadeye.wl.decadent.org.uk>
	<531D98D1.4000707@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 13:23:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Mon, 10 Mar 2014 10:49:53 +0000

> void phy_ethtool_get_wol(struct phy_device *phydev, struct
> ethtool_wolinfo *wol)
> {
> 	memset(wol, 0, sizeof(*wol));
> 
> 	if (phydev && phydev->drv->get_wol)
> 		phydev->drv->get_wol(phydev, wol);
> }
> 
> That would also simplify above drivers down to e.g:
> 
> static void cpsw_get_wol(struct net_device *ndev, struct
> ethtool_wolinfo *wol)
> {
> 	struct cpsw_priv *priv = netdev_priv(ndev);
> 	int slave_no = cpsw_slave_index(priv);
> 	phy_ethtool_get_wol(priv->slaves[slave_no].phy, wol);
> }
> 
> instead of:
> 
> static void cpsw_get_wol(struct net_device *ndev, struct
> ethtool_wolinfo *wol)
> {
> 	struct cpsw_priv *priv = netdev_priv(ndev);
> 	int slave_no = cpsw_slave_index(priv);
> 
> 	wol->supported = 0;
> 	wol->wolopts = 0;
> 
> 	if (priv->slaves[slave_no].phy)
> 		phy_ethtool_get_wol(priv->slaves[slave_no].phy, wol);
> }

Agreed, since phy_ethtool_get_wol() is the common routine used by the drivers,
we should make it clear the structure.
