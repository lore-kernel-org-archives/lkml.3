Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096Ab3EOOI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:08:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51046 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3EOOI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:08:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCHv3 3/6] clk: Add TI-Nspire clock drivers
Date: Wed, 15 May 2013 16:07:54 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com> <1368332581-94691-4-git-send-email-dt.tangr@gmail.com>
In-Reply-To: <1368332581-94691-4-git-send-email-dt.tangr@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305151607.54442.arnd@arndb.de>
X-Provags-ID: V02:K0:ihrtt+uKg4QcP63y0xoBJSlysWVSrjOkn2oYTflx7OD
 R7sK1tAytewQNPAA20l6S6B3ZTRk/4dgG0CE5/ZUlmJF9pkfAj
 Z0oTJipJDAm/iID5NRULGNeJ7Nc7KXwOLTdXJD6IKJs6z9BXO0
 VBmm3ThrPmnl6nS6fv8zKsTLOiaBqIFfwnQEnWaZwV7v1sf7VO
 N85DaKUmH43MQgmWtYrOXHXEhBaQURAavsyp2HF5mEOwY7a2hV
 el7hx1UwkeO5EPhwg6DNSeePShhjwmJ1/n+h6sqS5HobML1+LA
 NrQFptbQRCr4FwtoH1tv/g/xib38GLSGrENfWqEOZN47mbIeDI
 wJrxct/Gs/OFo3NX7oJc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 May 2013, Daniel Tang wrote:
> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> ---
>  drivers/clk/Makefile     |   1 +
>  drivers/clk/clk-nspire.c | 141 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 142 insertions(+)
>  create mode 100644 drivers/clk/clk-nspire.c

You are missing a binding in Documentation/devicetree, same as for some of
the other drivers in this series.

> +static int nspire_clk_read(struct device_node *node,
> +		struct nspire_clk_info *clk)
> +{
> +	u32 val;
> +	int ret;
> +	void __iomem *io;
> +	const char *type = NULL;
> +
> +	ret = of_property_read_string(node, "io-type", &type);
> +	if (ret)
> +		return ret;

Using a string here feels clumsy. Why not use the "compatible" property
to distinguish the different models?

> +static void __init nspire_ahbdiv_setup(struct device_node *node)
> +{
> +	int ret;
> +	struct clk *clk;
> +	const char *clk_name = node->name;
> +	const char *parent_name;
> +	struct nspire_clk_info info;
> +
> +	ret = nspire_clk_read(node, &info);
> +	if (WARN_ON(ret))
> +		return;
> +
> +	of_property_read_string(node, "clock-output-names", &clk_name);

It seems strange to assign the clk_name variable to node->name
first and then overriding it with the clock-output-names property.
Is that intentional? If so, please explain it in a comment.

> +
> +	pr_info("TI-NSPIRE Base: %uMHz CPU: %uMHz AHB: %uMHz\n",
> +		info.base_clock / MHZ,
> +		info.base_clock / info.base_cpu_ratio / MHZ,
> +		info.base_clock / info.base_ahb_ratio / MHZ);
> +}
> +
> +CLK_OF_DECLARE(nspire_clk, "nspire-clock", nspire_clk_setup);
> +CLK_OF_DECLARE(nspire_ahbdiv, "nspire-ahb-divider", nspire_ahbdiv_setup);

I would put each of these lines directly under the function it references.

	Arnd
