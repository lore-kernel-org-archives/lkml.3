Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaAHTMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:12:36 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:41013 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAHTMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:12:33 -0500
Date: Wed, 8 Jan 2014 11:12:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V1] input: fix memory leak in da9052 touchscreen driver
Message-ID: <20140108191229.GA25785@core.coreip.homeip.net>
References: <201401081709.s08H9nMr038265@swsrvapps-02.lan>
 <7aad8e91-f5d9-4527-8a94-bc038a9ccd85@email.android.com>
 <24DF37198A1E704D9811D8F72B87EB51847B1D99@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51847B1D99@NB-EX-MBX02.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 06:12:27PM +0000, Opensource [Anthony Olech] wrote:
> > -----Original Message-----
> > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > Sent: 08 January 2014 17:26
> > To: Opensource [Anthony Olech]
> > Cc: linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Huqiu Liu;
> > David Dajun Chen
> > Subject: Re: [PATCH V1] input: fix memory leak in da9052 touchscreen driver
> > Anthony Olech <anthony.olech.opensource@diasemi.com> wrote:
> > >The touchscreen component driver for the da9052/3 Dialog PMICs leaks
> > >memory by not freeing the input device in the remove call.
> > >This patch matches the existing call to input_alloc_device() in
> > >da9052_ts_probe() to a new call to input_free_device() in
> > >da9052_ts_remove()
> > >Suggested-by: Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>
> > >Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> > >---
> > >This patch is relative to linux-next repository tag next-20140108
> > >Many thanks to Huqiu Liu who found the bug.
> > No, this is not a bug. Please refer to input API spec in input.h
> > Thanks.
> 
> Hi Dmitry,
> the spec *seems* to say that if the allocation is done via devm_input_allocate_device(dev)
> then no explicit freeing must be done.
> 
> However that is not the case here, so the bug exists.

*sigh*

/**
 * input_free_device - free memory occupied by input_dev structure
 * @dev: input device to free
 *
 * This function should only be used if input_register_device()
 * was not called yet or if it failed. Once device was registered
 * use input_unregister_device() and memory will be freed once last
 * reference to the device is dropped.

THIS ^^^^^^^^^^^^^^^^^^^^

 *
 * Device should be allocated by input_allocate_device().
 *
 * NOTE: If there are references to the input device then memory
 * will not be freed until last reference is dropped.
 */

/**
 * input_allocate_device - allocate memory for new input device
 *
 * Returns prepared struct input_dev or %NULL.
 *
 * NOTE: Use input_free_device() to free devices that have not been
 * registered; input_unregister_device() should be used for already
 * registered devices.

and this ^^^^^^^^^^^^^^^^^^^^^^^^

 */

> 
> It does seem that there is an alternative way of resolving the issue, namely to:
> 1) change from allocate_device() to devm_input_allocate_device(dev) and
> 2) remove the exiosting input_free_device() from the error path in the probe() function

There is no issue, but if you want to convert the driver to using
managed resources that would be fine.

Thanks.

-- 
Dmitry
