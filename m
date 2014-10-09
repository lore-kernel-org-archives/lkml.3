Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbaJIIcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:32:04 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:44061 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJIIbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:31:55 -0400
MIME-Version: 1.0
In-Reply-To: <20141008222722.GJ7996@ZenIV.linux.org.uk>
References: <1412760595-3935-1-git-send-email-lftan@altera.com>
	<1412760595-3935-5-git-send-email-lftan@altera.com>
	<20141008222722.GJ7996@ZenIV.linux.org.uk>
Date: Thu, 9 Oct 2014 16:31:53 +0800
X-Google-Sender-Auth: MSebu6777s8sNUBGQ5fUSxaZx_k
Message-ID: <CAFiDJ59LZgCeMyNYEv-gWcghBPMJTmKDoyXb9jstToQXjtscHQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/29] nios2: Exception handling
From: Ley Foon Tan <lftan@altera.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 6:27 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>> +Lsignal_return:
>> +     ANDI32  r1, r10, _TIF_SIGPENDING | _TIF_NOTIFY_RESUME
>> +     beq     r1, r0, restore_all
>> +     mov     r4, sp                  /* pt_regs */
>> +     SAVE_SWITCH_STACK
>> +     call    do_notify_resume
>> +     beq     r2, r0, no_work_pending
>> +     RESTORE_SWITCH_STACK
>> +     /* prepare restart syscall here without leaving kernel */
>> +     ldw     r2, PT_R2(sp)   /* reload syscall number in r2 */
>> +     ldw     r4, PT_R4(sp)   /* reload syscall arguments r4-r9 */
>> +     ldw     r5, PT_R5(sp)
>> +     ldw     r6, PT_R6(sp)
>> +     ldw     r7, PT_R7(sp)
>> +     ldw     r8, PT_R8(sp)
>> +     ldw     r9, PT_R9(sp)
>> +     br      local_restart   /* restart syscall */
>> +
>> +no_work_pending:
>> +     RESTORE_SWITCH_STACK
>> +     br      restore_all
>
> Umm...  Branch to no_work_pending will be usuall taken.  How well does
> branch predictor on that processor cope with such things?
Nios2 have implemented dynamic branch prediction. Processor will use
current PC and previous history when lookup branch history table.
So this mean the same location branch will mostly predict correctly if
the branch is always taken or always not taken.


> Another thing is the point Richard made - multiple pending signals need to be
> handled.  IOW, that should be a branch to ret_from_exception, not restore_all.
Okay, will update this to branch to ret_from_exception.

Thanks for reviewing.

Regards
Ley Foon
