Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3ILPG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:06:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48671 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3ILPGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:06:55 -0400
Date: Thu, 12 Sep 2013 17:06:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: airlied@linux.ie
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [BUG] completely bonkers use of set_need_resched + VM_FAULT_NOPAGE
Message-ID: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

So I'm poking around the preemption code and stumbled upon:

drivers/gpu/drm/i915/i915_gem.c:                set_need_resched();
drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
drivers/gpu/drm/udl/udl_gem.c:          set_need_resched();

All these sites basically do:

  while (!trylock())
  	yield();

which is a horrible and broken locking pattern. 

Firstly its deadlock prone, suppose the faulting process is a FIFOn+1
task that preempted the lock holder at FIFOn.

Secondly the implementation is worse than usual by abusing
VM_FAULT_NOPAGE, which is supposed to install a PTE so that the fault
doesn't retry, but you're using it as a get out of fault path. And
you're using set_need_resched() which is not something a driver should
_ever_ touch.

Now I'm going to take away set_need_resched() -- and while you can
'reimplement' it using set_thread_flag() you're not going to do that
because it will be broken due to changes to the preempt code.

So please as to fix ASAP and don't allow anybody to trick you into
merging silly things like that again ;-)
