Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3GKQcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:32:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:4297 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab3GKQcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:32:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1045,1363158000"; 
   d="scan'208";a="363793316"
Message-ID: <51DEDDEF.4060502@linux.intel.com>
Date: Thu, 11 Jul 2013 09:31:43 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <51DDD3E9.6090601@linux.intel.com> <alpine.LNX.2.00.1307111204000.29788@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307111204000.29788@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 03:09 AM, Jiri Kosina wrote:
>>
>> I'm wondering if it would be easier/more general to just return to the
>> instruction.  The "more general" bit would allow this to be used for
>> other things, like alternatives, 
> 
> As Boris already pointed out, this is not really that interesting, as it's 
> being done through text_poke_early(), which is rather a different story 
> anyway.
> 
>> and perhaps eventually dynamic call patching.
> 
> Umm ... could you please elaborate either what exactly do you mean by 
> that, or why it can't be used currently as-is?

Dynamic call patching would be changing a CALL instruction *emitted by
the compiler* (and therefore lacking any metadata annotation) from one
target function to another.  Because it lacks metadata annotations, we
can't do this as a "big bang" (all at the same time) but rather would
have to do it on demand (the original CALL would point to a "patch me"
routine.)  This means a lot of patching cycles; stop_machine() is a
total nonstarter, even IPIs might be too expensive.

There is an alternative, which is postprocessing the executable to
generate metadata, but that has its own trickiness.

>> Returning to the instruction will, in effect, be a busy-wait for the 
>> faulted CPU until the patch is complete; more or less what stop_machine 
>> would do, but only for a CPU which actually strays into the affected 
>> region.
> 
> To be honest, I fail to see a clear advantage ... we don't avoid any extra 
> IPI by it, and wrt. "correctness", the end result is the same.
> 

The current code assumes that one of the two code sequences is a NOP,
and therefore that jumping over the region is legal.  This does not
allow for transitioning one active code sequence to another.

	-hpa

