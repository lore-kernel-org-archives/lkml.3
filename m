Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbaFKNOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:14:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52900 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaFKNOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:14:50 -0400
Date: Wed, 11 Jun 2014 14:15:00 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Chander Kashyap <k.chander@samsung.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Inderpal Singh <inderpal.s@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "olof@lixom.net" <olof@lixom.net>, Tushar Behera <trblinux@gmail.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH] ARM: EXYNOS: mcpm: Don't rely on firmware's
 secondary_cpu_start
Message-ID: <20140611131500.GA19884@red-moon>
References: <1402090985-8061-1-git-send-email-dianders@chromium.org>
 <20140607181221.GB25068@e102568-lin.cambridge.arm.com>
 <CAD=FV=X17PeJ6JPE9Qyc1QT07AvA2PTE69Q87gz9a6MdUHgi4A@mail.gmail.com>
 <20140609223831.GB16889@e102568-lin.cambridge.arm.com>
 <CANuQgHHxAhTNYX-JAEdRkO=PMYT4A5GwXcuQfiqwE0CEkQyR+w@mail.gmail.com>
 <CAD=FV=V5_RRNkgA7Rk7XbQw9m1qh6-RJA8arW7ZRU=QbWAPa+w@mail.gmail.com>
 <alpine.LFD.2.11.1406101146140.25775@knanqh.ubzr>
 <CADWw7OjqK3MAuqCHuv-WS3Bb2+2Q-FXth+7hqtwFoyAP6pyYhA@mail.gmail.com>
 <20140611101353.GA18781@e102568-lin.cambridge.arm.com>
 <CADWw7OghkwkMbU=eZG=OhxVowNJy_12UOo_pNYnXbimF73Uwdw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CADWw7OghkwkMbU=eZG=OhxVowNJy_12UOo_pNYnXbimF73Uwdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 11 Jun 2014 13:14:42.0006 (UTC) FILETIME=[1B253760:01CF8577]
X-MC-Unique: 114061114144712301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 01:14:21PM +0100, Chander Kashyap wrote:
> On Wed, Jun 11, 2014 at 3:43 PM, Lorenzo Pieralisi
> <lorenzo.pieralisi@arm.com> wrote:
> > On Wed, Jun 11, 2014 at 05:52:10AM +0100, Chander Kashyap wrote:
> >> Hi Doug,
> >>
> >> On Tue, Jun 10, 2014 at 9:19 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> >> > On Tue, 10 Jun 2014, Doug Anderson wrote:
> >> >
> >> >> My S-state knowledge is not strong, but I believe that Lorenzo's
> >> >> questions matter if we're using S2 for CPUidle (where we actually turn
> >> >> off power and hot unplug CPUs) but not when we're using S1 for CPUidle
> >> >> (where we just enter WFI/WFE).
> >> >>
> >>
> >> No Its not plain WFI.
> >>
> >> All cores in Exynos5420 can be powered off independently.
> >> This functionality has been tested.
> >>
> >> Below is the link for the posted patches.
> >>
> >> https://lkml.org/lkml/2014/6/10/194
> >>
> >> And as Nicolas wrote, these patches need MCPM for that.
> >
> > Chander, I cast a look into the code and I have a question
> > (you also told me on CPUidle review that only core off
> > is supported in CPUidle).
> >
> > When you say all cores can be powered off independently, do
> > you also mean that clusters can be powered off (in CPUidle) ?
> >
> > I am pointing this out since in the MCPM backend I noticed:
> >
> > "/* TODO: Turn off the cluster here to save power. */"
> >
> > I do not see any cluster power down request in the down path.
> >
> > If I am wrong, ignore my message, I am just writing to help.
> >
> > If you can only power down cores, but not the clusters on idle,
> > please keep in mind that you are currently cleaning and invalidating
> > the L2 when last man is running and this must not be taken
> > lightly since, if L2 stays on, that's a massive energy waste
> > for nothing.
> >
> > So, if clusters stay up, you _have_ to tweak the MCPM backend slightly
> > to avoid cleaning L2, that's pivotal.
> 
> Hi Lorenzo,
> Cluster shutdown is in progress. Abhilash will add support for that.
> 
> https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg31104.html

Hi Chander,

thanks. So, as a heads-up:

1) if you merge CPUidle support now, as it is it is at least suboptimal, may
   even burn more energy than it saves. Latencies in the bL idle driver
   are likely to be wrong, since they are for cluster shutdown and for
   TC2, not core power gating that should require shorter target_residencies.
   On top of that, L2 is cleaned and invalidated for nothing.
2) when cluster support is merged, you might want to extend the CPUidle
   driver to add an additional state (ie C1 core gating, C2 cluster
   gating) and to do that you should extend the driver and the MCPM
   back-end accordingly, I discussed that with Nico already some time ago
   and actually it should be fairly easy to do but we have got to talk
   about that.

Thank you,
Lorenzo

> 
> 
> >
> > Lorenzo
> >
> >>
> >> >> I believe that in ChromeOS we use S1 CPUidle and that it works fine.
> >> >> We've never implemented S2 that I'm aware of.
> >> >
> >> > You'll have to rely on MCPM for that.  That's probably why it hasn't
> >> > been implemented before.
> >> >
> >> >
> >> > Nicolas
> >> >
> >> > _______________________________________________
> >> > linux-arm-kernel mailing list
> >> > linux-arm-kernel@lists.infradead.org
> >> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

