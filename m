Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3JDCqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 22:46:52 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:45141 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3JDCqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 22:46:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAAQKjZNKLtqKK8eoKukHwARBMBYdWfHwxdWS-aU=YjYW+KU+Gg@mail.gmail.com>
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
 <1380839303-4834-1-git-send-email-seanpaul@chromium.org> <1380839303-4834-5-git-send-email-seanpaul@chromium.org>
 <CAAQKjZNKLtqKK8eoKukHwARBMBYdWfHwxdWS-aU=YjYW+KU+Gg@mail.gmail.com>
From: Sean Paul <seanpaul@chromium.org>
Date: Thu, 3 Oct 2013 22:41:27 -0400
Message-ID: <CAOw6vbKWjBL8jZ9iQ_Nk7-SmoTcTZ8TSMiwjOc2qT=HaJYFjAw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] drm/exynos: Initialize ptn3460 if present
To: Inki Dae <inki.dae@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 10:29 PM, Inki Dae <inki.dae@samsung.com> wrote:
> 2013/10/4 Sean Paul <seanpaul@chromium.org>:
>> This patch adds code to look for the ptn3460 in the device tree file on
>> exynos initialization. If ptn node is found, the driver will initialize
>> the ptn3460 driver and skip creating a DP connector (since the bridge
>> driver will register its own connector).
>>
>> Signed-off-by: Sean Paul <seanpaul@chromium.org>
>> ---
>>
>> v2:
>>         - Changed include from of_i2c.h to i2c.h
>>         - Changed of_find_by_name to of_find_compatible
>>
>>  drivers/gpu/drm/exynos/exynos_drm_core.c | 44 +++++++++++++++++++++++++++++++-
>>  1 file changed, 43 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_core.c b/drivers/gpu/drm/exynos/exynos_drm_core.c
>> index 1bef6dc..08ca4f9 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_core.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_core.c
>> @@ -12,7 +12,9 @@
>>   * option) any later version.
>>   */
>>
>> +#include <linux/i2c.h>
>>  #include <drm/drmP.h>
>> +#include <drm/bridge/ptn3460.h>
>>  #include "exynos_drm_drv.h"
>>  #include "exynos_drm_encoder.h"
>>  #include "exynos_drm_connector.h"
>> @@ -20,6 +22,40 @@
>>
>>  static LIST_HEAD(exynos_drm_subdrv_list);
>>
>> +struct bridge_init {
>> +       struct i2c_client *client;
>> +       struct device_node *node;
>> +};
>> +
>> +static bool find_bridge(const char *compat, struct bridge_init *bridge)
>> +{
>> +       bridge->client = NULL;
>> +       bridge->node = of_find_compatible_node(NULL, NULL, compat);
>
> Then, shouldn't the lvds-bridge driver be implemented as i2c driver so
> that such tricky isn't needed? Is there any reason you use such tricky
> codes?
>

This is what I was explaining earlier today. If the bridge driver is
just an i2c driver, it won't get a pointer to drm_device, and can't
register itself as a drm_bridge or drm_connector. To solve this, you
need the ptn3460_init callback.

If it's an i2c driver with the ptn3460_init callback, where it parses
the dt in probe, then you have a race between the ptn probe and the
ptn init/drm hooks. ie: it's possible drm will initialize and call
disable/post_disable/pre_enable/enable before things have been probed.
To solve this, you need to use some global state and/or locking.

So, to summarize. We can have this of_find_compatible with a init
callback, or we can have an i2c driver + global state/locking + init
callback. I chose the former, since it seemed easier.

If you have a better way to achieve this, I'm definitely interested,
but I saw this as the lesser of two evils.

Sean

> I think you need to implement the lvds-bridge driver as i2c driver,
> and then consider how to take care of this. I mean let's find a better
> way how we could take care of the i2c based driver in exynos drm
> framework or driver. In all cases, such tricky codes are not good.
>
>> +       if (!bridge->node)
>> +               return false;
>> +
>> +       bridge->client = of_find_i2c_device_by_node(bridge->node);
>> +       if (!bridge->client)
>> +               return false;
>> +
>> +       return true;
>> +}
>> +
>> +/* returns the number of bridges attached */
>> +static int exynos_drm_attach_lcd_bridge(struct drm_device *dev,
>> +               struct drm_encoder *encoder)
>> +{
>> +       struct bridge_init bridge;
>> +       int ret;
>> +
>> +       if (find_bridge("nxp,ptn3460", &bridge)) {
>> +               ret = ptn3460_init(dev, encoder, bridge.client, bridge.node);
>> +               if (!ret)
>> +                       return 1;
>> +       }
>> +       return 0;
>> +}
>> +
>>  static int exynos_drm_create_enc_conn(struct drm_device *dev,
>>                                         struct exynos_drm_subdrv *subdrv)
>>  {
>> @@ -36,6 +72,13 @@ static int exynos_drm_create_enc_conn(struct drm_device *dev,
>>                 DRM_ERROR("failed to create encoder\n");
>>                 return -EFAULT;
>>         }
>> +       subdrv->encoder = encoder;
>> +
>> +       if (subdrv->manager->display_ops->type == EXYNOS_DISPLAY_TYPE_LCD) {
>> +               ret = exynos_drm_attach_lcd_bridge(dev, encoder);
>> +               if (ret)
>> +                       return 0;
>> +       }
>>
>>         /*
>>          * create and initialize a connector for this sub driver and
>> @@ -48,7 +91,6 @@ static int exynos_drm_create_enc_conn(struct drm_device *dev,
>>                 goto err_destroy_encoder;
>>         }
>>
>> -       subdrv->encoder = encoder;
>>         subdrv->connector = connector;
>>
>>         return 0;
>> --
>> 1.8.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
