Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaIQIBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:01:23 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60886 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbaIQIBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:01:21 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, huangtao@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        Douglas Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rockchip@lists.infradead.org, Jianqun Xu <xjq@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, hj@rock-chips.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] ARM: rockchip: add basic smp support for rk3288
Date: Wed, 17 Sep 2014 10:03:39 +0200
Message-ID: <1818235.yqePbxBFzD@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <5418DDE9.1000603@rock-chips.com>
References: <1410864271-9277-1-git-send-email-kever.yang@rock-chips.com> <CAPz6YkVqhO6kJtySB7MrCYzVLgjViKLO3c_HgS_NVxt3-=SJew@mail.gmail.com> <5418DDE9.1000603@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kever,

Am Mittwoch, 17. September 2014, 09:03:37 schrieb Kever Yang:
> Sonny,
> 
> On 09/17/2014 04:17 AM, Sonny Rao wrote:
> > On Tue, Sep 16, 2014 at 3:44 AM, Kever Yang <kever.yang@rock-chips.com> 
wrote:
> >> This patch add basic rk3288 smp support, cpu 1~3 are in wfe state
> >> when get into kernel.
> >> 
> >> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> >> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> >> ---
> >> 
> >> Changes in v2:
> >> - use rk3288_boot_secondary instead ofsmp_boot_secondary
> >> - discards the power domain operation
> >> - handle the per cpu starup when actived by 'sev'
> >> 
> >>   arch/arm/mach-rockchip/core.h    |  1 +
> >>   arch/arm/mach-rockchip/headsmp.S | 14 +++++++++
> >>   arch/arm/mach-rockchip/platsmp.c | 63
> >>   ++++++++++++++++++++++++++++++++++++---- 3 files changed, 72
> >>   insertions(+), 6 deletions(-)
> >> 
> >> diff --git a/arch/arm/mach-rockchip/core.h
> >> b/arch/arm/mach-rockchip/core.h
> >> index 39bca96..13de05a 100644
> >> --- a/arch/arm/mach-rockchip/core.h
> >> +++ b/arch/arm/mach-rockchip/core.h
> >> @@ -18,3 +18,4 @@ extern char rockchip_secondary_trampoline_end;
> >> 
> >>   extern unsigned long rockchip_boot_fn;
> >>   extern void rockchip_secondary_startup(void);
> >> 
> >> +extern void rk3288_secondary_startup(void);
> >> diff --git a/arch/arm/mach-rockchip/headsmp.S
> >> b/arch/arm/mach-rockchip/headsmp.S index 73206e3..bacdb56 100644
> >> --- a/arch/arm/mach-rockchip/headsmp.S
> >> +++ b/arch/arm/mach-rockchip/headsmp.S
> >> @@ -20,6 +20,20 @@ ENTRY(rockchip_secondary_startup)
> >> 
> >>          b       secondary_startup
> >>   
> >>   ENDPROC(rockchip_secondary_startup)
> >> 
> >> +ENTRY(rk3288_secondary_startup)
> >> +       mrc p15, 0, r0, c0, c0, 5
> >> +       mov r2, #3
> >> +       and r0, r0, r2
> >> +       ldr r1, =0xff700000
> >> +       ldr r1, [r1]
> >> +       cmp r0, r1
> >> +       beq 2f
> >> +       ldr r2, =0xfffd0000
> >> +       mov pc, r2
> >> +2:
> >> +       b       secondary_startup
> >> +ENDPROC(rk3288_secondary_startup)
> > 
> > Comments on what's going on here would be nice.
> 
> I will do that in next version.
> 
> > It looks like what you're doing is checking to see whether this CPU is
> > the one that is supposed to wake up or not, but looking at sram
> > (written by the C code below), and this isn't the correct CPU then go
> > back to boot rom?  Since we read in int-mem from the device-tree it
> > would also probably be good to make that ldr r1, 0xff700000 reference
> > the sram_base_addr variable rather than hard coding here.
> 
> I don't like the hard coding either, but I don't know how to get the
> physical base of sram and bootrom address in the assemble code.

Take a look at how the rk3066 smp code handles the address: defining 
rockchip_boot_fn in headsmp.S, having it in core.h and filling it with the 
address in platsmp.c

I would think transfering the address read from dt could work similarly.


Heiko

