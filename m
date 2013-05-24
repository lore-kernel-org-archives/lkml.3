Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3EXLLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:11:43 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:46558 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3EXLLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:11:40 -0400
Message-ID: <519F4AE7.8000003@gmail.com>
Date: Fri, 24 May 2013 13:11:35 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH RFC v2] media: OF: add sync-on-green endpoint property
References: <1368710287-8741-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1368710287-8741-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prabhakar,

On 05/16/2013 03:18 PM, Lad Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> This patch adds "sync-on-green" property as part of
> endpoint properties and also support to parse them in the parser.

> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -101,6 +101,8 @@ Optional endpoint properties
>     array contains only one entry.
>   - clock-noncontinuous: a boolean property to allow MIPI CSI-2 non-continuous
>     clock mode.
> +-sync-on-green: a boolean property indicating to sync with the green signal in
> + RGB.

Are you sure this is what you need for the TVP7002 chip ?

I think we should differentiate between analog and digital signals and 
the related
device's configuration. AFAIU for the analog part there can be various video
sychronisation methods, i.e. ways in which the synchronisation signals are
transmitted along side the video component (RGB or luma/chroma) signals. 
According
to [1] (presumably not most reliable source of information) there are 
following
methods of transmitting sync signals:

  - Separate sync
  - Composite sync
  - Sync-on-green (SOG)
  - Sync-on-luminance
  - Sync-on-composite

And all these seem to refer to analog video signal.

 From looking at Figure 8 "TVP7002 Application Example" in the TVP7002's 
datasheet
([2], p. 52) and your initial TVP7002 patches it looks like what you 
want is to
specify polarity of the SOGOUT signal, so the processor that receives 
this signal
can properly interpret it, is it correct ?

If so then wouldn't it be more appropriate to define e.g. 'sog-active' 
property
and media bus flags:
	V4L2_MBUS_SYNC_ON_GREEN_ACTIVE_LOW
	V4L2_MBUS_SYNC_ON_GREEN_ACTIVE_HIGH
?

And for synchronisation method on the analog part we could perhaps define
'component-sync' or similar property that would enumerate all possible
synchronisation methods. We might as well use separate boolean properties,
but I'm a bit concerned about the increasing number of properties that need
to be parsed for each parallel video bus "endpoint".

Anyway I'm not sure if we would already have use cases for the 
'component-sync'
property.

[1] http://en.wikipedia.org/wiki/Component_video_sync
[2] 
http://www.ti.com/general/docs/lit/getliterature.tsp?genericPartNumber=tvp7002&fileType=pdf

>   Example
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index aa59639..b51d61f 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -100,6 +100,9 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>   	if (!of_property_read_u32(node, "data-shift",&v))
>   		bus->data_shift = v;
>
> +	if (of_get_property(node, "sync-on-green",&v))
> +		flags |= V4L2_MBUS_SYNC_ON_GREEN;
> +
>   	bus->flags = flags;
>
>   }
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 83ae07e..cf2c66f9 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -40,6 +40,7 @@
>   #define V4L2_MBUS_FIELD_EVEN_HIGH		(1<<  10)
>   /* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
>   #define V4L2_MBUS_FIELD_EVEN_LOW		(1<<  11)
> +#define V4L2_MBUS_SYNC_ON_GREEN		(1<<  12)

--
Regards,
Sylwester
