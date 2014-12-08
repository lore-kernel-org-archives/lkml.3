Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaLHSFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:05:07 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:51781 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaLHSFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:05:05 -0500
MIME-Version: 1.0
In-Reply-To: <20141208132827.GA13942@ulmo.nvidia.com>
References: <1417815001-9883-1-git-send-email-hali@codeaurora.org>
	<20141208132827.GA13942@ulmo.nvidia.com>
Date: Mon, 8 Dec 2014 13:05:04 -0500
Message-ID: <CAF6AEGtLS39vzFHaKTvSqFmZaGUC8hbGLT_yjD8b2gMVTfJOXg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/msm: Initial add eDP support in msm drm driver (V2)
From: Rob Clark <robdclark@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Hai Li <hali@codeaurora.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 8:28 AM, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Fri, Dec 05, 2014 at 04:30:00PM -0500, Hai Li wrote:
> [...]
>
>> +     if (IS_ERR(edp))
>> +             return PTR_ERR(edp);
>> +     priv->edp = edp;
>> +
>> +     return 0;
>> +}
>> +
>> +static void edp_unbind(struct device *dev, struct device *master,
>> +             void *data)
>
> We typically align parameters on subsequent lines with the first
> parameter on the first line. But perhaps Rob doesn't care so much.

no, I don't.. and aligned params is kinda annoying if function name or
return type changes make it get out of alignment ;-)

but either way is fine

[snip]

>> +/* Second part of initialization, the drm/kms level modeset_init */
>> +int msm_edp_modeset_init(struct msm_edp *edp,
>> +             struct drm_device *dev, struct drm_encoder *encoder)
>> +{
>> +     struct platform_device *pdev = edp->pdev;
>> +     struct msm_drm_private *priv = dev->dev_private;
>> +     int ret;
>> +
>> +     edp->encoder = encoder;
>> +     edp->dev = dev;
>> +
>> +     edp->bridge = msm_edp_bridge_init(edp);
>> +     if (IS_ERR(edp->bridge)) {
>> +             ret = PTR_ERR(edp->bridge);
>> +             dev_err(dev->dev, "failed to create eDP bridge: %d\n", ret);
>> +             edp->bridge = NULL;
>> +             goto fail;
>> +     }
>> +
>> +     edp->connector = msm_edp_connector_init(edp);
>> +     if (IS_ERR(edp->connector)) {
>> +             ret = PTR_ERR(edp->connector);
>> +             dev_err(dev->dev, "failed to create eDP connector: %d\n", ret);
>> +             edp->connector = NULL;
>> +             goto fail;
>> +     }
>> +
>> +     edp->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
>
> Why not use the more idiomatic platform_get_irq()?

It may have been a quirk of the downstream 3.10 kernel that I also
have to deal with for some devices, but I couldn't get
platform_get_irq() to work and so used irq_of_parse_and_map() in the
hdmi code.  I assume eDP would have the identical problem.

>> +     if (edp->irq < 0) {
>> +             ret = edp->irq;
>> +             dev_err(dev->dev, "failed to get irq: %d\n", ret);
>
> s/irq/IRQ/
>
>> diff --git a/drivers/gpu/drm/msm/edp/edp.h b/drivers/gpu/drm/msm/edp/edp.h
> [...]
>> +#ifndef __EDP_CONNECTOR_H__
>> +#define __EDP_CONNECTOR_H__
>> +
>> +#include <linux/clk.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/of_gpio.h>
>> +#include <linux/pwm.h>
>> +#include <linux/i2c.h>
>
> These should be alphabetically sorted.
>
>> diff --git a/drivers/gpu/drm/msm/edp/edp_aux.c b/drivers/gpu/drm/msm/edp/edp_aux.c
> [...]
>> +#define to_edp_aux(x) container_of(x, struct edp_aux, drm_aux)
>
> Perhaps this should be a static inline function for better type safety.
>

#define is at least consistent w/ rest of drm/msm code (and
obj_to_xyz() in drm core)..  although if misused it probably gives a
more confusing compile error compared to static inline fxn.

I wouldn't reject a patch that converted them all to static inline
fxns, but I think this is ok as-is

[snip]

>
>> +static int edp_sink_power_state(struct edp_ctrl *ctrl, u8 state)
>> +{
>> +     u8 s = state;
>> +
>> +     DBG("%d", s);
>> +
>> +     if (ctrl->dp_link.revision < 0x11)
>> +             return 0;
>> +
>> +     if (drm_dp_dpcd_write(ctrl->drm_aux, DP_SET_POWER, &s, 1) < 1) {
>> +             pr_err("%s: Set power state to panel failed\n", __func__);
>> +             return -ENOLINK;
>> +     }
>> +
>> +     return 0;
>> +}
>
> This is essentially drm_dp_link_power_up()/drm_dp_link_power_down().
> Please use common code where available. And if it's not available yet
> the code is completely generic, please add a core function so that
> other drivers can reuse it.

jfyi, I already have a patch that rips this back out and uses core
functions, once drm_dp_link_power_down() is merged ;-)

[snip]

>> +irqreturn_t msm_edp_ctrl_irq(struct edp_ctrl *ctrl)
>> +{
> [...]
>> +     if (isr1 & EDP_INTERRUPT_REG_1_HPD)
>> +             DBG("edp_hpd");
>
> Don't you want to handle this?
>
>> +
>> +     if (isr2 & EDP_INTERRUPT_REG_2_READY_FOR_VIDEO)
>> +             DBG("edp_video_ready");
>> +
>> +     if (isr2 & EDP_INTERRUPT_REG_2_IDLE_PATTERNs_SENT) {
>
> s/PATTERNs/PATTERNS/? I was going to make that comment to the definition
> of this define, but I can't seem to find it. I suspect that it comes
> from one of the generated headers, but I can't seem to find either the
> generated header nor the XML.

yes, it is generated..

fyi: https://github.com/freedreno/envytools/tree/master/rnndb

>
>> +             DBG("idle_patterns_sent");
>> +             complete(&ctrl->idle_comp);
>> +     }
>> +
>> +     msm_edp_aux_irq(ctrl->aux, isr1);
>> +
>> +     return IRQ_HANDLED;
>> +}
> [...]
>> +bool msm_edp_ctrl_panel_connected(struct edp_ctrl *ctrl)
>> +{
>> +     bool ret;
>
> This is unnecessary, the only place where this is used is to return the
> value of ctrl->edp_connected. You can use that directly instead.
>
> [...]
>> +     ret = ctrl->edp_connected;
>> +     mutex_unlock(&ctrl->dev_mutex);
>> +
>> +     return ret;
>> +}
>> +
>> +int msm_edp_ctrl_get_edid(struct edp_ctrl *ctrl,
>> +             struct drm_connector *connector, struct edid **edid)
>> +{
>> +     int ret = 0;
>> +
>> +     mutex_lock(&ctrl->dev_mutex);
>> +
>> +     if (ctrl->edid) {
>> +             if (edid) {
>> +                     DBG("Just return edid buffer");
>> +                     *edid = ctrl->edid;
>> +             }
>> +             goto unlock_ret;
>> +     }
>
> Is there a way to invalidate an existing EDID?

fwiw, the existing code looks to be enough for fixed eDP panels, but
doesn't really handle unplug (so some of the stale-edid issues
wouldn't crop up yet)..

I am ok will adding full blown DP hot(un)plug as a later patch, but
there are going to be a couple spots where we need to be careful about
stale EDID, etc..


BR,
-R
