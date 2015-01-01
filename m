Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbbAAULO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 15:11:14 -0500
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:46322 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbbAAULM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 15:11:12 -0500
Message-ID: <54A5A9DE.5060006@nexus-software.ie>
Date: Thu, 01 Jan 2015 20:11:10 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Reply-To: pure.logic@nexus-software.ie
Organization: Nexus Software
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, dvhart@infradead.org,
        platform-driver-x86@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>	<1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie> <CAHp75VeYg1oAp5x9OCKOyZGvkt9n4WBRuWV4QPBHbrq+vTzANg@mail.gmail.com>
In-Reply-To: <CAHp75VeYg1oAp5x9OCKOyZGvkt9n4WBRuWV4QPBHbrq+vTzANg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/12/14 15:05, Andy Shevchenko wrote:

<snip>
>> +int imr_del(int reg, unsigned long base, unsigned long size);
>
> Same comments as for add_range.
> Could it be imr_remove_range() ?

Can be. You've actually caught me out there, function name is "imr_del"
function description says imr_del_range(). Amazing to think I proof read
this file a number of times for exactly thing type of thing

I'm happy with

imr_add_range();
imr_remove_range();

>> +
>> +#endif /* _IMR_H */
>> diff --git a/arch/x86/include/asm/intel-quark.h
b/arch/x86/include/asm/intel-quark.h
>> new file mode 100644
>> index 0000000..f51ac8c
>> --- /dev/null
>> +++ b/arch/x86/include/asm/intel-quark.h

<snip>

>> +#ifdef CONFIG_X86_32
>> +static inline int cpu_is_quark(const struct cpuinfo_x86 *c)
>> +{
>> +       return (c->x86_vendor == X86_VENDOR_INTEL &&
>> +               c->x86 == 5 && c->x86_model == 9);
>> +}
>> +#else
>> +static inline int cpu_is_quark(const struct cpuinfo_x86 *c)
>> +{
>> +       return 0;
>> +}
>> +#endif
>> +
>> +#endif /* _ASM_X86_INTEL_QUARK_H */
>
> Could we use x86_match_cpu() instead?

I don't see why not. I'll kill this header and call out to
x86_match_cpu() in the Galileo and IMR code.

>> +       ret = iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
>> +                               reg, &imr->addr_lo);
>> +       if (ret)
>> +               return ret;
>> +
>> +       ret = iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
>> +                               ++reg, &imr->addr_hi);
>
> Could you use reg++ in previous line and so on?

Yes I could. Originally wrote the code with a pre-increment and then
changed the flow later on. Post-increment will work just as good now and
is more readable.

> One more idea, if you make a union inside the structure you may do
> this in a loop.
> struct imr {
>  union {
>   struct imr {
>  ...
>   };
>   u32 regs[IMR_NUM_REGS];
>  };
> }
> Mostly same for _write().

Since reg is incrementing on each iosf_mbi_dothing() that can work.

>> +       u32 reg = imr_dev.reg_base + (imr_id * IMR_NUM_REGS);
>> +       u32 reg_lock = reg;
>
> Do we need a separate variable? Would (reg - IMR_NUM_REGS) work for you?

Sure. A separate integer isn't required, I can make that change.

>> +done:
>> +       local_irq_restore(flags);
>
> Could you do like
>
>       local_irq_restore(flags);
>       return 0;
> done:
>       local_irq_restore(flags);
>       WARN(...)
>      return ret;
> ?

Doesn't change the logic so yeah, works for me.

>> +static int imr_dbgfs_state_show(struct seq_file *s, void *unused)
>> +{
>> +       int i, ret = -ENODEV;
>> +       struct imr imr;
>> +       u32 size;
>> +
>> +       mutex_lock(&imr_dev.lock);
>
> It seems you may get the imr_dev via parameters. I suggest to avoid
> using global variables as much as possible.

Appreciated, you're right globals are bad.

I think in this case the mutex at that scope is necessary though. Same
with the debugfs handle.

>> +
>> +       for (i = 0; i <= imr_dev.num; i++) {
>
> num is not num, but last one? Sounds confusing for me.

Will change.

>> +
>> +       f = debugfs_create_file("state", S_IFREG | S_IRUGO,
>> +                               dir, imr_dev, &imr_state_ops);
>> +       if (!f)
>> +               goto err;
>
> Are you planing to extend the debugfs contents? Would it be okay to
> use only one file for now?

No not planning to extend.
OK with the one file.

>> +}
>
> No need to put this function under ifdef  - debugfs has the stubs.

Ah - wasn't aware of that.
Great stuff - I'll kill the ifdefs - thanks !

> Can you define pr_fmt() ?
>
> 1 KiB.

Yep will do
:g/pr_info/s//pr_fmt/g

>
>> +                       base, size);
>> +               dump_stack();
>
> dump_stack is really needed here? In that case why not to use WARN()?

Hmm - I nope - dump_stack() isn't relevant since it's an in-kernel API.
Did an unthinking copy/past from the mtrr code

I'll zap that.

>> +       if (imr_check_range(base, size))
>> +               return -EINVAL;
>
> ret = imr_();
> if (ret)
>  return ret;

Good catch.

>> +       for (i = 0; i <= imr_dev.num; i++) {
>> +               ret = imr_read(i, &imr);
>> +               if (ret)
>> +                       goto done;
>> +
>> +               /* Find overlap */
>> +               if (imr_enabled(&imr)) {
>> +                       if (base >= imr_to_phys(imr.addr_lo) &&
>> +                               base <= imr_to_phys(imr.addr_hi)) {
>
>> +                               overlap = 1;
>> +                               break;
>
> Maybe
> ret = -EINVAL;
> goto done;

Agree - I like that change.
Waste of time to complete the loop if an overlap is detected.


>> +       if (reg >= 0) {
>> +               ret = imr_read(reg, &imr);
>> +               if (ret)
>> +                       goto done;
>> +
>> +               if (!imr_enabled(&imr) || imr.addr_lo & IMR_LOCK) {
>> +                       ret = -ENODEV;
>> +                       goto done;
>> +               }
>> +               found = 1;
>
> You may put a loop to the else branch instead of checking found at
> each iteration.

Sure.

> Happy New Year!

Thanks for the feedback Andy !
Best wishes in the New Year.

BOD


