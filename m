Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbaISNEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:04:38 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:44502 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaISNEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:04:35 -0400
MIME-Version: 1.0
In-Reply-To: <1411105668-32722-2-git-send-email-mark.yao@rock-chips.com>
References: <1411105668-32722-1-git-send-email-mark.yao@rock-chips.com>
	<1411105668-32722-2-git-send-email-mark.yao@rock-chips.com>
Date: Fri, 19 Sep 2014 15:04:34 +0200
Message-ID: <CANq1E4Ti0yOQ+jCiXy7=NtFQ9cbWLOSLf6q-HWVdDFtMB1n29Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] drm/rockchip: Add basic drm driver
From: David Herrmann <dh.herrmann@gmail.com>
To: Mark yao <mark.yao@rock-chips.com>
Cc: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-rockchip@lists.infradead.org, dianders@chromium.org,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>, xjq@rock-chips.com,
        kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com,
        zyw@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com,
        kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Sep 19, 2014 at 7:47 AM, Mark yao <mark.yao@rock-chips.com> wrote:
[snip]
> +static int rockchip_drm_bind(struct device *dev)
> +{
> +       return drm_platform_init(&rockchip_drm_driver, to_platform_device(dev));

Please avoid drm_platform_*() usage. We're about to drop all the
drm_bus midlayers. See the tegra driver how to do it, but basically
just this:

struct drm_device *ddev;

ddev = drm_dev_alloc(&rockchip_drm_driver, &to_platform_device(dev)->dev);
if (!ddev)
        return -ENOMEM;

r = drm_dev_set_unique(ddev, dev_name(&ddev->dev));
if (r < 0) {
        drm_dev_unref(ddev);
        return r;
}

r = drm_dev_register(ddev);
if (r < 0) {
        drm_dev_unref(ddev);
        return r;
}

> +}
> +
> +static void rockchip_drm_unbind(struct device *dev)
> +{
> +       drm_put_dev(dev_get_drvdata(dev));

Please use:

struct drm_device *ddev = dev_get_drvdata(dev);

drm_dev_unregister(ddev);
drm_dev_unref(ddev);


Thanks
David
