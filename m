Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3EOFVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 01:21:02 -0400
Received: from ozlabs.org ([203.10.76.45]:48496 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab3EOFU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 01:20:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: majianpeng <majianpeng@gmail.com>,
        "lizefan\@huawei.com" <lizefan@huawei.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] module: Add section ".ref.data" into kmemleak-scan-area.
In-Reply-To: <20130513164223.GF18828@arm.com>
References: <518DAA1A.3010407@gmail.com> <87bo8f39di.fsf@rustcorp.com.au> <20130513164223.GF18828@arm.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 15 May 2013 14:25:34 +0930
Message-ID: <878v3g2661.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:
> On Mon, May 13, 2013 at 03:24:09AM +0100, Rusty Russell wrote:
>> majianpeng <majianpeng@gmail.com> writes:
>> 
>> > In commit 523c81135,it used "__refdata" on event_class_ftrace_##call.
>> > It will cause kmemleak to misjudge because when loading module it did
>> > not add '.ref.data' into kmemleak-scan-area.
>> > 
>> > Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>> > ---
>> >  kernel/module.c |    3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> Catalin?
>> 
>> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Looks good, thanks for cc'ing me.
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

I use "Acked-by" to mean "it touches my code so normally it'd go in my
tree, but it's not".

Since you replied the same, I defer to your wishes and put it in my
fixes branch (or Linus will grab it now).  I also removed the extra
trailing space ('git am' complained).

Thanks,
Rusty.

From: Jianpeng Ma <majianpeng@gmail.com>
Date: Sat, 11 May 2013 10:04:14 +0800
Subject: [PATCH] module: Add section ".ref.data" into kmemleak-scan-area.

In commit 523c81135,it used "__refdata" on event_class_ftrace_##call.
It will cause kmemleak to misjudge because when loading module it did
not add '.ref.data' into kmemleak-scan-area.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
index b049939..e4ee1bf 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2434,7 +2434,8 @@ static void kmemleak_load_module(const struct module *mod,
 		const char *name = info->secstrings + info->sechdrs[i].sh_name;
 		if (!(info->sechdrs[i].sh_flags & SHF_ALLOC))
 			continue;
-		if (!strstarts(name, ".data") && !strstarts(name, ".bss"))
+		if (!strstarts(name, ".data") && !strstarts(name, ".bss") &&
+			!strstarts(name, ".ref.data"))
 			continue;
 
 		kmemleak_scan_area((void *)info->sechdrs[i].sh_addr,
