Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaJFTo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:44:29 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:38895 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaJFTo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:44:26 -0400
Date: Mon, 6 Oct 2014 21:44:18 +0200
From: Rabin Vincent <rabin@rab.in>
To: Oussama Ghorbel <ghorbel@pivasoftware.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux-kernel@vger.kernel.org,
        rogerq@ti.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
Message-ID: <20141006194418.GA399@debian>
References: <1411575303-18858-1-git-send-email-ghorbel@pivasoftware.com>
 <5425677B.9030700@pivasoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5425677B.9030700@pivasoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 02:17:47PM +0100, Oussama Ghorbel wrote:
> You may find merge conflict since v3.17-rc5.
> If necessary I can send a re-based version of this patch on v3.17-rc5 for
> seamless integration.

Looks like pandaboard USB is still broken on v3.17 due to this bug.
Please do send an updated patch based on latest mainline so that Kishon
can apply it easily when he gets around to it.

> On 09/24/2014 05:15 PM, Oussama Ghorbel wrote:
> >The USB OTG port does not work since v3.16 on omap platform.
> >This is a regression introduced by the commit
> >eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
> >  and remove).
> >This because the call to pm_runtime_enable() function is moved after the
> >call to devm_phy_create() function, which has side effect since later in
> >the subsequent calls of devm_phy_create() there is a check with
> >pm_runtime_enabled() to configure few things.
> >
> >Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
> >---
> >  drivers/phy/phy-omap-usb2.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> >index 34b3961..3fb9293 100644
> >--- a/drivers/phy/phy-omap-usb2.c
> >+++ b/drivers/phy/phy-omap-usb2.c
> >@@ -262,14 +262,16 @@ static int omap_usb2_probe(struct platform_device *pdev)
> >  	otg->phy		= &phy->phy;
> >  	platform_set_drvdata(pdev, phy);
> >+	pm_runtime_enable(phy->dev);
> >  	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
> >-	if (IS_ERR(generic_phy))
> >+	if (IS_ERR(generic_phy)) {
> >+		pm_runtime_disable(phy->dev);
> >  		return PTR_ERR(generic_phy);
> >+	}
> >  	phy_set_drvdata(generic_phy, phy);
> >-	pm_runtime_enable(phy->dev);
> >  	phy_provider = devm_of_phy_provider_register(phy->dev,
> >  			of_phy_simple_xlate);
> >  	if (IS_ERR(phy_provider)) {
