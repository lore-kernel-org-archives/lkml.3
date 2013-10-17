Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3JQKR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:17:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab3JQKRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:17:24 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 0/7] static_key: fix timer bugs & change api (a bit)
Date: Thu, 17 Oct 2013 12:10:23 +0200
Message-Id: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While fixing a simple crash on kvm module unload

1: rate_limit timer can fire after we free its key's module memory.

I noticed other deficiencies in jump_label/static_key code
(The most important is 4.)

2: jump_label_rate_limit() uses an initializator and thus cannot be used
   more than once, leaving no good way to change the timeout.

I have made the API easier on programmers: [1/7]
 * timer is automatically flushed on rmmod
 * jump_label_rate_limit() initializes only once
    - pretty hacky, but we cannot automatically initialize on
      kernel_init/insmod due to insufficient information and while I
      would love getting it through another section, it is probably
      better to do a useless check with this low-rate operation
    * we could flush the timer on change
    * 'init()' + 'set()' (+ 'exit()' ?) would be an alternative ...

3: schedule_delayed_work() does not queue the work if one is already
   pending, but atomic_inc(&key->enabled) is called anyway in
   static_key_slow_dec_deferred(), with the false belief it will be
   decreased when the timer fires.

Fixed in [2,3,4/7], by addition of static_key_slow_inc_deferred().

I'm still not happy with the final design: we don't want delayed
decrease, we just don't want change more that once a interval.
A good solution should immediately enable/disable if interval since last
change has already passed.
I'll generalize ratelimit (probably) to suit our needs, but it won't be
quick, so we could use this in the meantime.

4: static_key_{true,false}() is a horrible name for a representation of
   a boolean and its use is unnecessarily restricted

In patch [5/7], static keys are transformed so one key can be hinted
both ways. This is done by bloating the jump_entry.

Patch [6/7] changes the name to static_key_{likely,unlikely}() because
we no longer have incompatible behaviour.

5: jump_label_init() is called too late

I've seen some patches that debugged the case where we use static_keys
before patching.
Moving jump_label_init() near the top of start_kernel() should help us
avoid it. [7/7]

n: jump_label and static_key api should be split;
   static_key_deferred isn't complete api, or subclass of static_key;
   some functions should be renamed, some removed;
   ...

There are already some patches prepared, but the diffstat isn't pretty,
so I'm keeping them to ripen.

Applied on top of torvalds-3.12-rc5.

Radim Krčmář (7):
  static_key: flush rate limit timer on rmmod
  static_key: add static_key_slow_inc_deferred()
  static_key: keep deferred enabled counter debt
  static_key: use static_key_slow_inc_deferred()
  jump_label: relax branch hinting restrictions
  static_key: use {,un}likely instead of {tru,fals}e
  init: execute jump_label_init() earlier

 Documentation/static-keys.txt         | 39 ++++++++------------
 arch/arm/include/asm/jump_label.h     | 19 +++++++---
 arch/arm/kernel/jump_label.c          |  2 +-
 arch/mips/include/asm/jump_label.h    | 19 +++++++---
 arch/mips/kernel/jump_label.c         |  2 +-
 arch/powerpc/include/asm/jump_label.h | 19 +++++++---
 arch/powerpc/kernel/jump_label.c      |  2 +-
 arch/s390/include/asm/jump_label.h    | 19 +++++++---
 arch/s390/kernel/jump_label.c         |  2 +-
 arch/sparc/include/asm/jump_label.h   | 19 +++++++---
 arch/sparc/kernel/jump_label.c        |  2 +-
 arch/x86/include/asm/jump_label.h     | 19 +++++++---
 arch/x86/include/asm/spinlock.h       |  4 +--
 arch/x86/kernel/jump_label.c          | 32 +++--------------
 arch/x86/kvm/lapic.c                  |  7 ++--
 arch/x86/kvm/lapic.h                  |  6 ++--
 arch/x86/kvm/mmu_audit.c              |  2 +-
 include/linux/context_tracking.h      | 10 +++---
 include/linux/jump_label.h            | 66 +++++++++++++---------------------
 include/linux/jump_label_ratelimit.h  |  6 ++++
 include/linux/memcontrol.h            |  2 +-
 include/linux/netfilter.h             |  2 +-
 include/linux/perf_event.h            |  6 ++--
 include/linux/tick.h                  |  2 +-
 include/linux/tracepoint.h            |  4 +--
 include/linux/vtime.h                 |  2 +-
 include/net/sock.h                    |  4 +--
 init/main.c                           |  6 +++-
 kernel/context_tracking.c             |  4 +--
 kernel/events/core.c                  |  6 ++--
 kernel/jump_label.c                   | 68 ++++++++++++++++++++---------------
 kernel/sched/core.c                   |  4 ++-
 kernel/sched/cputime.c                |  2 +-
 kernel/sched/fair.c                   |  2 +-
 kernel/sched/sched.h                  |  4 +--
 lib/crc-t10dif.c                      |  2 +-
 net/core/dev.c                        |  8 ++---
 net/ipv4/udp.c                        |  4 +--
 net/ipv6/udp.c                        |  4 +--
 39 files changed, 231 insertions(+), 201 deletions(-)

-- 
1.8.3.1
