Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab3KANH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab3KANHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:07:55 -0400
Message-ID: <5273A765.6080705@redhat.com>
Date: Fri, 01 Nov 2013 14:06:45 +0100
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, scameron@beardog.cce.hp.com
CC: Jens Axboe <axboe@kernel.dk>, stephenmcameron@gmail.com,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: return 0 from driver probe function on success,
 not 1
References: <20131029184135.5505.77412.stgit@beardog.cce.hp.com>	<52700541.70405@kernel.dk>	<20131031144241.25090ab7a6c0b668c5c1c2b2@linux-foundation.org>	<20131031215444.GN31390@beardog.cce.hp.com> <20131031150618.fa9430269e0de7a5ebad1387@linux-foundation.org>
In-Reply-To: <20131031150618.fa9430269e0de7a5ebad1387@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 11:06 PM, Andrew Morton wrote:
> On Thu, 31 Oct 2013 16:54:44 -0500 scameron@beardog.cce.hp.com wrote:
>
>>>> How did this ever work?
>>> Beats me.  local_pci_probe() does
>>>
>>> 	rc = pci_drv->probe(pci_dev, ddi->id);
>>> 	if (rc) {
>>> 		pci_dev->driver = NULL;
>>> 		pm_runtime_put_sync(dev);
>>> 	}
>>> 	return rc;
>>>
>>> shrug, maybe this ->probe somehow has a different caller which checks
>>> for <0.
>> Older kernels (eg: http://lxr.linux.no/#linux+v2.6.32.61/drivers/pci/pci-driver.c )
>> had different code:
>>
>>  330__pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
>>  331{
>>  332        const struct pci_device_id *id;
>>  333        int error = 0;
>>  334
>>  335        if (!pci_dev->driver && drv->probe) {
>>  336                error = -ENODEV;
>>  337
>>  338                id = pci_match_device(drv, pci_dev);
>>  339                if (id)
>>  340                        error = pci_call_probe(drv, pci_dev, id);
>>  341                if (error >= 0) {
>>  342                        pci_dev->driver = drv;
>>  343                        error = 0;
>>  344                }
>>  345        }
>>  346        return error;
>>  347}
> So cciss is presently kompletely kaput?  If so, the kapputting code is
> present in 3.9 and probably earlier, so this patch is needed in 3.12 and
> -stable.  Or if not, what?

Steve posted similar patch for hpsa too and I'm sure someone would notice
when the hpsa driver was kaput. If I understand it correctly the driver
works with some limitation - rmmod doesn't work for example.

The problem in kernel is that the error handling in local_pci_probe
and  in __pci_device_probe is different for ret values > 0,
so we should fix it somewhere so it is in sync.
The documentation states that the probe function should return zero on success
so what about this -

This would bring the handling to sync
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 98f7b9b..200a071 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -317,8 +317,6 @@ __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
 		id = pci_match_device(drv, pci_dev);
 		if (id)
 			error = pci_call_probe(drv, pci_dev, id);
-		if (error >= 0)
-			error = 0;
 	}
 	return error;
 }


>
> (Playing question and answer like this is a bad way of writing a
> changelog btw - all this stuff should have been right there in the v1
> changelog).
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

