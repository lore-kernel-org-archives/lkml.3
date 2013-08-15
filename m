Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153Ab3HOQ1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:27:11 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:58082 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab3HOQ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:27:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130814175014.GA1080@redhat.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
 <1376497898-18619-3-git-send-email-zach@zachsthings.com> <20130814175014.GA1080@redhat.com>
From: Zach L <zach@zachsthings.com>
Date: Thu, 15 Aug 2013 09:26:34 -0700
Message-ID: <CADAMjFkDgyH+X=4UnNEKwgjjf4DxDvzkcKxJQpzLFnKL-ajK2Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] fs/binfmts: Better handling of binfmt loops
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.carpenter@oracle.com, keescook@chromium.org,
        cody@linux.vnet.ibm.com, zml@linux.vnet.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 10:50 AM, Oleg Nesterov wrote:
> On 08/14, Zach Levis wrote:
>>
>> Example: a qemu is configured to run 64-bit ELFs on an otherwise 32-bit
>> system. The system's owner switches to running with 64-bit executables,
>> but forgets to disable the binfmt_misc option that redirects 64bit ELFs
>> to qemu. Since the qemu executable is a 64-bit ELF now, binfmt_misc
>> keeps on matching it with the qemu rule, preventing the execution of any
>> 64-bit binary.
>
> Honestly, I dislike this version even more, sorry. The patch becomes
> much more complex, and and it is still not clear to me why do we want
> these complications.
>
It's a larger patch but the majority of the increase is from is
splitting the binfmt initialization code into a separate function to
address the issue you brought up where the state of the binprm was not
entirely restored
>> My (rough, but functional) test scripts for this issue are available at:
>>      https://gist.github.com/zml2008/6075418
>
> Well, suppose that someone tries to read this changelog in 2014 to
> understand the code. Are you sure this link will be still alive?
fairly likely github will be around for a while, but will put the
contents in the commit msg to be safer
>
> It would be better to have everything in the changelog, if possible.
>
>> +static void put_binfmts(struct linux_binprm *bprm, struct linux_binfmt *cur_fmt)
>> +{
>> +    if (bprm->previous_binfmts[1])
>> +        put_binfmt(bprm->previous_binfmts[1]);
>> +    if (bprm->previous_binfmts[0])
>> +        put_binfmt(bprm->previous_binfmts[0]);
>> +    if (cur_fmt)
>> +        put_binfmt(cur_fmt);
>> +}
>
> I didn't actually read this patch, but at first glance this doesn't look
> right. Just suppose that ->load_binary() succeeds at depth = N, this will
> be called N times.
ok, I've moved things around so this is only called once
>
[snip]
>
> And btw, if we want this, then why we only do this if recursion_depth == 0?
> Just condider '#!/path-to-the-binary-which-wants-this-patch".
Unless recursion_depth is 0, there could be a binfmt in between that
would expect its changes to the binprm to remain in effect in lower
handlers, so even with your example
>
> And again, the patch (afaics) translates -ELOOP into -ENOEXEC on failure,
> not good.
it doesn't do that, but init_binprm reset the return value to success,
which is worse. going to be fixed in the next revision
>
> Oleg.
>
