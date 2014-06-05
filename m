Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaFEQPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:15:14 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:49820 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaFEQPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:15:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140605160842.GE16642@pd.tnic>
References: <tip-baa916f39b50ad91661534652110df40396acda0@git.kernel.org>
 <538F9AFA.5050806@zytor.com> <20140604224920.GB4126@pd.tnic>
 <538FB775.8070405@amacapital.net> <20140605071805.GA16647@pd.tnic>
 <CAL01qpuj6jvH4XLvhHAszbqmSPXfW=VOdv+TqMwBuDnArL=ofw@mail.gmail.com>
 <20140605090206.GA16642@pd.tnic> <CALCETrU2TZhxOZyCvBd1nLDiU4ceiSx_Sd2bsDUCX5arOFidBg@mail.gmail.com>
 <20140605155307.GD16642@pd.tnic> <CALCETrVqqgExhuAYawh_7tc8-Nm8GGiMxmtw25mLFoxru-odZg@mail.gmail.com>
 <20140605160842.GE16642@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 5 Jun 2014 09:14:51 -0700
Message-ID: <CALCETrUors-39hUxS9Bg-dh+DzMcmPOs=6t998sbCVjqXYgyug@mail.gmail.com>
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state in
 irq ctxt
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 9:08 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jun 05, 2014 at 09:01:02AM -0700, Andy Lutomirski wrote:
>> NMI might be okay.  I haven't checked.
>
> Well, if efi decides to do FPU math and it happens in NMI, we will have
> to provide for proper contexts handling.
>
>> It has to change back, though.  Completely unrealistic and useless example:
>>
>> int ctxt = what_context_im_in();
>>
>> set_up_the_fpu(ctxt);
>>
>> // kprobe fires and changes the context
>> // kprobe does something
>
> And since we're being completely unrealistic, kprobe decides to use the
> fpu too and uses it...

Sure.  So it either needs to save and restore the state or to save it
and mark it for restore when the kprobe entry context is torn down.

>
>> // kprobe changes the context back
>>
>> use the FPU.  Life is good.
>>
>> put_back_the_fpu(ctxt);
>
> So you probably need some way of mapping preallocated, per-cpu FPU
> contexts to their users which can get and put them.
>
> It's a whole different question whether that makes sense though, at all
> or we simply remain conservative and don't do any efi in NMI context...

Is this NMI pstore thing done from any context that's supposed to be
recoverable?  It's always safe to use the FPU and then panic :)

Anyway, if we're just talking about EFI, there's an easier solution:
just preallocate a per-cpu FPU context for EFI and make the whole mess
be local to the EFI code.  For crypto, that's not so good.

--Andy
