Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3I0QNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:13:15 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:39689 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3I0QNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:13:11 -0400
MIME-Version: 1.0
In-Reply-To: <1380269034-38521-2-git-send-email-heiko.carstens@de.ibm.com>
References: <1380269034-38521-1-git-send-email-heiko.carstens@de.ibm.com>
	<1380269034-38521-2-git-send-email-heiko.carstens@de.ibm.com>
Date: Fri, 27 Sep 2013 09:13:10 -0700
X-Google-Sender-Auth: lnbWvGSlSE1T0FoHBtqo2WNODdQ
Message-ID: <CA+55aFyXRsEKYg6TAr4p=RY9TSY+XhJBJ-h5ApugP7YemfAmkQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mutex,spinlock: rename arch_mutex_cpu_relax() to cpu_relax_simple()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>, Waiman Long <waiman.long@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 1:03 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> s390 needs a special version of cpu_relax() for the new lockref code.
> The new variant should be a no-op but also have memory barrier semantics,
> since that is what the default cpu_relax() variant implements.

I'd actually prefer you do this without the renaming, and we just use
arch_mutex_cpu_relax() in the lockref code.

We have another set of patches kind-of pending that uses
arch_mutex_cpu_relax() (MCS lock for rwsem), and I don't want to screw
them up.

The _one_ thing I'd suggest is that you replace this:

 #ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
 #define arch_mutex_cpu_relax() cpu_relax()
 #endif

with just a simple

  #ifndef arch_mutex_cpu_relax
  # define arch_mutex_cpu_relax() cpu_relax()
  #endif

and get rid of that unnecessary CONFIG variable. I'm ok with CONFIG
variables, but they should be for bigger things than "I have this
particular function". The "I have this particular function" is
particularly easily solved with just using the function name as a
preprocessor symbol (either _because_ it is a macro in the first
place, or with a simple "#define fn_name fn_name" to let the generic
code know it exists).

So if you just move the

  #define arch_mutex_cpu_relax()    barrier()

into arch/s390/include/asm/processor.h (so that you always have it
when  you have the regular cpu_relax() one, and people don't need to
include <mutex.h> to get it), and then put that #ifdef into
lib/lockref.c, and we're all ok. We already did the equivalent for the
ARM use of cmpxchg64_relaxed().

And we can maybe rename it later, when there isn't any new use pending...

                Linus
