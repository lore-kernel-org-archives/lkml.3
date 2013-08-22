Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3HVNYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:24:20 -0400
Received: from 15.mo3.mail-out.ovh.net ([87.98.150.177]:47424 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752595Ab3HVNYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:24:19 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2013 09:24:19 EDT
Message-ID: <521610FE.7080807@overkiz.com>
Date: Thu, 22 Aug 2013 15:24:14 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, Mark Brown <broonie@kernel.org>,
        Nick Bowler <nbowler@elliptictech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC PATCH] phylib: mdio: handle register/unregister/register
 sequence
References: <1377174836-10569-1-git-send-email-b.brezillon@overkiz.com> <CAGVrzcaByva=8xiswcsW1B8G4dL=jY0RdaHKzNqaT_0Lrwbprg@mail.gmail.com> <52160CAC.3040603@overkiz.com> <CAGVrzcYTudGg-NH+REL3vDe6a5s6bkXRQH1-PFFs-HNEnJ-rTw@mail.gmail.com>
In-Reply-To: <CAGVrzcYTudGg-NH+REL3vDe6a5s6bkXRQH1-PFFs-HNEnJ-rTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 1224416149426108656
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/2013 15:15, Florian Fainelli wrote:
> 2013/8/22 boris brezillon <b.brezillon@overkiz.com>:
>> Hello Florian,
>>
>> Thanks for your answer.
>>
>>
>> On 22/08/2013 14:43, Florian Fainelli wrote:
>>> Hello Boris,
>>>
>>> 2013/8/22 Boris BREZILLON <b.brezillon@overkiz.com>:
>>>> Hello,
>>>>
>>>> This patch is a proposal to support the register/unregister/register
>>>> sequence on a given mdio bus.
>>>>
>>>> I use the register/unregister/register sequence to add a fallback when
>>>> the
>>>> of_mdiobus_register (this function calls mdiobus_register with phy_mask
>>>> set to ~0) does not register any phy device (because the device tree does
>>>> not define any phy).
>>>> In this case I call mdiobus_unregister and then call mdiobus_register
>>>> with
>>>> a phy_mask set to 0 to trigger a full mdio bus scan.
>>>>
>>>> I'm not sure this is the right way to do it (this is why I added RFC in
>>>> the
>>>> subject).
>>>>
>>>> Could someone help me figuring out what I should use to implement my
>>>> fallback ?
>>>>
>>>> 1) use the register/unregister/register sequence
>>>> 2) reimplement the "for (i = 0; i < PHY_MAX_ADDR; i++)" mdiobus_scan loop
>>> I think solution 2 is nicer, in that case, would it be enough in your
>>> case to export a function called mdiobus_scan()? You could call at a
>>> time you know PHY devices have a chance of having been probed?
>> mdiobus_scan is already exported:
>> struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
>>
>> This function scans the presence of a phy device at a given address.
>>
>> What I need is a loop which scan all the possible address on the given
>> mdio bus:
>>
>> struct phy_device *mdiobus_full_scan(struct mii_bus *bus)
>> {
>>      int i;
>>      for (i = 0; i < PHY_MAX_ADDR; i++) {
>>          if ((bus->phy_mask & (1 << i)) == 0) {
>>              struct phy_device *phydev;
>>
>>              phydev = mdiobus_scan(bus, i);
>>              if (IS_ERR(phydev)) {
>>                  err = PTR_ERR(phydev);
>>                  goto error;
>>              }
>>          }
>>      }
>>      return 0;
>>
>> error:
>>      while (--i >= 0) {
>>
>>          if (bus->phy_map[i])
>>              device_unregister(&bus->phy_map[i]->dev);
>>      }
>> }
>> EXPORT_SYMBOL(mdiobus_full_scan);
>>
>> Since I am the only one who need this kind of functionnality right now, I'm
>> not sure
>> this is a good idea to export a new function.
> A possible other use case for this full-scan is when you do not detect
> a PHY connected to your MDIO bus, and that you did not register a
> fixed PHY early enough for it to have been scanned by the fixed MDIO
> bus emulation. In that case the driver may:
>
> - scan hardware MDIO bus
> - do not find any PHY, register a fixed PHY
> - trigger a fixed MDIO bus full-rescan
> - attach to the discovered fixed PHY
>
> this is something currently done by the TI CPMAC driver in
> drivers/net/ethernet/ti/cpmac.c (altough fixed_phy_add() is called
> from platform code).
>

Okay, then we should consider this option.

>> This behaviour may be implemented in the of_mdiobus_register function:
>> when no dt phy node are found in the mdio bus dt node, we could launch a
>> full
>> scan.
>>
>> What do you think ?
> There is an existing kind of "autoscan" feature in
> drivers/of/of_mdio.c, starting with the second foreach_child_node()
> loop, so maybe that specific part could be exported and would achieve
> what you are looking for? It relies on the Ethernet PHY nodes to be
> attached to the MDIO bus node, but I assume this is what ultimately
> happens in your case as well?

The second foreach_child_node loop only registers the dt phy nodes
which does not define any reg property (automatic address asssignement ?).

Indeed, what I need is a fallback when the device tree does not define 
any phy
device (for old device tree backward compatibility).

