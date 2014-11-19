Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaKSCDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:03:13 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:49498 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaKSCDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:03:10 -0500
MIME-Version: 1.0
In-Reply-To: <20141118164100.GD6179@saruman>
References: <1416273684-11300-1-git-send-email-kever.yang@rock-chips.com>
	<Pine.LNX.4.44L0.1411181104280.1500-100000@iolanthe.rowland.org>
	<20141118164100.GD6179@saruman>
Date: Tue, 18 Nov 2014 18:03:09 -0800
X-Google-Sender-Auth: KCpbZNb2j_p2ONF8msm1nqKFCwE
Message-ID: <CAODwPW8hQdxv_ecaVHYjS4rHjZVB_G5zURDPCHzaPsEXVgs=fA@mail.gmail.com>
Subject: Re: [PATCH v2] usb: dwc2: resume root hub when device detect with
 suspend state
From: Julius Werner <jwerner@chromium.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Paul Zimmerman <paulz@synopsys.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Romain Perier <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Douglas Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>, addy ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Roy Li <roy.li@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> You should be aware that it's not safe to use hcd->state for anything
>> in a host controller driver.  That field is owned by usbcore, not by
>> the HCD, and it is not protected by any locks.
>>
>> Thus, for example, hcd->state does not get set to HC_STATE_SUSPENDED
>> until some time after the bus_suspend routine has returned.  A
>> port-change interrupt might occur during that time interval.

Looks like there is explicit code in hcd_bus_suspend() to check for
that race condition right after setting hcd->state, or do I
misinterpret that (the "Did we race with a root-hub wakeup event?"
part)? Also, it seems xhci_bus_suspend() explicitly sets 'hcd->state =
HC_STATE_SUSPENDED' before giving up the spinlock for some
undocumented reason, maybe to avoid exactly this problem. We could
just copy that trick if the hcd.c solution isn't enough (although the
DWC2 bus_suspend/bus_resume in the other patch don't grab that
spinlock right now, where I'm also not so sure if that's a good
idea...).
