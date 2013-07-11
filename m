Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab3GKOrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:47:12 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:41711 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756125Ab3GKOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:47:08 -0400
Message-ID: <51DEC56A.4050001@akamai.com>
Date: Thu, 11 Jul 2013 10:47:06 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@redhat.com>, Borislav Petkov <bpetkov@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>  <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>  <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>  <51DDD3E9.6090601@linux.intel.com> <1373553344.17876.13.camel@gandalf.local.home>
In-Reply-To: <1373553344.17876.13.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 10:35 AM, Steven Rostedt wrote:
> On Wed, 2013-07-10 at 14:36 -0700, H. Peter Anvin wrote:
>> On 07/10/2013 02:31 PM, Jiri Kosina wrote:
>>> If any CPU instruction execution would collide with the patching,
>>> it'd be trapped by the int3 breakpoint and redirected to the provided
>>> "handler" (which would typically mean just skipping over the patched
>>> region, acting as "nop" has been there, in case we are doing nop -> jump
>>> and jump -> nop transitions).
>>>
>> I'm wondering if it would be easier/more general to just return to the
>> instruction.  The "more general" bit would allow this to be used for
>> other things, like alternatives, and perhaps eventually dynamic call
>> patching.
>>
>> Returning to the instruction will, in effect, be a busy-wait for the
>> faulted CPU until the patch is complete; more or less what stop_machine
>> would do, but only for a CPU which actually strays into the affected region.
>>
> Wont work for ftrace, as it patches all functions, it even patches
> functions used to do the changes. Thus, it would cause a deadlock if a
> breakpoint were to spin till the changes were finished.
>
> -- Steve
>
>

I'm not sure this works for jump labels either. Some tracepoints (which
use jump_labels) have interrupts disabled across them. Thus, they will
spin with interrupts disabled, while we are trying to issue an IPI.

Thanks,

-Jason


