Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaGHO6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:58:12 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:48339 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbaGHO6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:58:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+c2E6eG_juEDh-GyheveqScxQ=98jqO1ZOjp1PgfVBGQ@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
	<53B51E81.4090700@redhat.com>
	<20140703183927.GA1629@google.com>
	<53B651C5.80602@redhat.com>
	<CAHse=S83APPfnEwO1fQbV_tNd=9zsAsZr42KbYM_He-c3C3P6A@mail.gmail.com>
	<53BA9094.9080401@redhat.com>
	<CAADnVQ+c2E6eG_juEDh-GyheveqScxQ=98jqO1ZOjp1PgfVBGQ@mail.gmail.com>
Date: Tue, 8 Jul 2014 07:58:08 -0700
X-Google-Sender-Auth: woplADCyrlMgAjdZw3gPZcCUljg
Message-ID: <CAGXu5jLoO9QsrT6koUEXebXPh3nBpLfanxqfm0bT7Js+_Fxq4g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] Adding FreeBSD's Capsicum security framework
 (part 1)
From: Kees Cook <keescook@chromium.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Drysdale <drysdale@google.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 3:33 PM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Mon, Jul 7, 2014 at 5:20 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> Il 07/07/2014 12:29, David Drysdale ha scritto:
>>
>>>> I think that's more easily done by opening the file as O_RDONLY/O_WRONLY
>>>> /O_RDWR.   You could do it by running the file descriptor's seccomp-bpf
>>>> program once per iocb with synthesized syscall numbers and argument
>>>> vectors.
>>>
>>>
>>> Right, but generating the equivalent seccomp input environment for an
>>> equivalent single-fd syscall is going to be subtle and complex (which
>>> are worrying words to mention in a security context).  And how many
>>> other syscalls are going to need similar special-case processing?
>>> (poll? select? send[m]msg? ...)
>>
>>
>> Yeah, the difficult part is getting the right balance between:
>>
>> 1) limitations due to seccomp's impossibility to chase pointers (which is
>> not something that can be lifted, as it's required for correctness)
>
> btw once seccomp moves to eBPF it will be able to 'chase pointers',
> since pointer walking will be possible via bpf_load_pointer() function call,
> which is a wrapper of:
>   probe_kernel_read(&ptr, unsafe_ptr, sizeof(void *));
>   return ptr;
> Not sure whether it helps this case or not. Just fyi.

It won't immediately help, since threads can race pointer target
contents (i.e. seccomp sees one thing, and then the syscall see
another thing). Having an immutable memory area could help with this
(i.e. some kind of "locked" memory range that holds all the "approved"
argument strings, at which point seccomp could then trust the chased
pointers that land in this range.) Obviously eBPF is a prerequisite to
this, but it isn't the full solution, as far as I understand it.

-Kees

-- 
Kees Cook
Chrome OS Security
