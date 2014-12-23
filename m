Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaLWLKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 06:10:22 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60537 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaLWLKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 06:10:20 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-4e-54994d990be3
Message-id: <54994D88.3000009@samsung.com>
Date: Tue, 23 Dec 2014 12:10:00 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@pengutronix.de, Russell King <rmk+kernel@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v6 3/3] of: Add of_graph_get_port_by_id function
References: <1419261091-29888-1-git-send-email-p.zabel@pengutronix.de>
 <1419261091-29888-4-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1419261091-29888-4-git-send-email-p.zabel@pengutronix.de>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xq7ozfWeGGGyZxGNx5et7Nov3G+cx
	WRz4s4PRonnxejaLVVN3slh0TlzCbrHp8TVWi8u75rBZ9GzYympxcZ28xdY9B5gs7t47wWKx
	+cNLNgdej5bmHjaPDx/jPGZ3zGT1uHNtD5vH/rlr2D3udx9n8ti8pN6j/6+BR9+WVYwenzfJ
	BXBFcdmkpOZklqUW6dslcGXcXjmLueCdaMWfxtwGxsOCXYycHBICJhI9j06yQNhiEhfurWfr
	YuTiEBJYyiixZvUiNpCEkMAnRoljz5xAbF4BLYn3Gz+xg9gsAqoSbzZvZgKx2QQ0Jf5uvglW
	LyoQIfFh1Vc2iHpBiR+T74EtEBEIkbi3pY8ZxGYWOM4ssf2UNYgtLOAicef+bxaIxc2MEid/
	TmEESXAKuEv8efMcaBkHUIO6xJQpuRC98hKb17xlnsAoMAvJilkIVbOQVC1gZF7FKJpamlxQ
	nJSea6hXnJhbXJqXrpecn7uJERJHX3YwLj5mdYhRgINRiYf35PsZIUKsiWXFlbmHGCU4mJVE
	eF+KzwwR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwGjlU1267L/1cd2tfSm+zU57hes1Itu2FWyJ
	P/i6931WzJuPvR/O+/w0boj9NXPC/rg5ad/Ze542TCrI/uPCwzOv7F+O5PO4Cz43NlwVvZW4
	7NC3dW+M/y7MfL/zBe/Oiwuy898fkd/x4G9LySG51M7iSTp+os53jF/xe38oDj3w4avXfCvH
	R1ZKLMUZiYZazEXFiQBIYc7agQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 12/22/2014 04:11 PM, Philipp Zabel wrote:
> This patch adds a function to get a port device tree node by port id,
> or reg property value.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/of/base.c        | 26 ++++++++++++++++++++++++++
>  include/linux/of_graph.h |  7 +++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index aac66df..c816299 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -2080,6 +2080,32 @@ int of_graph_parse_endpoint(const struct device_node *node,
>  EXPORT_SYMBOL(of_graph_parse_endpoint);
>  
>  /**
> + * of_graph_get_port_by_id() - get the port matching a given id
> + * @parent: pointer to the parent device node

Here you have 'parent' and 'node' in the code.

> + * @id: id of the port
> + *
> + * Return: A 'port' node pointer with refcount incremented. The caller
> + * has to use of_node_put() on it when done.
> + */
> +struct device_node *of_graph_get_port_by_id(struct device_node *node, u32 id)
> +{
> +	struct device_node *port;
> +
> +	for_each_child_of_node(node, port) {
> +		u32 port_id = 0;
> +
> +		if (of_node_cmp(port->name, "port") != 0)
> +			continue;
> +		of_property_read_u32(port, "reg", &port_id);
> +		if (id == port_id)
> +			return port;
> +	}
> +
> +	return NULL;
> +}


Maybe I miss something but it does not handle optional 'ports' node.

Regards
Andrzej


> +EXPORT_SYMBOL(of_graph_get_port_by_id);
> +
> +/**
>   * of_graph_get_next_endpoint() - get next endpoint node
>   * @parent: pointer to the parent device node
>   * @prev: previous endpoint node, or NULL to get first
> diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
> index e43442e..3c1c95a 100644
> --- a/include/linux/of_graph.h
> +++ b/include/linux/of_graph.h
> @@ -40,6 +40,7 @@ struct of_endpoint {
>  #ifdef CONFIG_OF
>  int of_graph_parse_endpoint(const struct device_node *node,
>  				struct of_endpoint *endpoint);
> +struct device_node *of_graph_get_port_by_id(struct device_node *node, u32 id);
>  struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
>  					struct device_node *previous);
>  struct device_node *of_graph_get_remote_port_parent(
> @@ -53,6 +54,12 @@ static inline int of_graph_parse_endpoint(const struct device_node *node,
>  	return -ENOSYS;
>  }
>  
> +static inline struct device_node *of_graph_get_port_by_id(
> +					struct device_node *node, u32 id)
> +{
> +	return NULL;
> +}
> +
>  static inline struct device_node *of_graph_get_next_endpoint(
>  					const struct device_node *parent,
>  					struct device_node *previous)
> 

