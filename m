Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaGJPva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:51:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50744 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbaGJPv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:51:28 -0400
Date: Thu, 10 Jul 2014 17:51:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 2/6] x86-mce: Modify CMCI storm exit to reenable instead
 of rediscover banks.
Message-ID: <20140710155119.GJ2970@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-3-git-send-email-hskinnemoen@google.com>
 <3908561D78D1C84285E8C5FCA982C28F328573E4@ORSMSX114.amr.corp.intel.com>
 <CAFQmdRaZ-wNTFzm_CAvuCWrNGDuWWdYRzADXjmz27XgsFUgNaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFQmdRaZ-wNTFzm_CAvuCWrNGDuWWdYRzADXjmz27XgsFUgNaA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:34:39PM -0700, Havard Skinnemoen wrote:
> On Wed, Jul 9, 2014 at 1:20 PM, Luck, Tony <tony.luck@intel.com> wrote:
> >> The CMCI storm handler previously called cmci_reenable() when exiting a
> >> CMCI storm. However, when entering a CMCI storm the bank ownership was
> >> not relinquished by the affected CPUs. The CMCIs were only disabled via
> >> cmci_storm_disable_banks(). The handler was updated to instead call a
> >> new function, cmci_storm_enable_banks(), to reenable CMCI on the already
> >> owned banks instead of rediscovering CMCI banks (which were still owned
> >> but disabled).
> >
> > Won't this cause problems if we online a cpu during the storm. We will
> > re-run the discovery algorithm and some other cpu that shares the bank
> > will see MCi_CTL2{30} is zero and claim ownership.
> 
> Yes, I think you're right. We didn't test this with CPU hotplugging.
> 
> I'm at loss about how to fix it though. We need the CMCI bits to
> detect shared banks, but they're not reflecting the actual state of
> things at that point. If the CPU gives up ownership of the banks, then
> we might just see the storm move from CPU to CPU, right?
> 
> We could keep a separate bitmask somewhere to indicate ownership, but
> even if we can see that the bank is shared with some other CPU, we
> don't know if it will be shared with a new CPU which we've never seen
> before...
> 
> Perhaps we need to temporarily disable the storm handling when we're
> bringing up a new CPU?

Looking at this more, maybe cmci_storm_disable_banks() was a bad idea
after all. There's __cmci_disable_bank() which properly drops ownership
after having disabled CMCI.

Maybe we should kill cmci_storm_disable_banks() and do
__cmci_disable_bank by iterating over them all...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
