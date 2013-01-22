Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab3AVMXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:23:31 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:53177 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3AVMXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:23:30 -0500
X-Nat-Received: from [202.181.97.72]:62313 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1358857391.30136
To: linus.walleij@linaro.org
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
	<CACRpkdY1sJPkPJx8zFbYOsvHFUM4S_6_eLWjifBpNyqH7cCrDA@mail.gmail.com>
	<201301221817.IDD95831.HVOOFMFJOLFSQt@I-love.SAKURA.ne.jp>
	<CACRpkdYRM9MDt92juV+x9w9BUnHpCSd2KCkZ5F7zwPfhn939ZQ@mail.gmail.com>
In-Reply-To: <CACRpkdYRM9MDt92juV+x9w9BUnHpCSd2KCkZ5F7zwPfhn939ZQ@mail.gmail.com>
Message-Id: <201301222123.CEJ65174.StJFMOQFVFHOLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 22 Jan 2013 21:23:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 22012013 #9161095, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> > Which one ("blank console bug" or "IRQ registration failure bug") does
> > "the boot regression" refer?
> 
> They are likely one and the same bug? The only regression on
> the versatile I have caused came from commit
> f5565295892eb93c3191aa241405fe8b685542d6.
> 
It seems that my case

  PCI: enabling device 0000:00:0c.0 (0100 -> 0103)
  sym0: <895a> rev 0x0 at pci 0000:00:0c.0 irq 27
  sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
  sym0: request irq 27 failure
  sym0: giving up ...

may not come from that commit.

> > Since the IRQ registration failure bug message contains IRQ number "27",
> > I suspect f5565295 "ARM: 7610/1: versatile: bump IRQ numbers"
> 
> Me too :-) Atleast Grant told me that that one patch fixed the
> boot regression.
> 
> And that is why I mentioned that patch specifically above,
> I think it's the only one you need.
> 
> > and 5ced33bc06 "ARM: 7611/1: VIC: fix bug in VIC irqdomain code"
> 
> I don't think you need this patch.
> 
> > but how can I test them?
> 
> Apply/compile/boot?
> 
> Sorry I don't quite get the question?

Well, my case was introduced between 07c9249f and 5c49985c but I cannot see
console messages from 07c9249f till 5c49985c.

I tried reverting f5565295 and/or 5ced33bc06 (as shown below) but it did not
help.

$ git pull origin master # Move to latest commit.
$ make -s
$ qemu-system-arm

The message in question ( "sym0: request irq 27 failure" ) was printed.

$ git show f5565295 | patch -p1 -R # Revert only "ARM: 7610/1: versatile: bump IRQ numbers"
$ make -s
$ qemu-system-arm

Cannot determine whether the message in question was printed or not, for
console shows no messages.

$ git show f5565295 | patch -p1 # Move to latest commit
$ git show 5ced33bc | patch -p1 -R # Revert only "ARM: 7611/1: VIC: fix bug in VIC irqdomain code"
$ make -s
$ qemu-system-arm

The message in question was printed.

$ git show f5565295 | patch -p1 -R # Also revert "ARM: 7610/1: versatile: bump IRQ numbers"
$ make -s
$ qemu-system-arm

Cannot determine whether the message in question was printed or not, for
console shows no messages.

> When you cannot proceed because you need a patch unrelated to the
> problem you want to solve, you apply that patch on top of the
> bisection HEAD with patch -p1 < foo.patch, test, reset HEAD,
> git bisect <result> etc....
> 
> I'm sorry if this is a bit complicated but bisection down several
> regressions is one of the more advanced forms of regression
> bug hunt... You're quite cool if you can handle it :-)

Sorry, I'm a beginner about git. I already know that 07c9249f is the cause of
"no console messages" and 5c49985c is the fix for "no console messages".
How can I setup a snapshot with 07c9249f and 5c49985c applied (I tried

  $ git reset --hard 07c9249f
  $ git format-patch --stdout 5c49985c^..5c49985c | patch -p1

but patch does not apply cleanly) so that I can find the commit causing
"sym0: request irq 27 failure" which is between 07c9249f and 5c49985c?

Regards.
