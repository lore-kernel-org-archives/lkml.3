Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaHGGyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:54:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46644 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaHGGyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:54:01 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-32-53e32285c676
Message-id: <53E3227B.1010000@samsung.com>
Date: Thu, 07 Aug 2014 08:53:47 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        YoungJun Cho <yj44.cho@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Dual-channel DSI
References: <20140805153923.GA3072@ulmo.nvidia.com>
In-reply-to: <20140805153923.GA3072@ulmo.nvidia.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xK7qtSo+DDR7N0bM48P4gi8X8I+dY
	La58fc9m0TlxCbvF5V1z2Cx+7prHYrF+/i02i707JzM6cHjsnHWX3WN2x0xWj/vdx5k8+ras
	YvQ4fmM7k8fnTXIBbFFcNimpOZllqUX6dglcGTuuf2Yu6DWvuL5pGUsD4zbNLkZODgkBE4n7
	d/cxQthiEhfurWfrYuTiEBJYyijRsus5WEJI4BOjxMIdMSA2r4CWxOz3d9hAbBYBVYmdN/6z
	gthsApoSfzffBIuLCoRJPPt1kAmiXlDix+R7LCBDRQTuMkrsf34JrIFZIF5i9coLYAuEBWQl
	NnxfwgKxzFhi/sNzYM2cQNd9azzL3sXIAVSvJ3H/ohZEq7zE5jVvmScwCsxCsmIWQtUsJFUL
	GJlXMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE/ZcdjIuPWR1iFOBgVOLhNTh9N1iINbGs
	uDL3EKMEB7OSCO8rvsfBQrwpiZVVqUX58UWlOanFhxiZODilGhjlcvV/hu+8ntOa7HWfr7c1
	jGNmpqqTfHNCXr/9m1T5xdeOnr/z6k/N9/omv7MaHm823Xu9OKSk7NF1ze8bm6vZjjYyl997
	42Jcr2UZeNLnwfSpJ25M91g3MYgxJXZhYZPumkWl6+NuX2ezW196QHXWDevLGakqqly7Uh6b
	mfrcfnhX1fvi5a9KLMUZiYZazEXFiQDupC32WQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Nice case.

On 08/05/2014 05:39 PM, Thierry Reding wrote:
> Hi everyone,
>
> I've been working on adding support for a panel that uses what's
> commonly known as dual-channel DSI. Sometimes this is referred to as
> ganged-mode as well.
>
> What is it, you ask? It's essentially a hack to work around the band-
> width restrictions of DSI, albeit one that's been commonly implemented
> by several SoC vendors.
>
> This typically works by equipping a peripheral with two DSI interfaces,
> each of which driving one half of the screen (symmetric left-right mode)
> or every other line (symmetric odd-even mode). Apparently there can be
> asymmetric modes in addition to those two, but they seem to be the
> common ones. Often both of the DSI interfaces need to be configured
> using DCS commands and vendor specific registers.
>
> A single display controller is typically used video data transmission.
> This is necessary to provide synchronization and avoid tearing and all
> kinds of other ugliness. For this to work both DSI controllers need to
> be made aware of which chunk of the video data stream is addressing
> them.
>
> From a software perspective, this poses two problems:
>
> 1) A dual-channel device is composed of two DSI peripheral devices which
>    cannot be programmed independently of each other. A typical example
>    is that the frame memory extents need to be configured differently
>    for each of the devices (using the DCS set_column_address and
>    set_page_address commands). Therefore each device must know of the
>    other, or there must be a driver that binds against a dummy device
>    that pulls in the two real devices.

I am not sure if I understand correctly, but I see it rather as one
device with two dsi-slave interfaces. Probably panel driver can
create dsi dummy device to program some registers
via second dsi interface but the panel will be attached to one control bus.
It seems to be very similar to mfd/i2c devices with two or more i2c
addresses.

>
> 2) On the DSI host side, each of the controller instances needs to know
>    the intimate details of the other controller (or alternatively, one
>    controller needs to be a "master" and the other a "slave").

The question is if they need to communicate each other, or they have
to have similar configurations applied?

>
> I'm looking for feedback on how this is handled on other SoCs, hence
> adding a few people that I know are working on DSI as well (or have in
> the past). If you know of any other people that might have useful advice
> on this topic, feel free to include them.
>
> Another goal of this discussion is to come up with a somewhat standard
> way to represent this in device tree (oh no!) so that panels can be
> easily reused on different SoCs.
>
> What I currently have for Tegra is something along these lines:
>
> 	dsi@54300000 {
> 		nvidia,ganged-mode = <&dsib>;
>
> 		panel@0 {
> 			compatible = "sharp,lq101r1sx01";
> 			reg = <0>;
>
> 			secondary = <&secondary>;
> 		};
> 	};
>
> 	dsib: dsi@54400000 {
> 		nvidia,ganged-mode;
>
> 		secondary: panel@0 {
> 			reg = <0>;
> 		};
> 	};
>
> There are a couple of other properties in those nodes, such as
> regulators and such, but I've omitted them so that the discussion can
> focus on the important bits.
>
> In the above the panel driver will bind against dsi@54300000/panel@0 and
> use the "secondary" property to obtain a reference to the DSI peripheral
> device of the second DSI interface of the device.
>
> Similarly, the dsi@54300000 primary DSI host will obtain a reference to
> a "slave" DSI host via the "nvidia,ganged-mode" property. The secondary
> DSI host dsi@54400000 will know that it's not a fully functional DSI
> output by the presence of the empty "nvidia,ganged-mode" property.
>
> Using the above I can get things to work, but it seems somewhat kludgy.
> For example it assumes that both DSI hosts are the same type. I'm not
> sure if it makes sense for dual-channel to use completely different DSI
> hosts given that they need to be very tightly coupled (take input from
> the same display controller, use the same PLL, ...). It's also kind of
> redundant to have to specify the dual relationship twice (once for the
> peripheral and once for the DSI hosts). There's also the issue that we
> should really be specifying a compatible string for the secondary
> instance of the DSI peripheral, but that would mean that it will bind
> against the same driver and then both would be programmed independently
> in the same way (without taking into account the differences between the
> two interfaces).
>
> One alternative to the above could be something like this:
>
> 	dsi@54300000 {
> 		nvidia,ganged-mode = <&dsib>;
> 		nvidia,panel = <&panel>
>
> 		primary: panel@0 {
> 			compatible = "sharp,lq101r1sx01-left";
> 			reg = <0>;
> 		};
> 	};
>
> 	dsib: dsi@54400000 {
> 		nvidia,ganged-mode;
>
> 		secondary: panel@0 {
> 			compatible = "sharp,lq101r1sx01-right";
> 			reg = <0>;
> 		};
> 	};
>
> 	panel {
> 		compatible = "sharp,lq101r1sx01";
> 		sharp,left = <&primary>;
> 		sharp,right = <&secondary>;
> 	};
>
> Which would give us a more natural way to represent this. On the other
> hand we loose information about the device type (/panel is no longer a
> DSI device) and associated meta-data (number of DSI lanes, ...).
>
> My primary concern is that this may not work for other SoCs since I've
> only tested it against Tegra. But the goal would be that the same panel
> connected to a different SoC would still be able to work with the same
> device tree binding.
>
> It would be great if anybody could share if they know how this works on
> other SoCs and if somebody's thought about how to implement it.

What about strictly following general 'rules' in DT:
1. Control bus is modeled using subnodes.
2. Video bus is modeled using video interface bindings.

Assuming this we will put panel node inside the first dsi node and we
should make
video link to other dsi node. Something like this:

dsiA {
    ports {
        port@0 {
            remote-endpoint = <&dc_port0>;
        };
        dsiA_port1: port@1 {
            remote-endpoint = <&panel_port0>;
    };
    panel@0 {
        compatible = "...";
        reg = <0>;
        ports {
            /* maybe common configuration for all ports */
            panel_port0: port@0 {
                /* configuration specific for port@0 */
                remote-endpoint = <&dsiA_port1>;
            };
            panel_port1: port@1 {
                /* configuration specific for port@1 */
                remote-endpoint = <&dsiB_port1>;
            };
        };
    };
};

dsiB {
    ports {
        port@0 {
            remote-endpoint = <&dc_port1>;
        };
        dsiA_port1: port@1 {
            remote-endpoint = <&panel_port1>;
    };
};

Regards
Andrzej


>
> Thierry

