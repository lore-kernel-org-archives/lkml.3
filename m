Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab3JHIq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:46:29 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:53134 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155Ab3JHIqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:46:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zzbb2dIdb82h98dI9371I936eIc3f2I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097h186068h8275dhz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
Message-ID: <5253C63D.5030904@freescale.com>
Date: Tue, 8 Oct 2013 16:45:49 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <joe@perches.com>, <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCHv6 02/16] drivers: thermal: introduce device tree parser
References: <1379537849-28425-1-git-send-email-eduardo.valentin@ti.com> <1379540136-28378-1-git-send-email-eduardo.valentin@ti.com> <52428D13.7080007@freescale.com> <5242F011.4090607@ti.com>
In-Reply-To: <5242F011.4090607@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 10:15 PM, Eduardo Valentin wrote:
> On 25-09-2013 03:13, Hongbo Zhang wrote:
>> On 09/19/2013 05:35 AM, Eduardo Valentin wrote:
>>>    [...]
>>> +
>>> +/***   sensor API   ***/
>>> +
>> You are introducing new concept here, the original framework and drivers
>> cannot use this, right? any further plan to update original framework
>> for this new feature?
>>
> Well, not new as such. Just a specific way to register sensors to
> thermal framework. What is really new is the fact that we really need to
> have sensors decoupled from thermal zone devices, and today we have
> these concepts pretty merged together.
> To answer your question, for now I am more concerned with the bindings
> definition. Once that is at least agreed, then we can follow up with the
> migration of existing drivers. For now, there are two examples in this
> series, first one is using one existing thermal driver, which is the TI
> SoC thermal driver, and the second one is the hwmon drivers, which are
> existing sensor drivers, but are not thermal drivers.
>
> The plan forward, once this series is accepted is to migrate existing
> drivers, yes, so that they can use device tree uniformly. Of course,
> this needs help from driver authors.
>
> My proposal will be to follow up this series with a two fold migration.
> First step to change the existing thermal drivers to have both, the
> current support and the device tree support. And second step, for those
> who wish to, we could remove the old code containing thermal data and
> have only dt support. Of course, this requires drivers authors input.
>
>
>
>>> +static struct thermal_zone_device *
>>> +thermal_zone_of_add_sensor(struct device_node *zone,
>>> +               struct device_node *sensor, void *data,
>>> +               int (*get_temp)(void *, long *),
>>> +               int (*get_trend)(void *, long *))
>>> +{
>>> +    struct thermal_zone_device *tzd;
>>> +    struct __thermal_zone *tz;
>>> +
>>> +    tzd = thermal_zone_get_zone_by_name(zone->name);
>>> +    if (IS_ERR(tzd))
>>> +        return ERR_PTR(-EPROBE_DEFER);
>>> +
>>> [...]
>>> +
>>> +/*
>>> + * Here are the thermal trip types. This must
>>> + * match with enum thermal_trip_type at
>>> + * include/linux/thermal.h
>>> + */
>>> +#define THERMAL_TRIP_ACTIVE        0
>>> +#define THERMAL_TRIP_PASSIVE        1
>>> +#define THERMAL_TRIP_HOT        2
>>> +#define THERMAL_TRIP_CRITICAL        3
>>> +
>> These macros seem duplicated with enum thermal_trip_type in thermal.h,
>> do you have further plan to merge them?
>> Or by using string "active",  "passive" etc in the dts, then you can
>> reuse the original enum definition.
> I am changing this so that in DT we have string constants, and we keep a
> map from string to enum, just like we have for phy-mode, as suggested by
> Mark.
>
> You can have a taste of it here:
> https://git.kernel.org/cgit/linux/kernel/git/evalenti/linux.git/commit/?h=thermal_work/thermal_core/dt_parser_rfc_v4&id=73f16c27fc763495188fba7d6e17b9c986efc6ac
>
> I will be reposting this version once we are done with this thread
> discussion and I am finished with my current test.
>
> If you have the time, I would appreciate if you could try the series on
> your board, as I am don't have access to your hardware. It would be
> really nice to see how this work is behaving in other environments then
> the one I have.

We have thermal management plan in next year, currently I don't have 
proper board to test this.
I would like to do it when I have time and board, but I will track these 
thermal treads.
>
> Thanks for your interest in this work.
>
>>> +/* On cooling devices upper and lower limits */
>>> +#define THERMAL_NO_LIMIT        (-1UL)
>>> +
>>> +#endif
>>> [...]
>>
>>
>>
>



