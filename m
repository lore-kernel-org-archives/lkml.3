Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaKTL2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:28:48 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:61888 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaKTL2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:28:43 -0500
MIME-Version: 1.0
In-Reply-To: <20141120104223.2cea8043@canb.auug.org.au>
References: <1416418072-18639-1-git-send-email-drysdale@google.com>
 <1416418072-18639-5-git-send-email-drysdale@google.com> <20141120104223.2cea8043@canb.auug.org.au>
From: David Drysdale <drysdale@google.com>
Date: Thu, 20 Nov 2014 11:28:22 +0000
Message-ID: <CAHse=S--yNmP5sTr2kg_7kb2V8Lh2FioTSH_o23MstVrdt4Wmw@mail.gmail.com>
Subject: Re: [PATCHv9 4/5] sparc: Hook up execveat system call.
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:42 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi David,
>
> On Wed, 19 Nov 2014 17:27:51 +0000 David Drysdale <drysdale@google.com> wrote:
>>
>> diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
>> index 580cde9370c9..15069cb35dac 100644
>> --- a/arch/sparc/kernel/systbls_64.S
>> +++ b/arch/sparc/kernel/systbls_64.S
>> @@ -88,6 +88,7 @@ sys_call_table32:
>>       .word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm_readv, compat_sys_process_vm_writev
>>  /*340*/      .word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
>>       .word sys32_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
>> +/*350*/      .word sys_execveat
>
> Shouldn't this be compat_sys_execveat?

Yeah, that would make sense -- thanks for spotting.

Looking at this more closely, I also wonder if we need a pair of wrappers
analogous to sys(32|64)_execve -- they include a (pipeline-executed)
flushw instruction after the jmpl to [compat_]sys_execve, which I guess
might be needed.  So I could add something like the following to
arch/sparc/kernel/syscalls.S:

  sys64_execveat:
      set sys_execveat, %g1
      jmpl %g1, %g0
      flushw
  #ifdef CONFIG_COMPAT
  sys32_execveat:
      set compat_sys_execveat, %g1
      jmpl %g1, %g0
      flushw
  #endif

However, I don't speak SPARC and can't run the code -- any thoughts
out there from someone who does & can?

Or maybe I should stop trying to be helpful with speculative patches, and
just leave wiring up the sparc stuff to the experts...

>>
>>  #endif /* CONFIG_COMPAT */
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
