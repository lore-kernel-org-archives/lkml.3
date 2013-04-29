Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab3D2Ls0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:48:26 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36032 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab3D2LsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:48:24 -0400
MIME-Version: 1.0
In-Reply-To: <3228007.esFOONCu9m@avalon>
References: <1367222401-26649-1-git-send-email-prabhakar.csengg@gmail.com> <3228007.esFOONCu9m@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 29 Apr 2013 17:18:02 +0530
Message-ID: <CA+V-a8ubM9NXA4XNACjXiO1RKRzVmaXOdoM4EyPx96m7S=ffVw@mail.gmail.com>
Subject: Re: [PATCH RFC] media: i2c: mt9p031: add OF support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Mon, Apr 29, 2013 at 5:05 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch. Please see below for a couple of comments in addition
> to the ones I've just sent (in reply to Sascha's e-mail).
>
Yep fixed them all.

 [snip]
>
>> ---
>>  .../devicetree/bindings/media/i2c/mt9p031.txt      |   43 ++++++++++++++
>>  drivers/media/i2c/mt9p031.c                        |   61 ++++++++++++++++-
>>  2 files changed, 103 insertions(+), 1 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9p031.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
>> b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt new file mode
>> 100644
>> index 0000000..b985e63
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
>> @@ -0,0 +1,43 @@
>> +* Aptina 1/2.5-Inch 5Mp CMOS Digital Image Sensor
>> +
>> +The Aptina MT9P031 is a 1/2.5-inch CMOS active pixel digital image sensor
>> +with an active imaging pixel array of 2592H x 1944V. It incorporates
>> +sophisticated camera functions on-chip such as windowing, column and row
>> +skip mode, and snapshot mode. It is programmable through a simple two-wire
>> +serial interface.
>> +The MT9P031 is a progressive-scan sensor that generates a stream of pixel
>> +data at a constant frame rate. It uses an on-chip, phase-locked loop (PLL)
>> +to generate all internal clocks from a single master input clock running
>> +between 6 and 27 MHz. The maximum pixel rate is 96 Mp/s, corresponding to
>> +a clock rate of 96 MHz.
>
> Isn't this text (directly copied from the datasheet) under Aptina's copyright
> ?
>
hmm :) do you want me change it ?

>> +Required Properties :
>> +- compatible : value should be either one among the following
>> +     (a) "aptina,mt9p031-sensor" for mt9p031 sensor
>> +     (b) "aptina,mt9p031m-sensor" for mt9p031m sensor
>> +
>> +- ext_freq: Input clock frequency.
>> +
>> +- target_freq:  Pixel clock frequency.
>> +
>> +Optional Properties :
>> +-reset: Chip reset GPIO (If not specified defaults to -1)
>> +
>> +Example:
>> +
>> +i2c0@1c22000 {
>> +     ...
>> +     ...
>> +     mt9p031@5d {
>> +             compatible = "aptina,mt9p031-sensor";
>> +             reg = <0x5d>;
>> +
>> +             port {
>> +                     mt9p031_1: endpoint {
>> +                             ext_freq = <6000000>;
>> +                             target_freq = <96000000>;
>> +                     };
>> +             };
>> +     };
>> +     ...
>> +};
>> \ No newline at end of file
>> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
>> index 28cf95b..66078a6 100644
>> --- a/drivers/media/i2c/mt9p031.c
>> +++ b/drivers/media/i2c/mt9p031.c
>> @@ -23,11 +23,13 @@
>>  #include <linux/regulator/consumer.h>
>>  #include <linux/slab.h>
>>  #include <linux/videodev2.h>
>> +#include <linux/of_device.h>
>>
>>  #include <media/mt9p031.h>
>>  #include <media/v4l2-chip-ident.h>
>>  #include <media/v4l2-ctrls.h>
>>  #include <media/v4l2-device.h>
>> +#include <media/v4l2-of.h>
>>  #include <media/v4l2-subdev.h>
>>
>>  #include "aptina-pll.h"
>> @@ -928,10 +930,66 @@ static const struct v4l2_subdev_internal_ops
>> mt9p031_subdev_internal_ops = { * Driver initialization and probing
>>   */
>>
>> +#if defined(CONFIG_OF)
>> +static const struct of_device_id mt9p031_of_match[] = {
>> +     {.compatible = "aptina,mt9p031-sensor", },
>> +     {.compatible = "aptina,mt9p031m-sensor", },
>
> As you'll need to resubmit anyway, please add a space between '{' and '.'
>
OK

>> +     {},
>> +};
>> +MODULE_DEVICE_TABLE(of, mt9p031_of_match);
>> +
[Snip]
>> -     struct mt9p031_platform_data *pdata = client->dev.platform_data;
>> +     struct mt9p031_platform_data *pdata = mt9p031_get_pdata(client);
>>       struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
>>       struct mt9p031 *mt9p031;
>>       unsigned int i;
>> @@ -1072,6 +1130,7 @@ MODULE_DEVICE_TABLE(i2c, mt9p031_id);
>>
>>  static struct i2c_driver mt9p031_i2c_driver = {
>>       .driver = {
>> +             .of_match_table = mt9p031_of_match,
>
> You can use the of_match_ptr() macro instead of defining mt9p031_of_match as
> NULL above.
>
Ok

Regards,
--Prabhakar Lad
