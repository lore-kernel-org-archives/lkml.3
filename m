Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3B1AtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:49:11 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53147 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3B1AtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:49:10 -0500
MIME-Version: 1.0
In-Reply-To: <20130227231826.GA30154@lizard.fhda.edu>
References: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com> <20130227231826.GA30154@lizard.fhda.edu>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 27 Feb 2013 19:48:38 -0500
X-Google-Sender-Auth: Bgbl19gLjZDHo15ZYhsLC4pTOWU
Message-ID: <CAP=VYLqg5Q_e4y6bD9x8idOvJx2n_knzujOY9Z0VyGDEQZTzag@mail.gmail.com>
Subject: Re: [PATCH] power: make goldfish option have a dependency on goldfish
To: Anton Vorontsov <anton@enomsg.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 6:18 PM, Anton Vorontsov <anton@enomsg.org> wrote:
> Hello Paul,
>
> On Wed, Feb 27, 2013 at 01:27:46PM -0500, Paul Gortmaker wrote:
>> Nearly all the other goldfish peripherals (mtd, keyboard, etc)
>> have a dependency on the main platform's GOLDFISH Kconfig item,
>> but this one got skipped, so add it.
>>
>> Cc: Anton Vorontsov <cbou@mail.ru>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> ---
>
> Our policy, IIRC, has been quite the opposite: we try to put as little
> dependencies as possible, letting drivers build on all different kinds of
> configs/arches/machines. Why? It helps us keep the code in a good shape.
>
> So, unless there are any unresolable build issues with the driver, I
> believe we should keep it as is.

Hi Anton,

Yes, I have heard that kind of argument before, but assuming you mean
"our policy" as being the kernel, and kernel people in general, allow me
to point out some observations.

--what is done here for the power subsystem is inconsistent with what
the goldfish additions did for a lot of other subsystems (as mentioned
in the commit log).   Most of the other goldfish subsystems had added
a clear dependency on the main GOLDFISH option.  Only power and
video had the missing dependencies.

--the argument of it keeping "the code in a good shape" is kind of weak,
in that it assumes the possible bugs will trigger out right compile failures
and warnings.  Some may, but it is a very very small subset.  Plus, say
for example, a driver is PPC specific, and we uncover an endian bug in
it for little endian.  Well, so what?  We are just spinning our wheels fixing
things for the academic value.

--we really _don't_ have a global policy to take the widest possible build
coverage after all.  For example, we do not build MIPS specific drivers
for arch=sparc, and we do not build m68k specific drivers for ARM.  Nor
should we start doing such a thing (for reasons listed below).

--forcing pointless build coverage impacts everyone.  Consider for a
moment, the linux-next tree, or anyone else doing routine coverage
builds.  If we adopt the "build everything even though you can't run
this code on that platform" policy, that build coverage grows out of
control, in terms of time spent.  The linux-next compile queue as it
is today barely gets completed within a 24h window.

--why shouldn't we restrict the maintenance overhead of CONFIG_FOO
to people who really do care about supporting and testing and updating
features conditional on CONFIG_FOO?  Given the size of the kernel
today, this seems to make sense in terms of developer "load balancing".

If you don't want to take the commit, I won't argue it any further, but
I genuinely do hope the above logical arguments perhaps might cause
you to  change your mind.

Thanks,
Paul.
--

>
> Thanks,
>
> Anton
>
>>  drivers/power/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
>> index 9e00c38..d314528 100644
>> --- a/drivers/power/Kconfig
>> +++ b/drivers/power/Kconfig
>> @@ -348,7 +348,7 @@ config AB8500_BM
>>
>>  config BATTERY_GOLDFISH
>>       tristate "Goldfish battery driver"
>> -     depends on GENERIC_HARDIRQS
>> +     depends on GENERIC_HARDIRQS && GOLDFISH
>>       help
>>         Say Y to enable support for the battery and AC power in the
>>         Goldfish emulator.
>> --
>> 1.8.1.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
