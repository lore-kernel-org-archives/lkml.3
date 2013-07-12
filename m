Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965230Ab3GLRkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:40:13 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61304 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab3GLRkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:40:11 -0400
Message-ID: <51E03F76.3090607@gmail.com>
Date: Fri, 12 Jul 2013 11:40:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
References: <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de> <20130705160043.GF325@redhat.com> <20130706072408.GA14865@gmail.com> <20130710151324.GA11309@redhat.com> <20130710152015.GA757@x4> <20130710154029.GB11309@redhat.com> <20130712103117.GA14862@gmail.com> <51E0230C.9010509@intel.com> <20130712154521.GD1020@redhat.com> <51E038ED.7050600@gmail.com> <20130712171808.GD1537@redhat.com>
In-Reply-To: <20130712171808.GD1537@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/13 11:18 AM, Dave Jones wrote:
> On Fri, Jul 12, 2013 at 11:12:13AM -0600, David Ahern wrote:
>   > On 7/12/13 9:45 AM, Dave Jones wrote:
>   > > Here's a fun trick:
>   > >
>   > > trinity -c perf_event_open -C4 -q -l off
>   > >
>   > > Within about a minute, that brings any of my boxes to its knees.
>   > > The softlockup detector starts going nuts, and then the box wedges solid.
>   >
>   > I tried that in a VM running latest Linus tree. I see trinity children
>   > getting nuked regularly from oom.
>
> Weird. I'm curious what the backtrace looks like in those cases.
> Where is it trying to allocate memory ?
> (Though that isn't usually too helpful in most cases, but in absense of
>   anything else..)

(gdb) bt
#0  0x000000313b27f3e0 in malloc () from /lib64/libc.so.6
#1  0x0000000000404405 in _get_address 
(null_allowed=null_allowed@entry=1 '\001') at generic-sanitise.c:151
#2  0x00000000004044ca in get_address () at generic-sanitise.c:182
#3  0x00000000004052a0 in fill_arg (childno=<optimized out>, 
call=call@entry=298, argnum=argnum@entry=1) at generic-sanitise.c:415
#4  0x000000000040548d in generic_sanitise (childno=childno@entry=0) at 
generic-sanitise.c:615
#5  0x0000000000405620 in mkcall (childno=childno@entry=0) at syscall.c:131
#6  0x0000000000407d85 in child_process () at child.c:219
#7  0x00000000004073ad in fork_children () at main.c:103
#8  main_loop () at main.c:308
#9  do_main_loop () at main.c:342
#10 0x000000000040253a in main (argc=<optimized out>, argv=<optimized 
out>) at trinity.c:180


In _get_address, case 8 must be happening a lot and I don't see a free 
when that address comes from malloc. Perhaps all of the rand() calls are 
breaking down in the VM. If I change that case from malloc to something 
static - like page_rand - memory stays flat.

David
