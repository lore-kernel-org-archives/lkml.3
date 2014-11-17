Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaKQSur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:50:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44525 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaKQSup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:50:45 -0500
Date: Mon, 17 Nov 2014 19:50:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Message-ID: <20141117185030.GA25157@pd.tnic>
References: <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
 <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic>
 <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic>
 <20141113180436.GG14070@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 09:56:38PM +0000, Luck, Tony wrote:
> ...
> But I think that means we need more than one of these structures ...
> we may not be done with one before a new machine check occurs. So
> we'd have to make an NMI-safe allocator to grab one for use inside
> do_machine_check()

Well, I think we might do something with a lockless list as it is being
done in ghes.c.

It allocates entries from its own pool in the NMI handler and
llist_add's them to a list.

Then, in user context it does llist_del_all and then looks at each of
the elements at leisure and stress-free :-)

Pool alloc/free is NMI-safe too so we should be good. It looks pretty
clean, I'd give it a try.

> General testing note - one thing I did see was that if inject 1000
> errors at 0.3s interval from my ssh'd login ... the serial console
> keeps streaming messages for about 40 seconds after my test says it is
> all done. This might be a factor in the other tests I've been running
> against the stack-switching code (especially with extra debug) ... at
> some point __log_buf must get full - what happens then?

Start gets overwritten AFAICR.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
