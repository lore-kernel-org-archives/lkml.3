Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab3AZIRZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 03:17:25 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64777 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3AZIRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 03:17:23 -0500
X-Nat-Received: from [202.181.97.72]:63384 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1359188223.29105
To: linus.walleij@linaro.org
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
	<CACRpkdY1sJPkPJx8zFbYOsvHFUM4S_6_eLWjifBpNyqH7cCrDA@mail.gmail.com>
	<201301221817.IDD95831.HVOOFMFJOLFSQt@I-love.SAKURA.ne.jp>
	<CACRpkdYRM9MDt92juV+x9w9BUnHpCSd2KCkZ5F7zwPfhn939ZQ@mail.gmail.com>
	<201301222123.CEJ65174.StJFMOQFVFHOLO@I-love.SAKURA.ne.jp>
In-Reply-To: <201301222123.CEJ65174.StJFMOQFVFHOLO@I-love.SAKURA.ne.jp>
Message-Id: <201301261717.JGJ04628.OOFVHFLOFJMtSQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 26 Jan 2013 17:17:07 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 26012013 #9418102, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> > I'm sorry if this is a bit complicated but bisection down several
> > regressions is one of the more advanced forms of regression
> > bug hunt... You're quite cool if you can handle it :-)
> 
> Sorry, I'm a beginner about git. I already know that 07c9249f is the cause of
> "no console messages" and 5c49985c is the fix for "no console messages".
> How can I setup a snapshot with 07c9249f and 5c49985c applied (I tried
> 
>   $ git reset --hard 07c9249f
>   $ git format-patch --stdout 5c49985c^..5c49985c | patch -p1
> 
> but patch does not apply cleanly) so that I can find the commit causing
> "sym0: request irq 27 failure" which is between 07c9249f and 5c49985c?

I did a blind git bisection (i.e. starting

  $ qemu-system-arm -M versatilepb -hda hda.img -kernel arch/arm/boot/zImage -append "root=/dev/sda1 init=/bin/sh" -nographic

and watching "top" for %CPU usage of qemu-system-arm , assuming that it goes to
100% only if detection of block device for / partition failed and kernel called
panic(), goes to 0% otherwise) in two patterns.

  $ git bisect start HEAD b1112249 v3.7 v3.6 v3.5 v3.4 v3.3 v3.2 v3.1 v3.0 -- arch/arm drivers/scsi/sym53c8xx_2/ drivers/scsi/*.[ch]

  $ git bisect start v3.8-rc1 95e629b7 b8db6b8 810883f0 b10bca0b 14318efb 414a6750e b1112249 v3.7 v3.6 v3.5 v3.4 v3.3 v3.2 v3.1 v3.0

Both patterns resulted in that commit 07c9249f
"ARM: 7554/1: VIC: use irq_domain_add_simple()" is the cause of

  PCI: enabling device 0000:00:0c.0 (0100 -> 0103)
  sym0: <895a> rev 0x0 at pci 0000:00:0c.0 irq 27
  sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
  sym0: request irq 27 failure
  sym0: giving up ...

message.

Would you have a look?

Regards.
