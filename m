Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab3K0Wxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:53:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53532 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631Ab3K0Wxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:53:38 -0500
Message-ID: <529677D7.9080203@zytor.com>
Date: Wed, 27 Nov 2013 14:53:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>	<5294F10C.8060901@amacapital.net>	<CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>	<52964EC7.9000504@zytor.com>	<52966C0A.7070201@zytor.com> <CA+55aFzr9ZKcGfT_Q31T9_vuCcmWxGCh0wixuZqt7VhjxxYU9g@mail.gmail.com>
In-Reply-To: <CA+55aFzr9ZKcGfT_Q31T9_vuCcmWxGCh0wixuZqt7VhjxxYU9g@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 02:41 PM, Linus Torvalds wrote:
> On Wed, Nov 27, 2013 at 2:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> For the record, this is the entire patch necessary to do the
>> sync_cores() system call -- and no potential interactions with security
>> frameworks or whatnot, simply because no security-sensitive operations
>> are performed of any kind.
>>
>> Comments/opinions appreciated.
> 
> If we just care about a core sync, then:
> 
>  - on_each_cpu() is overkill, since you really only want each CPU that
> can run that process.
> 
>    And we have that bitmask already: it's the same bitmask that we use
> for TLB flush purposes.
> 
>  - calling "sync_cores()" cross-cpu is overkill, since the IPI will
> already sync the other cores. And the current core is already going to
> be synchronized wrt the code change, since we're in kernel mode and
> the code is in user mode.
> 
> So I actually think your patch does too much - although it's possible
> that we should have a system call argument saying "sync just this
> process" or "sync all cores" so that people can literally do some
> "modify global instruction in shared library" games if they really
> really want to.

Yes, that was my main concern.

> That said, the thing I really do *not* like about this patch is that
> it makes the "insert 'int3' instruction" visible to user space. That
> makes the "global instruction" replacement impossible, for example,
> because while we'd sync all cores, we have no way to protect against
> other processes getting the breakpoint exception and just SIGSEGV'ing
> randomly as a result of *that*.
> 
> And even if we say "well, we don't care about the global case" (which
> is quite possibly the right thign to do), it's actually hard for
> threaded libraries to sanely catch SIGSGV for the breakpoint case too.
> And since the only reason for this existing IN THE FIRST PLACE is the
> threaded case, I have to say that I absolutely despise this "simpler"
> interface.
> 
> The interface may be simpler, but it's garbage.
> 
> I didn't like the first patch either, but the first patch with
> "replace the stupid pseudo-signal back-call with just waiting" at
> least seems to be a good interface. Unlike this kind of stuff.

If we are going to go down that route, I would like to see a list of
patch sites, not just one with a "timeout" that won't get used.  For
function tracing, for example, one may want to patch every function in
the program, and on the kernel side we already had to do batching for
that.  Similarly, for CPU feature patching, batching the operations make
sense.

	-hpa


