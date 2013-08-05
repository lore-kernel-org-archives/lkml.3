Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3HET6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:58:03 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:12340 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623Ab3HET6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:58:02 -0400
Message-ID: <520003B8.8090503@akamai.com>
Date: Mon, 05 Aug 2013 15:57:44 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Marek Polacek <polacek@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>, rth@twiddle.net
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <1375721715.22073.80.camel@gandalf.local.home> <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com> <1375725328.22073.101.camel@gandalf.local.home> <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com> <CA+55aFw=OX3Zz_PJc7NUGwFLAE1RYUsPe9Dn8qHDN0nZeW2R5A@mail.gmail.com> <CA+55aFyzmGzv3C9gy5Xi=pSmAOzpYMNAqrrrZmsvNbt4LdrorQ@mail.gmail.com> <20130805194009.GZ17022@redhat.com>
In-Reply-To: <20130805194009.GZ17022@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 03:40 PM, Marek Polacek wrote:
> On Mon, Aug 05, 2013 at 11:34:55AM -0700, Linus Torvalds wrote:
>> On Mon, Aug 5, 2013 at 11:24 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> Ugh. I can see the attraction of your section thing for that case, I
>>> just get the feeling that we should be able to do better somehow.
>> Hmm.. Quite frankly, Steven, for your use case I think you actually
>> want the C goto *labels* associated with a section. Which sounds like
>> it might be a cleaner syntax than making it about the basic block
>> anyway.
> FWIW, we also support hot/cold attributes for labels, thus e.g.
>
>    if (bar ())
>      goto A;
>    /* ... */
> A: __attribute__((cold))
>    /* ... */
>
> I don't know whether that might be useful for what you want or not though...
>
> 	Marek
>

It certainly would be.

That was how I wanted to the 'static_key' stuff to work, but 
unfortunately the last time I tried it, it didn't move the text 
out-of-line any further than it was already doing. Would that be 
expected? The change for us, if it worked would be quite simple. 
Something like:

--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -21,7 +21,7 @@ static __always_inline bool arch_static_branch(struct 
static_key *key)
                 ".popsection \n\t"
                 : :  "i" (key) : : l_yes);
         return false;
-l_yes:
+l_yes: __attribute__((cold))
         return true;
  }




