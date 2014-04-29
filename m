Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbaD2N3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:29:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:56821 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaD2N3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:29:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,951,1389772800"; 
   d="scan'208";a="502897319"
Message-ID: <535FA920.9080503@linux.intel.com>
Date: Tue, 29 Apr 2014 06:29:04 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 06:05 AM, Jiri Kosina wrote:
> 
> We were not able to come up with any other fix than avoiding using IST 
> completely on x86_64, and instead going back to stack switching in 
> software -- the same way 32bit x86 does.
> 

This is not possible, though, because there are several windows during
which if we were to take an exception which doesn't do IST, e.g. NMI, we
are worse than dead -- we are in fact rootable.  Right after SYSCALL in
particular.

> So basically, I have two questions:
> 
> (1) is the above analysis correct? (if not, why?)
> (2) if it is correct, is there any other option for fix than avoiding 
>     using IST for exception stack switching, and having kernel do the 
>     legacy task switching (the same way x86_32 is doing)?

It is not an option, see above.

> [1] http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-manual-325462.pdf
> 
> [2] 	"A special case can occur if an SMI handler nests inside an NMI 
> 	 handler and then another NMI occurs. During NMI interrupt 
> 	 handling, NMI interrupts are disabled, so normally NMI interrupts 
>  	 are serviced and completed with an IRET instruction one at a 
> 	 time. When the processor enters SMM while executing an NMI 
> 	 handler, the processor saves the SMRAM state save map but does 
> 	 not save the attribute to keep NMI interrupts disabled. 
> 	 Potentially, an NMI could be latched (while in SMM or upon exit) 
> 	 and serviced upon exit of SMM even though the previous NMI  
> 	 handler has still not completed."

I believe [2] only applies if there is an IRET executing inside the SMM
handler, which should not normally be the case.  It might also have been
addressed since that was written, but I don't know.

	-hpa



