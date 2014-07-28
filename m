Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980AbaG1HTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:19:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:51436 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbaG1HTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:19:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,747,1400050800"; 
   d="scan'208";a="576389692"
Message-ID: <53D5F8C9.4070008@intel.com>
Date: Mon, 28 Jul 2014 15:16:25 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        mnipxh <mnipxh@gmail.com>, Peter Hurley <peter@hurleysoftware.com>,
        gnomes@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] tty/n_gsm.c: do not clear gsm_mux entry when the gsm
 is not closed
References: <53D0CF0D.9060103@intel.com> <20140727180953.GA7232@kroah.com>
In-Reply-To: <20140727180953.GA7232@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Greg

于 2014年07月28日 02:09, Greg Kroah-Hartman 写道:
> On Thu, Jul 24, 2014 at 05:17:01PM +0800, xinhui.pan wrote:
>> If the gsmtty is still used by some process, we could not just
>> simply clear gsm_mux[gsm->num]. Clear it when gsm is being free.
>> Otherwise we will hit crashes when userspace close the gsmtty.
>>
>> Also add gsm_mux_get() and gsm_mux_put() to make gsm_mux[] is used safely.
>> We can do activation/deactivation with same gsm more than once now.
>> This is for fixing the FIXME.
>>
>> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
>> Reviewed-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
>> ---
>>  drivers/tty/n_gsm.c |   84 ++++++++++++++++++++++++++++++++++++---------------
>>  1 file changed, 60 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
>> index 81e7ccb..290df56 100644
>> --- a/drivers/tty/n_gsm.c
>> +++ b/drivers/tty/n_gsm.c
>> @@ -2020,6 +2020,58 @@ static void gsm_error(struct gsm_mux *gsm,
>>  }
>>  
>>  /**
>> + *	gsm_mux_get		-	get/fill one entry in gsm_mux
>> + *	@gsm: our gsm
>> + *
>> + *	Although its name end with get, it don't inc ref-count actually.
> 
> Then don't call it a 'get' function :(
> 

Thanks for you nice advices!
I will change its name. This is really a confusable name.

>> + *	get one entry is just like fill pte, first memory access will
>> + *	cause page_fault, the next accesses don't. So do here.
> 
> This doesn't make much sense to me, can you please explain it better?
> 
>> + */
>> +
> 
> blank line?
> 

Sorry about that. But I notice the other function's introduce in n_gsm.c is done in same way.
I just wanted to keep same code style.
OK, I will change it.
I think no blank line is better. :)

>> +static int gsm_mux_get(struct gsm_mux *gsm)
>> +{
>> +	int i;
>> +
>> +	if (gsm->num >= MAX_MUX) /* gsm is alloc by kzalloc, just be careful */
>> +		return -EIO;
> 
> -EIO?
> 

Thanks for pointing out the mistake.
perhaps -EINVAL is better.

>> +	if (gsm_mux[gsm->num] == gsm) /* We have already set gsm->num */
>> +		return 0;
>> +
>> +	spin_lock(&gsm_mux_lock);
>> +	for (i = 0; i < MAX_MUX; i++) {
>> +		if (gsm_mux[i] == NULL) {
>> +			gsm->num = i;
>> +			gsm_mux[i] = gsm;
>> +			break;
>> +		}
>> +	}
>> +	spin_unlock(&gsm_mux_lock);
>> +
>> +	if (i == MAX_MUX)
>> +		return -EBUSY;
>> +	return 0;
>> +}
>> +
>> +/**
>> + *	gsm_mux_put		-	put/clear one entry in gsm_mux
>> + *	@gsm: our gsm
>> + *
>> + *	Although its name end with put, it don't dec ref-count actually.
>> + *	put one entry is just like clear pte, So do here.
>> + */
>> +
>> +static void gsm_mux_put(struct gsm_mux *gsm)
>> +{
>> +	if (gsm->num >= MAX_MUX)
>> +		return;
>> +
>> +	spin_lock(&gsm_mux_lock);
>> +	if (gsm_mux[gsm->num] == gsm)
> 
> How can this not be true?

That is a big problem. let me explain it.

In current code, we add gsm into gsm_mux[] in gsm_activate_mux(). So if gsm_activate_mux() fails when gsm_mux[] is full, gsm->num is invaild, it is zero in fact.
So when will free this gsm, we have to check if gsm_mux[gsm->num] is really the one we are deleting.
The scenario is like below.
gsmld_open -> gsmld_attach_gsm -> gsm_activate_mux(fails) -> .... -> mux_put -> gsm_free_muxr -> gsm_mux_put(need check gsm_mux[gsm->num] == gsm).

Current code is a little hard to understand, So I suggest that move the *codes that changes gsm_mux[]* into gsm_alloc_mux(), then we don't need this check anymore.
Actually I have worked out a new patch with such idea.
And I am doing the normal tests set up by Intel test team and other trigger tests set up by myself. :)

> 
>> +		gsm_mux[gsm->num] = NULL;
>> +	spin_unlock(&gsm_mux_lock);
>> +}
> 
> Why can't you do dynamic reference counting of your structure, that
> would allow you to get rid of your global array, right?
> 

Thanks for your nice comments.
Struct gsm has a ref-count already. :)
And also adding a ref-count is a little hard to me. :(
This global array is used to keep tracking the gsms that stands for the gsmttyXX.
and it can tell us if we can create a new gsm. :)
In gsm_init we set *gsm_tty_driver = alloc_tty_driver(256);*

thanks,

xinhui

> thanks,
> 
> greg k-h
> 

Your reply really helps us a lot.
thanks,

xinhui

