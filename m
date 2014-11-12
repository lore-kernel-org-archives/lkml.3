Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaKLBDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:03:52 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:44876 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaKLBDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:03:50 -0500
Message-ID: <1415754212.12188.12.camel@debian>
Subject: Re: [PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
 mechanism to handle UCNA/DEFERRED error
From: Chen Yucong <slaoub@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Nov 2014 09:03:32 +0800
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F329293DE@ORSMSX114.amr.corp.intel.com>
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
	 <1415410821-15063-2-git-send-email-slaoub@gmail.com>
	 <546136C8.5060104@amd.com> <20141110221728.GA23419@pd.tnic>
	 <3908561D78D1C84285E8C5FCA982C28F329282FA@ORSMSX114.amr.corp.intel.com>
	 <20141111085612.GA31490@pd.tnic>
	 <3908561D78D1C84285E8C5FCA982C28F329293DE@ORSMSX114.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 18:44 +0000, Luck, Tony wrote:
> >> The bank 7 error reported as severity 0 because EN=0 ... so we took no action for it.
> >
> > How come EN is 0? Bank7 error reporting is not enabled? Why? Or the
> > error injection thing doesn't do it?
> 
> The "EN" bit is poorly named, and not well documented.  Here's a clip from the SDM:
> 
> One of bullets in 15.10.4.1 Machine-Check Exception Handler for Error Recovery
> 
>  When the EN flag is zero but the VAL and UC flags are one in the
>  IA32_MCi_STATUS register, the reported uncorrected error in this bank
>  is not enabled. As uncorrected errors with the EN flag = 0 are not the
>  source of machine check exceptions, the MCE handler should log and clear
>  non-enabled errors when the S bit is set and should continue searching
>  for enabled errors from the other IA32_MCi_STATUS registers. Note that
>  when IA32_MCG_CAP [24] is 0, any uncorrected error condition (VAL =1
>  and UC=1) including the one with the EN flag cleared are fatal and the
>  handler must signal the operating system to reset the system. For the
>  errors that do not generate machine check exceptions, the EN flag has
>  no meaning. See Chapter 19: Table 19-15 to find the errors that do not
>  generate machine check exceptions.
> 
> Unfortunately the reference to chapter 19 is stale (that is now all about
> performance monitoring - I'll log a bug with the SDM editor to find the
> right reference and fix this).
> 
> What this is trying to say is that the "EN" bit is to enable signaling
> of machine checks - so it only has meaning when checking banks from the
> machine check handler.  Errors that are logged, but not signaled, or signaled
> as CMCI will have MCi_STATUS.EN=0
> 
> 
> >> The bank 3 error got past that hurdle, then through the next BIT(8) set indicates a
> >> cache error. Fell at the last check because ADDRV=0.
> >
> > I guess you could tweak the injection path to write in a default address
> > so that that check gets bypassed...
> 
> I don't think this is an injection artifact. I think on this processor the mid-level-cache
> just isn't providing an address in this case.  It doesn't help to make one up - our whole
> game plan is to offline a page with a UC error - and we must have an address to know
> which page to offline.
> 
> Perhaps the severity table entries for UCNA and DEFERRED errors should look to see
> if ADDRV is set - if not, don't report this as UCNA/DEFERRED?
> 
We can also find the following snippet from AMD APM Volume 2:

9.3.2 Error-Reporting Register Banks - MCi_STATUS

EN—Bit 60. When set to 1, this bit indicates that the error condition is
enabled in the corresponding error-reporting control register (MCi_CTL).
Errors disabled by MCi_CTL do not cause a `machine-check exception'.

Just as what you said, the severity table entry for the "EN" check
should have been skipped when calling from the CMCI/Poll handler.
As shown below:

        MCESEV(
                NO, "Not enabled",
                EXCP, BITCLR(MCI_STATUS_EN)
                ),

thx!
cyc

