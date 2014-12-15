Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaLOOF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:05:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:39277 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaLOOFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:05:23 -0500
Date: Mon, 15 Dec 2014 14:05:19 +0000
From: Thomas Graf <tgraf@suug.ch>
To: "Varlese, Marco" <marco.varlese@intel.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "sfeldma@gmail.com" <sfeldma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 1/1] net: Support for switch port
 configuration
Message-ID: <20141215140519.GA21952@casper.infradead.org>
References: <C4896FB061E7DE4AAC93031BDCA044B104AC3257@IRSMSX108.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4896FB061E7DE4AAC93031BDCA044B104AC3257@IRSMSX108.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/14 at 04:23pm, Varlese, Marco wrote:
> +#ifdef CONFIG_NET_SWITCHDEV
> +static int do_setswcfg(struct net_device *dev, struct nlattr *attr)
> +{
> +	int rem, err = -EINVAL;
> +	struct nlattr *v;
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +
> +	nla_for_each_nested(v, attr, rem) {
> +		u32 op = nla_type(v);
> +		u64 value = nla_get_u64(v);
> +
> +		err = ops->ndo_switch_port_set_cfg(dev, op, value);
> +		if (err)
> +			break;
> +	}
> +	return err;
> +}
> +#endif

A strictly technical feedback first: I suggest to split the above into
a validation and commit part to keep Netlink operations atomic. Doing
commit & rollback for the deeply nested configuration we are heading
to will be difficult and error prone. Let's keep updates atomic for as
long as possible, i.e. individual set operations can't fail.
