Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3JBO5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:57:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:58675 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab3JBO4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:56:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1019,1371106800"; 
   d="scan'208";a="413006865"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran\, Aswin" <aswin@hp.com>,
        "Norton\, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Avoiding the dentry d_lock on final dput(), part deux: transactional memory
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	<5249D897.1010109@hp.com>
	<CA+55aFw6tOVMw=pKE_knj4BOwTi_JAX=4N=-5_WduykNPotdww@mail.gmail.com>
Date: Wed, 02 Oct 2013 07:56:50 -0700
In-Reply-To: <CA+55aFw6tOVMw=pKE_knj4BOwTi_JAX=4N=-5_WduykNPotdww@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 30 Sep 2013 13:04:34 -0700")
Message-ID: <87y56boh59.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Sep 30, 2013 at 1:01 PM, Waiman Long <waiman.long@hp.com> wrote:
>>
>> I think this patch is worth a trial if relevant hardware is more widely
>> available. The TSX code certainly need to be moved to an architecture
>> specific area and should be runtime enabled using a static key. We also need
>> more TSX support infrastructure in place first.
>
> I think we can pick that up from Andi's patches, he should have that.
> Although that did have very x86-specific naming (ie "xbegin"). And I
> don't think he used "asm goto" to quite the same advantage as this -
> and I think we do want to make sure that the overhead is minimal.

FWIW my version #0 used asm goto directly, but I later switched to not
using it to support more compilers and higher level abstractions (locks
etc.) and use the same intrinsics as the user level guys are using.

The two extra instructions from not using asm goto for xbegin
don't matter all that much in the end.

That's the old asm goto stuff I wrote originally
(user level version):

https://github.com/andikleen/tsx-tools/blob/master/include/rtm-goto.h

There was also a kernel version of it that patched, right 
now this is done in the main TSX patchkit like this:

https://git.kernel.org/cgit/linux/kernel/git/ak/linux-misc.git/commit/?h=hle312/rtm-base&id=9190346d57a9bc89e746aee774d07e54cd1e6e75

Essentially without RTM it just becomes and unconditional jump
to the abort handler, xabort is a nop, and xtest always returns 0.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
