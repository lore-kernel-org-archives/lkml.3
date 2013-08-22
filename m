Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3HVNXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:23:09 -0400
Received: from 20.mo3.mail-out.ovh.net ([178.33.47.94]:33864 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752011Ab3HVNXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:23:07 -0400
X-Greylist: delayed 1034 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2013 09:23:07 EDT
Message-ID: <52160CAC.3040603@overkiz.com>
Date: Thu, 22 Aug 2013 15:05:48 +0200
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
References: <1377174836-10569-1-git-send-email-b.brezillon@overkiz.com> <CAGVrzcaByva=8xiswcsW1B8G4dL=jY0RdaHKzNqaT_0Lrwbprg@mail.gmail.com>
In-Reply-To: <CAGVrzcaByva=8xiswcsW1B8G4dL=jY0RdaHKzNqaT_0Lrwbprg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 913386300023601392
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

Hello Florian,

Thanks for your answer.

On 22/08/2013 14:43, Florian Fainelli wrote:
> Hello Boris,
>
> 2013/8/22 Boris BREZILLON <b.brezillon@overkiz.com>:
>> Hello,
>>
>> This patch is a proposal to support the register/unregister/register
>> sequence on a given mdio bus.
>>
>> I use the register/unregister/register sequence to add a fallback when the
>> of_mdiobus_register (this function calls mdiobus_register with phy_mask
>> set to ~0) does not register any phy device (because the device tree does
>> not define any phy).
>> In this case I call mdiobus_unregister and then call mdiobus_register with
>> a phy_mask set to 0 to trigger a full mdio bus scan.
>>
>> I'm not sure this is the right way to do it (this is why I added RFC in the
>> subject).
>>
>> Could someone help me figuring out what I should use to implement my fallback ?
>>
>> 1) use the register/unregister/register sequence
>> 2) reimplement the "for (i = 0; i < PHY_MAX_ADDR; i++)" mdiobus_scan loop
> I think solution 2 is nicer, in that case, would it be enough in your
> case to export a function called mdiobus_scan()? You could call at a
> time you know PHY devices have a chance of having been probed?
mdiobus_scan is already exported:
struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);

This function scans the presence of a phy device at a given address.

What I need is a loop which scan all the possible address on the given
mdio bus:

struct phy_device *mdiobus_full_scan(struct mii_bus *bus)
{
     int i;
     for (i = 0; i < PHY_MAX_ADDR; i++) {
         if ((bus->phy_mask & (1 << i)) == 0) {
             struct phy_device *phydev;

             phydev = mdiobus_scan(bus, i);
             if (IS_ERR(phydev)) {
                 err = PTR_ERR(phydev);
                 goto error;
             }
         }
     }
     return 0;

error:
     while (--i >= 0) {
         if (bus->phy_map[i])
             device_unregister(&bus->phy_map[i]->dev);
     }
}
EXPORT_SYMBOL(mdiobus_full_scan);

Since I am the only one who need this kind of functionnality right now, 
I'm not sure
this is a good idea to export a new function.

This behaviour may be implemented in the of_mdiobus_register function:
when no dt phy node are found in the mdio bus dt node, we could launch a 
full
scan.

What do you think ?

Best Regards,

Boris
