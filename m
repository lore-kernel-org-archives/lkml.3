Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbaGVLxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:53:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:43840 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaGVLxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:53:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="573575231"
Message-ID: <53CE5097.2000502@intel.com>
Date: Tue, 22 Jul 2014 19:52:55 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, mnipxh <mnipxh@gmail.com>
CC: jslaby@suse.cz, linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] tty/tty_io.c: make a check before reuse cdev
References: <53CD0BD4.4050007@gmail.com> <20140721153840.GA6802@kroah.com>
In-Reply-To: <20140721153840.GA6802@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 2014年07月21日 23:38, Greg KH 写道:
> On Mon, Jul 21, 2014 at 08:47:16PM +0800, pp wrote:
>> As reuse the cdev may cause panic. After we unregister the tty device, we may use tty_hangup() o
>> other similar function to send a signal(SIGHUP) to process which has opend our device. But that
>> not succeed if the process couldn't get the signal. for example, a process forked
>> but his parent quited never get SIGHUP.
>>
>> Here is our scence.
>> tty driver register its device and init the cdevs, then process "A" open one cdev.
>> tty driver unregister its device and cdev_del the cdevs, call tty_hangup to (S)send signal SIGHUP to process A.
>> But that step(S) fails.
> 
> How can that fail?  What driver does this fail for?

hi, Greg
	Thanks for your nice comments. :)
	It's gsm driver that want to unregister/register tty device. We are working on our intel mobile phone,
When the phone goes into airplane-mode, the modem will disconnect from system, then gsmld_close() -> gsmld_detach_gsm() -> tty_unregister_device().
When the phone leaves airplane-mode, the modem will connect to system, then gsmld_open() -> gsmld_attach_gsm() -> tty_register_device()
In this way how gsm driver works.
It seems very normal and can work well. :)

But there is always something bad for us to deal with. 
If a process(A, its name) opens the /dev/gsmttyXX, and the process(A) is, for example, running with command "A &".
The process(A) is not able to receive the signal SIGHUP from __tty_hangup() -> tty_signal_session_leader(). 
There are several reasons that can stop process(A) from receiving signal SIGHUP. 
another example, B is running, and he makes a fork(), A is the child of B, then B quit, leave A running.
in such scenario, A is not able to receive signal SIGHUP, either. 
Anyway, we cannot guarantee process(A) will close /dev/gsmttyXX in time. That means we don't know when we can reuse the tty_driver->cdevs[XX].
one second, one minute? We don't know. We just don't trust user space. :)

> 
>> tty driver register its device and (D)init the cdevs again.
> 
> What driver does this with an "old" device, it should have created a new
> one, otherwise, as you have pointed out, it's a bug.
> 

I can't agree more with you. we should not use "old" device. 
gsm driver(gsm_tty_driver) call tty_register_device() to export gsmttyXX to userspace.
but tty core code manages cdevs by itself. cdevs is not directly used by any other tty drivers. Adding a check in n_gsm.c before call tty_register_device() seems 
breaking a rule and making things complex in my opinion.
I also find a fact that most tty drivers only call tty_register_device() in probe(), and call tty_unregister_device() in remove().
Q1:
Is this a rule, too? :)

I think my patch is not good enough. 
Q2:
How about (1)change struct *cdevs to struct **cdevs, and (2)use cdev_alloc() instead of cdev_init()? :)
Let char_dev core code manage the cdev. when the cdev's ref-count become zero, cdev will be released by char_dev core code self.

I very appreciate for your comments. and your advices are very important and helpful for me to solve this issue. 

thanks,

xinhui

> thanks,
> 
> greg k-h
> 
