Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732Ab3JPPhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:37:04 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37727 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759672Ab3JPPgf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Wed, 16 Oct 2013 11:36:35 -0400
Message-Id: <525ECEA102000078000FB906@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 16 Oct 2013 16:36:33 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "KVM list" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data
 selectors
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
 <CA+55aFwCe=t4dDbDhHTWhzA3zMEyyS2WSYBP2Sfe0eogGEBS1w@mail.gmail.com>
In-Reply-To: <CA+55aFwCe=t4dDbDhHTWhzA3zMEyyS2WSYBP2Sfe0eogGEBS1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.10.13 at 17:19, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Oct 16, 2013 at 5:00 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>
>> The basic idea here is to either use a priori information on the
>> intended state layout (in the case of 32-bit processes) or "sense" the
>> proper layout (in the case of KVM guests) by inspecting the already
>> saved FPU rip/rdp, and reading their actual values in a second save
>> operation.
> 
> The rip/rdp thing looks very hacky. And *without* the rip/rdp thing, I
> think the word-size always matches the TIF32 bit, right?

Correct. Which is why the "sensing" is done only when the word size
isn't known (i.e. in the case of running a KVM guest). This possibility
of avoiding the extra logic in the majority of cases is the main
difference to the Xen side solution (where we can bypass it only for
vCPU-s of 32-bit PV guests, which presumably isn't a majority).

> Why wouldn't the high bits be zero even in 64-bit mode? It would seem
> to be a *major* bug if you are in 64-bit mode but (for example) try to
> use the low 32-bit of virtual memory (ie something x32-like), and now
> your patch decides to use the 32-bit layout.
> 
> As far as I can tell, you actually corrupt rid/rdp in that case
> (because when you write the fcs thing, it overwrites the high bits of
> rip, and fos overwrites the high bits of rdp). So now bits that
> *should* be zero are not.
> 
> So you're basically trying to save some old state by corrupting new
> state instead.
> 
> Am I overlooking something?

In that case we use a 32-bit operand size [F]XRSTOR, and hence
the upper halves get treated as selectors, and the offsets get
zero-extended from the low halves, i.e. we preserve even more
state for such a 64-bit environment now too (albeit I doubt any
64-bit code actually cares). So if at all, copying the state out to
e.g. a signal context might need additional adjustment. That's the
main reason why I consider the patch RFC, i.e. possibly not ready
for being applied as is.

Jan

