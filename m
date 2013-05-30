Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3E3MiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:38:16 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:55364 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab3E3MiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:38:05 -0400
MIME-Version: 1.0
In-Reply-To: <CANFwon3SBnRBAFwPOAL6++fHdisxTh==2ZQWWDqyuoF5vPQLNQ@mail.gmail.com>
References: <CANFwon3SBnRBAFwPOAL6++fHdisxTh==2ZQWWDqyuoF5vPQLNQ@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Thu, 30 May 2013 20:37:24 +0800
Message-ID: <CANFwon14wX-7Jt1sJxAnY999N_X=CZZdytPsp5WQmpeQYhYCig@mail.gmail.com>
Subject: Re: KGTP (Linux debugger and tracer) 20130508 release (add single
 step support)
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Geunsik Lim <leemgs1@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Tao Ma <taoma.tm@gmail.com>,
        Oliver Yang <yangoliver@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I make a video to introduce how to use KGTP debug the Linux kernel of Android.
Please goto http://youtu.be/_UGN2j8Ctg0 or
http://www.tudou.com/programs/view/FjkQ6HhPnfE/ see the English
version.
Or goto http://www.tudou.com/programs/view/qCumSPhByFI/ or
http://youtu.be/9YMpAvsl37I see the Chinese version.

Thanks,
Hui

On Wed, May 8, 2013 at 5:41 PM, Hui Zhu <teawater@gmail.com> wrote:
> Hi guys,
>
> KGTP (http://code.google.com/p/kgtp/) is a flexible, lightweight and
> realtime Linux debugger and tracer.
> To use it, you don't need patch or rebuild the Linux kernel. Just
> build KGTP module and insmod it is OK.
>
> Please go to http://code.google.com/p/kgtp/wiki/HOWTO or
> http://code.google.com/p/kgtp/wiki/HOWTO (Chinese) to get more info
> about howto use KGTP.
>
> Please goto https://code.google.com/p/kgtp/wiki/HOWTO#Table_of_different_between_GDB_debug_normal_program_and_KGTP
> or https://code.google.com/p/kgtp/wiki/HOWTOCN#GDB调试普通程序和KGTP的区别表
> (Chinese) get the table of different between GDB debug normal program
> and KGTP if you have experience using GDB debug normal program.
>
> Now, KGTP 20130508 release.
> You can get the package for it from
> http://kgtp.googlecode.com/files/kgtp_20130508.tar.bz2
> or
> svn co https://kgtp.googlecode.com/svn/tags/20130508
>
> The main change of this release is complete the support of
> while-stepping.  KGTP can let Linux kernel do single step now.
> Please note that while-stepping is just support by X86 and X86_64 now.
> Howto use while-stepping:
> while-stepping is a special tracepoint action that include some actions with it.
> When tracepoints that its actions include "while-stepping n" execute,
> it will do n times single steps and executes the actions of
> while-stepping. For example:
> trace vfs_read
> #Because single step will make system slow, so use passcount or
> condition to limit the execution times of tracepoint is better.
> passcount 1
>   commands
>     collect $bt
>     collect $step_count
>     #do 2000 times single steps.
>     while-stepping 2000
>       #Following part is actions of "while-stepping 2000".
>       #Because step maybe execute to other functions, so does not
> access local variables is better.
>       collect $bt
>       collect $step_count
>     end
>   end
> You can switch KGTP to replay mode to select all the traceframe of a
> while-stepping tracepoint with GDB execution and reverse-execution
> commands. For example:
> Use tfind select one the traceframe of a while-stepping tracepoint.
> (gdb) tfind
> Found trace frame 0, tracepoint 1
> #0  vfs_read (file=0xffff8801f7bd4c00, buf=0x7fff74e4edb0 <Address
> 0x7fff74e4edb0 out of bounds>, count=16,
>     pos=0xffff8801f4b45f48) at /build/buildd/linux-3.2.0/fs/read_write.c:365
> 365     {
> Following commands will swith KGTP to replay mode.
>
> (gdb) monitor replay
> (gdb) tfind -1
> No longer looking at any trace frame
> #0  vfs_read (file=0xffff8801f7bd4c00, buf=0x7fff74e4edb0 <Address
> 0x7fff74e4edb0 out of bounds>, count=16,
>     pos=0xffff8801f4b45f48) at /build/buildd/linux-3.2.0/fs/read_write.c:365
> 365     {
> Then you can use execution commands.
>
> (gdb) n
> 368             if (!(file->f_mode & FMODE_READ))
> (gdb) p file->f_mode
> $5 = 3
> Set breakpoints (Just valid in replay mode, will not affect Linux
> kernel execution).
>
> (gdb) b 375
> Breakpoint 2 at 0xffffffff81179b75: file
> /build/buildd/linux-3.2.0/fs/read_write.c, line 375.
> (gdb) c
> Continuing.
>
> Breakpoint 2, vfs_read (file=0xffff8801f7bd4c00, buf=0x7fff74e4edb0
> <Address 0x7fff74e4edb0 out of bounds>, count=16,
>     pos=0xffff8801f4b45f48) at /build/buildd/linux-3.2.0/fs/read_write.c:375
> 375             ret = rw_verify_area(READ, file, pos, count);
> (gdb) s
> rw_verify_area (read_write=0, file=0xffff8801f7bd4c00,
> ppos=0xffff8801f4b45f48, count=16)
>     at /build/buildd/linux-3.2.0/fs/read_write.c:300
> 300             inode = file->f_path.dentry->d_inode;
> Use reverse-execution commands.
>
> (gdb) rs
>
> Breakpoint 2, vfs_read (file=0xffff8801f7bd4c00, buf=0x7fff74e4edb0
> <Address 0x7fff74e4edb0 out of bounds>, count=16,
>     pos=0xffff8801f4b45f48) at /build/buildd/linux-3.2.0/fs/read_write.c:375
> 375             ret = rw_verify_area(READ, file, pos, count);
> (gdb) rn
> 372             if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
> GDB commands tstart, tfind or quit can auto close the replay mode.
>
> Please goto https://code.google.com/p/kgtp/wiki/HOWTO#Use_while-stepping_let_Linux_kernel_do_single_step
> or https://code.google.com/p/kgtp/wiki/HOWTOCN#使用while-stepping让Linux内核做单步
> (Chinese version) get more info about it.
>
> Please goto http://code.google.com/p/kgtp/wiki/UPDATE get more info
> about this release.
>
> According to the comments of Christoph, Geoff and Andi.  I make lite
> patch for review.  Please goto https://lkml.org/lkml/2012/5/9/90 to
> see it.
>
> Thanks,
> Hui
