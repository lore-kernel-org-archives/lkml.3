Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaJBMS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:18:58 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:59233 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaJBMS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:18:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pavel Machek <pavel@denx.de>, Dinh Nguyen <dinguyen@opensource.altera.com>,
        linux@arm.linux.org.uk, atull <atull@opensource.altera.com>,
        yvanderv@opensource.altera.com, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com
Subject: Re: [PATCH 1/2] socfpga: hotplug: put cpu1 in wfi
Date: Thu, 02 Oct 2014 14:18:09 +0200
Message-ID: <3341525.7GDFQS2rGu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141001231646.GB1529@amd>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com> <542C26B6.7010302@opensource.altera.com> <20141001231646.GB1529@amd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:i5NGhEzU83c3I67hsjp1TadUd+RhJll4CmhYC1x4qJS
 FSEtjtGaVQfpAWgZZAnGWal4I/uGedH/qk/JOpUD4+2Em7QTqF
 EIsnv6UFmWjAV7Pw8Xpb5RPmh2ZlrizLtl2LWR/qhUJ1yAfxLi
 KHROutPeLQzu5b1jdhiPBMSm3OmAH8glcrxEunQR+7EqCXbimV
 LbtZJmLBRpay7+v7FsJb5lUZ7KFG7xsyNZbcs1wna5fDktGS2K
 1olhKJ43aSMwg/fRUcjr1pqWhTaMIjojsglV8ZZEdwgTcaqc4A
 vsizoXVdhjzdHcTl59oy7zgG9Q81maijBKWyO7bmqs8Qk0ygUw
 crA5YDES49IkBFPthQCw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2014 01:16:46 Pavel Machek wrote:
> > > 
> > > struct socfpga_reset_manager {
> > >         u32     status;
> > >         u32     ctrl;
> > >         u32     counts;
> > >         u32     padding1;
> > >         u32     mpu_mod_reset;
> > >         u32     per_mod_reset;
> > >         u32     per2_mod_reset;
> > >         u32     brg_mod_reset;
> > > };
> > > 
> > > from u-boot. Unlike macros, structs have advantages that typos lead to
> > > easier-to-see failure modes... (And they are easier to read/parse,
> > > too).
> > > 
> > 
> > Copying from uboot sounds good, but I already know that the CPU reset
> > offset is different for our next SOC, Arria 10. The Arria 10 SOC should
> > still be able to use the same MSL as Cyclone5 and Arria5, but with a few
> > differences. One of them being, the CPU1 reset offset is at 0x20 instead
> > of 0x10. So I think having a macro for this one register is a bit
> > cleaner than having to define a whole new struct for Arria10.
> 
> I don't think "whole new struct" is a problem. At least it will be
> plain to see what changed (which will get easily lost in ifdefs.
> 
> struct cyclone5_reset_manager {
>         struct socfpga_reset_manager common;
>         u32 brg_mod_reset;
> }
> 
> struct aria10_reset_manager {
>         struct socfpga_reset_manager common;
>         char filler[0x10];
>         u32 brg_mod_reset;
> }
> 
> if (of_machine_is_compatible("altr,socfpga-arria10"))
>         __raw_writel(0, (struct cyclone5_reset_manager *) rst_manager_base_addr->brg_mod_reset));
> else
>         __raw_writel(0, (struct aria10_reset_manager *) rst_manager_base_addr->brg_mod_reset));
> 
> ...does not sound that bad. (And you'll need some nice solution for
> u-boot, anyway...)

I think it would be better to just add more fields and access a different
field based on the SoC type than cast the structs around.

Also, never use __raw_writel unless you know exactly what you are doing.
This should use writel, or possibly writel_relaxed.

Finally, don't sprinkle of_machine_is_compatible() checks all over the
place. Make the decision once when you initially probe the machine.

	Arnd
