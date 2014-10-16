Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaJPXQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 19:16:14 -0400
Received: from ozlabs.org ([103.22.144.67]:35880 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbaJPXQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 19:16:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: David Woodhouse <David.Woodhouse@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arjun Sreedharan <arjun024@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: krealloc in kernel/params.c
In-Reply-To: <87fveo1h07.fsf@rasmusvillemoes.dk>
References: <87mw8y8jq7.fsf@rasmusvillemoes.dk> <87r3yaapyf.fsf@rustcorp.com.au> <87fveo1h07.fsf@rasmusvillemoes.dk>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 17 Oct 2014 09:29:27 +1030
Message-ID: <87wq7zaaeo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
> On Wed, Oct 15 2014, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
>> The kzalloc-then-always-krealloc pattern is perhaps overly simplistic,
>> but this code has clearly confused people.  It worked on me...
>>
>
> I think kzalloc immediately followed by kreallocing the returned value
> is rather ugly. Other than that:

Indeed, but it's an obvious pattern.  "If not initialized, initialize".

>> -		num = mk->mp->num;
>> -		attrs = mk->mp->grp.attrs;
>> +		/* First allocation. */
>> +		mk->mp = kzalloc(sizeof(*mk->mp), GFP_KERNEL);
>> +		if (!mk->mp)
>> +			return -ENOMEM;
>
> free_module_param_attrs does not check mk->mp for being NULL before
> kfree'ing mk->mp->grp.attrs, so this will oops.

Nice catch, folded this in:

diff --git a/kernel/params.c b/kernel/params.c
index 3ebe6c64aa67..ee92e67f2cee 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -650,7 +650,8 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
 #ifdef CONFIG_MODULES
 static void free_module_param_attrs(struct module_kobject *mk)
 {
-	kfree(mk->mp->grp.attrs);
+	if (mk->mp)
+		kfree(mk->mp->grp.attrs);
 	kfree(mk->mp);
 	mk->mp = NULL;
 }

Thanks!
Rusty.
