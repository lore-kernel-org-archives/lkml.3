Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab3GJWjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:39:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab3GJWjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:39:12 -0400
Date: Thu, 11 Jul 2013 00:39:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
In-Reply-To: <51DDD3E9.6090601@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1307110036000.25858@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <51DDD3E9.6090601@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, H. Peter Anvin wrote:

> > If any CPU instruction execution would collide with the patching,
> > it'd be trapped by the int3 breakpoint and redirected to the provided
> > "handler" (which would typically mean just skipping over the patched
> > region, acting as "nop" has been there, in case we are doing nop -> jump
> > and jump -> nop transitions).
> > 
> 
> I'm wondering if it would be easier/more general to just return to the
> instruction.  The "more general" bit would allow this to be used for
> other things, like alternatives, and perhaps eventually dynamic call
> patching.

Interesting idea ... This should be very easily done by just setting the 
"handler" to the exact address that is being patched, and it'll work 
exactly the way you are proposing, no?

> Returning to the instruction will, in effect, be a busy-wait for the
> faulted CPU until the patch is complete; more or less what stop_machine
> would do, but only for a CPU which actually strays into the affected region.

Exactly ... so the special case I am introducing for jump labels in 2/2 
(i.e. implicitly behaving like there was a nop) is an optimized one, but 
can be easily turned into busy loop by just redirecting the "handler" one 
instruction back in cases where it'd be desirable.

-- 
Jiri Kosina
SUSE Labs
