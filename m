Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbaKSNRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:17:43 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48904 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbaKSNRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:17:37 -0500
Date: Wed, 19 Nov 2014 14:17:58 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Mark yao <mark.yao@rock-chips.com>, Mark Rutland <mark.rutland@arm.com>,
        heiko@sntech.de, linux-doc@vger.kernel.org, kever.yang@rock-chips.com,
        dri-devel@lists.freedesktop.org, dianders@chromium.org,
        linux-api@vger.kernel.org, xxm@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>, huangtao@rock-chips.com,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, yxj@rock-chips.com,
        cf@rock-chips.com, Rob Herring <robh+dt@kernel.org>,
        marcheu@chromium.org, xw@rock-chips.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v12 1/3] drm: rockchip: Add basic drm driver
Message-ID: <20141119131758.GN25711@phenom.ffwll.local>
Mail-Followup-To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Mark yao <mark.yao@rock-chips.com>,
	Mark Rutland <mark.rutland@arm.com>, heiko@sntech.de,
	linux-doc@vger.kernel.org, kever.yang@rock-chips.com,
	dri-devel@lists.freedesktop.org, dianders@chromium.org,
	linux-api@vger.kernel.org, xxm@rock-chips.com,
	linux-rockchip@lists.infradead.org,
	Grant Likely <grant.likely@linaro.org>, huangtao@rock-chips.com,
	devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>, yxj@rock-chips.com,
	cf@rock-chips.com, Rob Herring <robh+dt@kernel.org>,
	marcheu@chromium.org, xw@rock-chips.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	Kumar Gala <galak@codeaurora.org>
References: <1416297587-18959-1-git-send-email-mark.yao@rock-chips.com>
 <1416297629-19024-1-git-send-email-mark.yao@rock-chips.com>
 <20141118083234.GZ25711@phenom.ffwll.local>
 <20141118142130.6c12ab50@bbrezillon>
 <20141118142447.GC25711@phenom.ffwll.local>
 <546BEDD9.1000205@rock-chips.com>
 <546BFA4D.3090700@rock-chips.com>
 <20141119100413.7ab613e9@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119100413.7ab613e9@bbrezillon>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:04:13AM +0100, Boris Brezillon wrote:
> AFAIU, the suggestion was to split drm_connector_init and
> drm_connector_register calls:
>  - drm_connector_init call should still be part of the load procedure
>    (this function adds the connector to the connector list which is used
>    by drm_mode_group_init_legacy_group)
>  - drm_connector_register should be called after the device has been
>    registered
> 
> Here what I've done and it seems to work:
> 
> static int atmel_hlcdc_dc_connector_plug_all(struct drm_device *dev)
> {
> 	struct drm_connector *connector, *failed;
> 	int ret;
> 
> 	mutex_lock(&dev->mode_config.mutex);
> 	list_for_each_entry(connector,
> 	&dev->mode_config.connector_list, head) { ret =
> 	drm_connector_register(connector); if (ret) {
> 			failed = connector;
> 			goto err;
> 		}
> 	}
> 	mutex_unlock(&dev->mode_config.mutex);
> 	return 0;
> 
> err:
> 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
> 		if (failed == connector)
> 			break;
> 
> 		drm_connector_unregister(connector);
> 	}
> 	mutex_unlock(&dev->mode_config.mutex);
> 
> 	return ret;
> }
> 
> [...]
> 
> static int atmel_hlcdc_dc_drm_probe(struct platform_device *pdev)
> {
> 	struct drm_device *ddev;
> 	int ret;
> 
> 	ddev = drm_dev_alloc(&atmel_hlcdc_dc_driver, &pdev->dev);
> 	if (!ddev)
> 		return -ENOMEM;
> 
> 	ret = drm_dev_set_unique(ddev, dev_name(ddev->dev));
> 	if (ret)
> 		goto err_unref;
> 
> 	ret = atmel_hlcdc_dc_load(ddev);
> 	if (ret)
> 		goto err_unref;
> 
> 	ret = drm_dev_register(ddev, 0);
> 	if (ret)
> 		goto err_unload;
> 
> 	ret = atmel_hlcdc_dc_connector_plug_all(ddev);
> 	if (ret)
> 		goto err_unregister;
> 
> 	return 0;
> 
> err_unregister:
> 	drm_dev_unregister(ddev);
> 
> err_unload:
> 	atmel_hlcdc_dc_unload(ddev);
> 
> err_unref:
> 	drm_dev_unref(ddev);
> 
> 	return ret;
> }
> 
> Daniel, can you confirm that's what you had in mind ?

Yup. To be able to have race-free driver load we need to split object
into an _init step (allocates structs and links to kernel-internal lists)
and _register (makes the object userspace-visible through sysfs and
dev-node kms object lookup idr).

This entire mess is all still fallout from the dark ages of the drm
midlayer and we'll probably have fun with this for another few years ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
