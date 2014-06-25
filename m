Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbaFYSbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:31:52 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61332 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbaFYSbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:31:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140625182012.GA19437@redhat.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
	<1403642893-23107-10-git-send-email-keescook@chromium.org>
	<20140625142121.GD7892@redhat.com>
	<CAGXu5jJtLrjbobZC1FD4WV-Jm2p7cRGa1aSPK-d_isnfCZAHdA@mail.gmail.com>
	<20140625165209.GA14720@redhat.com>
	<CAGXu5jLHDew1fifGY_mWgwcH7evm0T8rqSnBrw4XpoAXGK+t-Q@mail.gmail.com>
	<20140625172410.GA17133@redhat.com>
	<CAGXu5jKkLS3++_dtWHnjWudVvaSR9DRwjNG3q00SmSy6XoCMaw@mail.gmail.com>
	<20140625182012.GA19437@redhat.com>
Date: Wed, 25 Jun 2014 11:31:48 -0700
X-Google-Sender-Auth: aGErAidmIooTIFiXMdWJrG37Qhc
Message-ID: <CAGXu5jLh-a2x0N+kHW7qbZSW0gOPs8v05EzBFkMYQwhft8o2aA@mail.gmail.com>
Subject: Re: [PATCH v8 9/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-arch <linux-arch@vger.kernel.org>, linux-mips@linux-mips.org,
        Will Drewry <wad@chromium.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Julien Tinnes <jln@chromium.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Drysdale <drysdale@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:20 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/25, Kees Cook wrote:
>>
>> On Wed, Jun 25, 2014 at 10:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > However, do_execve() takes cred_guard_mutex at the start in prepare_bprm_creds()
>> > and drops it in install_exec_creds(), so it should solve the problem?
>>
>> I can't tell yet. I'm still trying to understand the order of
>> operations here. It looks like de_thread() takes the sighand lock.
>> do_execve_common does:
>>
>> prepare_bprm_creds (takes cred_guard_mutex)
>> check_unsafe_exec (checks nnp to set LSM_UNSAFE_NO_NEW_PRIVS)
>> prepare_binprm (handles suid escalation, checks nnp separately)
>>     security_bprm_set_creds (checks LSM_UNSAFE_NO_NEW_PRIVS)
>> exec_binprm
>>     load_elf_binary
>>         flush_old_exec
>>             de_thread (takes and releases sighand->lock)
>>         install_exec_creds (releases cred_guard_mutex)
>
> Yes, and note that when cred_guard_mutex is dropped all other threads
> are already killed,
>
>> I don't see a way to use cred_guard_mutex during tsync (which holds
>> sighand->lock) without dead-locking. What were you considering here?
>
> Just take/drop current->signal->cred_guard_mutex along with ->siglock
> in seccomp_set_mode_filter() ? Unconditionally on depending on
> SECCOMP_FILTER_FLAG_TSYNC.

Yeah, this looks good. *whew* Testing it now, so far so good.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
