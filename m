Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3KCMmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 07:42:32 -0500
Received: from intranet.asianux.com ([58.214.24.6]:34295 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3KCMma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 07:42:30 -0500
X-Spam-Score: -100.9
Message-ID: <52764475.9000205@asianux.com>
Date: Sun, 03 Nov 2013 20:41:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/befs/linuxvfs.c: need signed cast for variable 'block'
References: <5271C5E5.6080606@asianux.com> <CAGXu5jLMU0+VkJ6N3NTKbEtL+9FwF2gMOTU86-GH6SSXQ0rc0w@mail.gmail.com> <20131031190608.GH13318@ZenIV.linux.org.uk> <CAGXu5jJkXj975rbpJo8pTLakPLLpVVse+ecxwQ7Ds2x-ARAOxQ@mail.gmail.com> <20131031204558.GA30290@kroah.com> <527314D5.7090004@asianux.com> <52750237.5060409@asianux.com> <20131102154446.GB23938@kroah.com> <20131102162744.GJ13318@ZenIV.linux.org.uk>
In-Reply-To: <20131102162744.GJ13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2013 12:27 AM, Al Viro wrote:
> On Sat, Nov 02, 2013 at 08:44:46AM -0700, Greg KH wrote:
> 
>>> Oh, for me, it is not suitable to move a file system sub-directory to
>>> "drivers/*/" sub-directory. And I can not find any sub-directory like
>>> 'staging' under "fs" sub-directory, either.
>>>
>>> Do we have any sub-directory like "staging" in "fs" sub-directory? if
>>> no, do we have to create it or have to use another ways instead of?
>>
>> Just move the filesystem to drivers/staging/befs.
> 
> Actually, having read through that code...  It's not too scary; r/w
> support would've been much more hairy, but this is just r/o.  We
> probably don't need to move that sucker at all.
> 

After a quick look, I guess we can not remove it from Linux kernel:

 - according to "fs/befs/Kconfig",
   it is only for support file system from BeOS.

 - according to "http://en.wikipedia.org/wiki/BeOS",
   BeOS is still in use (although it is almost dead).

 - according to "git log -p fs/befs",
   it is still be changed recently.

Can any members provide more proofs for it (my proofs are not enough).
if it is still using, we have to keep it in Linux kernel, else support
to remove it to some where firstly (but not "drivers/*").


> As for befs_get_block(), I'd suggest
> 	* taking the range checks for block number into its ->bmap()
> (just check against the file size and return 0 if it doesn't fit)

befs_get_block() is called both by befs_bmap() and by befs_readpage(),
and I guess Al's "->bmap()" points to befs_bmap() -- if what I guess is
incorrect, please let me know, thanks.

So for me, just remove this check "if (block < 0) { ... }" is OK which
is Kees said.

And for me, need use "%llu" not "%lu" instead of "%ld" (according to
"Documentation/printk-format.txt").


> 	* turning the check for create != 0 into BUG_ON(create)

Can we be sure of:

 - in current case, kernel/sub-system must be continuing incorrectly.
 - and if let it continue, it will cause critical issue.

If:

  can be sure of both, use BUG_ON().
  can be sure of 1st item, use WARN_ON().
  can be sure of neither, keep original no touch.

For me, if what Kees said is correct (for "ioctl ... printks ..."), I
support to use WARN_ON() which indicates "the sub-system is continuing
incorrectly, although it not a critical issue".


> 	* making the befs_fblock2brun() failure quiet - the sucker
> will complain itself, just return that -EFBIG and be done with that.
> 

Do you mean befs_fblock2brun() must be OK (should check it previously)?
If not, we cann't skip the failure -- next iaddr2blockno() may cause panic.

And for me, use "-EFBIG" is really not quite smart.

Hmm... the same reason as above (if "ioctl ... printks ..." correct),
may we need WARN_ON(), and then still return "-EFBIG"?.



BTW: the local variable 'res' can be removed.



Thanks.
-- 
Chen Gang
