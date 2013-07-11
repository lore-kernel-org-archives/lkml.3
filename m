Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab3GKVqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 17:46:18 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:56620 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab3GKVqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 17:46:15 -0400
MIME-Version: 1.0
In-Reply-To: <000901ce7dc8$90a819b0$b1f84d10$@samsung.com>
References: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
	<000901ce7dc8$90a819b0$b1f84d10$@samsung.com>
Date: Thu, 11 Jul 2013 14:46:14 -0700
X-Google-Sender-Auth: xxpqh8JkY-aO6MhvD_XzuDqlGs0
Message-ID: <CAODwPW-=bo2BqcHopY32N76p6DDGNDmCrKFo1R4gEEZhsG-DYg@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
From: Julius Werner <jwerner@chromium.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

Yeah, I followed that discussion back then, but it seems to have
stalled a little (at least the HSIC patches haven't been picked up in
any kernel.org repo yet to my knowledge).

The problem is that I think these approaches cannot work reliably. I
agree that it would be nice to control the HSIC device from its own
driver, and have spent quite some time playing around with the
usb/misc/usb3503.c driver to try to make this work... but there's a
timing dependency here that you just can't model correctly with
independent drivers.

If the HSIC device is already active during boot (e.g. because it was
used by firmware), there's always a chance that the USB stack will
come up before the driver that resets it does. The device will be
enumerated as normal, and when the other driver later pulls the reset
signal the USB stack will not notice because there is no real
disconnect detection on HSIC. Only when you eventually try to send
another transfer to the device will you start to get timeouts, and the
newly reset device will not be able to reenumerate because the host
never asks it to.

I really don't see how you could solve this without putting some kind
of synchronization mechanism in the USB drivers. So this leaves
ehci-s5p and phy-samsung-usb2 as the only possible places, and I chose
the latter since all the host-side HSIC initialization is also there
already. I think if you think of it as "reset whatever is on the other
side of this PHY", it's okay to put it as an optional feature into the
PHY driver.
