Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab3CEUzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:55:52 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43541 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3CEUzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:55:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130305180542.GA12738@redhat.com>
References: <201303042055.38040.maciej.rutecki@gmail.com>
	<1362504883-9180-1-git-send-email-msb@chromium.org>
	<20130305174838.GA7276@redhat.com>
	<CACBanvqHRDsOQiMsQMw5_QDt1wFrb8_DRoiASSvqeA6XdFrwZQ@mail.gmail.com>
	<20130305180542.GA12738@redhat.com>
Date: Tue, 5 Mar 2013 12:55:47 -0800
X-Google-Sender-Auth: NzNKotdPGSaly4S26F1Mn6J0dDs
Message-ID: <CACBanvr7XvXbFjphpRwKHHJKzVuA-s6sF-qkPiizBV3+uqzpJw@mail.gmail.com>
Subject: Re: [PATCH] thinkpad-acpi: fix potential suspend blocking issue
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, ibm-acpi@hmh.eng.br,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 10:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/05, Mandeep Singh Baines wrote:
>>
>> On Tue, Mar 5, 2013 at 9:48 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > On 03/05, Mandeep Singh Baines wrote:
>> >>
>> >> @@ -2462,13 +2462,13 @@ static int hotkey_kthread(void *data)
>> >>       unsigned int poll_freq;
>> >>       bool was_frozen;
>> >>
>> >> +     set_freezable();
>> >> +
>> >>       mutex_lock(&hotkey_thread_mutex);
>> >>
>> >>       if (tpacpi_lifecycle == TPACPI_LIFE_EXITING)
>> >>               goto exit;
>> >>
>> >> -     set_freezable();
>> >> -
>> >
>> > I don't understand this code... but don't we have the same problem
>> > with kthread_freezable_should_stop() below? It can call __refrigerator()
>> > too under the same lock.
>> >
>>
>> I don't think the lock is held at that point. There is an unlock right
>> before entering the while loop and at the bottom of the loop.
>
> Hmm... Afaics this is another lock, hotkey_thread_data_mutex. But
> hotkey_thread_mutex is still held.
>

Ah. You're right. The two names were similar so that confused me. I'm
also looking at this code for the first time:)

This mutex seems wrong. Its held the entire time the kthread is
running. I think its used to synchronize on the exit of the kthread. A
completion would more appropriate in that case.

Regards,
Mandeep

> Oleg.
>
