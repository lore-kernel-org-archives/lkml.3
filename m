Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaG2T00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:26:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34189 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaG2T0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:26:25 -0400
Message-ID: <53D7F561.1000603@wwwdotorg.org>
Date: Tue, 29 Jul 2014 13:26:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nick Dyer <nick.dyer@itdev.co.uk>
CC: Yufeng Shen <miletus@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 00/15] atmel_mxt_ts - device tree, bootloader, etc
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>	<53CECAEC.8080905@wwwdotorg.org>	<53CFD50C.4040509@itdev.co.uk>	<53CFEF6E.2060905@wwwdotorg.org>	<53D10E78.4010908@itdev.co.uk>	<53D17845.4020507@wwwdotorg.org>	<53D26572.3030404@itdev.co.uk>	<53D2B8D0.5090000@wwwdotorg.org>	<CAPDwgkNrBRJRR6WtoPSfs8Yq=ui-Ptjju4mJ=9h=95YVFuxw7g@mail.gmail.com>	<53D6BF50.3070306@wwwdotorg.org>	<53D6DFE7.3040901@wwwdotorg.org> <CAPDwgkPL1utj3DFoFbOCcJsASpf+12nvKg1KcseV_MhEz66eiw@mail.gmail.com> <53D7C8CC.1050201@wwwdotorg.org> <53D7D47E.5060906@itdev.co.uk>
In-Reply-To: <53D7D47E.5060906@itdev.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 11:06 AM, Nick Dyer wrote:
> On 29/07/14 17:16, Stephen Warren wrote:
>> I then tried updating the firmware. This didn't work at all.
>>
>> First I tried via mxt-app:
>>
>>> root@localhost:~# ./obp-utils/mxt-app -d i2c-dev:1-004b --flash
>>> 130.1_1.0.170.bin
>>> Version:1.16-65-g0a4c
>>> Opening firmware file 130.1_1.0.170.bin
>>> Registered i2c-dev adapter:1 address:0x4b
>>> Chip detected
>>> Current firmware version: 1.0.AA
>>> Skipping version check
>>> Resetting in bootloader mode
>>> Registered i2c-dev adapter:1 address:0x25
>>> Error Remote I/O error (121) reading from i2c
>>> Bootloader read failure
>>> Bootloader not found
>>
>> Then I power-cycled and tried via the atmel_mxt_ts modules' sysfs files:
>>
>>> root@localhost:~# echo 1 >
>>> /sys/devices/soc0/7000c400.i2c/i2c-1/1-004b/update_fw
>>> [   38.495420] atmel_mxt_ts 1-004b: mxt_bootloader_read: i2c recv failed
>>> (-121)
>>> [   38.506208] atmel_mxt_ts 1-004b: mxt_bootloader_read: i2c recv failed
>>> (-121)
>>> [   38.513836] atmel_mxt_ts 1-004b: The firmware update failed(-121)
>>> -bash: echo: write error: Remote I/O error
>
> OK - that's the same error in both cases, it has tried to switch the device
> into bootloader mode, however it is not responding on the bootloader I2C
> address.
>
> Couple of things to check:
> - is the device in deep sleep mode when you run the mxt-app command? can
> you try doing "mxt-app [device] -W -T7 FFFF" which will make sure it is
> definitely not sleeping first.

That didn't hekp.

> - if you do "mxt-app [device] -i" straight after the --flash failure, does
> it respond (which would mean it hasn't actioned the reset-into-bootloader
> command)

That still works, so I assume it wasn't reset into bootloader mode. I 
also tried mxt-app --reset-bootloader, and mxt-app -i still works after 
that too.

>> I also found that removing the module (even without attempting a FW update)
>> yields:
>>
>> After attempted FW update via sysfs:
>>
>>> root@localhost:~# rmmod ./atmel_mxt_ts.ko
>>> [   81.995672] Unable to handle kernel NULL pointer dereference at virtual address 00000364
>
> Not good. It's trying to free an input device which isn't registered at
> that point. In a later patch in my series I add a guard around that
> (mxt_free_input_device):
> https://github.com/ndyer/linux/commit/bb4800ff8c185

It looks like 8d01a84b86b0 "Input: atmel_mxt_ts - implement T100 touch 
object support" from that branch is what solves the issue.

Ah, in linux-next, it's simply a double-unregister; both mxt_remove() 
and mxt_free_object_table() call 
input_unregister_device(data->input_dev). I think it would make sense to 
send the following patch for 3.17. Do you agree?

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c 
b/drivers/input/touchscreen/atmel_mxt_ts.c
index 03b85711cb70..da497dbf9735 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1353,8 +1353,10 @@ static int mxt_get_info(struct mxt_data *data)

  static void mxt_free_object_table(struct mxt_data *data)
  {
-	input_unregister_device(data->input_dev);
-	data->input_dev = NULL;
+	if (data->input_dev) {
+		input_unregister_device(data->input_dev);
+		data->input_dev = NULL;
+	}

  	kfree(data->object_table);
  	data->object_table = NULL;
@@ -2194,7 +2196,6 @@ static int mxt_remove(struct i2c_client *client)

  	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
  	free_irq(data->irq, data);
-	input_unregister_device(data->input_dev);
  	mxt_free_object_table(data);
  	kfree(data);

