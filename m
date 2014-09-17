Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaIQLDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:03:11 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:56904 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaIQLDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:03:08 -0400
Date: Wed, 17 Sep 2014 12:02:02 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: wsa@the-dreams.de, jdelvare@suse.de, arnd@arndb.de, dianders@chromium.org,
        sjg@chromium.org, laurent.pinchart+renesas@ideasonboard.com,
        u.kleine-koenig@pengutronix.de, boris.brezillon@free-electrons.com,
        maxime.coquelin@st.com, max.schwarz@online.de, schwidefsky@de.ibm.com,
        iivanov@mm-sol.com, jacob.jun.pan@linux.intel.com,
        soren.brinkmann@xilinx.com, bjorn.andersson@sonymobile.com,
        andrew@lunn.ch, skuribay@pobox.com, christian.ruppert@abilis.com,
        Romain.Baeriswyl@abilis.com, mika.westerberg@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c-designware: Intel BayTrail PMIC I2C bus support
Message-ID: <20140917120202.3b9058ae@alan.etchedpixels.co.uk>
In-Reply-To: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 10:36:07 -0700
"David E. Box" <david.e.box@linux.intel.com> wrote:

> +#if IS_ENABLED(CONFIG_I2C_SHARED_CONTROLLER)
> +extern int i2c_acquire_ownership(struct device *dev);
> +extern int i2c_release_ownership(struct device *dev);
> +#endif

You can just have the prototypes anyway - no need for more ifdefs than
required


> +#if IS_ENABLED(CONFIG_I2C_SHARED_CONTROLLER)
> +int i2c_shared_controller_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
> +	int num)
> +{
> +	struct dw_i2c_dev *dev = i2c_get_adapdata(adap);
> +	int err;
> +
> +	if (dev->shared_host) {
> +		err = dev->acquire_ownership(dev->dev);
> +		if (!err) {
> +			err = i2c_dw_xfer(adap, msgs, num);
> +			dev->release_ownership(dev->dev);
> +		} else
> +			dev_WARN(dev->dev, "couldnt acquire ownership\n");
> +
> +		return err;
> +	} else
> +		return i2c_dw_xfer(adap, msgs, num);
> +}
> +
> +static struct i2c_algorithm i2c_sc_algo = {
> +	.master_xfer	= i2c_shared_controller_xfer,
> +	.functionality	= i2c_dw_func,
> +};
> +#endif

I think this might be a lot cleaner if you put these pieces as functions
into i2c-designware-sem.c or a similar file and made the methods NULL
functions in the header in the case it's not supported ? Most of the
ifdeffery would then vanish into the extra file and keep the core code
cleaner ?


Alan
