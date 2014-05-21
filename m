Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaEUWNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:13:40 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:48515 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbaEUWNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:13:38 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz> <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
 <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
 <20140521214845.GG25130@pd.tnic> <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 15:13:16 -0700
Message-ID: <CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 3:01 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> But sending signals from #MC context is definitely a bad idea. I think
>> we had addressed this with irq_work at some point but my memory is very
>> hazy.
>
> We added code for recoverable errors to get out of the MC context
> before trying to lookup the page and send the signal.  Bottom of
> do_machine_check():
>
>         if (cfg->tolerant < 3) {
>                 if (no_way_out)
>                         mce_panic("Fatal machine check on current CPU", &m, msg);
>                 if (worst == MCE_AR_SEVERITY) {
>                         /* schedule action before return to userland */
>                         mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV);
>                         set_thread_flag(TIF_MCE_NOTIFY);
>                 } else if (kill_it) {
>                         force_sig(SIGBUS, current);
>                 }
>         }
>
> That TIF_MCE_NOTIFY prevents the return to user mode, and we end up in mce_notify_process().

Why is this necessary?

If the MCE hit kernel code, then we're going to die anyway.  If the
MCE hit user code, then we should be in a completely sensible context
and we can just send the signal.

--Andy

>
> The "force_sig()" there is legacy code - and perhaps should just move off to mce_notify_process()
> too (need to save "worst" so it will know what to do).
>
> -Tony



-- 
Andy Lutomirski
AMA Capital Management, LLC
