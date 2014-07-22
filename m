Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaGVQlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:41:06 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37336 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755985AbaGVQlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:41:04 -0400
Message-ID: <53CE941B.1030102@hurleysoftware.com>
Date: Tue, 22 Jul 2014 12:40:59 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "xinhui.pan" <xinhuix.pan@intel.com>, Greg KH <gregkh@linuxfoundation.org>,
        mnipxh <mnipxh@gmail.com>
CC: jslaby@suse.cz, linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] tty/tty_io.c: make a check before reuse cdev
References: <53CD0BD4.4050007@gmail.com> <20140721153840.GA6802@kroah.com> <53CE5097.2000502@intel.com>
In-Reply-To: <53CE5097.2000502@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 07:52 AM, xinhui.pan wrote:
> 
> 于 2014年07月21日 23:38, Greg KH 写道:
>> On Mon, Jul 21, 2014 at 08:47:16PM +0800, pp wrote:
>>> As reuse the cdev may cause panic. After we unregister the tty device, we may use tty_hangup() o
>>> other similar function to send a signal(SIGHUP) to process which has opend our device. But that
>>> not succeed if the process couldn't get the signal. for example, a process forked
>>> but his parent quited never get SIGHUP.
>>>
>>> Here is our scence.
>>> tty driver register its device and init the cdevs, then process "A" open one cdev.
>>> tty driver unregister its device and cdev_del the cdevs, call tty_hangup to (S)send signal SIGHUP to process A.
>>> But that step(S) fails.
>>
>> How can that fail?  What driver does this fail for?
> 
> hi, Greg
> 	Thanks for your nice comments. :)
> 	It's gsm driver that want to unregister/register tty device. We are working on our intel mobile phone,
> When the phone goes into airplane-mode, the modem will disconnect from system, then gsmld_close() -> gsmld_detach_gsm() -> tty_unregister_device().
> When the phone leaves airplane-mode, the modem will connect to system, then gsmld_open() -> gsmld_attach_gsm() -> tty_register_device()
> In this way how gsm driver works.
> It seems very normal and can work well. :)
> 
> But there is always something bad for us to deal with. 
> If a process(A, its name) opens the /dev/gsmttyXX, and the process(A) is, for example, running with command "A &".
> The process(A) is not able to receive the signal SIGHUP from __tty_hangup() -> tty_signal_session_leader(). 
> There are several reasons that can stop process(A) from receiving signal SIGHUP. 
> another example, B is running, and he makes a fork(), A is the child of B, then B quit, leave A running.
> in such scenario, A is not able to receive signal SIGHUP, either. 
> Anyway, we cannot guarantee process(A) will close /dev/gsmttyXX in time. That means we don't know when we can reuse the tty_driver->cdevs[XX].
> one second, one minute? We don't know. We just don't trust user space. :)

Or a process could simply ignore SIGHUP, in which case /dev/gsmttyXX
will not be closed until process termination.

>>> tty driver register its device and (D)init the cdevs again.
>>
>> What driver does this with an "old" device, it should have created a new
>> one, otherwise, as you have pointed out, it's a bug.
>>
> 
> I can't agree more with you. we should not use "old" device.

This is a gsm driver problem. The GSM driver is reusing device indexes
for still-open ttys.

The GSM driver uses a global table, gsm_mux[], to allocate device indexes
but prematurely clears the table entry in gsm_mux_cleanup(). If instead,
clearing the gsm_mux table entry were deferred to gsm_mux_free(), then
device indexes would not be getting reused until after the last tty
associated with the last gsm attach was closed.

Regards,
Peter Hurley
