Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaKLRZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:25:36 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:65247 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaKLRZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:25:35 -0500
MIME-Version: 1.0
In-Reply-To: <20141112172057.GA8303@redhat.com>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
 <1407998986-1834-5-git-send-email-gong.chen@linux.intel.com>
 <20141111114248.GD31490@pd.tnic> <20141112172057.GA8303@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Nov 2014 09:25:13 -0800
Message-ID: <CALCETrULGHnWhg2qj5Cr9L9neQ_qPE+83uSQny-kGoh7NH1cgQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] x86/mce: Simplify flow when handling recoverable
 memory errors
To: Oleg Nesterov <oleg@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, X86 ML <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 9:20 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Sorry, I am a bit confused...
>
> On 11/11, Borislav Petkov wrote:
>>
>> Roughly speaking, we want to be able to mark a task with the sign of
>> death and to kill it, if needed.
>
> "it" is current, yes?

This part I'm not sure about due to MCE broadcast.  "It" is current
for exactly one cpu that's in do_machine_check.

>
> So I agree with Andy, task_work_add() can work and you can also pass
> paddr/restartable to the handler.
>
> But,
>
>> The important part is *before* it
>> gets to run again.
>
> But it is already running? Perhaps you meant "before it returns to
> user-mode" ?
>

Right.  But killing it in the do_exit sense from do_machine_check is
currently impossible because do_machine_check runs on an IST stack.
With my patch, if do_machine_check sees user_mode_vm(regs) and
CONFIG_X86_64, then it will be running on the real task stack, so it
can enable interrupts, kill the task however it wants, etc.  This was
the original motivation for my patch.

--Andy
