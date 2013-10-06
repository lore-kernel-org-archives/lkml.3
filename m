Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3JFRbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 13:31:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54237 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab3JFRbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 13:31:41 -0400
Message-ID: <52519E7A.40804@ti.com>
Date: Sun, 6 Oct 2013 12:31:38 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Steve Glendinning <steve.glendinning@shawell.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, <mugunthanvnm@ti.com>
Subject: Re: [PATCH] usbnet: smsc95xx: Add device tree input for MAC address
References: <1380911156-14112-1-git-send-email-dmurphy@ti.com> <CACVXFVOVMvP=3y9h2Jrqn2sBQdKOZtrhQDAFYkdHKXFgQj=d0Q@mail.gmail.com>
In-Reply-To: <CACVXFVOVMvP=3y9h2Jrqn2sBQdKOZtrhQDAFYkdHKXFgQj=d0Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2013 10:05 AM, Ming Lei wrote:
> On Sat, Oct 5, 2013 at 2:25 AM, Dan Murphy <dmurphy@ti.com> wrote:
>> If the smsc95xx does not have a valid MAC address stored within
>> the eeprom then a random number is generated.  The MAC can also
>> be set by uBoot but the smsc95xx does not have a way to read this.
>>
>> Create the binding for the smsc95xx so that uBoot can set the MAC
>> and the code can retrieve the MAC from the modified DTB file.
> Suppose there are two smsc95xx usbnet devices connected to usb bus, and
> one is built-in, another is hotplug device, can your patch handle the situation
> correctly?

Look at this line in the patch below

sprintf(of_name, "%s%i", SMSC95XX_OF_NAME, dev->udev->dev.id);

I am appending the dev ID of the device to the of_name here.  As long as init_mac_address is called, the dev.id and the uBoot
entry match then yes.


>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>  Documentation/devicetree/bindings/net/smsc95xx.txt |   17 ++++++++++++++
>>  drivers/net/usb/smsc95xx.c                         |   24 ++++++++++++++++++++
>>  2 files changed, 41 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/smsc95xx.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/smsc95xx.txt b/Documentation/devicetree/bindings/net/smsc95xx.txt
>> new file mode 100644
>> index 0000000..4c37280
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/smsc95xx.txt
>> @@ -0,0 +1,17 @@
>> +* Smart Mixed-Signal Connectivity (SMSC) 95xx Controller
>> +
>> +Required properties:
>> +None
>> +
>> +Optional properties:
>> +- mac-address - Read the mac address that was stored by uBoot
>> +- local-address - Read the mac address that was stored by uBoot
>> +- address - Read the mac address that was stored by uBoot
>> +
>> +Examples:
>> +
>> +smsc0: smsc95xx@0 {
>> +       /* Filled in by U-Boot */
>> +       mac-address = [ 00 00 00 00 00 00 ];
>> +};
>> +
>> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
>> index 3f38ba8..baee0bd 100644
>> --- a/drivers/net/usb/smsc95xx.c
>> +++ b/drivers/net/usb/smsc95xx.c
>> @@ -31,6 +31,9 @@
>>  #include <linux/crc32.h>
>>  #include <linux/usb/usbnet.h>
>>  #include <linux/slab.h>
>> +#include <linux/of.h>
>> +#include <linux/of_net.h>
>> +
>>  #include "smsc95xx.h"
>>
>>  #define SMSC_CHIPNAME                  "smsc95xx"
>> @@ -62,6 +65,8 @@
>>  #define SUSPEND_ALLMODES               (SUSPEND_SUSPEND0 | SUSPEND_SUSPEND1 | \
>>                                          SUSPEND_SUSPEND2 | SUSPEND_SUSPEND3)
>>
>> +#define SMSC95XX_OF_NAME       "/smsc95xx@"
>> +
>>  struct smsc95xx_priv {
>>         u32 mac_cr;
>>         u32 hash_hi;
>> @@ -767,6 +772,25 @@ static int smsc95xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
>>
>>  static void smsc95xx_init_mac_address(struct usbnet *dev)
>>  {
>> +
>> +#ifdef CONFIG_OF
>> +       struct device_node *ap;
>> +       const char *mac = NULL;
>> +       char *of_name = SMSC95XX_OF_NAME;
>> +
>> +       sprintf(of_name, "%s%i", SMSC95XX_OF_NAME, dev->udev->dev.id);
>> +       ap = of_find_node_by_path(of_name);
>> +       if (ap) {
>> +               mac = of_get_mac_address(ap);
>> +               if (is_valid_ether_addr(mac)) {
>> +                       /* Device tree has a mac for this so use that */
>> +                       memcpy(dev->net->dev_addr, mac, ETH_ALEN);
>> +                       netif_dbg(dev, ifup, dev->net, "MAC address read from DTB\n");
>> +                       return;
>> +               }
>> +       }
>> +#endif
>> +
>>         /* try reading mac address from EEPROM */
>>         if (smsc95xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN,
>>                         dev->net->dev_addr) == 0) {
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> Thanks,


-- 
------------------
Dan Murphy

