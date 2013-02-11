Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3BKKx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:53:56 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:54234 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab3BKKxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:53:54 -0500
MIME-Version: 1.0
In-Reply-To: <5118C7B6.6040807@imgtec.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
	<1359024639-21915-9-git-send-email-vgupta@synopsys.com>
	<51189D2F.4030000@synopsys.com>
	<CACM3HyGNZxfOXpw01POBVT-YcVKQsnPkO6Kgg+epfZS-x-BRCg@mail.gmail.com>
	<5118C458.2070205@synopsys.com>
	<5118C7B6.6040807@imgtec.com>
Date: Mon, 11 Feb 2013 11:53:52 +0100
Message-ID: <CACM3HyG+4Pzx02iL9atxG+FOLiCcTeXR+ivzRO78bqDHNp5rGQ@mail.gmail.com>
Subject: Re: pt_regs leak into userspace (was Re: [PATCH v3 20/71] ARC: Signal handling)
From: Jonas Bonn <jonas.bonn@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2013 11:28, James Hogan <james.hogan@imgtec.com> wrote:
> On 11/02/13 10:13, Vineet Gupta wrote:
>> On Monday 11 February 2013 03:06 PM, Jonas Bonn wrote:
>>> On 11 February 2013 08:26, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>>>
>>>> The only downside of this patch is that userspace signal stack grows in size,
>>>> since signal frame only cares about scratch regs (pt_regs), but has to accommodate
>>>> unused placeholder for callee regs too by virtue of using user_regs_struct.
>>> Is this really true?  Don't setcontext and friends require that _all_
>>> the registers be part of sigcontext?
>>
>> But for an ABI - callee saved regs will anyhow be saved/restored even in
>> setcontext case ! So collecting it for that purpose seems useless, or am I missing
>> something here.
>
> I think Jonas' point was that signals are asynchronous, i.e. you could
> get interrupted by a signal at virtually any time during the program's
> execution.

No, I agree that the callee-saved regs don't need to be saved across a
signal handler invocation.  It's really just the setcontext case that
wants to be able to swap out the callee-saved regs.

And now that I think about it some more, I think this is done
incorrectly in the openrisc arch, too, as the fast-path for
rt_sigreturn probably only restores the call-clobbered regs.
sigreturn probably needs to be special-cased to _always_ restore all
the regs on its way back to userspace.  Not for the "signal" case, but
for the "setcontext" case; but these two are pretty-much
indistinguishable.

/Jonas
