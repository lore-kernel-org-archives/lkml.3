Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3ETOYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:24:41 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52586 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3ETOYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <519A00C7.6050208@gmail.com>
References: <1368982162-10126-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130519204552.GT18614@n2100.arm.linux.org.uk>
	<519A00C7.6050208@gmail.com>
Date: Mon, 20 May 2013 10:24:31 -0400
Message-ID: <CAF6AEGtTzkr3-stQj87s4fshRRR3STYbLiHYXsMcm4yem1ctkw@mail.gmail.com>
Subject: Re: [RFC] drm: i2c: add irq handler for tda998x slave encoder
From: Rob Clark <robdclark@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 6:53 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> On 05/19/2013 10:45 PM, Russell King - ARM Linux wrote:
>>
>> On Sun, May 19, 2013 at 06:49:22PM +0200, Sebastian Hesselbarth wrote:
>>>
>>> This adds an irq handler for HPD to the tda998x slave encoder driver
>>> to trigger HPD change instead of polling. The gpio connected to int
>>> pin of tda998x is passed through platform_data of the i2c client. As
>>> HPD will ultimately cause EDID read and that will raise an
>>> EDID_READ_DONE interrupt, the irq handling is done threaded with a
>>> workqueue to notify drm backend of HPD events.
>>>
>>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>>
>>
>> Okay, I think I get this..  Some comments:
>>
>>> +static irqreturn_t tda998x_irq_thread(int irq, void *data)
>>> +{
>>> +       struct drm_encoder *encoder = data;
>>> +       struct tda998x_priv *priv;
>>> +       uint8_t sta, cec, hdmi, lev;
>>> +
>>> +       if (!encoder)
>>> +               return IRQ_HANDLED;
>>
>>
>> This won't ever be NULL.  The IRQ layer stores the pointer you passed
>> in request_threaded_irq() and that pointer will continue to point at
>> that memory until the IRQ is freed.  The only way it could be NULL is
>> if you register using a NULL pointer.
>
>
> Russell,
>
> thanks for the comments. Of course, encoder can't be NULL here and I'll
> remove that check.
>
>
>> ...
>>>
>>> +       if (priv->irq<  0) {
>>> +               for (i = 100; i>  0; i--) {
>>> +                       uint8_t val = reg_read(encoder, REG_INT_FLAGS_2);
>>
>>
>> IRQ 0 is the cross-arch "no interrupt" number.  So just use !priv->irq
>> here and encourage anyone who uses -1 or NO_IRQ to fix their stuff. :)
>
>
> Ok, but gpio 0 still is a cross-arch valid gpio? ;)
>
>
>>> +       struct tda998x_priv *priv = to_tda998x_priv(encoder);
>>> +
>>> +       /* announce polling if no irq is available */
>>> +       if (priv->irq<  0)
>>
>>
>> Same here.
>>
>>> @@ -1122,7 +1197,9 @@ tda998x_encoder_init(struct i2c_client *client,
>>>
>>>         priv->current_page = 0;
>>>         priv->cec = i2c_new_dummy(client->adapter, 0x34);
>>> +       priv->irq = -EINVAL;
>>
>>
>> And just initialize to zero.  (it's allocated by kzalloc already right?
>> So that shouldn't be necessary.)
>>
>>> diff --git a/include/drm/i2c/tda998x.h b/include/drm/i2c/tda998x.h
>>> index 41f799f..1838703 100644
>>> --- a/include/drm/i2c/tda998x.h
>>> +++ b/include/drm/i2c/tda998x.h
>>> @@ -20,4 +20,8 @@ struct tda998x_encoder_params {
>>>         int swap_f, mirr_f;
>>>   };
>>>
>>> +struct tda998x_platform_data {
>>> +       int int_gpio;
>>> +};
>>> +
>>
>>
>> Should be combined with tda998x_encoder_params - the platform data is
>> really supposed to be passed to set_config - see this in
>> drm_encoder_slave.c:
>>
>>   * If @info->platform_data is non-NULL it will be used as the initial
>>   * slave config.
>> ...
>>          err = encoder_drv->encoder_init(client, dev, encoder);
>>          if (err)
>>                  goto fail_unregister;
>>
>>          if (info->platform_data)
>>                  encoder->slave_funcs->set_config(&encoder->base,
>>                                                   info->platform_data);
>>
>> So any platform data set will be passed into the set_config function...
>
>
> Sure, I'll put that into params. Will rebase my v1 PATCH on v3.10-rc1
> and that will create tda998x.h.
>
> But actually, this all raises the ultimate "how to deal with DT in drm"
> question: Currently, drm i2c slave encoders are registered within drm
> API which doesn't work well with DT nodes for those encoders.
>
> DT i2c adapters will register an i2c client and drm will try again in
> drm_i2c_encoder_init. Registering the i2c client again will cause it
> to fail because the i2c address is busy.
>
> Now, in drm_i2c_encoder_init we have access to the board_info struct
> that already offers .of_node which we could exploit here to not
> register another i2c client but try to get that already registered
> client or fall back to current behavior if NULL. of_node then could
> be set by the master encoder from e.g.
> "marvell,slave-encoder = <&tda998x>;".
>
> Or (and that is what I'd prefer) make use of the always empty i2c
> slave encoder _probe() as for any other i2c client. And hook up drm
> to a probed i2c client. That will also allow for the i2c client
> provide functions for other APIs, e.g. alsa.
>
> I am willing to dig into this, but would like to have a general
> opinion of David, Rob, and you.

I thing we probably want to re-visit the current way the i2c encoder
slave stuff works, to make for easier support of other sorts of
encoders, and possibly a starting point for shared panel drivers.
I've kinda been waiting to see how the common display/panel framework
stuff plays out, it's also possible that this would replace the i2c
encoder slave stuff.

BR,
-R

> Sebastian
