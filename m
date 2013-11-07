Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3KGUAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:00:21 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59061 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab3KGUAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:00:16 -0500
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org> <1383844657-17487-3-git-send-email-ard.biesheuvel@linaro.org> <20131107193339.GB3129@localhost.localdomain>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20131107193339.GB3129@localhost.localdomain>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <FB91D852-4790-4481-846C-0D3C20CD9048@linaro.org>
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
X-Mailer: iPad Mail (11B511)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH 2/4] cpu: advertise CPU features over udev in a generic way
Date: Thu, 7 Nov 2013 21:00:14 +0100
To: Dave Martin <Dave.Martin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 7 nov. 2013, at 20:33, Dave Martin <Dave.Martin@arm.com> wrote:
> 
>> On Thu, Nov 07, 2013 at 06:17:35PM +0100, Ard Biesheuvel wrote:
>> This patch implements a generic modalias 'cpu:feature:...' which
>> enables CPU feature flag based module loading in a generic way.
>> All the arch needs to do is enable CONFIG_ARCH_HAS_CPU_AUTOPROBE
>> and export a u32 called 'cpu_features'. (What each bit actually
>> means is irrelevant on this level.)
> 
> There seems to be an assumption here that a module is either a pure CPU
> accelerator, or it is completely independent of CPU features.
> 
> I'm not sure that this is true.  A CPU feature isn't a "device".
> Rather, it's a property of code (which might be a driver for something
> different -- maybe we have a hardware crypto accelerator where key
> scheduling must be done in software.  It's still a driver for the
> crypto engine, but we might have different implementations of the key
> scheduling, based on the CPU features avaiable).
> 

The use case I am targeting is dedicated instructions for AES, CRC, SHA1, SHA2, etc, all of which -on arm64- can be independently enabled by the implementer.  A single distro image should run as closely to optimal as possible right out of the box, especially in these cases.

> It's also not obvious why we should blindly load all CPU-feature-
> dependent helper modules on bgoot, regardless of whether the module(s)
> that use them are being loaded.
> 
> Maybe the amount of CPU feature dependent code is small enough that
> we don't really care about such subtleties, though.
> 
> It's also not clear how different optimised modules for the same
> thing would get prioritised.  Suppose there we have v5E and NEON
> optimised AES helper modules?  Both those CPU features are avaiable,
> but which module should we load?
> 
> If all candidate modules get loaded, which one actually gets used?
> Does the load order matter?
> 

In the cryptoapi case, each algorithm also has a priority assigned to it, which should be sufficient to break these kinds of ties. Other code exists (xor, raid6) that does a quick boot time benchmark of all available options. In general, though, this is undefined, so I agree that associating random bits of NEON or FP code with the CPU feature bit may make little sense, especially on v8 (which has feature bits for mandatory extensions like FP and ASIMD)

-- 
Ard.

>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>> drivers/base/cpu.c | 24 ++++++++++++++++++++++++
>> 1 file changed, 24 insertions(+)
>> 
>> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
>> index 49c6f4b..a661d31 100644
>> --- a/drivers/base/cpu.c
>> +++ b/drivers/base/cpu.c
>> @@ -276,6 +276,30 @@ static void cpu_device_release(struct device *dev)
>> }
>> 
>> #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
>> +ssize_t print_cpu_modalias(struct device *dev,
>> +               struct device_attribute *attr,
>> +               char *buf)
>> +{
>> +    extern u32 __weak cpu_features;
> 
> Why is this __weak?  Surely CONFIG_ARCH_HAS_CPU_AUTOPROBE=y makes no
> sense if the arch code does not define either cpu_features or
> arch_print_cpu_modalias()?  The build should be made to fail in that
> case...
> 
>> +    ssize_t n;
>> +    int i;
>> +    u32 f;
>> +
>> +    /*
>> +     * With 32 features maximum (taking 3 bytes each to print), we don't
>> +     * need to worry about overrunning the PAGE_SIZE sized buffer.
>> +     */
>> +    n = sprintf(buf, "cpu:feature:");
>> +    for (f = cpu_features, i = 0; f; f >>= 1, i++)
>> +        if (f & 1)
>> +            n += sprintf(&buf[n], ",%02X", i);
> 
> Why can't this overflow buf?
> 
> modalias matching is pretty much based on string matching, so I wonder
> whether we could use the human-readable feature strings instead.
> Those are already a stable ABI.  Relying on numbers unnecessarily
> encrypts the udev/modprobe config.
> 
> Otherwise, "%02X" seems to place an arbitrary limit of 256 features.
> I'm not sure that padding these numbers to a particular width is
> advantageous for the parser.
> 
>> +    buf[n++] = '\n';
>> +    return n;
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
> Maybe I'm misunderstanding things here, but I think this weak-symbol
> stuff is mainly useful when shipping a binary blob in which people can
> override certain symbols at link time.
> 
> We build vmlinux in one go, so I'm not sure that's appropriate here (?)
> 
>> static int cpu_uevent(struct device *dev, struct kobj_uevent_env *env)
>> {
>>    char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
>> -- 
>> 1.8.3.2
>> 
>> 
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
