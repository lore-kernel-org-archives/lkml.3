Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaKCS3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:29:49 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:60507 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaKCS3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:29:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAKyRK=hRX1xk_0cRNhZ341HwU9Nim5_vhpM5twJHUOt8fH29=w@mail.gmail.com>
References: <1415015305-15494-1-git-send-email-drysdale@google.com>
 <1415015305-15494-2-git-send-email-drysdale@google.com> <20141103152036.GA7996@ZenIV.linux.org.uk>
 <CALCETrWmivJCvAAZPQo9Jf5gDiSbpWKesjZWfqEQRXPOBSPY9g@mail.gmail.com>
 <CAHse=S9AGNF84cLYszPSM2q7-78+KfuTCoap7eYyMEcbx97Zyw@mail.gmail.com> <CAKyRK=hRX1xk_0cRNhZ341HwU9Nim5_vhpM5twJHUOt8fH29=w@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 10:29:21 -0800
Message-ID: <CALCETrXVLkqQNPNQRMm4Z6EGEJNNujpX_27GcV7CmQmSuSdsJQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] fs: add O_BENEATH flag to openat(2)
To: Julien Tinnes <jln@chromium.org>
Cc: David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Will Drewry <wad@chromium.org>,
        Jorge Lucangeli Obes <jorgelo@google.com>,
        Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>,
        Mike Depinet <mdepinet@google.com>,
        James Morris <james.l.morris@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 10:25 AM, Julien Tinnes <jln@chromium.org> wrote:
> On Mon, Nov 3, 2014 at 9:37 AM, David Drysdale <drysdale@google.com> wrote:
>>
>> On Mon, Nov 3, 2014 at 3:42 PM, Andy Lutomirski <luto@amacapital.net>
>> wrote:
>> > On Mon, Nov 3, 2014 at 7:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> >> On Mon, Nov 03, 2014 at 11:48:23AM +0000, David Drysdale wrote:
>> >>> Add a new O_BENEATH flag for openat(2) which restricts the
>> >>> provided path, rejecting (with -EACCES) paths that are not beneath
>> >>> the provided dfd.  In particular, reject:
>> >>>  - paths that contain .. components
>> >>>  - paths that begin with /
>> >>>  - symlinks that have paths as above.
>> >>
>> >> Yecch...  The degree of usefulness aside (and I'm not convinced that it
>> >> is non-zero),
>> >
>> > This is extremely useful in conjunction with seccomp.
>>
>> Yes, that was my understanding of how the Chrome[OS] folk wanted
>> to use it.
>
>
> Yes, exactly. Without this, if we want to give a sandboxed process A access
> to a directory, we need to:
> 1. Create a new 'broker" process B
> 2. Make sure to have an IPC channel between A and B.
> 3. SIGSYS open() and openat() in A via seccomp-bpf
> 4. Have an async-signal-safe handler that can IPC open / openat.

You can do this with user namespaces, too.  But this is way more
complicated than it should be, and it has a lot more overhead.

--Andy

>
> There is a lot of hidden complexity in such a set-up. For instance, if you
> need to prevent contention, the number of threads in the broker B should
> scale automatically.
>
> This is 'fine' (but undesirable) for a big beast such as Chromium which
> needs such a complex set-ups anyways, but David's patch would make it a lot
> easier to build a sandbox and whitelist directories for everyone, simply by
> enforcing O_BENEATH in seccomp and whitelisting open directory file
> descriptors in the sandboxed process.
>
> Julien



-- 
Andy Lutomirski
AMA Capital Management, LLC
