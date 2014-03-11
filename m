Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaCKIkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:40:35 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:35250 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaCKIkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:40:31 -0400
Message-ID: <531ECBFA.5010300@gmail.com>
Date: Tue, 11 Mar 2014 09:40:26 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: fix uninitalized WOL parameters in phy_ethtool_get_wol
References: <1394413270-7169-1-git-send-email-sebastian.hesselbarth@gmail.com> <1394419893.15968.88.camel@deadeye.wl.decadent.org.uk> <531D98D1.4000707@gmail.com> <1394493477.23624.21.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1394493477.23624.21.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 12:17 AM, Ben Hutchings wrote:
> On Mon, 2014-03-10 at 10:49 +0000, Sebastian Hesselbarth wrote:
>> On 03/10/2014 02:51 AM, Ben Hutchings wrote:
>>> On Mon, 2014-03-10 at 02:01 +0100, Sebastian Hesselbarth wrote:
>>>> phy_ethtool_get_wol is a helper to get current WOL settings from
>>>> a phy device. When using this helper on a PHY without .get_wol
>>>> callback, struct ethtool_wolinfo is never set-up correctly and
>>>> may contain misleading information about WOL status.
>>>>
>>>> To fix this, always zero relevant fields of struct ethtool_wolinfo
>>>> regardless of .get_wol callback availability.
>>>
>>> I think it's the caller's responsibility to zero out struct
>>> ethtool_wolinfo.  That is what ethtool_get_wol() does.
>>
>> Actually, phy_ethtool_get_wol is the caller here. This belongs to
>> a set of helpers that deal with phy_device, not netdev.
>
> Right, but ethtool_get_wol() is further up the stack and is responsible
> for initialising the struct to defaults.

Ok, currently we have 3 users of phy_ethtool_get_wol():
- mv643xx_eth and cpsw use that in their .get_wol callback that is
   called on ethtool_get_wol().
- phy_suspend to determine if it is safe to suspend a PHY

With phy_suspend, I could use a kernel-compatible __ethtool_get_wol()
but that requires to have an .attached_dev as __ethtool_get_wol()
takes netdev. This would limit phy_suspend to attached PHYs while
even non-attached PHYs should be suspended.

OTOH, if we don't want phy_ethtool_get_wol to clear out ethtool_wol and
no dependency on .attached_dev, phy_suspend is the only place to
properly initialize ethtool_wol on this level.

>>> Maybe you could split ethtool_get_wol() like we did
>>> ethtool_get_settings(), to support in-kernel invocation of ETHTOOL_GWOL?
>>
>> Looking at the other users of phy_ethtool_get_wol (mv643xx_eth and
>> cpsw), both drivers use this helper to determine what to pass back
>> on the corresponding ethtool_get_wol call.
>>
>> BTW, both drivers above do zero ethtool_wolinfo before calling
>> phy_ethtool_get_wol. I can either zero it in phy_suspend too or we
>> deal with it properly in phy_ethtool_get_wol instead:
>>
>> void phy_ethtool_get_wol(struct phy_device *phydev, struct
>> ethtool_wolinfo *wol)
>> {
>> 	memset(wol, 0, sizeof(*wol));
>>
>> 	if (phydev && phydev->drv->get_wol)
>> 		phydev->drv->get_wol(phydev, wol);
>> }
> [...]
>
> This trashes wol->cmd.  Don't do that.

You are right on this one, I'll missed it and will fix it up.

Sebastian

