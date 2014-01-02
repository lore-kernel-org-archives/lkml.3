Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136AbaABCZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 21:25:58 -0500
Received: from mail.wdtv.com ([66.118.69.84]:33540 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaABCZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 21:25:57 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: AMD microcode fails to update with v3.8.3 and newer, bisect failed
Date: Wed, 1 Jan 2014 21:25:55 -0500
Cc: linux-kernel@vger.kernel.org
References: <201401011752.00267.gheskett@wdtv.com> <20140102001900.GC19878@titan.lakedaemon.net>
In-Reply-To: <20140102001900.GC19878@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201401012125.55522.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 January 2014, Jason Cooper wrote:
>Gene,
>
>Most people on this list receive several _hundred_ to a couple thousand
>emails per day.  Please use a concise and descriptive Subject line so
>your email catches the eye of folks who can most help you.  I've updated
>it in this reply to:
>
>Subject: AMD microcode fails to update with v3.8.3 and newer, bisect
>failed
>
>An interesting point, when bisecting from v3.8.2 -> v3.8.3, all tested
>kernels work *except* v3.8.3.  When bisecting the other direction, from
>v3.8.3 -> v3.8.2, all kernels fail *except* v3.8.2.  This leads me to
>believe it is a configuration problem.
>
>Gene, could you build v3.8.2, confirm it works, and send the config
>file?  Then do the same for v3.8.3 (confirm fail, though) and send that
>config as well?

I tried that after sending this message.  The 3.8.2 from a tarball, and 
which I had been getting known good .configs from, reinstalled, now fails, 
can't mount /boot or some such. And I now have it mounting and dismounting 
via a LABEL="ububoot" in my /etc/fstab.  UUID's must have gone to hell when
I disabled the floppy in the bios.

Currently on 3.12.6, a tarball based build, PAE without the microcode 
patching according to a "dmesg|grep microcode" output

gene@coyote:~/src/linux-3.12.6$ sudo umount /boot
[sudo] password for gene:
gene@coyote:~/src/linux-3.12.6$ df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda2            955387652 255678680 651154988  29% /
none                   4146908       436   4146472   1% /dev
none                   4153304      3716   4149588   1% /dev/shm
none                   4153304       260   4153044   1% /var/run
none                   4153304         4   4153300   1% /var/lock
none                   4153304         0   4153304   0% /lib/init/rw
/dev/sdc2            960929128 513222732 398893956  57% /amandatapes
/dev/sdb1            953178004  69667928 835091364   8% /media/ubu12.4.2
/dev/sdd1            482336436 198274624 259537472  44% /media/home2
lathe:/home/gene     234470400   4697856 217862144   3% /net/lathe/home/gene
shop:/home/gene      234470400   7113728 215446016   4% /net/shop/home/gene

not there.

gene@coyote:~/src/linux-3.12.6$ sudo mount LABEL=ububoot /boot
gene@coyote:~/src/linux-3.12.6$ df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda2            955387652 255678688 651154980  29% /
none                   4146908       436   4146472   1% /dev
none                   4153304      3716   4149588   1% /dev/shm
none                   4153304       260   4153044   1% /var/run
none                   4153304         4   4153300   1% /var/lock
none                   4153304         0   4153304   0% /lib/init/rw
/dev/sdc2            960929128 513222732 398893956  57% /amandatapes
/dev/sdb1            953178004  69667928 835091364   8% /media/ubu12.4.2
/dev/sdd1            482336436 198274624 259537472  44% /media/home2
lathe:/home/gene     234470400   4697856 217862144   3% /net/lathe/home/gene
shop:/home/gene      234470400   7113728 215446016   4% /net/shop/home/gene
/dev/sda1              1007896    333288    623408  35% /boot

looks good.

So there is no problem I can see.  But 3.8.2 is now failing.

So, how far forward can I take a bisect, starting at v3.8.0 using the 
linux-stable clone pull?  I started to yesterday, but ran into the non 
mount of /boot problem which ate my lunch and I did not reset it yet.

>On Wed, Jan 01, 2014 at 05:51:59PM -0500, Gene Heskett wrote:
>> Greetings;
>> 
>> Back on the failure of the amd microcode to properly update the cpu. 
>> It seems to be somewhat interlocked with PAE.
>> 
>> Basically, 1. a 64 bit kernel will not boot, I think because it cannot
>> access the /boot partition to find its corresponding initrd file.
>
>Are the rootfs binaries 32 bit?  If so, did you enable
>CONFIG_IA32_EMULATION?

That line above does not now exist in my .config for 3.8.2. Ditto for 
the .config in 3.12.6.

How is the best way to restore this?


>You may be able to bypass your PAE problem by running a 64bit kernel
>with the above option.  Although, I'd prefer to get to the bottom of the
>failure. :)
>
>>  And if I check it, the rest of my .config is mix-mastered, and I have
>>  to copy a known good .config back into that tree before I can make a
>>  PAE kernel that actually boots.
>> 
>> 2. If I build w/o the PAE, then the microcode update works most of the
>> time.
>> 
>> 3. With PAE, it hasn't worked since 3.8.2 final.
>
>In addition to the two configs I mentioned above, could you do them with
>and without PAE (so four total)?
>
>> 4. I am building several thousand modules I don't need, because while I
>> can turn them off, about 2500-3000 of them but they are found to be
>> back on after a build and an attempted boot to that build fails, or
>> doesn't mount the /boot partition.  Its a failure either way.
>
>What is the exact series of commands causing this?  Are you saving your
>configs and running 'yes "" | make oldconfig' for testing different
>versions?
>
No, this is something new?  And I am not 'saving' the .config or config.old
so what is that exact procedure now.  The make itself does a make 
silentoldconfig that I see going by right after the make clean.  The last
I knew, a make xconfig only saved to the .config file.  And that is what 
the build made, none of this I know better than you BS I seem to have now.

Since my 3.8.2 build is now trashed, I'll go back and lookup your instructions
to make a default x64 config, for 3.12.0, try that, and if it fails I'll go get my
camera (its currently out in the shop with my cnc machine tools) and post 
a pix of the failed boot screen.  However, IF I make a change
using make xconfig, how do I make it "stick"?  Something is second guessing 
me and turning most of the modules I don't need to waste time building back 
on.  I have not kept track of the number of times I have disabled the raid 
stuff, only to see the megaraid module build go by in the make output.

>thx,
>
>Jason.
>
>> Attached is a .config that builds PAE but the microcode_ctl, when it
>> runs, fails.  And if I try to re-run /etc/init.d/microcode_ctl after
>> the boot, I get this:
>> 
>> [sudo] password for gene:
>> /etc/init.d/microcode_ctl: 90: gprintf: not found
>> 
>> But that is NOT what a demsg|grep microcode says:
>> gene@coyote:~$ dmesg|grep microcode
>> microcode: CPU0: patch_level=0x01000065
>> microcode: CPU1: patch_level=0x01000065
>> microcode: CPU2: patch_level=0x01000065
>> microcode: CPU3: patch_level=0x01000065
>> microcode: Microcode Update Driver: v2.00
>> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>> 
>> The above snippet should show 4 more lines, indicating the patch_level
>> is now 0x01000083.
>> 
>> I have been at this for about a week now, even did 3 bisects only to
>> have git blame the next makefile at the end of the bisect.  Must be
>> its default when it gives up?
>> 
>> Clueless, due to a lack of consistency in expected results, compounded
>> by something re-writing my .config file, that much is 100% repeatable.
>> 
Cheers Jason, Gene
