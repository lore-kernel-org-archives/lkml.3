Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3KAQ3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:29:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab3KAQ3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:29:02 -0400
Message-ID: <5273D684.90306@redhat.com>
Date: Fri, 01 Nov 2013 17:27:48 +0100
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: scameron@beardog.cce.hp.com, Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <axboe@kernel.dk>, stephenmcameron@gmail.com,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: return 0 from driver probe function on success,
 not 1
References: <20131029184135.5505.77412.stgit@beardog.cce.hp.com> <52700541.70405@kernel.dk> <20131031144241.25090ab7a6c0b668c5c1c2b2@linux-foundation.org> <20131031215444.GN31390@beardog.cce.hp.com> <20131031150618.fa9430269e0de7a5ebad1387@linux-foundation.org> <5273A765.6080705@redhat.com> <20131101063110.6a390f48.akpm@linux-foundation.org> <20131101140837.GO31390@beardog.cce.hp.com>
In-Reply-To: <20131101140837.GO31390@beardog.cce.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 03:08 PM, scameron@beardog.cce.hp.com wrote:
> On Fri, Nov 01, 2013 at 06:31:10AM -0700, Andrew Morton wrote:
>> On Fri, 01 Nov 2013 14:06:45 +0100 Tomas Henzl <thenzl@redhat.com> wrote:
>>
>>> The problem in kernel is that the error handling in local_pci_probe
>>> and  in __pci_device_probe is different for ret values > 0,
>>> so we should fix it somewhere so it is in sync.
>>> The documentation states that the probe function should return zero on success
>>> so what about this -
>>>
>>> This would bring the handling to sync
>>> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
>>> index 98f7b9b..200a071 100644
>>> --- a/drivers/pci/pci-driver.c
>>> +++ b/drivers/pci/pci-driver.c
>>> @@ -317,8 +317,6 @@ __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
>>>  		id = pci_match_device(drv, pci_dev);
>>>  		if (id)
>>>  			error = pci_call_probe(drv, pci_dev, id);
>>> -		if (error >= 0)
>>> -			error = 0;
>>>  	}
>>>  	return error;
>>>  }
>> ah, there it is.
>>
>> This change would turn semi-kaput drivers into kaput-kaput drivers.  It
>> would be better to add a runtime warning here so those drivers get
>> fixed.  Such a warning would need to reliably identify the offending
>> probe function so a simple WARN_ON() wouldn't be sufficient.
>>
> FWIW, I just booted up with the following change:
>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 98f7b9b..ef71bb5 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -264,9 +264,16 @@ static long local_pci_probe(void *_ddi)
>  	pm_runtime_get_sync(dev);
>  	pci_dev->driver = pci_drv;
>  	rc = pci_drv->probe(pci_dev, ddi->id);
> -	if (rc) {
> +	if (rc < 0) {
>  		pci_dev->driver = NULL;
>  		pm_runtime_put_sync(dev);
> +	} else {
> +		if (rc > 0) {
> +			dev_warn(dev,
> +				"Driver probe function returned %d, greater than 0\n", rc);
> +			rc = 0;
> +			
> +		}
>  	}
>  	return rc;
>  }
>
>
> And,
>
> [scameron@localhost linux-3.12-rc6]$ dmesg | grep 'Driver probe'
> [scameron@localhost linux-3.12-rc6]$
>
> Not that it means all that much since I don't have hardware for
> the majority of drivers, obviously.
>
> I think the above should make drivers with probe functions
> returning > 0 "work" again, but with a warning.
>
> The question would be, are there drivers which return > 0 and
> by this value intend to convey that the probe function has failed?

I think that this is unlikely and the patch is fine, but I can't speak for the drivers..

Please repost your patch so it gets more attention than in this thread. 

>
> -- steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

