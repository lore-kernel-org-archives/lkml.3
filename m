Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbaGWQE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:04:28 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44857 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757646AbaGWQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:04:26 -0400
Message-ID: <53CFDD05.4010104@hurleysoftware.com>
Date: Wed, 23 Jul 2014 12:04:21 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "xinhui.pan" <xinhuix.pan@intel.com>
CC: Greg KH <gregkh@linuxfoundation.org>, mnipxh <mnipxh@gmail.com>,
        jslaby@suse.cz, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] tty/tty_io.c: make a check before reuse cdev
References: <53CD0BD4.4050007@gmail.com> <20140721153840.GA6802@kroah.com> <53CE5097.2000502@intel.com> <53CE941B.1030102@hurleysoftware.com> <53CF7EAC.8010201@intel.com>
In-Reply-To: <53CF7EAC.8010201@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xinhui,

On 07/23/2014 05:21 AM, xinhui.pan wrote:
> 于 2014年07月23日 00:40, Peter Hurley 写道:
>> On 07/22/2014 07:52 AM, xinhui.pan wrote:
>>> 于 2014年07月21日 23:38, Greg KH 写道:
>>>> On Mon, Jul 21, 2014 at 08:47:16PM +0800, pp wrote:

>>>>> tty driver register its device and (D)init the cdevs again.
>>>>
>>>> What driver does this with an "old" device, it should have created a new
>>>> one, otherwise, as you have pointed out, it's a bug.
>>>>
>>>
>>> I can't agree more with you. we should not use "old" device.
>>
>> This is a gsm driver problem. The GSM driver is reusing device indexes
>> for still-open ttys.
>>
>> The GSM driver uses a global table, gsm_mux[], to allocate device indexes
>> but prematurely clears the table entry in gsm_mux_cleanup(). If instead,
>> clearing the gsm_mux table entry were deferred to gsm_mux_free(), then
>> device indexes would not be getting reused until after the last tty
>> associated with the last gsm attach was closed.
>>
> 
> Very nice solution. We will check if this can cause any risk, both to kernel and user space.
> Using a new tty base to register with new cdevs may give us more chance to wait PROCESS quit/close.
> when total 256 tty used up, what we should do is still in discuss.

I saw your patch for the use of gsm->num before gsm_activate_mux() has
allocated the table entry; thanks for fixing that.

As for what to do if all the gsm_mux table entries are used: if the error
is infrequent, I suggest simply returning an error which is what the
driver does currently. Otherwise, a more dynamic allocation scheme may be required.

I did notice while reviewing the error handling that gsmld_open() will
leak the entire composite ldisc data allocated by gsm_alloc_mux() if
gsmld_attach_gsm() fails.

Regards,
Peter Hurley

