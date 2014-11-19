Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaKST12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:27:28 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:39454 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbaKST10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:27:26 -0500
MIME-Version: 1.0
In-Reply-To: <2014111916244796336915@rock-chips.com>
References: <1416273684-11300-1-git-send-email-kever.yang@rock-chips.com>
	<Pine.LNX.4.44L0.1411181104280.1500-100000@iolanthe.rowland.org>
	<20141118164100.GD6179@saruman>
	<CAODwPW8hQdxv_ecaVHYjS4rHjZVB_G5zURDPCHzaPsEXVgs=fA@mail.gmail.com>
	<2014111916244796336915@rock-chips.com>
Date: Wed, 19 Nov 2014 11:27:25 -0800
X-Google-Sender-Auth: g2UnC6VYFtz11vJUoWgdT4UhHVg
Message-ID: <CAODwPW841PbmWDrrvO-k3HaCusSyKbgaBbvPRq9X5-m31Zws+w@mail.gmail.com>
Subject: Re: Re: [PATCH v2] usb: dwc2: resume root hub when device detect with
 suspend state
From: Julius Werner <jwerner@chromium.org>
To: =?UTF-8?B?5p2O5LqR5b+X?= <lyz@rock-chips.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        =?UTF-8?B?5p2o5Yev?= <kever.yang@rock-chips.com>,
        Paul Zimmerman <paulz@synopsys.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Romain Perier <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Douglas Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        =?UTF-8?B?5p+v6aOe6ZuE?= <addy.ke@rock-chips.com>,
        =?UTF-8?B?6JSh5p6r?= <cf@rock-chips.com>,
        =?UTF-8?B?5ZC06Imv5bOw?= <wulf@rock-chips.com>,
        =?UTF-8?B?6buE5rab?= <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        =?UTF-8?B?5p2O5LqR5b+X?= <roy.li@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 1:47 AM, 李云志 <lyz@rock-chips.com> wrote:
> hi Julius & Alan
>
>     Shall we use dwc2's private status "hsotg->lx_state" here instesd of
> "hcd->state" for checking root hub is in suspend state ?
> I see the EHCI driver do something like this(ehci->rh_state ==
> EHCI_RH_SUSPENDED) before resume the root hub.

It's not this simple, because lx_state only relates to the status of
the one port on the DWC2. That may be suspended even though the root
hub is not.

The USB core differentiates between suspending individual ports, and
suspending the whole root hub (which should automatically suspend all
ports in a host-controller-specific manner). This distinction may seem
silly on DWC2 because there is only one port to suspend, but you still
need to make it so that the USB core doesn't get confused. So the
different things you need to keep track of are:

 * is the one port individually suspended (through the
hub_control(SetPortFeature(PORT_SUSPEND)) method)
 * is the root hub suspended (through calling bus_suspend())
 * if the root hub gets suspended (through bus_suspend()), had the
port already been suspended before that (through a earlier
hub_control())... this is the thing I mentioned in your other patch

You can decide whether you want to bake that all into one variable
somehow or make it three, but we need to be able to tell all of these
things apart. The third bullet point will also require you to prevent
races of hub_control() with bus_suspend() (not sure if the kernel
already guarantees that or not), so I think we may have to rethink the
way the spinlock works (because it currently doesn't cover that).
