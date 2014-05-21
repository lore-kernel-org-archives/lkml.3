Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaEUOVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:21:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55857 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbaEUOVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:21:18 -0400
Date: Wed, 21 May 2014 16:20:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Petr Tesarik <ptesarik@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: 64bit x86: NMI nesting still buggy?
Message-ID: <20140521142055.GH21205@pd.tnic>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
 <20140429100345.3f76a5bd@gandalf.local.home>
 <alpine.LNX.2.00.1405211540080.20534@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1405211540080.20534@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 03:42:24PM +0200, Jiri Kosina wrote:
> Alright, Andy's iret optimization efforts do immediately bring a
> followup question -- why is this not a problem with iret-based return
> from #MC possibly interrupting NMI?

Yeah, and frankly, I don't see this nesting fun at all protected against
a #MC interrupting it at any point actually. Because once the #MC
handler returns, it goes into paranoid_exit and that place doesn't
account for NMIs at all, AFAICS.

Which would mean:

* NMI goes off
* MCE happens, we switch to machine_check which is paranoidzeroentry
* #MC handler is done -> paranoid_exit -> IRET
-> boom! Or if not "boom", at least, the NMI gets forgotten.

Am I missing something?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
