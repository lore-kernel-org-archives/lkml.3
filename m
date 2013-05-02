Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355Ab3EBWVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 18:21:21 -0400
Received: from shelob.surriel.com ([74.92.59.67]:34221 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab3EBWVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 18:21:20 -0400
Message-ID: <5182E667.1000603@surriel.com>
Date: Thu, 02 May 2013 18:19:19 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: question about lazy FPU restore
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh,

I have a question about the lazy fpu restore code in
switch_fpu_prepare.  Specifically, about the case where
the old task did not use the FPU, and the new task's
FPU state is still in the cpu.

         } else {
                 old->fpu_counter = 0;
                 old->thread.fpu.last_cpu = ~0;
                 if (fpu.preload) {
                         new->fpu_counter++;
                         if (!use_eager_fpu() && fpu_lazy_restore(new, cpu))
                                 fpu.preload = 0;
                         else
                                 prefetch(new->thread.fpu.state);
                         __thread_fpu_begin(new);
                 }
         }

In this branch, we call fpu_lazy_restore, which
confirms that the CPU still has the new task's state
in it.

However, if we are in eager fpu mode, we still end up
calling restore_fpu_checking from switch_fpu_finish,
even if the new task's FPU state is still resident in
the CPU.

Is there a particular reason we do this?

Would it be possible to always set fpu.preload = 0,
call clts, and __thread_set_has_fpu if fpu_lazy_restore
returns true?

That would allow us to skip the loading of FPU state
when re-entering a process that went briefly idle, before
getting something else to do, a common occurrance in
message passing workloads.
