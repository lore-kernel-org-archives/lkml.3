Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaB0EsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:48:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:33639 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaB0EsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:48:07 -0500
X-IronPort-AV: E=Sophos;i="4.97,552,1389715200"; 
   d="scan'208";a="9613249"
Message-ID: <530EC360.6010209@cn.fujitsu.com>
Date: Thu, 27 Feb 2014 12:47:28 +0800
From: Li Guang <lig.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20120421 Iceape/2.0.11
MIME-Version: 1.0
To: Kieran Clancy <clancy.kieran@gmail.com>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Dennis Jansen <dennis.jansen@web.de>
Subject: Re: [PATCH] ACPI / EC: Clear stale EC events on Samsung systems
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com> <530E9BEF.8080601@cn.fujitsu.com> <CAGf84Q+Xd9EUjOEMe3+EMRhdPaFgnAjNDOoPZmf=gn8mi=FhWw@mail.gmail.com>
In-Reply-To: <CAGf84Q+Xd9EUjOEMe3+EMRhdPaFgnAjNDOoPZmf=gn8mi=FhWw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 12:45:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 12:45:41,
	Serialize complete at 2014/02/27 12:45:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kieran Clancy wrote:
> On Thu, Feb 27, 2014 at 12:29 PM, Li Guang<lig.fnst@cn.fujitsu.com>  wrote:
>    
>>> +#define ACPI_EC_CLEAR_MAX      20      /* Maximum number of events to
>>> query
>>> +                                        * when trying to clear the EC */
>>>
>>>        
>>
>> 20 is enough?
>> the query index is length of a byte.
>>      
> On my machine, 8 seems to be enough, so 20 seems to be a conservative
> maximum. Just reading your other email, maybe we should set this to
> 32? or 40? 100?
>
> If it's not enough, hopefully anyone seeing bugs will notice the
> warning "maximum of X stale EC events cleared".
>
> Here's what happens if I plug/replug the AC lots of times (more than
> 8) during suspend:
>
> [ 8807.019800] ACPI : EC: --->  status = 0x29
> [ 8807.019804] ACPI : EC: --->  data = 0x66
> [ 8807.020790] ACPI : EC: --->  status = 0x29
> [ 8807.020793] ACPI : EC: --->  data = 0x66
> [ 8807.021793] ACPI : EC: --->  status = 0x29
> [ 8807.021798] ACPI : EC: --->  data = 0x66
> [ 8807.022831] ACPI : EC: --->  status = 0x29
> [ 8807.022834] ACPI : EC: --->  data = 0x66
> [ 8807.023788] ACPI : EC: --->  status = 0x29
> [ 8807.023792] ACPI : EC: --->  data = 0x66
> [ 8807.024787] ACPI : EC: --->  status = 0x29
> [ 8807.024791] ACPI : EC: --->  data = 0x66
> [ 8807.025787] ACPI : EC: --->  status = 0x29
> [ 8807.025790] ACPI : EC: --->  data = 0x66
> [ 8807.026787] ACPI : EC: --->  status = 0x29
> [ 8807.026790] ACPI : EC: --->  data = 0x66
> [ 8807.027786] ACPI : EC: --->  status = 0x09
> [ 8807.027790] ACPI : EC: --->  data = 0x00
> [ 8807.027792] ACPI : EC: 8 stale EC events cleared
>
> Note that most of these have SCI_EVT set, but the OS is not notified
> according to ACPI specs (seemingly because these events happened
> during sleep).
>
> The _Q66 method in my DSDT, is:
>
>                          P8XH (Zero, 0x66)
>                          If (LEqual (B1EX, One))
>                          {
>                              Notify (BAT1, 0x80)
>                          }
>
> So, basically, this is supposed to notify that the battery (BAT1 =
> PNP0C0A) has changed state, but they are stale events so we don't run
> the handlers.
>
>    
>>> +static int EC_FLAGS_CLEAR_ON_RESUME; /* EC should be polled on
>>> boot/resume */
>>>        
>> seems name is implicit, what about EC_FLAGS_QEVENT_CLR_ON_RESUME?
>> seems too long :-)
>>      
> In my mind this is referring to the function name (acpi_ec_)clear.
> Perhaps we could just make the connection more explicit in the
> comment:
>
> /* needs acpi_ec_clear() on boot/resume */
>
> Not sure if this is better?
>
>    
>>> +       /* Some hardware may need the EC to be cleared before use */
>>>        
>> description is implicit, should specify what we clear is Q event, not EC.
>>      
> Are Q events the only thing we can get from the EC data port? I've
> read the relevant parts of the ACPI spec and I can't say I am 100%
> sure.
>
>    
I guess you want to clear Q events here,
EC usually has ACPI space to be read by cmd 80.

Thanks!



