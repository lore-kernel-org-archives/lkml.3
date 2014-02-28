Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaB1VJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:09:04 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:35195 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaB1VJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:09:01 -0500
Message-ID: <5310FAE8.5090305@gmail.com>
Date: Fri, 28 Feb 2014 22:08:56 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/7] Documentation: of: Document graph bindings
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de> <1393522540-22887-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1393522540-22887-3-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Just couple minor comments...

On 02/27/2014 06:35 PM, Philipp Zabel wrote:
> The device tree graph bindings as used by V4L2 and documented in
> Documentation/device-tree/bindings/media/video-interfaces.txt contain
> generic parts that are not media specific but could be useful for any
> subsystem with data flow between multiple devices. This document
> describe the generic bindings.

s/describe/describes/

> Signed-off-by: Philipp Zabel<p.zabel@pengutronix.de>
> ---
> Changes since v4:
>   - Differentiate from graphs made by simple phandle links
>   - Do not mention data flow except in video-interfaces example
>   -
> ---
>   Documentation/devicetree/bindings/graph.txt | 129 ++++++++++++++++++++++++++++
>   1 file changed, 129 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/graph.txt
>
> diff --git a/Documentation/devicetree/bindings/graph.txt b/Documentation/devicetree/bindings/graph.txt
> new file mode 100644
> index 0000000..554865b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/graph.txt
> @@ -0,0 +1,129 @@
> +Common bindings for device graphs
> +
> +General concept
> +---------------
> +
> +The hierarchical organisation of the device tree is well suited to describe
> +control flow to devices, but there can be more complex connections between
> +devices that work together to form a logical compound device, following an
> +arbitrarily complex graph.
> +There already is a simple directed graph between devices tree nodes using
> +phandle properties pointing to other nodes to describe connections that
> +can not be inferred from device tree parent-child relationships. The device
> +tree graph bindings described herein abstract more complex devices that can
> +have multiple specifiable ports, each of which can be linked to one or more
> +ports of other devices.
> +
> +These common bindings do not contain any information about the direction of

s/of/or/ ?

> +type of the connections, they just map their existence. Specific properties
> +may be described by specialized bindings depending on the type of connection.
> +
> +To see how this binding applies to video pipelines, for example, see
> +Documentation/device-tree/bindings/media/video-interfaces.txt.
> +Here the ports describe data interfaces, and the links between them are
> +the connecting data buses. A single port with multiple connections can
> +correspond to multiple devices being connected to the same physical bus.
> +
> +Organisation of ports and endpoints
> +-----------------------------------
> +
> +Ports are described by child 'port' nodes contained in the device node.
> +Each port node contains an 'endpoint' subnode for each remote device port
> +connected to this port. If a single port is connected to more than one
> +remote device, an 'endpoint' child node must be provided for each link.
> +If more than one port is present in a device node or there is more than one
> +endpoint at a port, or a port node needs to be associated with a selected
> +hardware interface, a common scheme using '#address-cells', '#size-cells'
> +and 'reg' properties is used number the nodes.
> +
> +device {
> +        ...
> +        #address-cells =<1>;
> +        #size-cells =<0>;
> +
> +        port@0 {
> +	        #address-cells =<1>;
> +	        #size-cells =<0>;
> +		reg =<0>;
> +
> +                endpoint@0 {
> +			reg =<0>;
> +			...
> +		};
> +                endpoint@1 {
> +			reg =<1>;
> +			...
> +		};
> +        };
> +
> +        port@1 {
> +		reg =<1>;
> +
> +		endpoint { ... };
> +	};
> +};
> +
> +All 'port' nodes can be grouped under an optional 'ports' node, which
> +allows to specify #address-cells, #size-cells properties for the 'port'
> +nodes independently from any other child device nodes a device might
> +have.
> +
> +device {
> +        ...
> +        ports {
> +                #address-cells =<1>;
> +                #size-cells =<0>;
> +
> +                port@0 {
> +                        ...
> +                        endpoint@0 { ... };
> +                        endpoint@1 { ... };
> +                };
> +
> +                port@1 { ... };
> +        };
> +};
> +
> +Links between endpoints
> +-----------------------
> +
> +Each endpoint should contain a 'remote-endpoint' phandle property that points
> +to the corresponding endpoint in the port of the remote device. In turn, the
> +remote endpoint should contain a 'remote-endpoint' property. If it has one,
> +it must not point to another than the local endpoint. Two endpoints with their
> +'remote-endpoint' phandles pointing at each other form a link between the
> +containing ports.
> +
> +device_1 {
> +        port {
> +                device_1_output: endpoint {
> +                        remote-endpoint =<&device_2_input>;
> +                };
> +        };
> +};
> +
> +device_1 {

s/device_1/device_2/
But it might be better to use dashes instead of underscores
for the node names.

> +        port {
> +                device_2_input: endpoint {
> +                        remote-endpoint =<&device_1_output>;
> +                };
> +        };
> +};
> +
> +
> +Required properties
> +-------------------
> +
> +If there is more than one 'port' or more than one 'endpoint' node or 'reg'
> +property is present in port and/or endpoint nodes the following properties
> +are required in a relevant parent node:
> +
> + - #address-cells : number of cells required to define port/endpoint
> +                    identifier, should be 1.
> + - #size-cells    : should be zero.
> +
> +Optional endpoint properties
> +----------------------------
> +
> +- remote-endpoint: phandle to an 'endpoint' subnode of a remote device node.
> +

--
Regards,
Sylwester
