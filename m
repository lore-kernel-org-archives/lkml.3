Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaEUO7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:59:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbaEUO7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:59:00 -0400
Date: Wed, 21 May 2014 16:58:57 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>, Andy Lutomirski <luto@amacapital.net>
Subject: Re: 64bit x86: NMI nesting still buggy?
Message-ID: <20140521145857.GA5880@suse.cz>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
 <20140429100345.3f76a5bd@gandalf.local.home>
 <alpine.LNX.2.00.1405211540080.20534@pobox.suse.cz>
 <20140521142055.GH21205@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521142055.GH21205@pd.tnic>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 04:20:55PM +0200, Borislav Petkov wrote:
> On Wed, May 21, 2014 at 03:42:24PM +0200, Jiri Kosina wrote:
> > Alright, Andy's iret optimization efforts do immediately bring a
> > followup question -- why is this not a problem with iret-based return
> > from #MC possibly interrupting NMI?
> 
> Yeah, and frankly, I don't see this nesting fun at all protected against
> a #MC interrupting it at any point actually. Because once the #MC
> handler returns, it goes into paranoid_exit and that place doesn't
> account for NMIs at all, AFAICS.
> 
> Which would mean:
> 
> * NMI goes off
> * MCE happens, we switch to machine_check which is paranoidzeroentry
> * #MC handler is done -> paranoid_exit -> IRET
> -> boom! Or if not "boom", at least, the NMI gets forgotten.
> 
> Am I missing something?

I think to get a full BOOM you need a bit more complex process, namely:

	* NMI triggered
	* NMI handler starts
	* MCE happens
	* Second NMI triggered and queued
	* handler done, IRET
	* Second NMI handler starts and overwrites NMI return address on stack
	* Second NMI handler ends
	* First NMI handler ends and goes into an infinite IRET loop, always
	  returning to the beginning of itself

But you do have all the ingredients.

And I don't see any other way out than not calling IRET for MCEs.

-- 
Vojtech Pavlik
Director SUSE Labs
