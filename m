Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3CLIQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:16:36 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:59216 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3CLIQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:16:34 -0400
Date: Tue, 12 Mar 2013 09:16:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe
 section
Message-ID: <20130312081628.GA30665@gmail.com>
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Beacuse hash_64() is called from the get_kprobe() inside
> int3 handler, kernel causes int3 recursion and crashes if
> kprobes user puts a probe on it.
> 
> Usually hash_64() is inlined into caller function, but in
> some cases, it has instances by gcc's interprocedural
> constant propagation.
> 
> This patch adds __kprobes tag on the hash_64() and moves
> all those instances into .text.kprobe section so that
> kprobes can refuse probing on the instances.
> 
> I've ensured that all hash_64 instances moves to the
> address between __kprobes_text_start and __kprobes_text_end
> with this patch as below.
> 
> ffffffff8138bea0 T __kprobes_text_start
> ffffffff8138bec0 t hash_64.constprop.8
> ffffffff8138ef98 t hash_64.constprop.26
> ffffffff8138efae t hash_64
> ffffffff8138f066 t hash_64.constprop.43
> ffffffff8138f649 t hash_64.constprop.25
> ffffffff8139103a t hash_64.constprop.77
> ffffffff81391050 t hash_64.constprop.24
> ffffffff81391066 t hash_64.constprop.40
> ffffffff8139107c t hash_64.constprop.15
> ffffffff81391092 T __kprobes_text_end
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reported-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> ---
>  include/linux/hash.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/hash.h b/include/linux/hash.h
> index 61c97ae..d83f62f 100644
> --- a/include/linux/hash.h
> +++ b/include/linux/hash.h
> @@ -15,6 +15,7 @@
>   */
>  
>  #include <asm/types.h>
> +#include <linux/kprobes.h>

I have no objections to the fix itself, but this inclusion of kprobes.h in 
hash.h is somewhat sad: kprobes.h is a 'fat' header that includes a lot of 
header files - while hash.h is a really basic type header included in 
close to a hundred .c files.

I think one solution would be for the __kprobes definition to move to a 
more basic header file - such as types.h or compiler.h (where the 
'notrace' attribute is placed too), to stop this header dependency creep.

Thanks,

	Ingo
