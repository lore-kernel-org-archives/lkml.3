Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaEUWLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:11:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:26493 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbaEUWK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:10:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,882,1392192000"; 
   d="scan'208";a="544515264"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>
CC: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Subject: RE: [RFC] x86_64: A real proposal for iret-less return to kernel
Thread-Topic: [RFC] x86_64: A real proposal for iret-less return to kernel
Thread-Index: AQHPdT5wRvlmui20OUO5csd5VXpJ+ZtMCOaA//+MFSA=
Date: Wed, 21 May 2014 22:01:36 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home>
 <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz>
 <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
 <20140521163315.GJ21205@pd.tnic>
 <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
 <20140521214845.GG25130@pd.tnic>
 <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
In-Reply-To: <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4LMB40c022702

> But sending signals from #MC context is definitely a bad idea. I think
> we had addressed this with irq_work at some point but my memory is very
> hazy.

We added code for recoverable errors to get out of the MC context
before trying to lookup the page and send the signal.  Bottom of
do_machine_check():

        if (cfg->tolerant < 3) {
                if (no_way_out)
                        mce_panic("Fatal machine check on current CPU", &m, msg);
                if (worst == MCE_AR_SEVERITY) {
                        /* schedule action before return to userland */
                        mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV);
                        set_thread_flag(TIF_MCE_NOTIFY);
                } else if (kill_it) {
                        force_sig(SIGBUS, current);
                }
        }

That TIF_MCE_NOTIFY prevents the return to user mode, and we end up in mce_notify_process().

The "force_sig()" there is legacy code - and perhaps should just move off to mce_notify_process()
too (need to save "worst" so it will know what to do).

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
