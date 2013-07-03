Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab3GCUxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:53:08 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:27927 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215Ab3GCUxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:53:06 -0400
Message-ID: <51D48F24.1020406@hp.com>
Date: Wed, 03 Jul 2013 16:52:52 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v3 03/25] dcache: Enable lockless update of d_count in
 dentry structure
References: <1372882741-22563-1-git-send-email-Waiman.Long@hp.com> <1372882741-22563-4-git-send-email-Waiman.Long@hp.com> <CA+55aFzRbOgBhmL3y=bgR=OakOH6RizVYD5XBc8aP9LzfMn8cA@mail.gmail.com>
In-Reply-To: <CA+55aFzRbOgBhmL3y=bgR=OakOH6RizVYD5XBc8aP9LzfMn8cA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 04:37 PM, Linus Torvalds wrote:
> This patch grew a lot, and that seems to be mainly because of bad reasons.

That is the main reason why I choose to implement it the way it was in 
my previous version. As I add one more level to access d_lock and 
d_count, I need to change a lot more files.

> I'd suggest dropping the whole
> "lockref_ret_count()"/"lockref_ret_lock()" helpers, which cause all
> the annoyance, and just make people use the members directly.

Yes, I can do that. They are used in not that many places.

> Then, just do
>
>     #define d_lock d_lockref.lockref_lock
>
> or similar, so that all the existing code just continues to work,
> without the need for the syntactic changes:
>
> -       spin_lock(&dentry->d_lock);
> +       d_lock(dentry);

I had been thinking about that. The use of d_lock should be pretty safe 
as I didn't see that variable name used in other places. I didn't do it 
because I am afraid that people may say that using macro mapping like 
this is not a good idea. By doing that, the patch should shrink 
considerably.

> For d_count, we probably do need to have the wrapper macro:
>
>    #define dentry_count(dentry)  ((dentry)->d_lockref.lockref_count)
>
> and change the existing users of "dentry->d_count" to use that, but
> there are fewer of those than there are of people taking the dentry
> lock. And most of them are in fs/dcache.c and would be affected by
> this set of patches anyway.

The d_count name is not unique to the dentry structure. So files that 
access d_count have to be modified explicitly.

I will see if there are more feedback and send an updated patchset by 
the end of this week or early next week.

Regards,
Longman
