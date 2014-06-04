Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaFDPlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:41:51 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:52511 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaFDPlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:41:49 -0400
Message-ID: <538F3E3B.5080906@mutualink.net>
Date: Wed, 04 Jun 2014 11:41:47 -0400
From: Mike Remski <mremski@mutualink.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: ftdi_sio BUG: NULL pointer dereference
References: <20140602162027.GB13790@localhost> <538CA54C.4040803@mutualink.net> <20140602164957.GC13790@localhost> <538CB049.9020805@mutualink.net> <20140602174630.GD13790@localhost> <538DA0BD.5080208@mutualink.net> <20140604141937.GA11160@localhost> <538F2D51.2010508@mutualink.net> <20140604145200.GB11160@localhost> <538F3360.40407@mutualink.net> <20140604150938.GD11160@localhost>
In-Reply-To: <20140604150938.GD11160@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 11:09 AM, Johan Hovold wrote:
> On Wed, Jun 04, 2014 at 10:55:28AM -0400, Mike Remski wrote:
>> On 06/04/2014 10:52 AM, Johan Hovold wrote:
>>> On Wed, Jun 04, 2014 at 10:29:37AM -0400, Mike Remski wrote:
>>>> On 06/04/2014 10:19 AM, Johan Hovold wrote:
>>>>> >From 4ddea3a573b8c15beefb67bc35c440850063d79d Mon Sep 17 00:00:00 2001
>>>>> From: Johan Hovold <johan@kernel.org>
>>>>> Date: Wed, 4 Jun 2014 14:09:43 +0200
>>>>> Subject: [PATCH 1/5] USB: ftdi_sio: fix null deref at port probe
>>>>>
>>>>> Fix NULL-pointer dereference when probing an interface with no
>>>>> endpoints.
>>>>>
>>>>> These devices have two bulk endpoints per interface, but this avoids
>>>>> crashing the kernel if a user forces a non-FTDI device to be probed.
>>>>>
>>>>> Note that the iterator variable was made unsigned in order to avoid
>>>>> a maybe-uninitialized compiler warning for ep_desc after the loop.
>>>>>
>>>>> Fixes: 895f28badce9 ("USB: ftdi_sio: fix hi-speed device packet size
>>>>> calculation")
>>>>>
>>>>> Reported-by: Mike Remski <mremski@mutualink.net>
>>>>> Cc: <stable@vger.kernel.org>	# 2.3.61
>>>>> Signed-off-by: Johan Hovold <johan@kernel.org>
>>>>> ---
>>>>>     drivers/usb/serial/ftdi_sio.c | 7 +++++--
>>>>>     1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
>>>>> index 7c6e1dedeb06..3019141397eb 100644
>>>>> --- a/drivers/usb/serial/ftdi_sio.c
>>>>> +++ b/drivers/usb/serial/ftdi_sio.c
>>>>> @@ -1564,14 +1564,17 @@ static void ftdi_set_max_packet_size(struct usb_serial_port *port)
>>>>>     	struct usb_device *udev = serial->dev;
>>>>>     
>>>>>     	struct usb_interface *interface = serial->interface;
>>>>> -	struct usb_endpoint_descriptor *ep_desc = &interface->cur_altsetting->endpoint[1].desc;
>>>>> +	struct usb_endpoint_descriptor *ep_desc;
>>>>>     
>>>>>     	unsigned num_endpoints;
>>>>> -	int i;
>>>>> +	unsigned i;
>>>>>     
>>>>>     	num_endpoints = interface->cur_altsetting->desc.bNumEndpoints;
>>>>>     	dev_info(&udev->dev, "Number of endpoints %d\n", num_endpoints);
>>>>>     
>>>>> +	if (!num_endpoints)
>>>>> +		return;
>>>>> +
>>>>>     	/* NOTE: some customers have programmed FT232R/FT245R devices
>>>>>     	 * with an endpoint size of 0 - not good.  In this case, we
>>>>>     	 * want to override the endpoint descriptor setting and use a
>>>> Thanks Johan.  I tried to get the cdc_acm working;  did not have much
>>>> luck/time (typical overcommit on workload) I will retry with the commit
>>>> mentioned.
>>>> I will try the patch today and get back to you.  Nice on the ep_desc:
>>>> looking at the code priv->max_packet_size is attached to the port, your
>>>> change would use the last thing off of cur_altsetting->endpoint[], but
>>>> I'm wondering if we should actually be setting priv->max_packet_size to
>>>> whatever the max is of all endpoint[].desc->wMaxPacketSize?
>>>>
>>>> Thoughts?
>>> This is the exact same behaviour as the old code (minus the NULL-deref).
>>>
>>> These device have two bulk endpoints per interface and they are supposed
>>> to be using the same max packet size (64 or 512 depending on device and
>>> host).
>>>
>>> This value is also used during depacketisation of incoming data (and
>>> packetisation of outgoing data for legacy devices). I'm pretty convinced
>>> you're using the wrong driver, something which would lead to corruption
>>> of incoming data when the (non-existing) status bytes are stripped from
>>> the stream.
>>>
>>> You really should try cdc-acm.
>>>
>>> Johan
>> Sorry, forgot to add:
>> Tested patch and it works as desired.
> Thanks, I'll add a Tested-by tag then.
>
> Johan

Ok, had a chance to try the cdc-acm;  yes it's the ancient one that is 
in the base install of CentOS 6.4 (2.6.32-71.29.1 centos patched).  I'm 
hitting something similar;  I noticed there where a few commits for NULL 
pointer dereferences in cdc-acm.c.

I'll poke into this a bit (yes, I know try a newer kernel, etc) and let 
you know what I find (or perhaps this looks similar to something already 
seen?).  This device is the same as the original ftdi crash, 1.2 is the 
same interface with bNumEndpoints == 0.

Jun  4 11:35:20 nicA91A84 kernel: cdc_acm 5-2:1.2: This device cannot do 
calls on its own. It is not a modem.
Jun  4 11:35:20 nicA91A84 kernel: BUG: unable to handle kernel NULL 
pointer dereference at 00000004
Jun  4 11:35:20 nicA91A84 kernel: IP: [<f84f9c9e>] 
acm_probe+0x44e/0x127c [cdc_acm]
Jun  4 11:35:20 nicA91A84 kernel: *pdpt = 00000000354eb001 *pde = 
000000007f003067
Jun  4 11:35:20 nicA91A84 kernel: Oops: 0000 [#1] SMP
Jun  4 11:35:20 nicA91A84 kernel: last sysfs file: 
/sys/devices/pci0000:00/0000:00:1d.0/usb5/5-2/product


-- 
Office: (978)401-4032 (x123 internally)
Cell: (603) 759-6953

