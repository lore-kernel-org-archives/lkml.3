Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3HAQCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:02:31 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34536 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891Ab3HAQCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:02:30 -0400
Date: Thu, 01 Aug 2013 09:02:23 -0700
Message-ID: <20130801090223.Horde.UZGId5ir309R_oaPIezA7qA@imap.linux.ibm.com>
From: Zach Levis <zml@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Zach Levis <zach@zachsthings.com>, Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + fs-binfmts-better-handling-of-binfmt-loops.patch added to -mm
 tree
References: <20130731200805.GA29678@redhat.com>
 <20130801150532.GA15349@redhat.com>
In-Reply-To: <20130801150532.GA15349@redhat.com>
User-Agent: Internet Messaging Program (IMP) H4 (5.0.22)
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080116-7182-0000-0000-000007F0223B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Oleg Nesterov <oleg@redhat.com>:

> On 07/31, Oleg Nesterov wrote:
>>
>> > From: Zach Levis <zml@linux.vnet.ibm.com>
>> > Subject: fs/binfmts: better handling of binfmt loops
>> >
>> > With these changes, when a binfmt loop is encountered, the ELOOP will
>> > propagate back to the 0 depth.  At this point the argv and argc values
>> > will be reset to what they were originally and an attempt is made to
>> > continue with the following binfmt handlers.
>>
>> I must admit, I do not really understand why do we want to recover
>> after pr_err(). Perhaps the changelog could say a bit more.
>
> And still can't. Probably I missed something, but it seems that
> this tries to "fix" the wrong /proc/sys/fs/binfmt_misc/register...
>
So an example of what this would be used for (going into commit  
message of a v2 with your earlier suggestions):
A qemu is configured to run 64-bit ELFs on an otherwise 32-bit system.  
The system's owner switches to running with 64-bit executables, but  
forgets to disable the binfmt_misc option that redirects 64bit ELFs to  
qemu. Since the qemu executable is a 64-bit ELF now, binfmt_misc keeps  
on matching it with the qemu rule, preventing the execution of any  
64-bit binary.

With this patch, an error is printed and search_binary_handler()  
continues on to the next handler, allowing the original executable to  
run normally so the user can (hopefully) fix their misconfiguration  
more easily.

>> > +
>> > +				copy_strings(bprm->argc_orig, *((struct user_arg_ptr *)  
>> bprm->argv_orig), bprm);
>>
>> Perhaps it would be more clean to add "struct user_arg_ptr;"
>> into binfmts.h and avoid the typecast.

I was kinda trying to avoid exposing the struct, but yeah, that's better.
>>
>> And I do not think we should ignore the possible error from
>> copy_strings(). Even if we know that it succeeded before, another
>> thread can, say, unmap this memory in between.
>
> And since we do copy_strings() again we probably need acct_arg_size()
> after remove_arg_zero() loop, although this is not that important.
I'm not sure if that's even necessary. It looks like there's  
copy_strings()->get_arg_page()->acct_arg_size() that's already called.
>
> And with this patch "depth == 0" check(s) look even worse, imho we
> need to cleanup this code first. And proc_exec_connector() looks
> simply wrong. I'll try to make a patch.
>
> But once again, I can be easily wrong, so please correct me.
>
> Oleg.


