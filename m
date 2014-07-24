Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934919AbaGXKYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:24:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:20975 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbaGXKYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:24:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,723,1400050800"; 
   d="scan'208";a="574728549"
Message-ID: <53D0DEBE.2030502@intel.com>
Date: Thu, 24 Jul 2014 18:23:58 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg KH <gregkh@linuxfoundation.org>, mnipxh <mnipxh@gmail.com>,
        jslaby@suse.cz, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] tty/tty_io.c: make a check before reuse cdev
References: <53CD0BD4.4050007@gmail.com> <20140721153840.GA6802@kroah.com> <53CE5097.2000502@intel.com> <53CE941B.1030102@hurleysoftware.com> <53CF7EAC.8010201@intel.com> <53CFDD05.4010104@hurleysoftware.com>
In-Reply-To: <53CFDD05.4010104@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Peter

于 2014年07月24日 00:04, Peter Hurley 写道:
> Hi Xinhui,
> 
> On 07/23/2014 05:21 AM, xinhui.pan wrote:
>> 于 2014年07月23日 00:40, Peter Hurley 写道:
>>> On 07/22/2014 07:52 AM, xinhui.pan wrote:
>>>> 于 2014年07月21日 23:38, Greg KH 写道:
>>>>> On Mon, Jul 21, 2014 at 08:47:16PM +0800, pp wrote:
> 
>>>>>> tty driver register its device and (D)init the cdevs again.
>>>>>
>>>>> What driver does this with an "old" device, it should have created a new
>>>>> one, otherwise, as you have pointed out, it's a bug.
>>>>>
>>>>
>>>> I can't agree more with you. we should not use "old" device.
>>>
>>> This is a gsm driver problem. The GSM driver is reusing device indexes
>>> for still-open ttys.
>>>
>>> The GSM driver uses a global table, gsm_mux[], to allocate device indexes
>>> but prematurely clears the table entry in gsm_mux_cleanup(). If instead,
>>> clearing the gsm_mux table entry were deferred to gsm_mux_free(), then
>>> device indexes would not be getting reused until after the last tty
>>> associated with the last gsm attach was closed.
>>>
>>
>> Very nice solution. We will check if this can cause any risk, both to kernel and user space.
>> Using a new tty base to register with new cdevs may give us more chance to wait PROCESS quit/close.
>> when total 256 tty used up, what we should do is still in discuss.
> 
> I saw your patch for the use of gsm->num before gsm_activate_mux() has
> allocated the table entry; thanks for fixing that.
> 
> As for what to do if all the gsm_mux table entries are used: if the error
> is infrequent, I suggest simply returning an error which is what the
> driver does currently. Otherwise, a more dynamic allocation scheme may be required.
>

Yes, agree with you. This error is infrequent. Intel software will close the gsmtty after read/write hit errors.
We don't need dynamic allocation. So keep returning an error here. :)

> I did notice while reviewing the error handling that gsmld_open() will
> leak the entire composite ldisc data allocated by gsm_alloc_mux() if
> gsmld_attach_gsm() fails.
> 

Thanks for your reviewing. Do you mean gsm = gsm_alloc_mux() will cause leak if gsmld_attach_gsm fails?
As there is no gsm_free_mux()? If so, Yes, it is. In such scenario, gsmld_close is not called. and gsm_free_mux
is not called, either.
Thanks for your nice comments. You really help us fix several ugly issues.
Let me have a deep think about it.

thanks,

xinhui

> Regards,
> Peter Hurley
> 
