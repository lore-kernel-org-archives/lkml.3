Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaG1MLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:11:46 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57396 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaG1ML0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:11:26 -0400
Message-ID: <53D63DE6.1000605@suse.cz>
Date: Mon, 28 Jul 2014 14:11:18 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "xinhui.pan" <xinhuix.pan@intel.com>, Greg KH <gregkh@linuxfoundation.org>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, mnipxh <mnipxh@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/n_gsm.c: fix a memory leak in gsmld_open
References: <53D6067C.4000702@intel.com> <53D60E8F.6080208@suse.cz> <53D611EC.2000907@intel.com> <53D634BB.3060306@intel.com>
In-Reply-To: <53D634BB.3060306@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 01:32 PM, xinhui.pan wrote:
> 于 2014年07月28日 17:03, xinhui.pan 写道:
>> Hi, Jiri
>>
>> 于 2014年07月28日 16:49, Jiri Slaby 写道:
>>> On 07/28/2014 10:14 AM, xinhui.pan wrote:
>>>> If gsmld_attach_gsm fails, the gsm is not used anymore.
>>>> tty core will not call gsmld_close to do the cleanup work.
>>>> tty core just restore to the tty old ldisc.
>>>> That always causes memory leak.
>>>
>>> Nice catch!
>>>
>>>> --- a/drivers/tty/n_gsm.c
>>>> +++ b/drivers/tty/n_gsm.c
>>>> @@ -2382,7 +2383,13 @@ static int gsmld_open(struct tty_struct *tty)
>>>>  
>>>>  	/* Attach the initial passive connection */
>>>>  	gsm->encoding = 1;
>>>> -	return gsmld_attach_gsm(tty, gsm);
>>>> +
>>>> +	ret = gsmld_attach_gsm(tty, gsm);
>>>> +	if (ret != 0) {
>>>> +		gsm_cleanup_mux(gsm);
>>>> +		mux_put(gsm);
>>>
>>> It is quite illogical to put the mux here. It should be in gsmld_open.
>>> I.e. gsm_cleanup_mux here, mux_put there.
>>>
>>
>> Thanks for your reply :)
>> But I am a little confused with your comments, could you explain it when you are free?
>> Sorry for my poor English.
>>
> 
> hi, Jiri
> 	I guess you want gsm_cleanup_mux() called in gsmld_attach_gsm(), just after gsm_activate_mux() fails?
> Yes, that seems really make sence. :)

Oh, I don't know what made me think you are changing gsmld_attach_gsm. I
misread the patch.

So in the end, your patch looks fine to me.

thanks,
-- 
js
suse labs
