Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaJTWsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:48:32 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:61411 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbaJTWs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:48:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAHse=S-Xyk7CFn=tAGzo+tuUFt+04aBw+mGQmi=kWAaBJGALBw@mail.gmail.com>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
 <87zjcszz8y.fsf@x220.int.ebiederm.org> <CAHse=S-Xyk7CFn=tAGzo+tuUFt+04aBw+mGQmi=kWAaBJGALBw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Oct 2014 15:48:06 -0700
Message-ID: <CALCETrXBjLZTWVJfcsE4NA-JP9zSSgn=6ND0=cZ9BTy=CoN7pA@mail.gmail.com>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
To: David Drysdale <drysdale@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 6:48 AM, David Drysdale <drysdale@google.com> wrote:
> On Sun, Oct 19, 2014 at 1:20 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> [Added Eric Biederman, since I think your tree might be a reasonable
>>> route forward for these patches.]
>>>
>>> On Thu, Jun 5, 2014 at 6:40 AM, David Drysdale <drysdale@google.com> wrote:
>>>> Resending, adding cc:linux-api.
>>>>
>>>> Also, it may help to add a little more background -- this patch is
>>>> needed as a (small) part of implementing Capsicum in the Linux kernel.
>>>>
>>>> Capsicum is a security framework that has been present in FreeBSD since
>>>> version 9.0 (Jan 2012), and is based on concepts from object-capability
>>>> security [1].
>>>>
>>>> One of the features of Capsicum is capability mode, which locks down
>>>> access to global namespaces such as the filesystem hierarchy.  In
>>>> capability mode, /proc is thus inaccessible and so fexecve(3) doesn't
>>>> work -- hence the need for a kernel-space
>>>
>>> I just found myself wanting this syscall for another reason: injecting
>>> programs into sandboxes or otherwise heavily locked-down namespaces.
>>>
>>> For example, I want to be able to reliably do something like nsenter
>>> --namespace-flags-here toybox sh.  Toybox's shell is unusual in that
>>> it is more or less fully functional, so this should Just Work (tm),
>>> except that the toybox binary might not exist in the namespace being
>>> entered.  If execveat were available, I could rig nsenter or a similar
>>> tool to open it with O_CLOEXEC, enter the namespace, and then call
>>> execveat.
>>>
>>> Is there any reason that these patches can't be merged more or less as
>>> is for 3.19?
>>
>> Yes.  There is a silliness in how it implements fexecve.  The fexecve
>> case should be use the empty string "" not a NULL pointer to indication
>> that.  That change will then harmonize execveat with the other ...at
>> system calls and simplify the code and remove a special case.  I believe
>> using the empty string "" requires implementing the AT_EMPTY_PATH flag.
>
> Good point -- I'll shift to "" + AT_EMPTY_PATH.

Pending a better idea, I would also see if the patches can be changed
to return an error if d_path ends up with an "(unreachable)" thing
rather than failing inexplicably later on.

--Andy
