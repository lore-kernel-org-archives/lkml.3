Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaJIRfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:35:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41229 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaJIRfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:35:38 -0400
Date: Thu, 9 Oct 2014 19:35:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: slaoub@gmail.com, Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20141009173529.GC17647@pd.tnic>
References: <1412037578.21488.11.camel@debian>
 <20140930072553.GA4639@pd.tnic>
 <1412070991.16556.12.camel@cyc>
 <20140930100940.GD4639@pd.tnic>
 <1412138102.21488.20.camel@debian>
 <20141002131206.GA16452@pd.tnic>
 <CAOjmkp9qQiTbqU3NUhUDAoQAa8wAPJnE_qXbDuBKrA3ee1_APQ@mail.gmail.com>
 <5435B206.60402@amd.com>
 <20141008225750.GH16892@pd.tnic>
 <20141009165339.GA11360@arav-dinar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141009165339.GA11360@arav-dinar>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 11:53:39AM -0500, Aravind Gopalakrishnan wrote:
> How do you mean "last error"?
> The interrupt is only fired upon overflow..

And? Think about it, what is causing the overflow? A CE, right?

There was even a call to machine_check_poll() there which we removed,
but for another reason. In any case, you should have the error signature
in the MCA banks of the last error causing the overflow, right? This is
what I mean with last error.

However(!),...

> CE error if collected through polling gives proper decoding info. So,
> why should this be any different for the same CE error for which an
> interrupt is generated on crossing a threshold?

... we're currently using a special signature to signal the overflow
with the K8_MCE_THRESHOLD_BASE thing. You simply report a special bank
and this way you can tell userspace that this is an overflow error. I
think that was the reason behind the software-defined banks.

Now, we can also drop that and simply log a normal error but make sure
MASK_OVERFLOW_HI is passed onto userspace so that it can see that the
error is an overflow error. I.e., something like this:

        mce_setup(&m);
	// rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus); - not sure about this one - we're not looking at MCGSTATUS for CEs
        // rdmsrl(address, m.misc); - this MSR can be saved too as we're reading
	// the MISC register already.
        rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
        m.bank = bank;
        mce_log(&m);

so in the end it'll be something like this:

	mce_setup(&m);
	m.misc = (high << 32) | low;
	rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
	m.bank = bank;
        mce_log(&m);

so I'm still on the fence about what we want to do and am expecting
arguments. I like the last one more because it is simpler and tools
don't need to know about the software-defined banks.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
