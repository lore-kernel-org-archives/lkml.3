Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3CEQEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:04:37 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:32960 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab3CEQEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:04:35 -0500
MIME-Version: 1.0
In-Reply-To: <51359E9D.7040802@intel.com>
References: <201303042055.38040.maciej.rutecki@gmail.com>
	<51359E9D.7040802@intel.com>
Date: Tue, 5 Mar 2013 08:04:34 -0800
X-Google-Sender-Auth: rMw83gVKi1CrzWs1CGzzCBAxuMk
Message-ID: <CACBanvptz6rvoiOqDA96EsFAZBo9-xtrtVnTqoDr8F3964eP8Q@mail.gmail.com>
Subject: Re: [REGRESSION] [3.9-rc1] BUG: ktpacpi_nvramd/446 still has locks held!
From: Mandeep Singh Baines <msb@chromium.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: maciej.rutecki@gmail.com, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 11:28 PM, Aaron Lu <aaron.lu@intel.com> wrote:
> On 03/05/2013 03:55 AM, Maciej Rutecki wrote:
>> Last known good: 3.8.0
>> Bad version: 3.9-rc1
>>
>> [    6.116492] =====================================
>> [    6.116614] [ BUG: ktpacpi_nvramd/446 still has locks held! ]
>> [    6.116737] 3.9.0-rc1 #1 Not tainted
>> [    6.116821] -------------------------------------
>> [    6.116900] 1 lock held by ktpacpi_nvramd/446:
>> [    6.116973]  #0:  (&hotkey_thread_mutex){+.+...}, at: [<ffffffffa024e87e>]
>> hotkey_kthread+0x1f/0x354 [thinkpad_acpi]
>> [    6.117193]
>> [    6.117193] stack backtrace:
>> [    6.117268] Pid: 446, comm: ktpacpi_nvramd Not tainted 3.9.0-rc1 #1
>> [    6.117381] Call Trace:
>> [    6.117445]  [<ffffffff810877ea>] debug_check_no_locks_held+0x8f/0x93
>> [    6.117600]  [<ffffffff8107d8ac>] set_freezable+0x3e/0x64
>> [    6.117703] input: ThinkPad Extra Buttons as
>> /devices/platform/thinkpad_acpi/input/input5
>> [    6.117918]  [<ffffffffa024e890>] hotkey_kthread+0x31/0x354 [thinkpad_acpi]
>> [    6.118088]  [<ffffffffa024e85f>] ? issue_volchange.29885+0x54/0x54
>> [thinkpad_acpi]
>> [    6.118250]  [<ffffffff8105e296>] kthread+0xac/0xb4
>> [    6.118356]  [<ffffffff8105e1ea>] ? __kthread_parkme+0x60/0x60
>> [    6.118491]  [<ffffffff814b243c>] ret_from_fork+0x7c/0xb0
>> [    6.118614]  [<ffffffff8105e1ea>] ? __kthread_parkme+0x60/0x60
>>
>> Config:
>> http://mrutecki.pl/download/kernel/3.9.0-rc1/config-3.9.0-rc1
>>
>> full dmesg:
>> http://mrutecki.pl/download/kernel/3.9.0-rc1/dmesg-3.9.0-rc1.txt
>>
>
> Thanks for the report!
>
> Looks like the following commit is related:
> commit 6aa9707099c4b25700940eb3d016f16c4434360d
> Author: Mandeep Singh Baines <msb@chromium.org>  Thu Feb 28 09:03:18 2013
>
> lockdep: check that no locks held at freeze time
>
> And the code to trigger this problem is here:
> static int hotkey_kthread(void *data)
> {
>         struct tp_nvram_state s[2];
>         u32 poll_mask, event_mask;
>         unsigned int si, so;
>         unsigned long t;
>         unsigned int change_detector;
>         unsigned int poll_freq;
>         bool was_frozen;
>
>         mutex_lock(&hotkey_thread_mutex);
>
>         if (tpacpi_lifecycle == TPACPI_LIFE_EXITING)
>                 goto exit;
>
>         set_freezable();
> ~~~~~~~~~~~~~~~~~~~~~~~~~~
> in thinkpad_acpi.c.
>
> I don't know much about freeze, I've no idea what is the problem.
> So Mandeep and Henrique, can you please kindly take a look? Thanks.
>

Hi Aaron,

I will take a look at this.

In general, you don't want to grab a lock and freeze. You will block
suspend because another thread may try go grab the lock. In the case
of cgroup freezer, you could cause a deadlock.

There is also discussion happening on this thread:

https://lkml.org/lkml/2013/3/4/221

Regards,
Mandeep

> -Aaron
>
