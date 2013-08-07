Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab3HGUaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:30:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818Ab3HGUaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:30:22 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=8WDeNtya6e4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=FBSalxFJak0A:10 a=oGMlB6cnAAAA:8 a=K7hpe1EHq2gghiSB1okA:9 a=QEXdDO2ut3YA:10 a=CY6gl2JlH4YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375907419.6848.27.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 3/2] x86/jump labels: Count and display the short
 jumps used
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Date: Wed, 07 Aug 2013 16:30:19 -0400
In-Reply-To: <CA+55aFwNWsd4eSA_wZzz9L1q=ROkdBf_SBE5gYGSZksg-Kv2Jg@mail.gmail.com>
References: <20130807173606.872055511@goodmis.org>
	 <1375898048.6848.18.camel@gandalf.local.home>
	 <CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com>
	 <2e3a4a90-2915-4b75-b807-b0e802e4955f@email.android.com>
	 <CA+55aFwNWsd4eSA_wZzz9L1q=ROkdBf_SBE5gYGSZksg-Kv2Jg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 12:49 -0700, Linus Torvalds wrote:
> On Wed, Aug 7, 2013 at 12:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > Well we do... both to extract relocations and to sort the exception table.  Perhaps we need to merge those kinds of postprocessing tools?
> 
> If we can do this generically and without adding 500 lines of
> specialized code, my argument obviously goes away.

And the code that does this work is actually in the kernel today,
although, seldom used.

The recordmount.[ch] can do this modification. It's main purpose was to
create a table of mcount call locations that ftrace can use to convert
to nops on boot. As it only converts white-listed sections (doesn't
convert things like .init or .exit, as there exists no way today to
generically know when they are removed), it only creates the pointers to
those sections that ftrace will touch.

Those sections that do not get converted, can have a call to mcount that
is not changed to a nop. Most places this is not the case, because
things like __init have "notrace" defined to keep those functions from
being profiled. But if another section is added that ftrace does not
know about, it will get a call to mcount and cause a bit of a slow down.
Note, mcount itself looks like:

mcount:
	retq

To handle these missed cases, the recordmcount.c was modified to convert
the call to mcount into a nop. There's a flag you can set to have this
warn on locations that it converts:

make RECORDMCOUNT_WARN=1

It will give a warning at the locations that it converted, which should
then be white-listed or have notrace added to it.

This is the code I based the update_jump_labels from. With a bit of
work, all these ELF parsers could probably be consolidated, and this
addition may not be that hard or complex to add.

-- Steve


