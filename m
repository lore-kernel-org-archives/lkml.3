Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaGGWd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:33:56 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:62614 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaGGWdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:33:53 -0400
MIME-Version: 1.0
In-Reply-To: <53BA9094.9080401@redhat.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
	<53B51E81.4090700@redhat.com>
	<20140703183927.GA1629@google.com>
	<53B651C5.80602@redhat.com>
	<CAHse=S83APPfnEwO1fQbV_tNd=9zsAsZr42KbYM_He-c3C3P6A@mail.gmail.com>
	<53BA9094.9080401@redhat.com>
Date: Mon, 7 Jul 2014 15:33:52 -0700
Message-ID: <CAADnVQ+c2E6eG_juEDh-GyheveqScxQ=98jqO1ZOjp1PgfVBGQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] Adding FreeBSD's Capsicum security framework
 (part 1)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Drysdale <drysdale@google.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 5:20 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 07/07/2014 12:29, David Drysdale ha scritto:
>
>>> I think that's more easily done by opening the file as O_RDONLY/O_WRONLY
>>> /O_RDWR.   You could do it by running the file descriptor's seccomp-bpf
>>> program once per iocb with synthesized syscall numbers and argument
>>> vectors.
>>
>>
>> Right, but generating the equivalent seccomp input environment for an
>> equivalent single-fd syscall is going to be subtle and complex (which
>> are worrying words to mention in a security context).  And how many
>> other syscalls are going to need similar special-case processing?
>> (poll? select? send[m]msg? ...)
>
>
> Yeah, the difficult part is getting the right balance between:
>
> 1) limitations due to seccomp's impossibility to chase pointers (which is
> not something that can be lifted, as it's required for correctness)

btw once seccomp moves to eBPF it will be able to 'chase pointers',
since pointer walking will be possible via bpf_load_pointer() function call,
which is a wrapper of:
  probe_kernel_read(&ptr, unsafe_ptr, sizeof(void *));
  return ptr;
Not sure whether it helps this case or not. Just fyi.

> 2) subtlety and complexity of the resulting code.
>
> The problem stems when you have a single a single syscall operating on
> multiple file descriptors.  So for example among the cases you mention poll
> and select are problematic; sendm?msg are not.  They would be if Capsicum
> had a capability for SCM_RIGHTS file descriptor passing, but I cannot find
> it.
>
> But then you also have to strike the right balance between a complete
> solution and an overengineered one.
>
> For example, even though poll and select are problematic, I wonder what
> would really the point be in blocking them; poll/select are level-triggered,
> and calling them should be idempotent as far as the file descriptor is
> concerned.  If you want to prevent a process/thread from issuing blocking
> system calls, but you'd do that with a per-process filter, not with
> per-file-descriptor filters or capabilities.
>
>
>> Capsicum capabilities are associated with the file descriptor (a la
>> F_GETFD), not the open file itself -- different FDs with different
>> associated rights can map to the same underlying open file.
>
>
> Good to know, thanks.  I suppose you have testcases that cover this.
>
> Paolo
> --
>
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
