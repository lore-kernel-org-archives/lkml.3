Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaHLBNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 21:13:22 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:50350 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaHLBNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 21:13:21 -0400
From: Sadasivan Shaiju <sshaiju@mvista.com>
References: <ad46c9518e35397c8f4d281a3f88d129@mail.gmail.com> <20140811224925.GE30401@n2100.arm.linux.org.uk>
In-Reply-To: <20140811224925.GE30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIMrSjqJ+zE6DRXcig0zB+0d2N4vgMrJTSymzjdNxA=
Date: Mon, 11 Aug 2014 18:12:35 -0700
Message-ID: <dfaec2915a403865125b1e06c35386f9@mail.gmail.com>
Subject: RE: PATCH -RCU locking on last_VFP_context[cpu] in vfp_notifier [2.6.32]
To: Russell King - ARM Linux <linux@arm.linux.org.uk>, Catalin.Marinas@arm.com
Cc: linux-kernel@vger.kernel.org, shaiju_sada@yahoo.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Russell,

Thanks  for  looking  into  the  issue.

This  issue  came  up  when  I  was  doing  econa (ARM)  board bringup
for Montavista (cavium) .
Following  was  the  bug  description .

  Using cge60-econa-cns3420-2.6.32_110928_1104937 the kernel failed to
boot with
the following error:

Internal error: Oops: 817 [#1] from cpu 1 PREEMPT SMP
last sysfs file: /sys/devices/virtual/bdi/0:19/uevent
Modules linked in: hmac ctr deflate
CPU: 1    Tainted: G        W   (2.6.32.46.cge #1)
PC is at vfp_notifier+0x48/0xbc
LR is at vfp_notifier+0x44/0xbc
pc : []    lr : []    psr: 60000013
sp : aeee1d30  ip : aeee1d50  fp : aeee1d4c
r10: af8d6460  r9 : ffffffff  r8 : af88c000
r7 : a05ba584  r6 : af88c000  r5 : 00000001  r4 : 40000000
r3 : 00000000  r2 : 00000000  r1 : 40000000  r0 : aeee0230
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5787d  Table: 2eeec00a  DAC: 00000017
Process grep (pid: 1710, stack limit = 0xaeee0270)
Stack:  from cpu 1 (0xaeee1d30 to 0xaeee2000)


During  the  bring up  I  used  to  intract  with   Catalin Marinas(
Catalin.Marinas@arm.com)from  ARM  .  He  is  copied on the email .
Catalin  has  pointed   out  the  following  patch  to  me ,  which
solved  my problem .  I  just  want  to make  sure  the patch  goes to
mainline kernel.

> The  following  patch  provided  by  you  solves  my  problem .  thanks
.
>
> http://article.gmane.org/gmane.linux.ports.arm.kernel/56631

Great.

--
Catalin



Regards,
Shaiju.


-----Original Message-----
From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
Sent: Monday, August 11, 2014 3:49 PM
To: Sadasivan Shaiju
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH -RCU locking on last_VFP_context[cpu] in vfp_notifier
[2.6.32]

On Mon, Aug 11, 2014 at 03:24:18PM -0700, Sadasivan Shaiju wrote:
> Hi ,
>
> I  work for Montavista (Cavium Inc) as  a  Technical  Lead .  I want
> to push some  of the kernel  patches to  rt community (2.6.32 kernel
> 2.6.33 rt patch)  , so  that  It  will  go  to  the  main line These
> patches  are reviewed  and approved  by  our system Architect.  I
> request  you to include  in the main line .  These  issues  were
> reported  during econa board bringup at montavista.
>
> Problem Description:
> Using cge60-econa-cns3420-2.6.32, the kernel failed to boot with the
> following
> error:
>
> Internal error: Oops: 817 [#1] from cpu 1 PREEMPT SMP last sysfs file:
> /sys/devices/virtual/bdi/0:19/uevent
> Modules linked in: hmac ctr deflate
> CPU: 1    Tainted: G        W   (2.6.32.46.cge #1)
> PC is at vfp_notifier+0x48/0xbc
> LR is at vfp_notifier+0x44/0xbc
> pc : []    lr : []    psr: 60000013
> sp : aeee1d30  ip : aeee1d50  fp : aeee1d4c
> r10: af8d6460  r9 : ffffffff  r8 : af88c000
> r7 : a05ba584  r6 : af88c000  r5 : 00000001  r4 : 40000000
> r3 : 00000000  r2 : 00000000  r1 : 40000000  r0 : aeee0230
> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 00c5787d  Table: 2eeec00a  DAC: 00000017 Process grep (pid:
> 1710, stack limit = 0xaeee0270)
> Stack:  from cpu 1 (0xaeee1d30 to 0xaeee2000)
>
> Root Cause:
> On the SMP architecture, last_VFP_context[cpu] becomes NULL because it
> gets released on a different CPU.
>
> How Solved:
> Fixed by exiting the thread instead of releasing the thread in the
> vfp_notifier.
>
> I  request you  to include  the above patch to  the main line kernel .
> If any questions  please contact me  at  sshaiju@mvista.com
> (shaiju_sada@yahoo.com)

This is totally insufficient for fixing a bug in a complex piece of code.

You fail to explain exactly _how_ the bug arises.  You say
"last_VFP_context[cpu] becomes NULL because it gets released on a
different CPU" - how does that happen?

The only places that last_VFP_context[cpu] is set to NULL is within a cpu
= get_cpu()..put_cpu() region, which by definition *must* be running on
the CPU specified by 'cpu'.

Without a proper diagnosis showing exactly what the race is which causes
the above oops, there's nothing I can do.  Sorry.

--
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
