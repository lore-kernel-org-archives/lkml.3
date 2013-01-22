Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3AVJNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:13:13 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:38004 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab3AVJNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:13:08 -0500
Message-ID: <50FE5816.30703@compulab.co.il>
Date: Tue, 22 Jan 2013 11:12:54 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121218 Thunderbird/10.0.11
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] usb: musb: fix context save over suspend.
References: <20130121202831.40a09bbc@notabene.brown> <50FD28D3.5070107@compulab.co.il> <20130122083832.7a3026c9@notabene.brown>
In-Reply-To: <20130122083832.7a3026c9@notabene.brown>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

It looks like Kevin has a new address:
Kevin Hilman <khilman@deeprootsystems.com>

On 01/21/13 23:38, NeilBrown wrote:
> On Mon, 21 Jan 2013 13:38:59 +0200 Igor Grinberg <grinberg@compulab.co.il>
> wrote:
> 
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
> 
>> Hi Neil,
> 
>> On 01/21/13 11:28, NeilBrown wrote:
>>>
>>>
>>> The standard suspend sequence involves runtime_resuming
>>> devices before suspending the system.
>>> So just saving context in runtime_suspend and restoring it
>>> in runtime resume isn't enough.  We  must also save in "suspend"
>>> and restore in "resume".
>>>
>>> Without this patch, and OMAP3 system with off_mode enabled will find
>>> the musb port non-functional after suspend/resume.  With the patch it
>>> works perfectly.
> 
>> Hmmm... Some time ago, this has been removed in
>> 5d193ce8 (usb: musb: PM: fix context save/restore in suspend/resume path)
> 
>> Am I missing something? Or things changed and now this patch is correct?
> 
> Hi Igor,
>  thanks for alerting me to that patch .... does anyone else get the feeling
>  that power management to too complex to be understood by a mere human?
> 
>  That commit (5d193ce8) suggests that the musb-hdrc device is an
>  'omap_device', or maybe has a PM domain set to something else.
>  However it isn't/doesn't.  dev->pm_domain is NULL.  So no PM domain layer
>  will ever call the musb_core musb_runtime_suspend/resume.
> 
>  The parent device - musb-omap2430 - is an omap device, does have pm_domain
>  set, and does have its omap2430_runtime_suspend/resume called for system
>  suspend and so the context for that device is saved and restored.
>  However that doesn't help the context for musb-hdrc.
> 
>  Whether musb ever was an omap_device is beyond my archaeological skills to
>  determine.
> 
>  Kevin:  Was musb-hdrc ever a device with a pm_domain? or was it only ever
>      the various possible parents that had domains?
>      Are you able to defend your earlier patch in today's kernel?  It
>      certainly causes my device not to work properly.
> 
> Thanks,
> NeilBrown
> 
> 
> 
> 
>>>
>>> Signed-off-by: NeilBrown <neilb@suse.de>
>>>
>>> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
>>> index fd34867..b6ccc02 100644
>>> --- a/drivers/usb/musb/musb_core.c
>>> +++ b/drivers/usb/musb/musb_core.c
>>> @@ -2225,6 +2225,7 @@ static int musb_suspend(struct device *dev)
>>>  	}
>>>  
>>>  	spin_unlock_irqrestore(&musb->lock, flags);
>>> +	musb_save_context(musb);
>>>  	return 0;
>>>  }
>>>  
>>> @@ -2234,6 +2235,8 @@ static int musb_resume_noirq(struct device *dev)
>>>  	 * unless for some reason the whole soc powered down or the USB
>>>  	 * module got reset through the PSC (vs just being disabled).
>>>  	 */
>>> +	struct musb	*musb = dev_to_musb(dev);
>>> +	musb_restore_context(musb);
>>>  	return 0;
>>>  }
>>>  
> 
>> - -- 
>> Regards,
>> Igor.
>> 


- -- 
Regards,
Igor.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQ/lgWAAoJEBDE8YO64EfacIAP/3nyXjs8QQpcD6RcNuRSLp3O
veKU2grzsUOL/Eu/8TQMM7WDz5n8YlycQ6/THNGGYojjOlEimDC02wbsI4gc5j41
QC1/XGf62Nlxv6CzORzkGkUoKXtVWzgMYKddWKPEwsXMKPun/LH4ZGDp+7Rkfcmu
U0k7LM1Pv487iG9pF3Bq5BPYeMxyxyFJC0PiQEK1ZE65RKWbCvInibc7p1bvZ+XX
JQxf8Qx1p/kBhqWc6LLpcHT5Z3B/F+3rxEhvf8lSu5fdRPHFffcmuX7bIbC/GlTe
e6mODA114mtn5YbaKCmnYExvJcpz4Nziy+8fGLJ56aAyeKI1wsOJzhWDpSKwQiIF
CVtYulk5iIfaeUA4sAzvRqEu7dJuaVgm6mEeGHQjebPastYhK7vHjiEOJJ2+LQrs
698A9wMLckp4AQ75HiwXRgi5N0W528gD8piNoIA9Sh1LwyytIa5Wg7uYw14UjtLJ
QIerm0v6Ay+8FbVfmpm9k0v3HkYfv0ZVTSdtIXVAE30+WKIBTn0yszxWYo6JZtvj
p0NEFUNVuR3C9k/xyzkcqwJh8Q6DrleWJeHWL59xgWWKzfeDKjU/DMOuWmuVEkTO
aRdAlW32VDtUeWlWz3Jz3IOWZRJQKCW2o97n/MDyxwMoRiMWcHxYw6jti6se9S7a
IGZeEMCcf39fnH5o7i2q
=nwGe
-----END PGP SIGNATURE-----
