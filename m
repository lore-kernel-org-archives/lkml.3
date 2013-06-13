Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab3FMGpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 02:45:41 -0400
Received: from mail.advaoptical.com ([91.217.199.15]:35950 "EHLO
	mail.advaoptical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab3FMGpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 02:45:36 -0400
Message-ID: <51B96A68.40102@advaoptical.com>
Date: Thu, 13 Jun 2013 09:44:56 +0300
From: Oded Gabbay <ogabbay@advaoptical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <stef.van.os@prodrive.nl>, <timur@tabi.org>,
        <Dongsheng.Wang@freescale.com>, <paulus@samba.org>,
        <netdev@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <B38951@freescale.com>
Subject: Re: [PATCH] MDIO: FSL_PQ_MDIO: Fix bug on incorrect offset of tbipa
 register
References: <1371041258-15298-1-git-send-email-ogabbay@advaoptical.com> <51B88EED.6090709@linutronix.de> <1371061871.18413.44@snotra>
In-Reply-To: <1371061871.18413.44@snotra>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.179.55]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-13_03:2013-06-12,2013-06-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 09:31 PM, Scott Wood wrote:
> On 06/12/2013 10:08:29 AM, Sebastian Andrzej Siewior wrote:
>> On 06/12/2013 02:47 PM, Oded Gabbay wrote:
>> > This patch fixes a bug in the fsl_pq_mdio.c module and in relevant 
>> device-tree
>> > files regarding the correct offset of the tbipa register in the eTSEC
>> > controller in some of Freescale's PQ3 and QorIQ SoC.
>> > The bug happens when the mdio in the device tree is configured to 
>> be compatible
>> > to "fsl,gianfar-tbi". Because the mdio device in the device tree 
>> points to
>> > addresses 25520, 26520 or 27520 (depends on the controller ID), the 
>> variable
>> > priv->map at function fsl_pq_mdio_probe, points to that address. 
>> However,
>> > later in the function there is a write to register tbipa that is 
>> actually
>> > located at 25030, 26030 or 27030. Because the correct address is 
>> not io mapped,
>> > the contents are written to a different register in the controller.
>> > The fix sets the address of the mdio device to start at 25000, 
>> 26000 or 27000
>> > and changes the mii_offset field to 0x520 in the relevant entry
>> > (fsl,gianfar-tbi) of the fsl_pq_mdio_match array.
>> >
>> > Note: This patch may break MDIO functionallity of some old 
>> Freescale's SoC
>> > until Freescale will fix their device tree files. Basically, every 
>> device tree
>> > which contains an mdio device that is compatible to 
>> "fsl,gianfar-tbi" should be
>> > examined.
>>
>> Not as is.
>> Please add a check for the original address. If it has 0x520 at the end
>> print a warning and fix it up. Please add to the patch description
>> which register is modified instead if this patch is not applied.
>> Depending on how critical this it might has to go stable.
>
> I'm not sure it's stable material if this is something that has never 
> worked...
>
> The device tree binding will also need to be fixed to note the 
> difference in "reg" between "fsl,gianfar-mdio" and "fsl-gianfar-tbi" 
> -- and should give an example of the latter.
>
> -Scott
I read the 2 comments and I'm not sure what should be the best way to 
move ahead.
I would like to describe what is the impact of not accepting this patch:
When you connect any eTSEC, except the first one, using SGMII, you must 
configure the TBIPA register because
the MII management configuration uses the TBIPA address as part of the 
SGMII initialization sequence,
as described in the P2020 Reference manual.
So, if that register is not initialized, the sequence is broken the and 
eTSEC is not functioning (can not send/receive
packets).
I still think the best way to fix it is what I did:
1. Point the priv->map to the start of the whole registers range of the 
eTSEC
2. Set mii_offset to 0x520 in the "gianfar-tbi" entry of the 
"fsl_pq_mdio_match" array.
3. Fix all the usages of the "gianfar-tbi" in the device tree files - 
change the starting address and reg range

I think this is the best way because it is stated in "fsl_pq_mdio_probe" 
function that:
     /*
      * Some device tree nodes represent only the MII registers, and
      * others represent the MAC and MII registers.  The 'mii_offset' field
      * contains the offset of the MII registers inside the mapped register
      * space.
      */
and that's why we have priv->map and priv->regs. So my fix goes 
according to the current design of the driver.

-Oded
