Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3LKLis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:38:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46115 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab3LKLir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:38:47 -0500
Date: Wed, 11 Dec 2013 12:38:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <bitbucket@online.de>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
Message-ID: <20131211113839.GF21683@pd.tnic>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
 <1386478624.4748.19.camel@marge.simpson.net>
 <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com>
 <1386559014.4875.16.camel@marge.simpson.net>
 <1386652637.5374.72.camel@marge.simpson.net>
 <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de>
 <1386732093.5964.6.camel@marge.simpson.net>
 <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 12:28:36PM +0100, Thomas Gleixner wrote:
> On Wed, 11 Dec 2013, Mike Galbraith wrote:
> > Alakazam..
> > Yup, magical gremlin repellent works on 8 socket DL980 too.
> 
> Now here is a less magical version of the gremlin repellent.
> 
> And just for the amusement value: The erratum for the series 7400
> says:
> 
> AAI65. MONITOR/MWAIT May Have Excessive False Wakeups
> 
> Problem:	Normally, if MWAIT is used to enter a C-state that is
> 		C1 or higher, a store to the address range armed by
> 		the MONITOR instruction will cause the processor to
> 		exit MWAIT. Due to this erratum, false wakeups may
> 		occur when the monitored address range was recently
> 		written prior to executing the MONITOR instruction.
> 
> Implication:	Due to this erratum, performance and power savings may
> 		be impacted due to excessive false wakeups.
> 
> Workaround: 	Execute a CLFLUSH Instruction immediately before every
> 		MONITOR instruction when the monitored location may
> 		have been recently written.
> 
> Now that looks like the very same issue on these westmere EX
> machines.
> 
> These false wakeups can be observed already before the idle changes
> and now they are just more prominent.
> 
> Adding that clflush() unconditionally fixes the issue at least on
> Boris machine.
> 
> Mike, can you retest on that 8 socket monstrum, please?
> 
> So it looks like the idle power regression is actually a software
> change which exhibits a hardware "regression".

Right, if it turns out that this is really the case and that this
erratum hasn't been fixed for models later than 29 - we'd need the
additional model numbers to set X86_FEATURE_CLFLUSH_MONITOR correctly.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
