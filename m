Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab3K3LZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 06:25:49 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:44585 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3K3LZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 06:25:48 -0500
Message-ID: <5299CB38.8090808@linux.com>
Date: Sat, 30 Nov 2013 12:25:44 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, EDAC <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
References: <5298F900.9000208@linux.com> <20131129205628.GA20144@pd.tnic> <52999419.7040600@linux.com> <20131130111214.GB4323@pd.tnic>
In-Reply-To: <20131130111214.GB4323@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-30 12:12, Borislav Petkov:
> On Sat, Nov 30, 2013 at 08:30:33AM +0100, Levente Kurusa wrote:
>> No, if the call to put_device gives up the last reference to the
>> device, then device_release gets called which in turn frees the memory
>> associated with it. In this case, mce_device_release() will get
>> called, which is just a simple kfree call.
> 
> Aah, that's that delayed freeing the driver core does, right. Now you
> made me go and look into detail:
> 
> device_unregister
> |->put_device
>   |->kobject_put
>      |->kref_put(&kobj->kref, kobject_release)
> 	|->kref_sub(kref, 1, release)
> 	   |->release
> 	   |->kobject_release
> 	      |->kobject_cleanup
> 	         |->t->release
> 		 |->device_release
> 		    |->mce_device_release
> 
Now this tree makes me wonder if there are devices where
the author forgot to set a device_release or when the put_device
is not called. I will take a look into this.
> 
> Ok, I see it now. :-) :-)
> 
> Thanks, I'll take your patch as-is.
> 
Awesome, thanks! :-)


-- 
Regards,
Levente Kurusa
