Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3CLLD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:03:59 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:39595 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3CLLD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:03:57 -0400
Message-ID: <513F0B9B.5050307@hitachi.com>
Date: Tue, 12 Mar 2013 20:03:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe
 section
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522> <20130312081628.GA30665@gmail.com>
In-Reply-To: <20130312081628.GA30665@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/12 17:16), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Beacuse hash_64() is called from the get_kprobe() inside
>> int3 handler, kernel causes int3 recursion and crashes if
>> kprobes user puts a probe on it.
>>
>> Usually hash_64() is inlined into caller function, but in
>> some cases, it has instances by gcc's interprocedural
>> constant propagation.
>>
>> This patch adds __kprobes tag on the hash_64() and moves
>> all those instances into .text.kprobe section so that
>> kprobes can refuse probing on the instances.
>>
>> I've ensured that all hash_64 instances moves to the
>> address between __kprobes_text_start and __kprobes_text_end
>> with this patch as below.
>>
>> ffffffff8138bea0 T __kprobes_text_start
>> ffffffff8138bec0 t hash_64.constprop.8
>> ffffffff8138ef98 t hash_64.constprop.26
>> ffffffff8138efae t hash_64
>> ffffffff8138f066 t hash_64.constprop.43
>> ffffffff8138f649 t hash_64.constprop.25
>> ffffffff8139103a t hash_64.constprop.77
>> ffffffff81391050 t hash_64.constprop.24
>> ffffffff81391066 t hash_64.constprop.40
>> ffffffff8139107c t hash_64.constprop.15
>> ffffffff81391092 T __kprobes_text_end
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Reported-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
>> Cc: Pavel Emelyanov <xemul@parallels.com>
>> Cc: Jiri Kosina <jkosina@suse.cz>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> ---
>>  include/linux/hash.h |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/hash.h b/include/linux/hash.h
>> index 61c97ae..d83f62f 100644
>> --- a/include/linux/hash.h
>> +++ b/include/linux/hash.h
>> @@ -15,6 +15,7 @@
>>   */
>>  
>>  #include <asm/types.h>
>> +#include <linux/kprobes.h>
> 
> I have no objections to the fix itself, but this inclusion of kprobes.h in 
> hash.h is somewhat sad: kprobes.h is a 'fat' header that includes a lot of 
> header files - while hash.h is a really basic type header included in 
> close to a hundred .c files.
> 
> I think one solution would be for the __kprobes definition to move to a 
> more basic header file - such as types.h or compiler.h (where the 
> 'notrace' attribute is placed too), to stop this header dependency creep.

Agreed, that sounds nice to me too!

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


