Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbaAHQRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:17:22 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:12429 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756517AbaAHQRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:17:20 -0500
Message-ID: <1389197839.23721.31.camel@hornet>
Subject: Re: [RFC 18/18] mfd: vexpress: Split sysreg functions into MFD cells
From: Pawel Moll <pawel.moll@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>
Date: Wed, 08 Jan 2014 16:17:19 +0000
In-Reply-To: <20140106104030.GI23772@lee--X1>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
	 <1387815830-8794-19-git-send-email-pawel.moll@arm.com>
	 <20140106104030.GI23772@lee--X1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 10:40 +0000, Lee Jones wrote:
> > +static struct mfd_cell vexpress_sysreg_cells[] = {
> > +	{
> > +		.name = "syscon",
> > +		.of_compatible = "arm,vexpress-sysreg,sys_id",
> > +		.num_resources = 1,
> > +		.resources = (struct resource []) {
> > +			DEFINE_RES_MEM(SYS_ID, 0x4),
> > +		},
> > +		.platform_data = &vexpress_sysreg_sys_id_pdata,
> > +		.pdata_size = sizeof(vexpress_sysreg_sys_id_pdata),
> 
> Not sure how comfortable I am with using Device Tree and populating
> platform_data with information which by the looks of it you're
> planning to make persistent. What's stopping you from using a DT
> property to name the block, or better yet, just use the compatible
> string? Also, won't naming these blocks in DT also aid other OSes?

Right. This particular of_compatible string in the *_cells is a leftover
from previous versions of the patch. Only the gpio-related ones, as
mentioned in the example:

>  Example:
>         v2m_sysreg: sysreg@10000000 {
>                 compatible = "arm,vexpress-sysreg";
>                 reg = <0x10000000 0x1000>;
> -               gpio-controller;
> -               #gpio-cells = <2>;
> +
> +               v2m_led_gpios: sys_led@08 {
> +                       compatible = "arm,vexpress-sysreg,sys_led";
> +                       gpio-controller;
> +                       #gpio-cells = <2>;
> +               };
> +
> +               v2m_mmc_gpios: sys_mci@48 {
> +                       compatible = "arm,vexpress-sysreg,sys_mci";
> +                       gpio-controller;
> +                       #gpio-cells = <2>;
> +               };
> +
> +               v2m_flash_gpios: sys_flash@4c {
> +                       compatible = "arm,vexpress-sysreg,sys_flash";
> +                       gpio-controller;
> +                       #gpio-cells = <2>;
> +               };
>         };

are supposed for the sake the gpio users (and some of them don't exist
in some version of the sysregs).

> > +	return mfd_add_devices(&pdev->dev, PLATFORM_DEVID_AUTO,
> > +			vexpress_sysreg_cells,
> > +			ARRAY_SIZE(vexpress_sysreg_cells), mem, 0, 0);
> 
> Don't use 0 as NULL, you will cause a sparse error.

... and rightly so! ;-) Well spotted, thanks!

Paweł

