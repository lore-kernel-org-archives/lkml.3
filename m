Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaKLRa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:30:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58071 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbaKLRaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:30:55 -0500
Date: Wed, 12 Nov 2014 18:30:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Message-ID: <20141112173048.GI16807@pd.tnic>
References: <20141111230926.GR31490@pd.tnic>
 <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
 <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic>
 <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3292AE0D@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3292AE0D@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 05:17:55PM +0000, Luck, Tony wrote:
> > Not that easy for testing the #MC path - there we have to inject real
> > MCEs and then noodle through the memory_failure() code. I'd be very much
> > interested to see what would happen if two MCEs happen back-to-back with
> > your change, the second one being raised when we're on the kernel stack
> > and in memory_failure()...
> 
> If the second one hits before we clear MCG_STATUS, then the processor resets.
> 
> If the second one is caused by the recovery thread somewhere in memory_failure(),
> then Andy won't switch stacks - but we will declare this a fatal error an panic (we have
> no recovery from machine checks in the kernel).
> 
> Otherwise the memory_failure() thread is the innocent bystander. If the affected thread
> decides to do recovery, then the first thread will be allowed to return and continue.
> 
> I might worry a bit if the second error is another thread hitting the *same* page which
> hasn't finished processing yet ... then the second will chase along behind the first trying
> to fix the same problem.  I *think* the first will complete and the second will just end
> up here:
> 
> 	if (TestSetPageHWPoison(p)) {
> 		printk(KERN_ERR "MCE %#lx: already hardware poisoned\n", pfn);
> 		return 0;
> 	}
> 
> which is really early in memory_failure().

Yeah, I meant this case: when we have switched stacks, exited
do_machine_check() and running the recovery code. Exactly then we get
another MCE. And the code might handle it, as you say, but I'd like to
see this in action first to be sure - it is not trivial code.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
