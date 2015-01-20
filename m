Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbbATKSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:18:09 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:40740 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbbATKSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:18:07 -0500
Date: Tue, 20 Jan 2015 10:17:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Wolfram Sang <wsa@the-dreams.de>,
        linux-mips@linux-mips.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] i2c: drop ancient protection against sysfs refcounting
 issues
Message-ID: <20150120101752.GI26493@n2100.arm.linux.org.uk>
References: <1421693756-12917-1-git-send-email-wsa@the-dreams.de>
 <20150119190142.GA9451@kroah.com>
 <20150119230427.GH26493@n2100.arm.linux.org.uk>
 <20150120014159.GA3349@kroah.com>
 <54BDFE30.5090303@metafoo.de>
 <20150120071256.GA18983@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120071256.GA18983@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 03:12:56PM +0800, Greg Kroah-Hartman wrote:
> On Tue, Jan 20, 2015 at 08:05:20AM +0100, Lars-Peter Clausen wrote:
> > On 01/20/2015 02:41 AM, Greg Kroah-Hartman wrote:
> > >On Mon, Jan 19, 2015 at 11:04:27PM +0000, Russell King - ARM Linux wrote:
> > >>On Tue, Jan 20, 2015 at 03:01:42AM +0800, Greg Kroah-Hartman wrote:
> > >>>On Mon, Jan 19, 2015 at 07:55:56PM +0100, Wolfram Sang wrote:
> > >>>>diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > >>>>index 39d25a8cb1ad..15cc5902cf89 100644
> > >>>>--- a/drivers/i2c/i2c-core.c
> > >>>>+++ b/drivers/i2c/i2c-core.c
> > >>>>@@ -41,7 +41,6 @@
> > >>>>  #include <linux/of_device.h>
> > >>>>  #include <linux/of_irq.h>
> > >>>>  #include <linux/clk/clk-conf.h>
> > >>>>-#include <linux/completion.h>
> > >>>>  #include <linux/hardirq.h>
> > >>>>  #include <linux/irqflags.h>
> > >>>>  #include <linux/rwsem.h>
> > >>>>@@ -1184,8 +1183,7 @@ EXPORT_SYMBOL_GPL(i2c_new_dummy);
> > >>>>
> > >>>>  static void i2c_adapter_dev_release(struct device *dev)
> > >>>>  {
> > >>>>-	struct i2c_adapter *adap = to_i2c_adapter(dev);
> > >>>>-	complete(&adap->dev_released);
> > >>>>+	/* empty, but the driver core insists we need a release function */
> > >>>
> > >>>Yeah, it does, but I hate to see this in "real" code as something is
> > >>>probably wrong with it if it happens.
> > >>>
> > >>>Please move the rest of 'i2c_del_adapter' into the release function
> > >>>(what was after the wait_for_completion() call), and then all should be
> > >>>fine.
> > >>
> > >>Are you sure about that?  Some drivers do this, eg,
> > >>
> > >>         i2c_del_adapter(&drv_data->adapter);
> > >>         free_irq(drv_data->irq, drv_data);
> > >>
> > >>where drv_data was allocated using devm_kzalloc(), and so will be
> > >>released when the ->remove callback (which calls the above
> > >>i2c_del_adapter()) returns... freeing the embedded device struct.
> > >
> > >But that will fail today if the memory is freed in i2c_del_adapter(), so
> > >there shouldn't be any change in logic here.
> > >
> > >Or am I missing something obvious?
> > 
> > The memory is not freed in i2c_del_adapter().
> 
> Right, and I'm not saying it should be, just move the existing logic
> into the release callback, and the code flow should be the same and we
> don't end up with an "empty" release callback.

IMHO there are two possibilities here:

1. leave it as-is, where we ensure that the remainder of i2c_del_adapter
   does not complete until the release callback has been called.

2. fix it properly by taking (eg) the netdev approach to i2c_adapter,
   or an alternative solution which results in decoupling the lifetime
   of the struct device from the i2c_adapter.

Either of these would be much better than removing the completion and
then moving a chunk of code to make it "look" safer than it actually is
and thereby introducing potential use-after-free bugs.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
