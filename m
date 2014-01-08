Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaAHKFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:05:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaAHKFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:05:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, tj@kernel.org,
        sergei.shtylyov@cogentembedded.com, b.zolnierkie@samsung.com,
        hdegoede@redhat.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Balaji T K <balajitk@ti.com>
Subject: Re: [PATCH v3 2/3] ata: ahci_platform: Manage SATA PHY
Date: Wed, 08 Jan 2014 11:05:07 +0100
Message-ID: <6214646.nAF6lzWV79@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52CD2176.6050102@ti.com>
References: <1389174428-31414-1-git-send-email-rogerq@ti.com> <1389174428-31414-3-git-send-email-rogerq@ti.com> <52CD2176.6050102@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VaC4eVmEnFPfBU+R/lNws6G7D/6/ZEW8bOJT0TTcD8L
 EJD95bXcWzUK5YuLtab5TXHCUGmGswrnhaEmBjkQxTO9k1f4OB
 yv7Y1OJwUe3/7qyAv7NQBiwojZnzYsiwInbNlpymmrk1431Jc4
 FXTlSCLd4QXddNjJmBcJOtWyIAcuvlMsydYXNwKGC+ze57Vsxk
 z9muBWUOYYxGRxPp8Wq5vepIHmkY+l19kkKevB63IysnUYPycu
 EL4+lbEVxRXT/KHJ0gebc3Eq/LrTgPRTTyTX2wDeOWZVFRmV1v
 9iNVBbxgRRv+lIuV9MQF2JNHZ4lTsgXpuojS9kcJJvR5ZIRwvk
 Cx971S1jekBDwi0aoe8A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014 15:29:18 Kishon Vijay Abraham I wrote:
> > +     hpriv->phy = devm_phy_get(dev, "sata-phy");
> > +     if (IS_ERR(hpriv->phy)) {
> > +             dev_dbg(dev, "can't get sata-phy\n");
> > +             /* return only if -EPROBE_DEFER */
> > +             if (PTR_ERR(hpriv->phy) == -EPROBE_DEFER) {
> > +                     rc = -EPROBE_DEFER;
> > +                     goto disable_unprepare_clk;
> > +             }
> > +     }

This should probably check for all errors except "not present"
rather than checking for -EPROBE_DEFER. We want to abort the
probe function for deferred probe as well as the case where we
a PHY was listed but isn't working properly.

> > +     if (!IS_ERR(hpriv->phy)) {
> > +             phy_init(hpriv->phy);
> 
> Don't we have to check the return values of phy_init and phy_power_on? Is it
> not needed because it is an optional phy?

Right. I think we should set hpriv->phy to NULL if it's not there and
then call the functions only if it's actually present but bail out on
an error.

	Arnd
