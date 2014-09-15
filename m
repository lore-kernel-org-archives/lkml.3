Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaIOQ6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:58:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:40552 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaIOQ6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:58:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,529,1406617200"; 
   d="scan'208";a="603131927"
Date: Mon, 15 Sep 2014 09:55:45 -0700
From: "David E. Box" <david.e.box@linux.intel.com>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: wsa@the-dreams.de, jdelvare@suse.de, arnd@arndb.de, dianders@chromium.org,
        sjg@chromium.org, laurent.pinchart+renesas@ideasonboard.com,
        u.kleine-koenig@pengutronix.de, boris.brezillon@free-electrons.com,
        max.schwarz@online.de, schwidefsky@de.ibm.com, iivanov@mm-sol.com,
        jacob.jun.pan@linux.intel.com, soren.brinkmann@xilinx.com,
        bjorn.andersson@sonymobile.com, andrew@lunn.ch, skuribay@pobox.com,
        christian.ruppert@abilis.com, Romain.Baeriswyl@abilis.com,
        mika.westerberg@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c-designware: Intel BayTrail PMIC I2C bus support
Message-ID: <20140915165545.GA2039@pathfinder>
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
 <54168DE2.8020303@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54168DE2.8020303@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Mon, Sep 15, 2014 at 08:57:38AM +0200, Maxime Coquelin wrote:

> >+		err = dev->acquire_ownership(dev->dev);
> Have you considered using hwspinlocks instead?

No, I've not used it before but it looks applicable here. I'll take a look.

> >@@ -212,6 +259,25 @@ static int dw_i2c_probe(struct platform_device *pdev)
> >  	adap->dev.parent = &pdev->dev;
> >  	adap->dev.of_node = pdev->dev.of_node;
> >
> >+#if IS_ENABLED(CONFIG_I2C_SHARED_CONTROLLER)
> >+	if (dev->shared_host)
> >+		adap->algo = &i2c_sc_algo;
> >+
> >+	r = i2c_add_numbered_adapter(adap);
> >+	if (r) {
> >+		dev_err(&pdev->dev, "failure adding adapter\n");
> >+		return r;
> >+	}
> >+
> >+	if (dev->shared_host)
> >+		pm_runtime_forbid(&pdev->dev);
> >+	else {
> >+		pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
> >+		pm_runtime_use_autosuspend(&pdev->dev);
> >+		pm_runtime_set_active(&pdev->dev);
> >+		pm_runtime_enable(&pdev->dev);
> >+	}
> >+#else
> Why do you put all this under config flags?

So that this additional code only compiles for this very specific
implementation.

> >@@ -268,7 +334,11 @@ static int dw_i2c_resume(struct device *dev)
> >  	struct dw_i2c_dev *i_dev = platform_get_drvdata(pdev);
> >
> >  	clk_prepare_enable(i_dev->clk);
> >-	i2c_dw_init(i_dev);
> >+
> >+#if IS_ENABLED(CONFIG_I2C_SHARED_CONTROLLER)
> >+	if (!i_dev->shared_host)
> >+#endif
> Putting this under config flag should not be needed.
> 
> And even not under config flags, why don't you re-initialize your
> device in case of resume?

Because the device is already being managed by hardware, not the OS.

David Box
