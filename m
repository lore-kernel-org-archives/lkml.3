Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbbAVKTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:19:05 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:64423 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbAVKSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:18:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: wstephen@codeaurora.org
Cc: jcliburn@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ethernet: atheros: Add nss-gmac driver
Date: Thu, 22 Jan 2015 11:18:50 +0100
Message-ID: <1753817.oBE21Kj2o0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <f9cbb34c9228b2af7ed6c1c96a6aa61c.squirrel@www.codeaurora.org>
References: <1420754626-30121-1-git-send-email-wstephen@codeaurora.org> <1702448.pOVnDx4KzI@wuerfel> <f9cbb34c9228b2af7ed6c1c96a6aa61c.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:1VGk0IfRgOpoM9p0Z7nFqDNRfPAoTL6Xsg5HEX6cYXCfl2wxtDN
 dh9uDqGWmC9r+8EVarSjLdYD2p/r6hMWr5D9jHewYiivfamI9S4uF8SCo6m4q9YJ5HPCsr3
 tEcopp9SYliM3nPtk21lU6gZ14VbYtmH2gmAf0KPR3pp1ZcUuxXW+bpLogxgSju1kVB1SJ8
 QxaB0RLZ+/qd1CiXH24cw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2015 00:20:59 wstephen@codeaurora.org wrote:
> > Right. For review purposes, I think it would be helpful to split this
> > huge patch into several steps then:
> >
> > - add a base driver
> > - add the overlay interface
> > - add the nss driver
> >
> > Ideally more of them.
> 
> The nss-drv driver is open sourced but we are currently not planning to
> upstream to linux kernel yet because we are still actively adding new
> features
> https://www.codeaurora.org/cgit/quic/qsdk/oss/lklm/nss-drv
> 
> > Thanks for the description, this sounds very interesting indeed. I do
> > have more questions though: how do you get the rules into the NSS driver?
> > Does this get handled transparently by the openvswitch driver or
> > did you have to add new user interfaces for it?
> >
> 
> No, we are not using openvswitch. We have a connection manager monitoring
> conntrack events and creates rules then send it through the interface
> built in nss-drv.
> 

I see. In this case, I think merging your new driver is not a good idea:

- We already have a driver (dwmac1000) for the ethernet hardware,
  which is known to work on a lot of hardware and has an established
  binding.

- The main difference in your new driver is the plug-in interface,
  but that has no upstream users

- The nss driver is not getting submitted, and has little chance of
  getting merged if you do, because it introduces a driver-specific
  API for something that should be hardware independent.

You can simplify your private nss code a lot if you remove the
abstraction layer and only implement ethernet features you need
in the same module, and then load either the upstream driver or
your nss driver. Make sure they use a compatible binding so the
device gets attached to just one of the two drivers. For the
built-in case, you can use the 'unbind' interface from user space
to remove the device from the dwmac1000 driver.

	Arnd
