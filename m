Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbaGWUQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:16:17 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:40786 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaGWUQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:16:15 -0400
Message-ID: <53D0180B.40709@gmail.com>
Date: Wed, 23 Jul 2014 16:16:11 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
CC: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/16] rcu: Remove redundant check for online cpu
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com> <1406092194-13004-10-git-send-email-bobby.prani@gmail.com> <20140723122112.GJ11241@linux.vnet.ibm.com> <CAJhHMCAoLQPnJYCeqftXwZb6D4ECuJb4g04b4OO5BLf6iC1ENw@mail.gmail.com> <20140723135024.GR11241@linux.vnet.ibm.com> <CAJhHMCAZ__1xkEou44iux=Z6v6NAKPrTvWob6tqorm23nNygOA@mail.gmail.com> <20140723142314.GV11241@linux.vnet.ibm.com> <CAJhHMCA4Fdd4JbtKdNGABFYRBCqaLukLbydLAFA-3RiZXaTngA@mail.gmail.com> <20140723153018.GY11241@linux.vnet.ibm.com> <CAJhHMCBDZyHYCo01T421f+No0ZBWfjsUXijg+MT1A2U621izpA@mail.gmail.com> <20140723191542.GA9398@linux.vnet.ibm.com>
In-Reply-To: <20140723191542.GA9398@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 3:15 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>> > If you change the "awake" to something like "am_online", I could get
>> > behind this one.
>>
>> OK! I will submit that in the next series(with the zalloc check).
>
> You caught me at a weak moment...  This change just adds an extra
> line of code and doesn't really help anything.
>
> So please leave this one out.
>

<resending as the assembly was garbled>

It adds an extra line of code and generates better assembly code. Last
try to convince you before I give up :-)

Size:
        text    data     bss     dec     hex filename
before  30664    7844      32   38540    968c kernel/rcu/tree.o
after   30648    7844      32   38524    967c kernel/rcu/tree.o

Assembly:

Before:

	if (!rcu_is_watching() && cpu_online(smp_processor_id()))
    26d3:	83 e2 01             	and    $0x1,%edx
    26d6:	75 1f                	jne    26f7 <__call_rcu+0x1c7>
    26d8:	65 8b 14 25 00 00 00 	mov    %gs:0x0,%edx
    26df:	00 
			26dc: R_X86_64_32S	cpu_number
    26e0:	48 8b 0d 00 00 00 00 	mov    0x0(%rip),%rcx        # 26e7 <__call_rcu+0x1b7>
			26e3: R_X86_64_PC32	cpu_online_mask-0x4
    26e7:	89 d2                	mov    %edx,%edx
    26e9:	48 0f a3 11          	bt     %rdx,(%rcx)
    26ed:	19 d2                	sbb    %edx,%edx
    26ef:	85 d2                	test   %edx,%edx
    26f1:	0f 85 29 02 00 00    	jne    2920 <__call_rcu+0x3f0>
		invoke_rcu_core();

	/* If interrupts were disabled or CPU offline, don't invoke RCU core. */
	if (irqs_disabled_flags(flags) || cpu_is_offline(smp_processor_id()))
    26f7:	48 f7 45 d0 00 02 00 	testq  $0x200,-0x30(%rbp)
    26fe:	00 
    26ff:	0f 84 e6 fe ff ff    	je     25eb <__call_rcu+0xbb>
    2705:	65 8b 14 25 00 00 00 	mov    %gs:0x0,%edx
    270c:	00 
			2709: R_X86_64_32S	cpu_number
    270d:	48 8b 0d 00 00 00 00 	mov    0x0(%rip),%rcx        # 2714 <__call_rcu+0x1e4>
			2710: R_X86_64_PC32	cpu_online_mask-0x4
    2714:	89 d2                	mov    %edx,%edx
    2716:	48 0f a3 11          	bt     %rdx,(%rcx)
    271a:	19 d2                	sbb    %edx,%edx
    271c:	85 d2                	test   %edx,%edx
    271e:	0f 84 c7 fe ff ff    	je     25eb <__call_rcu+0xbb>

After:

	bool cpu_up = cpu_online(smp_processor_id());
    26c1:	65 8b 14 25 00 00 00 	mov    %gs:0x0,%edx
    26c8:	00 
			26c5: R_X86_64_32S	cpu_number
    26c9:	48 8b 0d 00 00 00 00 	mov    0x0(%rip),%rcx        # 26d0 <__call_rcu+0x1a0>
			26cc: R_X86_64_PC32	cpu_online_mask-0x4
    26d0:	89 d2                	mov    %edx,%edx
    26d2:	48 0f a3 11          	bt     %rdx,(%rcx)
    26d6:	19 d2                	sbb    %edx,%edx
    26d8:	85 d2                	test   %edx,%edx
    26da:	41 0f 95 c4          	setne  %r12b

	if (!rcu_is_watching() && cpu_up)
    26f0:	83 e2 01             	and    $0x1,%edx
    26f3:	75 09                	jne    26fe <__call_rcu+0x1ce>
    26f5:	45 84 e4             	test   %r12b,%r12b
    26f8:	0f 85 12 02 00 00    	jne    2910 <__call_rcu+0x3e0>
		invoke_rcu_core();

	/* If interrupts were disabled or CPU offline, don't invoke RCU core. */
	if (irqs_disabled_flags(flags) || !cpu_up)
    26fe:	48 f7 45 d0 00 02 00 	testq  $0x200,-0x30(%rbp)
    2705:	00 
    2706:	0f 84 df fe ff ff    	je     25eb <__call_rcu+0xbb>
    270c:	45 84 e4             	test   %r12b,%r12b
    270f:	0f 84 d6 fe ff ff    	je     25eb <__call_rcu+0xbb>

-- 
Pranith
