Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127AbaKNEtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 23:49:46 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36243 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934226AbaKNEtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 23:49:45 -0500
MIME-Version: 1.0
In-Reply-To: <5463FE5E.906@rock-chips.com>
References: <1415624983-22413-1-git-send-email-kever.yang@rock-chips.com>
	<CAD=FV=V-D3qTtnwjme8k=boUkoGGPmfvcF=Jboq0qcRBzKrY6g@mail.gmail.com>
	<5463FE5E.906@rock-chips.com>
Date: Thu, 13 Nov 2014 20:49:44 -0800
X-Google-Sender-Auth: XLofNeOppgSsyDZ98ZLqduMFBG8
Message-ID: <CAODwPW9Avc1RCdDoarGg2cZirn7ivu4JEdUTV485J=nLLmecTQ@mail.gmail.com>
Subject: Re: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
From: Julius Werner <jwerner@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: Doug Anderson <dianders@chromium.org>, Paul Zimmerman <paulz@synopsys.com>,
        Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Romain Perier <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julius Werner <jwerner@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I will figure out how to make dwc2 detect the device connect after auto
> suspend,
> or disable the auto suspend feature for the dwc2 hcd.

I think auto-suspend of the root hub device (which is what calls
bus_suspend, but is not the host controller device itself) is expected
to always happen and not really meant to be disabled. I'm surprised
that the controller would fail to come back up, though. Does removing
the PCGCTL part make it work? That's the only thing I can think of
(but then again the function should immediately return if the port is
not in L0, so if there is nothing plugged in the suspend shouldn't
really do anything).

Another thing might be that the port connect interrupt does not
correctly resume the root hub. I don't really know many details about
how that works, and it seems pretty complicated. But I can see that
all other HCDs seem to call usb_hcd_resume_root_hub() from their
interrupt handlers, which we don't. There's also a
usb_hcd_start_port_resume() in EHCI which I'm not familiar with, that
seems to have been added recently. And finally, it seems that all
normal host controllers (UHCI/OHCI/EHCI/XHCI) now do the
usb_hcd->uses_new_polling thing (where you're supposed to call
hcd_poll_rh_status() from the HCD code)... the old polling code still
seems to be in place, but without any relevant driver using I wouldn't
be so sure if it's still functional.

+Alan who should know HCD/core interactions much better and might have
some ideas what the DWC2 driver is still missing right now.
