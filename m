Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbbAMRSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:18:46 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:50247 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbbAMRSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:18:44 -0500
MIME-Version: 1.0
In-Reply-To: <20150113171134.GA27519@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
 <1421012793-30106-5-git-send-email-riel@redhat.com> <20150113171134.GA27519@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 13 Jan 2015 09:18:22 -0800
Message-ID: <CALCETrWuOeYYpwbfX3x56KZSV_1nC+r7GHRiYH=pt_xOuOVM2g@mail.gmail.com>
Subject: Re: [RFC PATCH 04/11] x86,fpu: defer FPU restore until return to userspace
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 9:11 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/11, riel@redhat.com wrote:
>>
>> Defer restoring the FPU state, if so desired, until the task returns to
>> userspace.
>
> And I have another concern.
>
> Afaocs with this patch the idle threads will run with TIF_LOAD_FPU set but
> without fpu.has_fpu.

Yuck.  IMO there are still too many possible states.

AFAICS the sensible states for a task are:

 - Task is current on some cpu and FPU is loaded into that cpu.
 - Task is current on some cpu and FPU is in memory.
 - Task is current on some cpu and FPU is loaded into a different cpu.
 - Task is not current and FPU is in memory.
 - Task is not current and FPU is loaded into some cpu.

Am I missing anything?  (In lazy mode, there are a few more involving CR0.TS.)

That's five states, plus an optional cpu number.  But we have tons of
state variable that can express all kinds of nonsense things.

If we asserted that we were in a sensible state and fixed the things
that exited the sensible states, maybe this would be easier to
understand and debug.

--Andy
