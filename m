Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaGaLdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:33:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49443 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbaGaLd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:33:28 -0400
Date: Thu, 31 Jul 2014 13:33:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        Michal Simek <michals@xilinx.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Punnaiah Choudary <kpc528@gmail.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        Srikanth Vemula <svemula@xilinx.com>
Subject: Re: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr ecc
 controller
Message-ID: <20140731113324.GB4375@pd.tnic>
References: <9dc2a947-d2ab-4f00-8ed3-d2499cb6fdfd@BN1BFFO11FD002.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9dc2a947-d2ab-4f00-8ed3-d2499cb6fdfd@BN1BFFO11FD002.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 03:41:47PM +0000, Punnaiah Choudary Kalluri wrote:
> >So you're telling me that you want one edac driver for *two* memory
> >controllers which can be present on a single system *at* *the* *same*
> >*time*? Is that it?
> 
> Yes.

Oh, this'll be fun. :-P

> >
> >How exactly is that topology supposed to look like, work, etc, etc? What
> >kind of error reporting do you imagine you want to do with EDAC?
> 
> Zynq (All programmable SOC) contains a dual core ARM cortex A9 based processing
> System(PS) and Xilinx programmable logic(PL) in a single device.
> 
> Assume the application is a broadcast camera. The design for this system use PS as
> Control plane and use PL as data plane for processing the video data. So, the design 
> may have two different memory controllers one in PS and another one in PL.   
> PS is running with Linux OS and PL doesn't have the OS and it is  controlled by the 
> OS running on PS.

Ok.

>  Now the requirement is to develop a monitoring system for all the
> hardware failures Including ddr ecc errors. Since the broadcast camera
> involves more data processing and DDR memory access, there is a high
> probability of getting ddr ecc errors over the period.

So you're saying the camera has memory with ECC? People really pay
attention on getting error free video frames? :-)

Or this is just an example? You're saying the PL will need ECC for some
applications?

> So, the user should be intimated with these errors when they occur and if the error rate
>  is high, then the user can consider the preventive methods. Without this error reporting
> mechanism it is difficult to debug the issues like memory corruption, kernel oops which
>  may occur due to ddr ecc failures.
> 
> Since, the memory controllers are different, it need two edac drivers for reporting the ecc 
> errors and also maintaining the statistics of that particular memory controller. With the current
> framework, there is a chance that both the drivers get mc_num as zero and malfunction. 
> Assume the code for the two drivers looks like below
> 
> Driver 1:
> 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
> 			    sizeof(struct  ctrl1_drvdata));
> 
> Driver 2:
> 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
> 			    sizeof(struct ctrl2_drvdata));
> 
> Issue:
>   Since driver is providing the mc_num to framework, now there is chance that only one device active as
>  both the drivers claiming the same number.
> 
> Solution 1:
>  Keep two drivers in single file and use static global variable for tracking the mc_num. This solution looks
> good but the drivers may not be generic as these driver would be in a zynq_edac.c file. So others may not
> reuse these drivers

Ok, I think I know what you mean. And this architecture works just fine.
On x86 we have one EDAC instance per memory controller so on a multinode
machine with multiple memory controllers, we do edac_mc_alloc() per
memory controller.

For examples, see amd64_edac::init_one_instance() and sb_edac should
have this too. So you basically have a local array of instances which
you allocate and setup.

If someone wants to reuse the driver, then we can talk about this later,
when the time comes.

For now I think you should put both PS and PL stuff in one file,
zynq_edac or so.

Any issues with this design?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
