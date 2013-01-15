Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3AOKai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:30:38 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:39830 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3AOKah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:30:37 -0500
Message-ID: <50F52FC8.4000701@openvz.org>
Date: Tue, 15 Jan 2013 14:30:32 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121123 Firefox/10.0.11 Iceape/2.7.11
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: RCU: non-atomic assignment to long/pointer variables in gcc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/atomic_ops.txt (182dd4b277177e8465ad11cd9f85f282946b5578)
says that pointers, longs, ints, and chars are stored and loaded atomically.

But GCC actually may split assignment to 'long' variable into two instructions.
see example in http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55981

GCC also splits assignments to 'volatile' variables and this is actually a bug in gcc.

volatile unsigned long y;

y = 0x100000001ul;

   400728:	c7 05 66 06 20 00 01 	movl   $0x1,0x200666(%rip)        # 600d98 <y>
   40072f:	00 00 00
   400732:	c7 05 60 06 20 00 01 	movl   $0x1,0x200660(%rip)        # 600d9c <y+0x4>
   400739:	00 00 00

fortunately for y = 0; it generates this:

   40071d:	48 c7 05 70 06 20 00 	movq   $0x0,0x200670(%rip)        # 600d98 <y>
   400724:	00 00 00 00

Thus NULL is safe, but constant ERR_PTR may be dangerous.

Probably rcu_assign_pointer() should use ACCESS_ONCE() around lvalue, because
splitting assignment for non-volatile variable seems like completely valid,
but this may help only after fixing that bug in GCC.
