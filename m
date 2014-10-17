Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaJQAek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 20:34:40 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:54480 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaJQAej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 20:34:39 -0400
Date: Fri, 17 Oct 2014 02:34:30 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: getaddrinfo slowdown in 3.17.1, due to getifaddrs
Message-ID: <20141017003430.GB29584@sesse.net>
References: <20141017002132.GA29584@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141017002132.GA29584@sesse.net>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 02:21:32AM +0200, Steinar H. Gunderson wrote:
> Hi,
> 
> We recently upgraded a machine from 3.14.5 to 3.17.1, and a Perl script we're
> running to poll SNMP suddenly needed ten times as much time to complete.

e341694e3eb57fcda9f1adc7bfea42fe080d8d7a looks like it might cause something
like this (it certainly added the synchronize_net() call). Cc-ing people on 
that commit; quoting the entire rest of the message for reference.

> ps shows that it keeps being in state D (ie., I/O), and strace with -ttT
> shows this curious pattern:
> 
> 02:11:33.106973 socket(PF_NETLINK, SOCK_RAW, 0) = 42 <0.000013>
> 02:11:33.107013 bind(42, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 0 <0.000010>
> 02:11:33.107051 getsockname(42, {sa_family=AF_NETLINK, pid=1128, groups=00000000}, [12]) = 0 <0.000008>
> 02:11:33.107094 sendto(42, "\24\0\0\0\26\0\1\3\265^@T\0\0\0\0\0\0\0\0", 20, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 20 <0.000015>
> 02:11:33.107146 recvmsg(42, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"L\0\0\0\24\0\2\0\265^@Th\4\0\0\2\10\200\376\1\0\0\0\10\0\1\0\177\0\0\1"..., 4096}], msg_controllen=0, msg_flags=0}, 0) = 332 <0.000016>
> 02:11:33.107208 recvmsg(42, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"H\0\0\0\24\0\2\0\265^@Th\4\0\0\n\200\200\376\1\0\0\0\24\0\1\0\0\0\0\0"..., 4096}], msg_controllen=0, msg_flags=0}, 0) = 936 <0.000010>
> 02:11:33.107262 recvmsg(42, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\24\0\0\0\3\0\2\0\265^@Th\4\0\0\0\0\0\0\1\0\0\0\24\0\1\0\0\0\0\0"..., 4096}], msg_controllen=0, msg_flags=0}, 0) = 20 <0.000009>
> 02:11:33.107313 close(42)               = 0 <0.057092>
> 02:11:33.164529 open("/etc/hosts", O_RDONLY|O_CLOEXEC) = 42 <0.000080>
> <more stuff...>
> 
> Debugging with gdb indicates that this is from getaddrinfo calls, which the
> program (for, well, Perl reasons) uses as part of DNS reverse lookups.
> getaddrinfo wants to look at the list of interfaces on the system
> (__check_pf in glibc), which calls out to netlink via getifaddrs.
> Note specifically the call to close(), which takes 57 ms to complete.
> 
> This doesn't happen on every single getaddrinfo call, but more like 50% of
> them. I've tried on another machine, running 3.16.3, and we don't see
> anything like it.
> 
> I've distilled it down to this Perl script:
> 
>   #! /usr/bin/perl
>   use strict;
>   use warnings;
>   use Socket::GetAddrInfo;
>   
>   for my $i (1..1000) {
>   	my ($err, @res) = Socket::GetAddrInfo::getaddrinfo("127.0.0.1", undef, { flags => Socket::GetAddrInfo::AI_NUMERICHOST });
>   }
> 
> On my 3.16.3 machine, this completes in 26 ms. On the 3.17.1 machine:
> 65 _seconds_! According to the stack, this is what it's doing:
> 
> [<ffffffff810766b7>] wait_rcu_gp+0x48/0x4f
> [<ffffffff81078be5>] synchronize_sched+0x29/0x2b
> [<ffffffff813aacdb>] synchronize_net+0x19/0x1b
> [<ffffffff813d313e>] netlink_release+0x25b/0x2b7
> [<ffffffff8139af07>] sock_release+0x1a/0x79
> [<ffffffff8139b1f4>] sock_close+0xd/0x11
> [<ffffffff8111feca>] __fput+0xdf/0x184
> [<ffffffff8111ff9f>] ____fput+0x9/0xb
> [<ffffffff81051610>] task_work_run+0x7c/0x94
> [<ffffffff810026b2>] do_notify_resume+0x55/0x66
> [<ffffffff8146feda>] int_signal+0x12/0x17
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> strace indicates it starts off nicely, then goes completely off:
> 
> cirkus:~> time strace -e close -ttT perl test.pl 
> 02:20:39.292060 close(3)                = 0 <0.000041>
> 02:20:39.292407 close(3)                = 0 <0.000037>
> 02:20:39.292660 close(3)                = 0 <0.000010>
> 02:20:39.292883 close(3)                = 0 <0.000009>
> 02:20:39.293100 close(3)                = 0 <0.000009>
> [some more fast ones...]
> 02:20:39.311421 close(4)                = 0 <0.000009>
> 02:20:39.311927 close(3)                = 0 <0.000011>
> 02:20:39.312188 close(3)                = 0 <0.072224>
> 02:20:39.384979 close(3)                = 0 <0.059658>
> 02:20:39.445378 close(3)                = 0 <0.048205>
> 02:20:39.494213 close(3)                = 0 <0.060195>
> ^C
> 
> Is there a way to fix this? Somehow I doubt we're the only ones calling
> getaddrinfo in this way. :-)
> 
> /* Steinar */
-- 
Homepage: http://www.sesse.net/
