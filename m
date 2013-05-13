Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3EMH1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:27:19 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:52516 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3EMH1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:27:18 -0400
MIME-Version: 1.0
In-Reply-To: <e3016dd4-99f5-4d32-a802-d4d03bcf470f@email.android.com>
References: <1368422091-959-1-git-send-email-ice799@gmail.com> <e3016dd4-99f5-4d32-a802-d4d03bcf470f@email.android.com>
From: Joe Damato <ice799@gmail.com>
Date: Mon, 13 May 2013 00:26:47 -0700
Message-ID: <CADk91pOUjhoh-6Wp2LtfX9T9vzAP49HvtayDrTG6=iDUN7++og@mail.gmail.com>
Subject: Re: [PATCH] x86: Reduce duplicated code in the x86_64 context switch path.
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 11:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> This is a net addition in code, and send to only make it harder to understand what is happening.  As such I don't think this is a good idea.

OK, I tweaked it slightly to break even on lines of code sent a v2. I
do think it would be nice to remove the duplicated code and (IMHO) it
makes __switch_to easier to read.

> Joe Damato <ice799@gmail.com> wrote:
>
>>Signed-off-by: Joe Damato <ice799@gmail.com>
>>---
>> arch/x86/include/asm/switch_to.h |   30 ++++++++++++++++++++++++++++++
>> arch/x86/kernel/process_64.c     |   29 ++---------------------------
>> 2 files changed, 32 insertions(+), 27 deletions(-)
>>
>>diff --git a/arch/x86/include/asm/switch_to.h
>>b/arch/x86/include/asm/switch_to.h
>>index 4ec45b3..a322cc6 100644
>>--- a/arch/x86/include/asm/switch_to.h
>>+++ b/arch/x86/include/asm/switch_to.h
>>@@ -124,6 +124,36 @@ do {                                                                      \
>>              __switch_canary_iparam                                     \
>>            : "memory", "cc" __EXTRA_CLOBBER)
>>
>>+#define loadsegment_fs(fs, index)                                       \
>>+      loadsegment(fs, index)
>>+
>>+#define loadsegment_gs(gs, index)                                       \
>>+      load_gs_index(index)
>>+
>>+#define switch_segment(prev, next, index, seg, msr)                          \
>>+      do {                                                                   \
>>+              /*                                                             \
>>+               * Segment register != 0 always requires a reload.  Also       \
>>+               * reload when it has changed.  When prev process used 64bit   \
>>+               * base always reload to avoid an information leak.            \
>>+               */                                                            \
>>+              if (unlikely(index | next->index | prev->seg)) {               \
>>+                      loadsegment_##seg(seg, next->index);                   \
>>+                      /*                                                     \
>>+                       * Check if the user used a selector != 0; if yes      \
>>+                       *  clear 64bit base, since overloaded base is always  \
>>+                       *  mapped to the Null selector                        \
>>+                       */                                                    \
>>+                      if (index)                                             \
>>+                        prev->seg = 0;                                       \
>>+              }                                                              \
>>+                                                                             \
>>+              /* when next process has a 64bit base use it */                \
>>+              if (next->seg)                                                 \
>>+                wrmsrl(msr, next->seg);                                      \
>>+              prev->index = index;                                           \
>>+      } while (0)
>>+
>> #endif /* CONFIG_X86_32 */
>>
>> #endif /* _ASM_X86_SWITCH_TO_H */
>>diff --git a/arch/x86/kernel/process_64.c
>>b/arch/x86/kernel/process_64.c
>>index 355ae06..f41d026 100644
>>--- a/arch/x86/kernel/process_64.c
>>+++ b/arch/x86/kernel/process_64.c
>>@@ -318,34 +318,9 @@ __switch_to(struct task_struct *prev_p, struct
>>task_struct *next_p)
>>
>>       /*
>>        * Switch FS and GS.
>>-       *
>>-       * Segment register != 0 always requires a reload.  Also
>>-       * reload when it has changed.  When prev process used 64bit
>>-       * base always reload to avoid an information leak.
>>        */
>>-      if (unlikely(fsindex | next->fsindex | prev->fs)) {
>>-              loadsegment(fs, next->fsindex);
>>-              /*
>>-               * Check if the user used a selector != 0; if yes
>>-               *  clear 64bit base, since overloaded base is always
>>-               *  mapped to the Null selector
>>-               */
>>-              if (fsindex)
>>-                      prev->fs = 0;
>>-      }
>>-      /* when next process has a 64bit base use it */
>>-      if (next->fs)
>>-              wrmsrl(MSR_FS_BASE, next->fs);
>>-      prev->fsindex = fsindex;
>>-
>>-      if (unlikely(gsindex | next->gsindex | prev->gs)) {
>>-              load_gs_index(next->gsindex);
>>-              if (gsindex)
>>-                      prev->gs = 0;
>>-      }
>>-      if (next->gs)
>>-              wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
>>-      prev->gsindex = gsindex;
>>+      switch_segment(prev, next, fsindex, fs, MSR_FS_BASE);
>>+      switch_segment(prev, next, gsindex, gs, MSR_KERNEL_GS_BASE);
>>
>>       switch_fpu_finish(next_p, fpu);
>>
>
> --
> Sent from my mobile phone. Please excuse brevity and lack of formatting.
