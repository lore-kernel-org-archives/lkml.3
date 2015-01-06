Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbbAFDC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 22:02:57 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:46369 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbbAFDCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 22:02:54 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Kever Yang <kever.yang@rock-chips.com>,
        Doug Anderson <dianders@chromium.org>
CC: Felipe Balbi <balbi@ti.com>, Dinh Nguyen <dinguyen@opensource.altera.com>,
        "romain.perier@gmail.com" <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jwerner@chromium.org" <jwerner@chromium.org>
Subject: RE: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
Thread-Topic: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
Thread-Index: AQHP/OemHIpdmIh/Rku4z/uYLWGLo5xeK1WAgAAWRACAVGDcIIAAjd6A//+FEeA=
Date: Tue, 6 Jan 2015 03:02:51 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030484505A12@US01WEMBX2.internal.synopsys.com>
References: <1415624983-22413-1-git-send-email-kever.yang@rock-chips.com>
 <CAD=FV=V-D3qTtnwjme8k=boUkoGGPmfvcF=Jboq0qcRBzKrY6g@mail.gmail.com>
 <5463FE5E.906@rock-chips.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304845059B3@US01WEMBX2.internal.synopsys.com>
 <54AB3D7D.4000707@rock-chips.com>
In-Reply-To: <54AB3D7D.4000707@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.20]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t06332qj010278

> From: Kever Yang [mailto:kever.yang@rock-chips.com]
> Sent: Monday, January 05, 2015 5:42 PM
> 
> Hi Paul,
> 
> I think you need this patch to fix the problem:
> 
> usb: dwc2: resume root hub when device detect with suspend state
> https://patchwork.kernel.org/patch/5325111/
> 
> Thanks,
> 
> - Kever
> On 01/06/2015 09:23 AM, Paul Zimmerman wrote:
> >> From: Kever Yang [mailto:kever.yang@rock-chips.com]
> >> Sent: Wednesday, November 12, 2014 4:42 PM
> >>
> >> On 11/13/2014 07:22 AM, Doug Anderson wrote:
> >>> Kever,
> >>>
> >>> On Mon, Nov 10, 2014 at 5:09 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> >>>> Hcd controller needs bus_suspend/resume, dwc2 controller make
> >>>> root hub generate suspend/resume signal with hprt0 register
> >>>> when work in host mode.
> >>>> After the root hub enter suspend, we can make controller enter
> >>>> low power state with PCGCTL register.
> >>>>
> >>>> We also update the lx_state for hsotg state.
> >>>>
> >>>> This patch has tested on rk3288 with suspend/resume.
> >>>>
> >>>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> >>>> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> >>>> ---
> >>>>
> >>>> Changes in v3:
> >>>> - remove CONFIG_PM macro for bus_suspend/resume
> >>>> - add PCGCTL operation for no device connect case
> >>>>
> >>>> Changes in v2:
> >>>> - update commit message
> >>>> - make dwc2 suspend/resume sourcecode work
> >>>>
> >>>>    drivers/usb/dwc2/hcd.c | 88 +++++++++++++++++++++++++++++++++++++++++++-------
> >>>>    1 file changed, 77 insertions(+), 11 deletions(-)
> >>> I would certainly appreciate confirmation, but my inclination is to
> >>> NAK this change due to the fact that it regresses functionality.  I
> >>> haven't done any serious review of it, but I've been testing it and it
> >>> appears to break hotplug.
> >>>
> >>> Said another way, I did this:
> >>>
> >>> 1. Without this patch, I booted with a USB stick in.  It was detected.
> >>> I unplugged it, waited 5 seconds, and then plugged it back in.  The
> >>> USB stick was redetcted.
> >>>
> >>> 2. With this patch, I did the same thing.  The USB not redected after
> >>> plugging it back in.
> >> With this patch, the dwc2 hcd/root hub will be auto suspend after device
> >> on port is disconnected, and it can't detect the device connect any more,
> >> I think that's the problem.
> >>
> >> I will figure out how to make dwc2 detect the device connect after auto
> >> suspend,
> >> or disable the auto suspend feature for the dwc2 hcd.
> > Kever,
> >
> > This patch has made it into Linus' kernel as commit 0cf884e819e0, and
> > it breaks disconnect/connect on at least the Altera SOCFPGA platform.
> > I haven't been able to test it on any other platforms.
> >
> > You need to submit a patch to either fix this, or to only enable this
> > feature for the Rock-chip platform. Otherwise the patch has to be
> > reverted.

Unfortunately, after applying that patch there is another problem. If I
connect a device that causes an overcurrent condition to the root port,
then the port is dead after that. No further devices are detected until
after I reboot.

I tried adding another call to usb_hcd_resume_root_hub() in the
"if (hprt0 & HPRT0_OVRCURRCHG)" branch, but then an overcurrent
condition causes a continuous stream of these messages:

[  133.348776] dwc2 ffb40000.usb: GetPortStatus wIndex=0x0001 flags=0x00000022
[  133.355717] dwc2 ffb40000.usb: Overcurrent change detected
[  133.361179] dwc2 ffb40000.usb:   HPRT0: 0x00020000
[  133.365960] dwc2 ffb40000.usb: port_status=00080000
[  133.373236] hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0000
[  133.380038] hub 1-0:1.0: hub_suspend
[  133.384237] usb usb1: bus auto-suspend, wakeup 1
[  133.393631] dwc2 ffb40000.usb: DWC OTG HCD HUB STATUS DATA: Root port status changed
[  133.401341] dwc2 ffb40000.usb:   port_connect_status_change: 0
[  133.407157] dwc2 ffb40000.usb:   port_reset_change: 0
[  133.412186] dwc2 ffb40000.usb:   port_enable_change: 0
[  133.417310] dwc2 ffb40000.usb:   port_suspend_change: 0
[  133.422519] dwc2 ffb40000.usb:   port_over_current_change: 1
[  133.428154] usb usb1: suspend raced with wakeup event
[  133.433191] usb usb1: usb auto-resume
[  133.441522] hub 1-0:1.0: hub_resume
[  133.455505] dwc2 ffb40000.usb: GetPortStatus wIndex=0x0001 flags=0x00000022
[  133.462443] dwc2 ffb40000.usb: Overcurrent change detected
[  133.467907] dwc2 ffb40000.usb:   HPRT0: 0x00020000
[  133.472684] dwc2 ffb40000.usb: port_status=00080000
[  133.480088] hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0000
[  133.485578] hub 1-0:1.0: hub_suspend
[  133.489157] usb usb1: bus auto-suspend, wakeup 1
[  133.493768] dwc2 ffb40000.usb: _dwc2_hcd_suspend()
[  133.498540] dwc2 ffb40000.usb: DWC OTG HCD HUB STATUS DATA: Root port status changed
[  133.506257] dwc2 ffb40000.usb:   port_connect_status_change: 0
[  133.512065] dwc2 ffb40000.usb:   port_reset_change: 0
[  133.517102] dwc2 ffb40000.usb:   port_enable_change: 0
[  133.522218] dwc2 ffb40000.usb:   port_suspend_change: 0
[  133.527428] dwc2 ffb40000.usb:   port_over_current_change: 1
[  133.533069] usb usb1: suspend raced with wakeup event
[  133.538098] usb usb1: usb auto-resume
[  133.546439] hub 1-0:1.0: hub_resume

Any ideas?

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
