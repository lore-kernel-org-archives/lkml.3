Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab3FLEHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 00:07:39 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39078 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3FLEHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 00:07:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130612123248.GA23978@linux-youquan.bj.intel.com>
References: <51B79BE5.80804@sr71.net>
	<1637965.BN0HgQKvFj@vostro.rjw.lan>
	<51B7A1F8.6080507@sr71.net>
	<27437213.QrmAtijARn@vostro.rjw.lan>
	<1370989954.21540.4.camel@misato.fc.hp.com>
	<20130612120343.GA22109@linux-youquan.bj.intel.com>
	<51B7BFB0.8080401@sr71.net>
	<20130612123248.GA23978@linux-youquan.bj.intel.com>
Date: Tue, 11 Jun 2013 21:07:37 -0700
X-Google-Sender-Auth: jZwm9q1m0myyLZtmvwTzmr4Pf7A
Message-ID: <CAE9FiQXWi7mn6AM=A2qrHO=3S_oLT7wBRLm19rP987hGzwdqKA@mail.gmail.com>
Subject: Re: cpu hotplug: possible_cpus broken (again?) next-20130607
From: Yinghai Lu <yinghai@kernel.org>
To: Youquan Song <youquan.song@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave@sr71.net>, Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Youquan Song <youquan.song@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 5:32 AM, Youquan Song
<youquan.song@linux.intel.com> wrote:
>> On 06/12/2013 05:03 AM, Youquan Song wrote:
>> > +#ifdef CONFIG_SMP
>> > +              /* return when cpu number greater than maximum number of
>> > CPUs */
>> > +               if (setup_max_cpus <= num_online_cpus() + 1) {
>> > +                       cpu_hotplug_driver_unlock();
>> > +                       return -EINVAL;
>> > +               }
>> > +#endif
>> >                 from_nid = cpu_to_node(cpuid);
>> >                 ret = cpu_up(cpuid);
>>
>> Your patch is line-wrapped.
>>
>> Also, the #ifdef is unnecessary.  If CONFIG_SMP is off:
>>
>>       static const unsigned int setup_max_cpus = NR_CPUS;
>>       #define num_online_cpus() 1U
>>
>> The compiler will take care of optimizing out the the if() without the
>> explicit #ifdef.
>>
>> Also, the +1 looks goofy to me.  Doesn't this do the same thing (and
>> isn't it much easier to read)?
>>
>>       if (num_online_cpus() >= setup_max_cpus)
>>
>
> Thanks. Here is a formal patch for it. please review and try.
>
> Subject: [PATCH] core: Fix maxcpus boot option broken
>
> maxcpus boot option to limit maximum number of CPUs on system, but this option
> is broken at recent kernel. Though we use maxcpus to limit CPUs number, but
> current kernel will register all of present CPUs in sysfs.
> udev will enumerate all registered cpu at sysfs, and it will bring up the CPU
> if the CPU is offline. So the maxcpus option is broken.
>
> This patch will limit the online cpus number not over limitation of maxcpus
> option. So it will keep the maxcpus limitation when udev enumeration
> or other intention of bring up CPUs over the limitation by method like
> echo 1 > /sys/devices/system/cpu/online

Interesting, you are changing long standing meaning of maxcpus=

We always use maxcpus=1 to have one cpu up, and later in user space
to online other cpus like
echo 1 > /sys/devices/system/cpuX/online.

aka maxcpus= is a soft limit or initial online nr.

we already have nr_cpus= for hard limit.

So need to drop
 commit 3e275a5ba367ab74b3a4e49114307baed989fcac
 Author: Youquan Song <youquan.song@intel.com>
 Date:   Fri Jun 7 10:07:08 2013 +1000

     drivers/base/cpu.c: fix maxcpus boot option

Greg,
Can you drop that 3e275a5ba36 from your drivers/core tree ?

Thanks

Yinghai
