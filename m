Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbaJ2V0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:26:13 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52309 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757065AbaJ2V0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:26:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dan Streetman <ddstreet@ieee.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Neil Zhang <zhangwm@marvell.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        nfont@linux.vnet.ibm.com
Subject: Re: [PATCH V2] Driver cpu: update online when cpu_up/down besides sysfs
Date: Wed, 29 Oct 2014 22:46:46 +0100
Message-ID: <4115047.A3orYVLyA3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALZtONCkQVeau8JETKtxuQsoGnVymKPOgwvcidHH=EFVmhKc5g@mail.gmail.com>
References: <1414378748-8855-1-git-send-email-zhangwm@marvell.com> <544EBB70.6020507@intel.com> <CALZtONCkQVeau8JETKtxuQsoGnVymKPOgwvcidHH=EFVmhKc5g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 27, 2014 08:46:08 PM Dan Streetman wrote:
> On Mon, Oct 27, 2014 at 5:38 PM, Rafael J. Wysocki
> <rafael.j.wysocki@intel.com> wrote:
> > On 10/27/2014 3:59 AM, Neil Zhang wrote:
> >>
> >> The current per-cpu offline info won't be updated when we use
> >> any other method besides sysfs to call cpu_up/down.
> >> Thus the cpu/online can't reflect the real online status.
> >>
> >> This patch is going to fix the issue introduced by commit
> >> 0902a9044fa5b7a0456ea4daacec2c2b3189ba8c (Driver core:
> >> Use generic offline/online for CPU offline/online)
> >>
> >> CC: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Tested-by: Dan Streetman <ddstreet@ieee.org>
> >> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> >
> >
> > Oh dear, no.
> >
> > Please first tell me what exactly the problem you're seeing is.
> 
> For some background, here is my last comment on the first email thread on this:
> https://lkml.org/lkml/2014/10/27/595
> 
> I didn't create this patch, but the problem essentially is that before
> your commit the individual cpu online nodes
> (/sys/devices/system/cpu/cpuN/online) stayed in sync during
> cpu_down/up, because they used the cpu_online_mask; while after the
> commit, they are tracked by the cpu's generic dev->offline flag, which
> isn't updated during cpu_down/up.

Which is not triggered from sysfs.

> So now, any place in the kernel
> that brings a cpu up or down must also update the cpu->dev->offline
> flag.

Not any place.  In particular, system suspend-resume doesn't need to
do that, because it takes CPUs offline and then brings them back
online.

If there's a place in the kernel where CPUs are taken offline and
left in that state, then it needs to be updated.

> My interest in the patch was coincidental because I was seeing
> the same problem when using dlpar operations to hotplug cpus, which
> uses the arch/powerpc/platform/pseries/dlpar.c code; that code brings
> a cpu offline when it's hot-removed (and the cpu online when it's
> hot-added), but it hasn't been changed to also update the cpu's
> dev->offline flag.

It should be modified to do that.

> As I said in the previous email to the first thread, the ppc dlpar
> operation might be changed in the future to fully unregister a cpu
> when it's hot-removed, which would remove the entire sysfs cpuN
> directory.  Alternately and/or until then, it could be updated to
> simply update the cpu'd dev->offline flag (that's what I originally
> did for my own testing).  However, without a central place to update
> the cpu's dev->offline field, like this, or possibly in
> set_cpu_online(), or elsewhere during cpu_down/up, each place in the
> kernel that calls cpu_down() or cpu_up() also needs to update the
> dev->offline flag.  It's possible that the ppc dlpar code is the only
> place in the kernel that has this problem; I haven't searched.

It is quite likely to be the only place like that.

While I'm not familiar with the code in question, the most straightforward
way to fix the problem would be to replace cpu_down() in there with
device_offline(get_cpu_device(cpu)), but that needs to be called under
device_hotplug_lock.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
