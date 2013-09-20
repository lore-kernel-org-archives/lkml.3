Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3ITQef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:34:35 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33125 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3ITQee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:34:34 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdasfW9OzZHPgfksjkHgw+Z-n7Tc_d2yXYy+BjShUhAYFg@mail.gmail.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
	<CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com>
	<CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com>
	<CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com>
	<CACRpkdZDqoqrEPfdra+iVS-hopLpJbPmWh=r8UkYRFUMg17jpw@mail.gmail.com>
	<523C6A88.30800@linux.vnet.ibm.com>
	<CACRpkdasfW9OzZHPgfksjkHgw+Z-n7Tc_d2yXYy+BjShUhAYFg@mail.gmail.com>
Date: Fri, 20 Sep 2013 18:34:34 +0200
Message-ID: <CACRpkdbEdR6g7cGouSxVoCp7jFRUSmP9yKcu5+afEMqUR45Kfg@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 5:40 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Sep 20, 2013 at 5:32 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On 09/20/2013 08:51 PM, Linus Walleij wrote:
>
>>> sa11x0_pcmcia_init() which starts this chain of events is called as
>>> an fs_initcall(), see drivers/pcmcia/sa1100_generic.c
>>
>> But fs_initcall() comes after arch_initcall() right? (looking at
>> include/linux/init.h). Since the corresponding cpufreq-driver (drivers/
>> cpufreq/sa1100-cpufreq.c) uses arch_initcall() to register itself, it
>> is all the more surprising how this could happen...
>
> Hm it does happen if the cpufreq driver does not probe *at all*
> right? I will look closer at this, maybe it just doesn't register
> properly for some SA1100 variants...

Aha yeah this is it. The h3600 has an SA1110 and uses
drivers/cpufreq/sa1110-cpufreq.c.

This driver needs to know the RAM mounted on the board,
if it is this or that type, to perform properly.

This is passed from the command line or a default is selected
from the machine type:

    if (!name[0]) {
        if (machine_is_assabet())
            name = "TC59SM716-CL3";
        if (machine_is_pt_system3())
            name = "K4S641632D";
        if (machine_is_h3100())
            name = "KM416S4030CT";
        if (machine_is_jornada720())
            name = "K4S281632B-1H";
        if (machine_is_nanoengine())
            name = "MT48LC8M16A2TG-75";
    }

In this case we have neither. So the cpufreq driver fails to
register. But the kernel used to survive in any case, as you
could call cpufreq_get() without a cpufreq driver registered.

I think your suggested patch fixes the issue.

As a proper fix I'd like to add a default RAM type for the h3600
but that is for later...

Yours,
Linus Walleij
