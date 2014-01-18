Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaARGUo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 01:20:44 -0500
Received: from aurora.thatsmathematics.com ([162.209.10.89]:39080 "EHLO
	aurora.thatsmathematics.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbaARGUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 01:20:41 -0500
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jan 2014 01:20:41 EST
Date: Fri, 17 Jan 2014 23:15:17 -0700 (MST)
From: Nate Eldredge <nate@thatsmathematics.com>
X-X-Sender: nate@minerva.lan
To: linux-kernel@vger.kernel.org
cc: Maarten Baert <maarten-baert@hotmail.com>
Subject: math_state_restore and kernel_fpu_end disable interrupts?
Message-ID: <alpine.DEB.2.10.1401172242390.2906@minerva.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In trying to track down a bug (see below), I noticed that 
math_state_restore() in arch/x86/kernel/traps.c appears to unconditionally 
disable interrupts when called.  Is this intended behavior or a bug?

The bug in question is triggered by dumping core on an ecryptfs file 
system when aesni-intel is loaded.  (See 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1265841 for the 
original report.)  The symptom is that __find_get_block() gets called with 
interrupts disabled, causing a BUG().  I tried to find where interrupts 
were getting disabled and wound up in aes_set_key_common() in 
arch/x86/crypto/aesni-intel_glue.c.  It calls aesni_set_key(), and since 
that uses the FPU, it wraps it in kernel_fpu_begin()/kernel_fpu_end(). 
But kernel_fpu_end() calls math_state_restore() which disables interrupts. 
I've verified that interrupts are still enabled just before the call to 
kernel_fpu_end().

math_state_restore() does:

local_irq_enable();
init_fpu(tsk);
local_irq_disable();

with the result that interrupts are disabled when it finishes, even if 
they were enabled to begin with.  That looks strange to me; are we sure it 
shouldn't just save and restore the interrupt flag?  Or are we not 
supposed to call it with interrupts enabled?

Given the intimidating comment preceding math_state_restore() ("Don't 
touch unless you *really* know how it works"), it's entirely possible I am 
missing something...

Any suggestions appreciated.  Thanks!

-- 
Nate Eldredge
nate@thatsmathematics.com

