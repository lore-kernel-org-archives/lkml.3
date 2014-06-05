Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaFEQnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:43:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50424 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaFEQna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:43:30 -0400
Message-ID: <53909E1B.3020503@zytor.com>
Date: Thu, 05 Jun 2014 09:43:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Borislav Petkov <bp@alien8.de>, Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
References: <20140604224920.GB4126@pd.tnic> <538FB775.8070405@amacapital.net> <20140605071805.GA16647@pd.tnic> <CAL01qpuj6jvH4XLvhHAszbqmSPXfW=VOdv+TqMwBuDnArL=ofw@mail.gmail.com> <20140605090206.GA16642@pd.tnic> <CALCETrU2TZhxOZyCvBd1nLDiU4ceiSx_Sd2bsDUCX5arOFidBg@mail.gmail.com> <20140605155307.GD16642@pd.tnic> <CALCETrVqqgExhuAYawh_7tc8-Nm8GGiMxmtw25mLFoxru-odZg@mail.gmail.com> <20140605160842.GE16642@pd.tnic> <CALCETrUors-39hUxS9Bg-dh+DzMcmPOs=6t998sbCVjqXYgyug@mail.gmail.com> <20140605161834.GF16642@pd.tnic> <53909B50.50407@zytor.com> <CALCETrVhN36asNbx40BTK8TU3eCLq36-hh-i1MKMw=iL=5_m0A@mail.gmail.com>
In-Reply-To: <CALCETrVhN36asNbx40BTK8TU3eCLq36-hh-i1MKMw=iL=5_m0A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 09:35 AM, Andy Lutomirski wrote:
>>
>> The bottom line is that we can't call EFI from a context where we can't
>> use the FPU.  Or specifically, we can't then resume execution.  If all
>> we're doing is stashing away some data before dying, well, then, by all
>> means - but we need to make sure that is what actually happens.
> 
> I bet we have to be extra careful about EFI: I imagine that, if we
> take an NMI or MCE while in EFI code, another call into EFI is a
> terrible idea, which might be a good reason to have the EFI code track
> its own context and prevent nesting.
> 

I strongly suspect we also want to make sure that we don't ever let more
than one CPU into EFI context.  This would also make it possible to have
a dedicated XSAVE buffer for EFI.

Now, the tricky part: what do we do if another CPU is already in EFI and
we want to do something.

> 
> I suppose it's a question of how valuable making a change like this
> would be (two per-thread xstate areas plus a bunch per cpu, say).  I
> doubt that the memory usage matters much, but writing and maintaining
> it will be a mild PITA.  Maybe no worse than the current stuff.
> 
> What are the major users?  If it worked really well, we could enable
> SSE for all kernel code, but at least all the crypto stuff would
> benefit a lot.
> 

No, enabling SSE for all kernel code would force us to context-switch on
any kernel entry or exit, which is way too expensive for what it gains.
 However, perhaps the realtime people will be happier if we don't have
to stop preemption.

	-hpa


