Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab3B0JAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 04:00:40 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:44889 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab3B0JAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 04:00:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcLAK3KLVFbdWOb/2dsb2JhbABFuicih0Z8FnOCHwEBBAEnQBEBBQsLGAkWDwkDAgECAUUGDQEFAgEBiAkKvmGNQYFTB4NAA5ZBiWOHB4MJgWg
X-IPAS-Result: AjcLAK3KLVFbdWOb/2dsb2JhbABFuicih0Z8FnOCHwEBBAEnQBEBBQsLGAkWDwkDAgECAUUGDQEFAgEBiAkKvmGNQYFTB4NAA5ZBiWOHB4MJgWg
Message-ID: <512DCB33.6030500@igalia.com>
Date: Wed, 27 Feb 2013 10:00:35 +0100
From: =?ISO-8859-1?Q?Samuel_Iglesias_Gons=E1lvez?= <siglesias@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipack: add missing put_device() after device_register()
 failed
References: <1361869395-23110-1-git-send-email-siglesias@igalia.com> <20130226222842.GA20670@core.coreip.homeip.net>
In-Reply-To: <20130226222842.GA20670@core.coreip.homeip.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

First of all, thanks for your comments.

On 02/26/2013 11:28 PM, Dmitry Torokhov wrote:
> On Tue, Feb 26, 2013 at 10:03:15AM +0100, Samuel Iglesias Gonsalvez wrote:
>> put_device() must be called after device_register() fails,
>> since device_register() always initializes the refcount
>> on the device structure to one.
>>
>> dev->id is free'd inside of ipack_device_release function.
>> So, it's not needed to do it here.
>>
>> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
>> ---
>>  drivers/ipack/ipack.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
>> index 7ec6b20..3588ccf 100644
>> --- a/drivers/ipack/ipack.c
>> +++ b/drivers/ipack/ipack.c
>> @@ -449,7 +449,7 @@ int ipack_device_register(struct ipack_device *dev)
>>  
>>  	ret = device_register(&dev->dev);
>>  	if (ret < 0)
>> -		kfree(dev->id);
>> +		put_device(&dev->dev);
> 
> Now callers have no idea if they have to free (put_device) it in case of
> failure or it is already done for them, because a few lines earlier, if
> pack_device_read_id() fails, it simply returns error code.
> 
> IMO if a function did not allocate object it should not try to free it,
> callers should dispose of the device as they see fit.
> 
> What is missing, however, is dev->id = NULL assignment so that if caller
> does put_device() kit won't double-free the memory.

OK. I will write a patch.

> Also it would make
> sense to split device_register into device_init() and device_add() so
> that device_init() is very first thing you do and in case of all
> failures callers should use put_device().
> 

It makes sense. I will write a patch for it.

> Also tpci200.c need to learn to clean up after itself and I also not
> sure why it tries to provide its own release function.
>

tpci200 driver is the one who allocated the struct ipack_device and it
should free it. The path to release it is the following:

* The kernel will call the corresponding release() function of the
struct device. This callback is linked to ipack_release_device() in
ipack.c. In that function, there is a kfree(dev->id) as it was
previously allocated by ipack bus driver.

* Then, ipack_release_device() calls the carrier's release function to
indicate that the device is being released and the carrier driver needs
to take care of its own resources.

In summary, each driver allocate and free its own resources when
unregistering a device.

Thanks,

Sam
