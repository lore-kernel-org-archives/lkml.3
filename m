Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbaKEPc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:32:58 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:62308 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbaKEPc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:32:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAH_=xoa36gKcEpi8mSE9cedghqE4FhBCVMQNPV_1qDyk1Bb2ng@mail.gmail.com>
References: <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
 <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
 <CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
 <20141031084220.GA29085@infradead.org> <CALCETrXdPV5+qJ438Ky=tfBiEmqeeTYNuukQS7TcjbEwDgzwGQ@mail.gmail.com>
 <CA+55aFxUdjsm0gC0ULaOq_RhDLjWp=RDOE_O9qXdQRPqJUrZVA@mail.gmail.com>
 <20141103083447.GA8617@infradead.org> <CALCETrUjbfSiPUvTzTfOVAbxy5dy3PpKnnC+h4P_+FOeibTgDw@mail.gmail.com>
 <CAH_=xobsXZq9M-vXDN_+cQmvRLtgPOzHMbrnzsEToMgLD5CoxA@mail.gmail.com>
 <CA+55aFw29MUj+w46yneut2yxXOH1RQmDud5KL8V-SPyPWm1WqA@mail.gmail.com>
 <20141105082721.GB19607@infradead.org> <CAH_=xoa36gKcEpi8mSE9cedghqE4FhBCVMQNPV_1qDyk1Bb2ng@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 5 Nov 2014 07:32:34 -0800
Message-ID: <CALCETrXDq_k+7w0RXJMpPv36w_Jf+3rJiihfMxS=TFo8rq95ew@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
To: Eric Rannaud <e@nanocritical.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 7:21 AM, Eric Rannaud <e@nanocritical.com> wrote:
> On Wed, Nov 5, 2014 at 12:27 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Mon, Nov 03, 2014 at 11:04:27AM -0800, Linus Torvalds wrote:
>>> Oh, so you don't actually need any file contents at all?
>>>
>>> If that is actually a real usage, then maybe we should just say that
>>> "O_TMPFILE|O_RDONLY" is fine, and remove the check that it has to be
>>> writable.
>>
>> Wasn't this disallowed to prevent problems on old kernels that don't use
>> O_TMPFILE?  In that case we'd ignore the flag and would just get a file
>> handle for the directory instead.
>
> Yes, that was the idea at first, as discussed at
> http://article.gmane.org/gmane.linux.file-systems/76273, in commit
> bb458c644. But soon after that, O_WRONLY was allowed (ba57ea64cb1),
> and O_RDWR was removed from O_TMPFILE. Now only remain the explicit
> checks in build_open_flags() that Linus mentioned.
>
> If we allow
>     fd = open("/tmp", O_TMPFILE|O_RDONLY, 0600)
> it would be seen by an old kernel as
>     fd = open("/tmp", O_DIRECTORY|O_RDONLY, 0600)
> which will succeed.
>
> But unlike the other cases the creative definition of O_TMPFILE was
> meant to prevent, this does not create a security risk for anyone
> implementing a secure tmpfile, as they would be asking for a writable
> fd.

I have no idea whether it's a security risk, but it's a serious "wtf?!?" risk.

>
> To implement an atomic open() with O_TMPFILE+flink, if neither
> O_WRONLY nor O_RDWR is in flags, you would have to manually check with
> fstat that fd is indeed a regular file and not a directory. At least
> if you need to run on old kernels.
>
> If such a changes goes in, the man page for open(2) should talk about
> what happens on old kernels (it already has an explanation for the
> writable case).

With my occasional-API-reviewer hat on, NAK NAK NAK.  This is even
more insane than the rest of the O_TMPFILE interface.  If you want to
support this kind of use case (which seems entirely reasonable to me),
then just add a syscall, please.

Also, you can, mostly, downgrade from O_RDWR to O_RDONLY.  We could
easily add a way to downgrade all the way, I think.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
