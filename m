Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbaGUPIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:08:19 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60381 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592AbaGUPIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:08:17 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVMk5hTAvMgL0V2ycy-P=LCtOktimw5Hst+aFYLS6jewXw@mail.gmail.com>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
	<1405373897-31671-7-git-send-email-keescook@chromium.org>
	<CACVXFVOnxjXjnKRWg7sv425POLSS96kAxxEohtLqj4dvcxnRyg@mail.gmail.com>
	<CAGXu5j+xx2exZdD64mXWzmvVUzBrFUOg-kZ5E4+tvKAuGTKW4w@mail.gmail.com>
	<CACVXFVMk5hTAvMgL0V2ycy-P=LCtOktimw5Hst+aFYLS6jewXw@mail.gmail.com>
Date: Mon, 21 Jul 2014 08:08:16 -0700
X-Google-Sender-Auth: 2ZwQQEJdUMbVbgFHlH-w3cXcOS8
Message-ID: <CAGXu5jLD=9cqzV90JKEBJjwzTXVzGhz9_1nnwFCG_0zcA1TE8A@mail.gmail.com>
Subject: Re: [PATCH 6/7] firmware_class: add "fd" input file
From: Kees Cook <keescook@chromium.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 6:42 PM, Ming Lei <ming.lei@canonical.com> wrote:
> On Mon, Jul 21, 2014 at 1:43 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Sat, Jul 19, 2014 at 8:04 PM, Ming Lei <ming.lei@canonical.com> wrote:
>>> On Tue, Jul 15, 2014 at 5:38 AM, Kees Cook <keescook@chromium.org> wrote:
>>>> As an alternative to loading bytes from the "data" blob when reading
>>>> firmware, let kernel read from an fd, so that the LSM can reason about
>>>> the origin of firmware contents during userspace on-demand loading.
>>>
>>> From user space view, maybe it is better to keep previous usage and just
>>> check if loading is from 'data' blob or fd in 'echo 0 > loading' of
>>> firmware_loading_store(), then the 'fd' usage becomes very similar with
>>> before.
>>
>> I don't think this is a good idea because otherwise there isn't a good
>> way to have an "atomic" check of the firmware contents. What does it
>
> Could you share why 'atomic' check is necessary? As we know, it isn't
> real atomic, :-).

Right, I don't really mean actually atomic. I just mean "a single
write operation for loading a single firmware".

>> means to write to "fd" several times, then write "data" a little,
>> before writing "loading", etc? I originally wrote the patch series
>
> That depends how firmware loader supports these cases, and won't
> be difficult to handle them.
>
> For non-fd userspace interface, it is very flexible to be capable of
> supporting to load firmware data from multiple images, or in flight.
> With single 'fd' interface, it won't be possible any more.

That's entirely correct. But I'm not suggesting replacing loading/data
with fd, I'm suggesting adding an additional separate interface. Any
system that wants to generate non-file-backed firmware or do multiple
images at once can continue to use the loading/data interface.

However, since nearly all systems currently use udev and its firmware
helper that reads from single files, this change allows the bulk of
systems to be able to reason via the LSM about the origin of
userspace-delivered firmwares.

>> requiring the "loading" piece, and it ended up being very complicated
>> due to needing to switch the memory buffer logic back and forth.
>> Everything is much much cleaner if "fd" is single-shot, and not part
>> of the loading/data interface semantics.
>
> You might not avoid the 'loading' piece completely, how does
> the userspace handle non-exist firmware image? The reasonable
> way is to abort the loading from userspace via 'echo -1 > loading'
> since userspace already sees that, and you may choose to let kernel
> side handle that, but your current patch doesn't support it yet.

That's not true -- my series doesn't remove or change any of the
existing interface behavior. If userspace doesn't find a firmware
image, it can still write -1 into loading. What I've added is simply a
new way to load the firmware, in line with finit_module and
kexec_file_load: we need to be able to load files from userspace via
fd instead of via blobs.

There is no reason for the fd interface to use "loading" to indicate
it's state. First, it's redundant: loading starts the moment fd_store
is called: from the userspace perspective, the entire load process
happens during that write. Once the write returns, loading has
finished. Adding the requirement for writing "loading" before and
after complicates userspace and complicates kernel-space since now it
must distinguish between fw_buf's is_paged_buf state, and determine
how to interact with intermixed calls to "data". For example, what
would this mean:

echo 1 > loading
write to data
write to fd
echo 0 > loading

With my current patch, writes to "fd" will be rejected if a write to
"loading" has happened, to be able to trivially distinguish between
the two interfaces, and to keep sanity in the state of is_paged_buf
logic.

It seems to me that keeping the interfaces separate makes the most
sense and provides the cleanest approach.

Perhaps it would be easier if I also sent the patch to udev's helper,
so you could see how I propose handling the userspace change to using
the new interface?

-Kees

-- 
Kees Cook
Chrome OS Security
