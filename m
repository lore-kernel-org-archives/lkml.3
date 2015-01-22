Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbbAVI7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:59:45 -0500
Received: from mail-yk0-f173.google.com ([209.85.160.173]:47984 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbbAVI7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:59:36 -0500
MIME-Version: 1.0
In-Reply-To: <54C05207.6010306@nexus-software.ie>
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie>
	<1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie>
	<CAHp75VfNzXo=gkOhjkEGn+bSqk2kr+hOD_5PNxq4CsLjOqtG=w@mail.gmail.com>
	<54C05207.6010306@nexus-software.ie>
Date: Thu, 22 Jan 2015 10:59:36 +0200
Message-ID: <CAHp75Vcd8axwSETRG8eq9Tu7Z0aPTDKfQr__gMsczt1PQ75sdg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, dvhart@infradead.org,
        boon.leong.ong@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 3:27 AM, Bryan O'Donoghue
<pure.logic@nexus-software.ie> wrote:
> On 21/01/15 20:57, Andy Shevchenko wrote:

[]

>>> +       ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
>>> +                               reg++, imr->rmask);
>>> +       if (ret)
>>> +               goto done;
>>> +
>>> +       ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
>>> +                               reg, imr->wmask);
>>
>>
>> Wouldn't be reg++ here as well? Below you substitute full offset which
>> I think points just to next register.
>
>
> I don't think we want to increment below..
>
>>
>>> +       if (ret)
>>> +               goto done;
>>> +
>>> +       /* Lock bit must be set separately to addr_lo address bits */
>>> +       if (lock) {
>>> +               imr->addr_lo |= IMR_LOCK;
>>> +               ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
>>> +                                       reg - IMR_LOCK_OFF,
>>> imr->addr_lo);
>>> +       }
>
>
> ..because we calculate an offset anyway. An additional increment would just
> be unnecessary cycles.

Offset is a compile-time constant, right? And it should be 4.
Otherwise its meaning somehow looks confusing. I looked again and
would recommend to substitute it by NUM_REGS here and leave register
increment. I don't think it's a really big deal to waste CPU cycles
here since you use slower IOSF communication.

>>> +               pr_info("protecting kernel .text - .rodata: %ldk (%p -
>>> %p)\n",
>>> +                       size / 1024, &_text, &__end_rodata);
>>
>>
>> size >> 10
>
>
> Andy.
>
> It was size >> 10 for V1 and you called it out as a magic number :)
>
> IMO, size / 1024 requires less thought to understand when reading the code.

Oh, my bad. Now a bit modified suggestion, to add KiB inside format
string and leave  / 1024. Would it work for you?

-- 
With Best Regards,
Andy Shevchenko
