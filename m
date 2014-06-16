Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbaFPSV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:21:26 -0400
Received: from mout.gmx.net ([212.227.17.22]:61254 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629AbaFPSVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:21:24 -0400
Message-ID: <539F35A0.2050002@gmx.de>
Date: Mon, 16 Jun 2014 20:21:20 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Eric Paris <eparis@redhat.com>, Richard Weinberger <richard@nod.at>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com> <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com> <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com> <539F2B2D.6050105@gmx.de> <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com> <539F3077.7040005@gmx.de> <CALCETrUUC6g_y4nJkSYo7MrKB8ehyXgnnuBHxGCDrq1d4zp2BQ@mail.gmail.com>
In-Reply-To: <CALCETrUUC6g_y4nJkSYo7MrKB8ehyXgnnuBHxGCDrq1d4zp2BQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:rUtht54uM6fhJ59pwhe6LUYG0yDtM+Erv8t22/07J9/JabTfkl5
 qGySnEznt0gSNDE7L2iMYuVm04j6a3OpSlraFolWlRv64/FZ2YzlZnTRGsrRLJzlm4UHbpj
 SM8Pq0AjxCIiAy1oTplBsAdQ3+Hio4Vj7NZsx6pggix/Vqj937dqZw6FvZEsN1MOozSSazw
 DJ7D0HSJEK5mcHg9+JYVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 08:15 PM, Andy Lutomirski wrote:
> On Mon, Jun 16, 2014 at 10:59 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>> On 06/16/2014 07:50 PM, Andy Lutomirski wrote:
>>> cc: eparis.  This might be a new audit bug.
>>>
>>> On Mon, Jun 16, 2014 at 10:36 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>>> On 06/16/2014 07:32 PM, Andy Lutomirski wrote:
>>>>> On Mon, Jun 16, 2014 at 10:29 AM, Richard Weinberger <richard@nod.at> wrote:
>>>>>> Am 16.06.2014 19:25, schrieb Andy Lutomirski:
>>>>>>> On Mon, Jun 16, 2014 at 10:21 AM, Richard Weinberger
>>>>>>> <richard.weinberger@gmail.com> wrote:
>>>>>>>> On Mon, Jun 16, 2014 at 6:33 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>>>>>>>> $ cat syscall.c
>>>>>>>>> #include <unistd.h>
>>>>>>>>> #include <sys/syscall.h>
>>>>>>>>> int main(){return syscall(1000)!=-1;}
>>>>>>>
>>>>>>> What architecture are you building for?  On i386 and x86_64, 1000
>>>>>>> shouldn't be big enough to trigger this.
>>>>>>
>>>>>> Toralf, is this an UML kernel?
>>>>>>
>>>>>
>>>>> I'm also interested in the userspace architecture.  If it's x32
>>>>> userspace, then I'm not surprised that there's a problem.
>>>>
>>>> It is a x86 system (ThinkPad T420) - not x32.
>>>
>>> I don't think this is CVE-2014-3917.  It looks like you're hitting this BUG:
>>>
>>> BUG_ON(context->in_syscall || context->name_count);
>>>
>>> Can you send the output of:
>>>
>>> auditctl -l [run as root]
>>>
>>> and
>>>
>>> dmesg |grep audit
>>>
>>> Are you using ptrace or anything like that (e.g. strace) when you
>>> trigger this?  Are you using a funny glibc version?  Do you have
>>> selinux or something like that enabled?
>>>
>>> --Andy
>>>
>> n22 ~ # auditctl -l
>> LIST_RULES: exit,never arch=1073741827 (0x40000003) syscall=read,write,open,close,brk,fcntl,dup2,mmap,munmap,stat,fstat,nanosleep,rt_sigaction
>>
>>
>> no ptrace/strace/SELinux, this is a stable x86 Gentoo Linux, glibc is 2.17, unstable are just KDE + Co.
>>
>> (@Richard: no. it is not an UML guest, I just stumbled over this while I tried to upgrade an unstable ~x86 Gentoo UML image using chroot)
>>
>> The trigger is just given by that C one-liner and kernel 3.15 (erm, I did not checked, if 3.14.x hit its too)
> 
> At the very least, it looks like sysret_audit can result in invoking
> the audit exit hook twice. That's not what's causing this, but it
> still looks fishy.
> 
> Toralf, can you run your test program under strace, post the output,
> and see whether it still crashes?  There's some chance that strace
> will "fix" it, since strace causes a different set of hooks to run.
>
tfoerste@n22 ~/tmp $ cat syscall.c
#include <unistd.h>
#include <sys/syscall.h>
int main(){return syscall(1000)!=-1;}

tfoerste@n22 ~/tmp $ gcc strcmp.c && strace ./a.out
execve("./a.out", ["./a.out"], [/* 75 vars */]) = 0
brk(0)                                  = 0x85f3000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7750000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=164108, ...}) = 0
mmap2(NULL, 164108, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7727000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0 \316\1\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1750448, ...}) = 0
mmap2(NULL, 1759980, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7579000
mmap2(0xb7721000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1a8000) = 0xb7721000
mmap2(0xb7724000, 10988, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7724000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7578000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb75786c0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7721000, 8192, PROT_READ)   = 0
mprotect(0x8049000, 4096, PROT_READ)    = 0
mprotect(0xb7774000, 4096, PROT_READ)   = 0
munmap(0xb7727000, 164108)              = 0
fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 5), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb774f000
write(1, "1\n", 21
)                      = 2
exit_group(2)                           = ?
+++ exited with 2 +++


> Any ideas, Eric?
> 
> --Andy
> 


-- 
Toralf

