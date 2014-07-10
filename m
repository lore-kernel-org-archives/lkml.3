Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaGJSDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:03:49 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:38584 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGJSDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:03:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140710164151.GA5603@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-5-git-send-email-hskinnemoen@google.com>
	<20140710164151.GA5603@pd.tnic>
Date: Thu, 10 Jul 2014 11:03:43 -0700
Message-ID: <CAFQmdRbguE7O16diTNMXMU-3E8Zeu=Y=vcXVHKRyxzbq09TfzQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 9:41 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Jul 09, 2014 at 10:09:24AM -0700, Havard Skinnemoen wrote:
>> @@ -617,14 +620,28 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>>
>>               this_cpu_write(mce_polled_error, 1);
>>               /*
>> +              * Optimize for the common case where no MCEs are found.
>> +              */
>> +             spin_lock_irqsave(&mce_banks[i].poll_spinlock, irq_flags);
>
> This is pretty heavy - we're disabling interrupts for *every* bank and
> with shorter polling intervals, this could become problematic fast.

The lock is only taken if there are actual MCEs to be handled. The
following check is left in place above this:

        m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
        if (!(m.status & MCI_STATUS_VAL))
                continue;

But yeah, if there are lots of errors happening, it might get expensive.

> What's wrong with doing this with cheap atomic_inc/dec_and_test?

For non-shared banks, we might risk some CPUs not being able to poll
their banks in a long time if they happen to be more or less
synchronized with a different CPU. This will also get worse with
shorter polling intervals, and with larger numbers of CPUs.

Havard
