Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3KGUzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:55:53 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:39913 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3KGUzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:55:46 -0500
MIME-Version: 1.0
In-Reply-To: <20131107193339.GB3129@localhost.localdomain>
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
	<1383844657-17487-3-git-send-email-ard.biesheuvel@linaro.org>
	<20131107193339.GB3129@localhost.localdomain>
Date: Thu, 7 Nov 2013 21:55:44 +0100
Message-ID: <CAKv+Gu90zfrMfQKo2frX0hRWqjQNm0sw_dJpFdXZ+AWrbATz-Q@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] cpu: advertise CPU features over udev in a
 generic way
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2013 20:33, Dave Martin <Dave.Martin@arm.com> wrote:
> On Thu, Nov 07, 2013 at 06:17:35PM +0100, Ard Biesheuvel wrote:
>> This patch implements a generic modalias 'cpu:feature:...' which
>> enables CPU feature flag based module loading in a generic way.
>> All the arch needs to do is enable CONFIG_ARCH_HAS_CPU_AUTOPROBE
>> and export a u32 called 'cpu_features'. (What each bit actually
>> means is irrelevant on this level.)

[ ... ]

> Why is this __weak?  Surely CONFIG_ARCH_HAS_CPU_AUTOPROBE=y makes no
> sense if the arch code does not define either cpu_features or
> arch_print_cpu_modalias()?  The build should be made to fail in that
> case...
>

If you define the latter but not the former, you will still get a link
error. But indeed, getting this stuff right is the main point of this
RFC series.
Just putting a '#define arch_print_cpu_modalias
arch_print_cpu_modalias' in the right place and testing for it here is
indeed a lot better.

>> +     ssize_t n;
>> +     int i;
>> +     u32 f;
>> +
>> +     /*
>> +      * With 32 features maximum (taking 3 bytes each to print), we don't
>> +      * need to worry about overrunning the PAGE_SIZE sized buffer.
>> +      */
>> +     n = sprintf(buf, "cpu:feature:");
>> +     for (f = cpu_features, i = 0; f; f >>= 1, i++)
>> +             if (f & 1)
>> +                     n += sprintf(&buf[n], ",%02X", i);
>
> Why can't this overflow buf?
>

Because there are only so many bits you can shift out of a u32 before
it becomes zero.

> modalias matching is pretty much based on string matching, so I wonder
> whether we could use the human-readable feature strings instead.
> Those are already a stable ABI.  Relying on numbers unnecessarily
> encrypts the udev/modprobe config.
>

Introducing symbolic names would add an arch specific dependency to
the host tool that is used to generate the .ko metadata from the
custom ELF sections. This being a port of a similar feature on x86,
the comments in scripts/mod/file2alias.c were helpful in figuring out
that that was deemed too complicated at the time. And we don't resolve
PCI or USB VIDs to vendor names either, as this is just module
metadata for machine matching.

> Otherwise, "%02X" seems to place an arbitrary limit of 256 features.
> I'm not sure that padding these numbers to a particular width is
> advantageous for the parser.
>

Using a u32 already brings it down to 32, but it is sufficient for now
and I think changing it later if necessary should be doable.

>> +     buf[n++] = '\n';
>> +     return n;
>> +}
>> +
>> +ssize_t __attribute__((weak, alias("print_cpu_modalias")))
>> +arch_print_cpu_modalias(struct device *, struct device_attribute *, char *);
>> +
>
> If an implementation of arch_print_cpu_modalias() is linked with this,
> won't that result in the print_cpu_modalias() defined here just being
> included as dead code?
>
> i.e., we knowingly link into the kernel some code that the build-time
> configuration tells us is dead.
>

Absolutely true. See the above.

> Maybe I'm misunderstanding things here, but I think this weak-symbol
> stuff is mainly useful when shipping a binary blob in which people can
> override certain symbols at link time.
>
> We build vmlinux in one go, so I'm not sure that's appropriate here (?)
>

I agree, and (as I pointed out in my cover letter) I was prepared for
people perhaps having problems with that.
But yes, it seems just #defining arch_print_cpu_modalias in the
appropriate place and #ifndef'ing on it seems much bettter.

-- 
Ard.
