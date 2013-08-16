Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3HPWQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:16:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53188 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab3HPWPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:15:02 -0400
Date: Fri, 16 Aug 2013 14:47:15 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH RFC 1/3] spmi: Linux driver framework for SPMI
Message-ID: <20130816194714.GH4035@joshc.qualcomm.com>
References: <cover.1376596224.git.joshc@codeaurora.org>
 <02deef1d90121011ab1df90ad704ef0ee36e2584.1376596224.git.joshc@codeaurora.org>
 <20130816184614.GA31510@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816184614.GA31510@kroah.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg-

Thanks for the comments.

On Fri, Aug 16, 2013 at 11:46:14AM -0700, Greg Kroah-Hartman wrote:
> On Fri, Aug 09, 2013 at 01:37:09PM -0700, Josh Cartwright wrote:
> > --- /dev/null
> > +++ b/drivers/of/of_spmi.c
> > @@ -0,0 +1,74 @@
> > +/* Copyright (c) 2012,2013 The Linux Foundation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 and
> > + * only version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +#define pr_fmt(fmt) "%s: " fmt, __func__
> 
> As you never make a pr_* call in this file, this line isn't needed.

I'll clean these up for v2.

> > +static int
> > +spmi_read_data(struct spmi_device *sdev, uint8_t *buf, int offset, int cnt)
> > +{
> > +	int ret = 0;
> > +	int len;
> > +	uint16_t addr;
> > +
> > +	while (cnt > 0) {
> > +		addr = offset & 0xFFFF;
> > +		len = min(cnt, MAX_REG_PER_TRANSACTION);
> > +
> > +		ret = spmi_ext_register_readl(sdev, addr, buf, len);
> > +		if (ret < 0) {
> > +			pr_err("SPMI read failed, err = %d\n", ret);
> 
> Should be using dev_err() instead.

These too.

[..]
> > +
> > +	/* Make a copy of the user data */
> > +	char *kbuf = kmalloc(count + 1, GFP_KERNEL);
> > +	if (!kbuf)
> > +		return -ENOMEM;
> > +
> > +	ret = copy_from_user(kbuf, buf, count);
> > +	if (ret == count) {
> > +		pr_err("failed to copy data from user\n");
> 
> No need for a message here at all, you will get a message in the
> function if something happened wrong.
> 
> Also, shouldn't it just be a simple:
> 	if (copy_from_user()) {
> test?

Indeed, thanks.

[..]
> > +void __exit spmi_dfs_exit(void)
> > +{
> > +	pr_debug("de-initializing spmi debugfs ...");
> 
> Not needed, use the in-kernel trace functionality if you really want to
> know this.

Will kill these.

> > --- /dev/null
> > +++ b/drivers/spmi/spmi-dbgfs.h
> > @@ -0,0 +1,37 @@
> > +/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 and
> > + * only version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +#ifndef _SPMI_DBGFS_H
> > +#define _SPMI_DBGFS_H
> > +
> > +#include <linux/spmi.h>
> > +#include <linux/debugfs.h>
> > +
> > +#ifdef CONFIG_DEBUG_FS
> 
> Why?  If debugfs isn't enabled, the functions should just compile away
> with the debugfs_() calls, so no need to do this type of thing here,
> right?

Not sure I follow you, but it may be because this is a bit misleading.

Currently CONFIG_DEBUG_FS is being extended to also mean "do you want
the SPMI core to create device entries?".  It would probably make more
sense to have a CONFIG_SPMI_DEBUG option which is def_bool DEBUG_FS, as
other busses have.

The #ifdef here would then be #ifdef CONFIG_SPMI_DEBUG, as well as in
the Makefile:

  spmi-core-$(CONFIG_SPMI_DEBUG) += spmi-dbgfs.o

> > +
> > +extern void __init spmi_dfs_init(void);
> > +extern void __exit spmi_dfs_exit(void);
> > +extern void spmi_dfs_add_controller(struct spmi_controller *ctrl);
> > +extern void spmi_dfs_del_controller(struct spmi_controller *ctrl);
> > +extern void spmi_dfs_add_device(struct spmi_device *sdev);
> > +extern void spmi_dfs_del_device(struct spmi_device *sdev);
> > +
> > +#else
> > +
> > +static inline void __init spmi_dfs_init(void) { }
> > +static inline void __exit spmi_dfs_exit(void) { }
> > +static inline void spmi_dfs_add_controller(struct spmi_controller *ctrl) { }
> > +static inline void spmi_dfs_del_controller(struct spmi_controller *ctrl) { }
> > +static inline void spmi_dfs_add_device(struct spmi_device *sdev) { }
> > +static inline void spmi_dfs_del_device(struct spmi_device *sdev) { }
> > +#endif
> > +
> > +#endif /* _SPMI_DBGFS_H */

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
