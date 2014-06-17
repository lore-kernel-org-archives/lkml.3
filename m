Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956AbaFQNtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:49:12 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:56746 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbaFQNtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:49:10 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Hagen Paul Pfeifer <hagen@jauu.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include: kernel.h: rewrite min3, max3 and clamp using min and max
In-Reply-To: <20140616161804.bb06ed842f59371c031d1252@linux-foundation.org>
Organization: http://mina86.com/
References: <1402952842-12886-1-git-send-email-mina86@mina86.com> <20140616161804.bb06ed842f59371c031d1252@linux-foundation.org>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140617:linux-kernel@vger.kernel.org::s9qq/v9QusndepUl:0000000000000000000000000000000002qnw
X-Hashcash: 1:20:140617:rostedt@goodmis.org::UyfXvDdXFp12hlAU:00000000000000000000000000000000000000000043Js
X-Hashcash: 1:20:140617:akpm@linux-foundation.org::j8T1zL/kpAc3r/3N:0000000000000000000000000000000000004FMZ
X-Hashcash: 1:20:140617:hagen@jauu.net::FA6MrJ4/iC31+6y2:0009Dlm
Date: Tue, 17 Jun 2014 15:49:05 +0200
Message-ID: <xa1tionzwsry.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16 2014, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 16 Jun 2014 23:07:22 +0200 Michal Nazarewicz <mina86@mina86.com> wrote:
>
>> It appears that gcc is better at optimising a double call to min
>> and max rather than open coded min3 and max3.  This can be observed
>> here:
>> 
>> ...
>>
>> Furthermore, after ___make allmodconfig && make bzImage modules___ this is the
>> comparison of image and modules sizes:
>> 
>>     # Without this patch applied
>>     $ ls -l arch/x86/boot/bzImage **/*.ko |awk '{size += $5} END {print size}'
>>     350715800
>> 
>>     # With this patch applied
>>     $ ls -l arch/x86/boot/bzImage **/*.ko |awk '{size += $5} END {print size}'
>>     349856528
>
> We saved nearly a megabyte by optimising min3(), max3() and clamp()? 
>
> I'm counting a grand total of 182 callsites for those macros.  So the
> saving is 4700 bytes per invokation?  I don't believe it...

You're absolutely right.  I must have messed something up here.  This
portion of the commit message should be removed.

So I've redone this just on just the kernel image with allmodconfig:

    Linux mpn-glaptop 3.13.0-29-generic #53~precise1-Ubuntu SMP Wed Jun 4 22:06:25 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
    gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3
    Copyright (C) 2011 Free Software Foundation, Inc.
    This is free software; see the source for copying conditions.  There is NO
    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    
    -rwx------ 1 mpn eng 51224656 Jun 17 14:15 vmlinux.before
    -rwx------ 1 mpn eng 51224608 Jun 17 13:57 vmlinux.after

48 bytes reduction.  The do_fault_around was a few instruction shorter
and as far as I can tell saved 12 bytes on the stack, i.e.:

    $ grep -e rsp -e pop -e push do_fault_around.*
    do_fault_around.before.s:push   %rbp
    do_fault_around.before.s:mov    %rsp,%rbp
    do_fault_around.before.s:push   %r13
    do_fault_around.before.s:push   %r12
    do_fault_around.before.s:push   %rbx
    do_fault_around.before.s:sub    $0x38,%rsp
    do_fault_around.before.s:add    $0x38,%rsp
    do_fault_around.before.s:pop    %rbx
    do_fault_around.before.s:pop    %r12
    do_fault_around.before.s:pop    %r13
    do_fault_around.before.s:pop    %rbp

    do_fault_around.after.s:push   %rbp
    do_fault_around.after.s:mov    %rsp,%rbp
    do_fault_around.after.s:push   %r12
    do_fault_around.after.s:push   %rbx
    do_fault_around.after.s:sub    $0x30,%rsp
    do_fault_around.after.s:add    $0x30,%rsp
    do_fault_around.after.s:pop    %rbx
    do_fault_around.after.s:pop    %r12
    do_fault_around.after.s:pop    %rbp

or here side-by-side:

    Before                    After
    push   %rbp               push   %rbp          
    mov    %rsp,%rbp          mov    %rsp,%rbp     
    push   %r13                                    
    push   %r12               push   %r12          
    push   %rbx               push   %rbx          
    sub    $0x38,%rsp         sub    $0x30,%rsp    
    add    $0x38,%rsp         add    $0x30,%rsp    
    pop    %rbx               pop    %rbx          
    pop    %r12               pop    %r12          
    pop    %r13                                    
    pop    %rbp               pop    %rbp          

There are also fewer branches:

    $ grep ^j do_fault_around.*
    do_fault_around.before.s:jae    ffffffff812079b7
    do_fault_around.before.s:jmp    ffffffff812079c5
    do_fault_around.before.s:jmp    ffffffff81207a14
    do_fault_around.before.s:ja     ffffffff812079f9
    do_fault_around.before.s:jb     ffffffff81207a10
    do_fault_around.before.s:jmp    ffffffff81207a63
    do_fault_around.before.s:jne    ffffffff812079df
    
    do_fault_around.after.s:jmp    ffffffff812079fd
    do_fault_around.after.s:ja     ffffffff812079e2
    do_fault_around.after.s:jb     ffffffff812079f9
    do_fault_around.after.s:jmp    ffffffff81207a4c
    do_fault_around.after.s:jne    ffffffff812079c8

And here's with allyesconfig on a different machine:

    $ uname -a; gcc --version; ls -l vmlinux.*
    Linux erwin 3.14.7-mn #54 SMP Sun Jun 15 11:25:08 CEST 2014 x86_64 AMD Phenom(tm) II X3 710 Processor AuthenticAMD GNU/Linux
    gcc (GCC) 4.8.3
    Copyright (C) 2013 Free Software Foundation, Inc.
    This is free software; see the source for copying conditions.  There is NO
    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    
    -rwx------ 1 mina86 mina86 230616126 Jun 17 15:39 vmlinux.before*
    -rwx------ 1 mina86 mina86 230614861 Jun 17 14:36 vmlinux.after*

1265 bytes reduction.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
