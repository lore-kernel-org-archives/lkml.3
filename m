Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3AUB4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:56:37 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:53789 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3AUB4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:56:35 -0500
MIME-Version: 1.0
In-Reply-To: <87ip6rwcvz.fsf@rustcorp.com.au>
References: <20130118074309.GB31793@elgon.mountain> <87ip6rwcvz.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jan 2013 17:56:14 -0800
X-Google-Sender-Auth: qwLzCFHXh6PHU52D9LIJ1DCDWoI
Message-ID: <CA+55aFzEkSOWL13cX2xaYttPF5=Qpvya9Yapk-RC8KQ5=QJk+w@mail.gmail.com>
Subject: Re: [patch] module: potential deadlock in error path
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 5:20 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
>> We take the lock twice if we hit this goto.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> Damn, just pushed that to Linus: should have read mail first.
>
> I've added this, thanks.

I'm not pulling this. It seems stupid.

Why isn't the fix just this (whitespace-damaged, cut-and-pasted)
one-liner instead? I may be blind, but as far as I cal tell, there's
exactly one single place we do that "giti ddebug_cleanup", and it
wants to unlock the mutex, so we should just move the unlock down one
line instead.

Hmm? Is there some hidden magic going on that I can't see?

                  Linus

---
diff --git a/kernel/module.c b/kernel/module.c
index d25e359279ae..eab08274ec9b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3274,8 +3274,8 @@ again:
        /* module_bug_cleanup needs module_mutex protection */
        mutex_lock(&module_mutex);
        module_bug_cleanup(mod);
-       mutex_unlock(&module_mutex);
  ddebug_cleanup:
+       mutex_unlock(&module_mutex);
        dynamic_debug_remove(info->debug);
        synchronize_sched();
        kfree(mod->args);
