Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaHHH0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:26:34 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40560 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaHHH0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:26:32 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-e6-53e47ba5a3a4
Message-id: <53E47B99.3040105@samsung.com>
Date: Fri, 08 Aug 2014 09:26:17 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        YoungJun Cho <yj44.cho@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Dual-channel DSI
References: <20140805153923.GA3072@ulmo.nvidia.com>
 <53E3227B.1010000@samsung.com> <20140807072530.GE17340@ulmo>
 <53E33B48.1080401@samsung.com> <20140807085424.GC13315@ulmo.nvidia.com>
In-reply-to: <20140807085424.GC13315@ulmo.nvidia.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xy7pLq58EGxzZwm9x4P1BFov5R86x
	Wlz5+p7NonPiEnaLy7vmsFn83DWPxWL9/FtsFnt3TmZ04PDYOesuu8fsjpmsHve7jzN59G1Z
	xehx/MZ2Jo/Pm+QC2KK4bFJSczLLUov07RK4Mm6ePMBaMNmhYtfls6wNjJ3GXYycHBICJhK9
	P7ewQNhiEhfurWcDsYUEljJKTLhc1MXIBWR/YpS403kSLMEroCWxbPUhMJtFQFXi9/EJYM1s
	ApoSfzffBIuLCoRJPPt1kAmiXlDix+R7YDUiAroS/0+/AbOZBXqZJE5ejAexhQVkJTZ8X8IC
	sWwPo8SCmUuZQRKcAqYSLz5tB7I5gBr0JO5f1ILolZfYvOYt8wRGgVlIVsxCqJqFpGoBI/Mq
	RtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJCw/7KDcfExq0OMAhyMSjy8BqfvBguxJpYVV+Ye
	YpTgYFYS4a35/DhYiDclsbIqtSg/vqg0J7X4ECMTB6dUA+OcRL9FG+/f79phEvt8yp/e8MLv
	R+xjNDafmLDo1205pveW3fnpDk8X/LLl5X6mOFdVtusFc9mZi9WnqrYf16q/sqfzzlvzlh9b
	IzvfZWw2dfoZenjtEpMmp5UXI/am7t62ZbGB1qxVGuflP0wPnLO0+NGFz211C9oOyFl3cb3b
	Ec57UObkUpe1SizFGYmGWsxFxYkAc1FRnFkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 10:54 AM, Thierry Reding wrote:
> On Thu, Aug 07, 2014 at 10:39:36AM +0200, Andrzej Hajda wrote:
>> On 08/07/2014 09:25 AM, Thierry Reding wrote:
>>> On Thu, Aug 07, 2014 at 08:53:47AM +0200, Andrzej Hajda wrote:
>>>> Hi Thierry,
>>>>
>>>> Nice case.
>>>>
>>>> On 08/05/2014 05:39 PM, Thierry Reding wrote:
>>>>> Hi everyone,
>>>>>
>>>>> I've been working on adding support for a panel that uses what's
>>>>> commonly known as dual-channel DSI. Sometimes this is referred to as
>>>>> ganged-mode as well.
>>>>>
>>>>> What is it, you ask? It's essentially a hack to work around the band-
>>>>> width restrictions of DSI, albeit one that's been commonly implemented
>>>>> by several SoC vendors.
>>>>>
>>>>> This typically works by equipping a peripheral with two DSI interfaces,
>>>>> each of which driving one half of the screen (symmetric left-right mode)
>>>>> or every other line (symmetric odd-even mode). Apparently there can be
>>>>> asymmetric modes in addition to those two, but they seem to be the
>>>>> common ones. Often both of the DSI interfaces need to be configured
>>>>> using DCS commands and vendor specific registers.
>>>>>
>>>>> A single display controller is typically used video data transmission.
>>>>> This is necessary to provide synchronization and avoid tearing and all
>>>>> kinds of other ugliness. For this to work both DSI controllers need to
>>>>> be made aware of which chunk of the video data stream is addressing
>>>>> them.
>>>>>
>>>>> From a software perspective, this poses two problems:
>>>>>
>>>>> 1) A dual-channel device is composed of two DSI peripheral devices which
>>>>>    cannot be programmed independently of each other. A typical example
>>>>>    is that the frame memory extents need to be configured differently
>>>>>    for each of the devices (using the DCS set_column_address and
>>>>>    set_page_address commands). Therefore each device must know of the
>>>>>    other, or there must be a driver that binds against a dummy device
>>>>>    that pulls in the two real devices.
>>>> I am not sure if I understand correctly, but I see it rather as one
>>>> device with two dsi-slave interfaces. Probably panel driver can
>>>> create dsi dummy device to program some registers
>>>> via second dsi interface but the panel will be attached to one control bus.
>>>> It seems to be very similar to mfd/i2c devices with two or more i2c
>>>> addresses.
>>> They are in fact attached to two different control busses. The DSI
>>> controllers that talk to each are separate. On Tegra they are the same
>>> type of IP block, but still two separate instances (with their own
>>> clock, reset, etc. inputs).
>>>
>>> So the panel driver can't create a dummy device to talk to the second
>>> DSI interface because the second DSI interface uses a different DSI
>>> host.
>> Why different DSI host does not allow that? The only thing panel needs
>> is the reference to another DSI host and this can be provided via
>> DT direct phandle or video interface.
> I'm sure one could find ways to make it work. That doesn't mean it's a
> good idea, though. The second peripheral is physically there on the
> second DSI host controller's bus, so it the device should be in device
> tree because so that the device tree matches reality.

The question is what is the reality? Do we have two separate dsi
devices? In such case
both devices should appear in DT.
If we have single device attached to two different DSI hosts I suppose
device should appear
only in one location in DT with link to another DSI host.

>
>>>>> 2) On the DSI host side, each of the controller instances needs to know
>>>>>    the intimate details of the other controller (or alternatively, one
>>>>>    controller needs to be a "master" and the other a "slave").
>>>> The question is if they need to communicate each other, or they have
>>>> to have similar configurations applied?
>>> On Tegra at least the configuration needs to be almost the same. There
>>> are two registers that may need to be programmed differently. But they
>>> don't have to communicate with each other. Essentially the two registers
>>> that require different programming define which parts of the display
>>> controller's data stream they need to capture and turn into DSI packets.
>>>
>>> Theoretically it would be possible to make this work with two completely
>>> different DSI controllers, but in practice I'd expect that to never
>>> happen. So I'm not sure we need to consider the case where the register
>>> layout is different between the two DSI host controllers.
>> So maybe the configuration could be provided by the panel.
> What configuration? I suppose one idea would be for the panel driver to
> set the type of dual-channel mode that it's using. Panels can typically
> be configured to do symmetric left-right or symmetric odd-even. I think
> technically it's possible to have asymmetric modes, too, but to be
> honest I don't want to think about those yet.
>
> So I think it's reasonable for the DSI device to provide information as
> to what mode it's using. Perhaps that could be done as part of the slave
> setup.
>
>>> I've come up with another alternative that works:
>>>
>>> 	dsi@54300000 {
>>> 		panel: panel@0 {
>>> 			compatible = "sharp,lq101r1sx01";
>>> 			reg = <0>;
>>> 		};
>>> 	};
>>>
>>> 	dsi@54400000 {
>>> 		panel@0 {
>>> 			compatible = "sharp,lq101r1sx01";
>>> 			reg = <0>;
>>>
>>> 			master = <&panel>;
>>> 		};
>>> 	};
>> But here you have again two compatibles and two devices in DT representing
>> one HW device.
> Because that's what they really are. There are two different devices,
> it's just that they happen to be driving two separate halves of the same
> panel.

Compatible string "sharp,lq101r1sx01" clearly indicates that there are
two panels of type LQ101R1SX01.
If you really want to split this panel as two separate devices maybe you
should probably use separate
compatibles to make it more clear, sth like: "sharp,lq101r1sx01_link1",
"sharp,lq101r1sx01_link2".
Anyway it looks odd to me :)

>
>> I am not sure if it is better. If you do not like video
>> interfaces
>> maybe better would be sth like this:
>>
>> 	dsi@54300000 {
>> 		panel: panel@0 {
>> 			compatible = "sharp,lq101r1sx01";
>> 			reg = <0>;
>> 			secondary_dsi = <&dsiB>;
>>  		};
>> 	};
>>
>> 	dsiB: dsi@54400000 {
>> 	};
> That's pretty much the same thing that I proposed, except that it
> reverses the link between the two.
For me it is fundamentally different - in your proposition you have two
different panels, in my you have only one, attached to one dsi with
phandle to 2nd dsi.
> In fact I tried something similar to
> that before, but it has a couple of problems: if the secondary device
> does not have a compatible string (that's probably not valid in device
> tree to begin with) then there's no way for the device to report what
> format it expects or what number of lanes it uses. But those are
> parameters that are needed to set up the DSI (and display controllers).

I2C has:
struct i2c_client *
i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)

DSI could have something similar, this way you could pass everything you
need.

>
> One other problem with the above is that the dependency implied by your
> "secondary_dsi" property is the wrong way around. The above would mean
> that &panel requires &dsiB's services to function, but that's not the
> case. If anything it's the other way around. &panel could still work
> standalone (though only drive the left half of the screen).

Why? Interpretation of the private property is up to this specific
binding documentation
and it can define the property optional. On the other side if the
property is present
and the panel driver cannot connect to dsiB it is up to the panel driver
what to do,
it can fail or continue to work with single dsi.

Summarizing it seems the core of the problem is to answer the question
if the panel should be represented
as single device or as two devices.


Regards
Andrzej

>
> Thierry

