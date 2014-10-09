Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaJIQd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:33:26 -0400
Received: from mail-by2on0114.outbound.protection.outlook.com ([207.46.100.114]:35400
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751170AbaJIQdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:33:17 -0400
X-WSS-ID: 0ND6RB8-08-YNW-02
X-M-MSG: 
Date: Thu, 9 Oct 2014 11:53:39 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <slaoub@gmail.com>, Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20141009165339.GA11360@arav-dinar>
References: <20140929120546.GB6495@pd.tnic> <1412037578.21488.11.camel@debian>
 <20140930072553.GA4639@pd.tnic> <1412070991.16556.12.camel@cyc>
 <20140930100940.GD4639@pd.tnic> <1412138102.21488.20.camel@debian>
 <20141002131206.GA16452@pd.tnic>
 <CAOjmkp9qQiTbqU3NUhUDAoQAa8wAPJnE_qXbDuBKrA3ee1_APQ@mail.gmail.com>
 <5435B206.60402@amd.com> <20141008225750.GH16892@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141008225750.GH16892@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(2473001)(24454002)(164054003)(51704005)(97756001)(92726001)(31966008)(77096002)(50466002)(76482002)(120916001)(50986999)(83506001)(68736004)(85852003)(95666004)(84676001)(106466001)(97736003)(92566001)(33716001)(102836001)(33656002)(23726002)(105586002)(86362001)(110136001)(93886004)(47776003)(64706001)(87936001)(99396003)(46102003)(107046002)(54356999)(80022003)(85306004)(76176999)(44976005)(4396001)(101416001)(46406003)(20776003)(21056001)(107986001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 0359162B6D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB249;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 12:57:50AM +0200, Borislav Petkov wrote:
> On Wed, Oct 08, 2014 at 04:52:06PM -0500, Aravind Gopalakrishnan wrote:
> > I am not understanding why m.bank is assigned this value..
> 
> That's a very good question, see below for some history.
> 
> > 
> > It only causes incorrect decoding-
> > [  608.832916] DEBUG: raise_amd_threshold_event
> > [  608.832926] [Hardware Error]: Corrected error, no action required.
> > [  608.833143] [Hardware Error]: CPU:26 (15:2:0)
> > MC165_STATUS[-|CE|MiscV|-|AddrV|-|-]: 0x8c00000000000000
> > [  608.833551] [Hardware Error]: MC165_ADDR: 0x0000000000000000
> > [  608.833777] [Hardware Error]: cache level: RESV, tx: INSN
> > [  608.834034] amd_inject module loaded ...
> > 
> > 
> > (Obviously, as in amd_decode_mce() we switch (m->bank) for decoding the
> > status and there is no bank 165)
> > 
> > OTOH, if m.bank = bank;
> > Then we get correct decoding info-
> 
> Yes, and I think we should do that only if we're using the *last* error
> to report the overflow with: we're reporting a thresholding counter
> overflow and the bank on which it was detected on should, of course, be
> part of the report.
> 

How do you mean "last error"?
The interrupt is only fired upon overflow..

> The "funny" bank is some sort of a software defined banks thing which
> got added in 2005 (see the patch I dug out below) and it was supposed
> to be used (I'm guessing here) for reporting thermal events using MCA
> (dumb idea, if you ask me) so since thermal events don't really have
> a bank, they decided to have some sort of a software-defined MCA bank
> which doesn't correspond to any hardware bank.
> 
> Then Jacob decided to use it for some reason too:
> 
> 95268664390b ("[PATCH] x86_64: mce_amd support for family 0x10 processors")
> 
> maybe because thresholding errors don't have a bank associated with them
> but if I'm not missing anything, they do!
> 

Right. The thresholding registers are nothing but _MISC(x) where x is a
bank value.

> Oh oh, ok, it just dawned on me! I think I know what it *might* have
> been: they wanted to report the overflowing with a special error
> signature which uses a software-defined bank. Ok, that actually makes
> sense: when you see an error for a sw-defined bank, you're reporting an
> thresholding counter overflow.
> 
> Which means that we shouldn't be populating m.status either, i.e. what
> we did earlier:
> 
> 	rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
> 
> because this is a special error type.
>

How is it a "special error type"? It's still the same CE error that
we get notified with. Only difference being - now it's crossed a
specific 'threshold_limit'

So- I am not getting the rationale behind a S/W defined bank for reporting
this.

CE error if collected through polling gives proper decoding
info. So, why should this be any different for the same CE error for
which an interrupt is generated on crossing a threshold?

Thanks,
-Aravind

> Hmm, it is too late here to think straight, more tomorrow. But Aravind,
> that was a very good question, you actually made me dig into git history
> :-)
> 
> Good night.
> 
