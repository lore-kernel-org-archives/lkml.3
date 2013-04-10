Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab3DJGTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:19:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37826 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3DJGTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:19:18 -0400
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: "Poddar, Sourav" <sourav.poddar@ti.com>, Kevin Hilman <khilman@linaro.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Balbi, Felipe" <balbi@ti.com>, "Nayak, Rajendra" <rnayak@ti.com>
Subject: RE: [PATCHv3] driver: serial: prevent UART console idle on suspend
 while using "no_console_suspend"
Thread-Topic: [PATCHv3] driver: serial: prevent UART console idle on suspend
 while using "no_console_suspend"
Thread-Index: AQHOMf/UbV07E720zk6AHOHLsAfKmpjH5XwQgAYBjgCAAGAu44AAW/AAgABcfmA=
Date: Wed, 10 Apr 2013 06:19:08 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433ED96446@DBDE01.ent.ti.com>
References: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com>
	<87mwtclvua.fsf@linaro.org> <516463D2.2070008@ti.com>
 <87obdnh6au.fsf@linaro.org> <516501A0.4000004@ti.com>
In-Reply-To: <516501A0.4000004@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.119]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sourav, Kevin,

On Wed, Apr 10, 2013 at 11:37:28, Poddar, Sourav wrote:
> Hi,
> On Wednesday 10 April 2013 12:37 AM, Kevin Hilman wrote:
> > Sourav Poddar<sourav.poddar@ti.com>  writes:
> >
> >> Hi Kevin,
> >> On Friday 05 April 2013 11:10 PM, Kevin Hilman wrote:
> >>> Sourav Poddar<sourav.poddar@ti.com>   writes:
> >>>
> >>>> With dt boot, uart wakeup after suspend is non functional while using
> >>>> "no_console_suspend" in the bootargs. With "no_console_suspend" used, we
> >>>> should prevent the runtime suspend of the uart port which is getting used
> >>>> as an console.
> >>>>
> >>>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
> >>>> Cc: Felipe Balbi<balbi@ti.com>
> >>>> Cc: Rajendra nayak<rnayak@ti.com>
> >>>> Tested on omap5430evm, omap4430sdp.
> >>>>
> >>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
> >>> Rather than make these special checks inside the driver's runtime PM
> >>> callbacks, you should just disable runtime PM (pm_runtime_disable())
> >>>
> >>> Then, this should be broken into 2 patches.
> >>>
> >>> 1) serial core: add the '->is_console' flag.  (nit on naming: don't call
> >>>      it port_is_console, since the struct is already a uart_port)
> >>>
> >>> 2) In the OMAP UART driver's ->prepare callback, check the is_console flag
> >>>      and pm_runtime_disable() accordingly  (then pm_runtime_enable() in
> >>>      the drivers's ->complete callback.
> >>>
> >>> Kevin
> >> I was working on your above suggestions, but realised there is not
> >> only console
> >> uart which has the requirement of keeping the clocks enabled while going on
> >> suspend.
> >>
> >> If you see arch/arm/boot/dts/am33xx.dtsi, there is a ocmcram which has
> >> "no_idle_on_suspend" property used.
> > Can you please ask the AM33xx folks how (and why) this is being used?
> >
> > I don't see/find a driver for this device in mainline, so without a
> > driver this flag will not be used.
> >
> Looping in Vaibhav Bedia for ocmcram..
> 
> [Vaibhav]:
>    There is a discussion going on about a cleaner way of handling
>    ti, no_idle_on_suspend" part (as this is a sort of hack). We got a way
>    around for UART ($subject) by making serial core/driver handle this 
> for us.
>    But with this, we will delete codes around "no_idle_on_suspend" flag in
>    omap_device file.
> 
>    But, we realised that its not only UART which requires the clocks to 
> be active
>    whie going for suspend. There is a dts entry for ocmcram also.
> 
>    As Kevin also pointed out, we don't see a driver for this device in 
> mainline, It would be
>    great if you can explain how its getting used?
> 
>    You can find the complete discussion on v3 here:
>       https://lkml.org/lkml/2013/4/5/239
> 

The flag in question is used to ensure that the clock to OCMC RAM is not
disabled by the PM code.

>From the changelog which added this flag:

"Note: OCMC RAM is part of the PER power domain and supports
 retention. The assembly code for low power entry/exit will
 run from OCMC RAM. To ensure that the OMAP PM code does not
 attempt to disable the clock to OCMC RAM as part of the
 suspend process add the no_idle_on_suspend flag."

We had discussed about the usage of this flag in the RFC version
of the patch [1].

Regards,
Vaibhav

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/129510.html
