Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaCNJGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:06:37 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62601 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbaCNJGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:06:33 -0400
Message-ID: <5322C6B2.6040905@gmail.com>
Date: Fri, 14 Mar 2014 10:06:58 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: David Miller <davem@davemloft.net>
CC: f.fainelli@gmail.com, ben@decadent.org.uk, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: phy: fix uninitalized WOL parameters in phy_ethtool_get_wol
References: <1394484661-4554-2-git-send-email-sebastian.hesselbarth@gmail.com> <1394578975-12588-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140313.153832.967564223480298567.davem@davemloft.net>
In-Reply-To: <20140313.153832.967564223480298567.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 08:38 PM, David Miller wrote:
> From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Date: Wed, 12 Mar 2014 00:02:55 +0100
>
>> phy_ethtool_get_wol is a helper to get current WOL settings from
>> a phy device. When using this helper on a PHY without .get_wol
>> callback, struct ethtool_wolinfo is never set-up correctly and
>> may contain misleading information about WOL status.
>>
>> To fix this, always zero relevant fields of struct ethtool_wolinfo
>> regardless of .get_wol callback availability.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>
> I'm starting to see this situation more clearly now, especially with
> Ben's most recent commentary.
>
> The basic notion is that one must do ethtool ops are designed such that
> the top-level execution context in net/core/ethtool.c takes care of
> initializing the structure.
>
> In this case, we're referring specifically to ethtool_get_wol(), which
> runs any time ETHTOOL_GWOL is requested.
>
> Therefore no ethtool_ops->get_wol() implementation should duplicate
> this work, that goes for all of such cases which invoke the function
> we are talking about here, phy_ethtool_get_wol().
>
> So the first change is definitely to remove:
>
> 	wol->supported = 0;
> 	wol->wolopts = 0;
>
> from:
>
> drivers/net/ethernet/marvell/mv643xx_eth.c:mv643xx_eth_get_wol()
> drivers/net/ethernet/ti/cpsw.c:cpsw_get_wol()
>
> Next, I think phy_suspend() must create the same environment the
> call sites above guarentee for phy_ethtool_get_wol(), namely
> by changing the declaration of 'wol' to:
>
> 	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
>
> which will cause the compiler to clear out the rest of the structure
> for us, as the same declaration does in ethtool_get_wol().
>
> Finally, purge the spurious clears in phydev_ops->get_wol(), namely
> in at803x_get_wol() and m88e1318_get_wol().
>
> So, to reiterate, OPS never have to be mindful of initializing the
> ethtool result with zeros.  However, anyone who calls into OPS
> directly must provide said expected state.
>
> Are we all on the same page now?

Yes, we are. I'll send a fix for phy_suspend in a minute - still based
on v3.14-rc1 in case there will be another -rc.

If not, I'll rebase that fix on net-next together with patches for the
four offending drivers you named above.

Sebastian


