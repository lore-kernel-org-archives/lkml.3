Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3AKIS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 03:18:56 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:43816 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3AKISy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 03:18:54 -0500
Message-ID: <50EFCAE6.9070306@omicron.at>
Date: Fri, 11 Jan 2013 09:18:46 +0100
From: Christian Riesch <christian.riesch@omicron.at>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: freddy@asix.com.tw
CC: Ming Lei <ming.lei@canonical.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, louis@asix.com.tw,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit
 ethernet adapter driver
References: <1357867046-22918-1-git-send-email-freddy@asix.com.tw> <CACVXFVMdgx1we67poF5yU5pAYRYoA9Ao1EJqQgGBaaORuARFQQ@mail.gmail.com>
In-Reply-To: <CACVXFVMdgx1we67poF5yU5pAYRYoA9Ao1EJqQgGBaaORuARFQQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2013-01-11 03:45, Ming Lei wrote:
> Cc netdev and usb lists.
>
>
> On Fri, Jan 11, 2013 at 9:17 AM,  <freddy@asix.com.tw> wrote:
>> From: Freddy Xin <freddy@asix.com.tw>
>>
>> This patch adds a driver for ASIX's AX88179 family of USB 3.0/2.0
>> to gigabit ethernet adapters. It's based on the AX88xxx driver but
>> the usb commands used to access registers for AX88179 are completely different.
>> This driver had been verified on x86 system with AX88179/AX88178A and
>> Sitcomm LN-032 USB dongles.
>>
>> Signed-off-by: Freddy Xin <freddy@asix.com.tw>
>> ---
>>   drivers/net/usb/Kconfig        |   18 +
>>   drivers/net/usb/Makefile       |    1 +
>>   drivers/net/usb/ax88179_178a.c | 1457 ++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 1476 insertions(+)
>>   create mode 100644 drivers/net/usb/ax88179_178a.c
>>

[...]

>> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
>> new file mode 100644
>> index 0000000..47504ea
>> --- /dev/null
>> +++ b/drivers/net/usb/ax88179_178a.c
[...]
>> +static int ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>> +                           u16 size, void *data)
>> +{
>> +       int ret;
>> +       ret = usbnet_read_cmd(dev, cmd,
>> +                              USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>> +                              value, index, data, size);
>> +
>> +       if (ret != size && ret >= 0)
>> +               return -EINVAL;
>> +       return ret;
>> +}
>> +
>> +static int ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>> +                            u16 size, void *data)
>> +{
>> +       return usbnet_write_cmd(dev, cmd, USB_DIR_OUT | USB_TYPE_VENDOR
>> +                               | USB_RECIP_DEVICE, value, index, data, size);
>> +}
>> +
>> +static void
>> +ax88179_write_cmd_async(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>> +                                   u16 size, void *data)
>> +{
>> +       usbnet_write_cmd_async(dev, cmd,
>> +                              USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>> +                              value, index, data, size);
>> +}
>> +

ax88179_read_cmd, ax88179_write_cmd, and ax88179_write_cmd_async 
duplicate code from asix_common.c.

[...]

>> +static int ax88179_get_eeprom(struct net_device *net,
>> +                             struct ethtool_eeprom *eeprom, u8 *data)
>> +{
>> +       struct usbnet *dev = netdev_priv(net);
>> +       u16 *ebuf = (u16 *)data;
>> +       int i;
>> +
>> +       /* Crude hack to ensure that we don't overwrite memory
>> +        * if an odd length is supplied

Have a look at asix_get_eeprom() in asix_common.c for a better 
implementation. There is also code for programming the eeprom 
(asix_set_eeprom in asix_common.c), can this be used for the 
AX88179/178A as well?

Regards, Christian

>> +        */
>> +       if (eeprom->len % 2)
>> +               return -EINVAL;
>> +
>> +       /* ax8817x returns 2 bytes from eeprom on read */
>> +       for (i = 0; i < eeprom->len / 2; i++) {
>> +               if (ax88179_read_cmd(dev, AX_ACCESS_EEPROM,
>> +                       eeprom->offset + i, 1, 2, &ebuf[i]) < 0)
>> +                       return -EINVAL;
>> +       }
>> +       return 0;
>> +}
>> +

