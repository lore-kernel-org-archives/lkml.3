Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbbAVB1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:27:46 -0500
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:33380 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbbAVB1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:27:38 -0500
Message-ID: <54C05207.6010306@nexus-software.ie>
Date: Thu, 22 Jan 2015 01:27:35 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, dvhart@infradead.org,
        boon.leong.ong@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie>	<1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie> <CAHp75VfNzXo=gkOhjkEGn+bSqk2kr+hOD_5PNxq4CsLjOqtG=w@mail.gmail.com>
In-Reply-To: <CAHp75VfNzXo=gkOhjkEGn+bSqk2kr+hOD_5PNxq4CsLjOqtG=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/15 20:57, Andy Shevchenko wrote:
>
> Few nitpicks and comments below.
>
>> +/*
>> + * IMR agent access mask bits
>> + * See section 12.7.4.7 from quark-x1000-datasheet.pdf for register
>> + * definitions
>
> What about dots at the end of sentences?

Murphy's law says - no matter how many times you proof read for full 
stop you'll miss at least one :)

>> +#define pr_fmt(fmt) "imr: " fmt
>
> Maybe more usual
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Sure.

>> +       ret = iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
>> +                               reg++, &imr->rmask);
>> +       if (ret)
>> +               return ret;
>> +
>> +       return iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
>> +                               reg, &imr->wmask);
>
> I would keep this in the same style like
> ret =
> if (ret)
>   return ret;
>
> return 0;
>
> It might be easy to extend if needed, though it's a really minor change.

No problem

>> +
>> +       ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
>> +                               reg++, imr->rmask);
>> +       if (ret)
>> +               goto done;
>> +
>> +       ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
>> +                               reg, imr->wmask);
>
> Wouldn't be reg++ here as well? Below you substitute full offset which
> I think points just to next register.

I don't think we want to increment below..

>
>> +       if (ret)
>> +               goto done;
>> +
>> +       /* Lock bit must be set separately to addr_lo address bits */
>> +       if (lock) {
>> +               imr->addr_lo |= IMR_LOCK;
>> +               ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
>> +                                       reg - IMR_LOCK_OFF, imr->addr_lo);
>> +       }

..because we calculate an offset anyway. An additional increment would 
just be unnecessary cycles.

>
> Could it fit one line less?

Yes. Will change.

>> +
>> +#ifdef CONFIG_DEBUG_FS
>> +/**
>> + * imr_dbgfs_state_show
>> + * Print state of IMR registers
>> + *
>> + * @s:         pointer to seq_file for output
>> + * @unused:    unused parameter
>> + * @return:    0 on success or error code passed from mbi_iosf on failure
>> + */
>> +static int imr_dbgfs_state_show(struct seq_file *s, void *unused)
>
> I didn't remembter if I told you, but please use s->private for the
> imr_dev pointer.
> Everywhere in debugfs calls and if possible in other functions as well.

No missed s->private. Will incorporate for V3.

>> +}
>> +
>> +/**
>> + * imr_debugfs_unregister
>> + * Unregister debugfs hooks
>> + *
>> + * @imr:       IMR structure representing address and access masks
>> + * @return:
>> + */
>> +static void imr_debugfs_unregister(void)
>> +{
>> +       if (!imr_dev.file)
>> +               return;
>
> Redundant check. I think I told you that already.

I think you did. V3

>> +static void __init imr_fixup_memmap(void)
>> +{
>> +       unsigned long base  = virt_to_phys(&_text);
>> +       unsigned long size = virt_to_phys(&__end_rodata) - base;
>
> Shouldn't be phys_addr_t ?
> Oh, It might be good for all address parameters in the introduced API.

Well the reference MTRR code doesn't do phs_addr_t
OTOH so what. I think phys_addr_t is more representative of the data 
being passed, so will include @ V3.

>> +               pr_info("protecting kernel .text - .rodata: %ldk (%p - %p)\n",
>> +                       size / 1024, &_text, &__end_rodata);
>
> size >> 10

Andy.

It was size >> 10 for V1 and you called it out as a magic number :)

IMO, size / 1024 requires less thought to understand when reading the code.

>> +
>> +#ifdef CONFIG_DEBUG_IMR_SELFTEST
>> +       /* Run optional self test */
>> +       imr_self_test(base, size);
>> +#endif
>
> I think it makes sense to move this piece to the init.
> I don't see what is exceptional in this function that test belongs here.

Fair enough.

>> +#ifdef CONFIG_DEBUG_FS
>> +       ret = imr_debugfs_register();
>> +       if (ret != 0)
>> +               return ret;
>
> It's non-fatal error.
> Thus,
> if (ret)
>   pr_warn("DebugFS wasn't initialized\n");
>
> Move it after we have imr_dev in place and supply it to debugfs as a
> private pointer.

Agree

>> + * return:
>> + */
>> +static void __exit imr_exit(void)
>> +{
>> +#ifdef CONFIG_DEBUG_FS
>
> I suspect you may remove all those ifdefs and compiler should shrink
> not used code since debugfs has the stubs.
>
>> +       imr_debugfs_unregister();
>> +#endif
>> +}

Hrmm. I'll revist that @ V3.

Thanks for the quick feedback.

--
BOD
