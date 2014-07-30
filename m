Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaG3O0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:26:35 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:59928 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaG3O0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:26:32 -0400
Date: Wed, 30 Jul 2014 10:26:22 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Lucas Stach <l.stach@pengutronix.de>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] thermal: of: look for sensor driver parent node if
 device node missing
Message-ID: <20140730142622.GA3808@developer>
References: <1405336354-31310-1-git-send-email-ldewangan@nvidia.com>
 <1405339495.4627.3.camel@weser.hi.pengutronix.de>
 <20140730131846.GB14219@developer>
 <53D8F578.1030409@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D8F578.1030409@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Laxman,

On Wed, Jul 30, 2014 at 07:09:04PM +0530, Laxman Dewangan wrote:
> On Wednesday 30 July 2014 06:48 PM, Eduardo Valentin wrote:
> > Laxman,
> >
> > On Mon, Jul 14, 2014 at 02:04:55PM +0200, Lucas Stach wrote:
> >> Am Montag, den 14.07.2014, 16:42 +0530 schrieb Laxman Dewangan:
> >>> There are some mfd devices which supports junction thermal interrupt
> >>> like ams,AS3722. The DT binding of these devices are defined as the
> >>> flat and drivers for sub module of such devices are registered as
> >>> the mfd_add_devices. In this method, the sub devices registered as
> >>> platform driver and these do not have the of_node pointer on their
> >>> device structure. In this case, use the parent of_node pointer to
> >>> get the required of_node pointer.
> >>>
> >>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> >>> ---
> >>>   drivers/thermal/of-thermal.c | 2 ++
> >>>   1 file changed, 2 insertions(+)
> >>>
> >>> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> >>> index 04b1be7..85a7d71 100644
> >>> --- a/drivers/thermal/of-thermal.c
> >>> +++ b/drivers/thermal/of-thermal.c
> >>> @@ -396,6 +396,8 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
> >>>   		return ERR_PTR(-EINVAL);
> >>>   
> >>>   	sensor_np = dev->of_node;
> >>> +	if (!sensor_np && dev->parent)
> >>> +		sensor_np = dev->parent->of_node;
> >>>   
> >>>   	for_each_child_of_node(np, child) {
> >>>   		struct of_phandle_args sensor_specs;
> >> This seems like the wrong way around. If the MFD has subdev information
> >> stored in the parent node it should be the MFD drivers responsibility to
> >> populate the subdev of_node with its own node. The subdev should not be
> >> forced to make such possible unsafe assumptions.
> >>
> > This is my understanding too. MFD device drivers must populate the
> > required data onto their sub devices while creating them.
> >
> 
> Sometime ago, Stephen sent patch on MFD to initialize the mfd sub 
> devices of_node with parent node.
> 
> mfd: always assign of_node in mfd_add_device()
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/217482.html
> 

In fact, as I mentioned, this is a controversal subject.

> But it has unforeseen issue and reverted with patch
> mfd: Revert "mfd: Always assign of_node in mfd_add_device()"
> https://groups.google.com/forum/#!msg/rtc-linux/2LeLipSPFs0/XfPCKpT1BnUJ
> 

Indeed, the strategy had issues.

> So we do not have any mechanism here to pass the parent of_node to the 
> of-thermal.

Yeah, but still, as you can see this issue is present in other places apart from
of-thermal. Therefore, it is clear that needs to be fixed somewhere else
than in of-thermal so that others benefit too, don't you agree?

> 
> Adding Stephen and Lee for more comment.

Sure.

In general, I believe letting sub devices to access the MFD core data
(in this case, the parent of node data) is somehow racy. I would prefer
we could have a way to populate the of_node of subdevs with only the
required info.


