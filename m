Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaGKW6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:58:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40116 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaGKW6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:58:10 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAGXu5jLnyvbnjadgMaee816zN9XFcB2HQUHWusCH0viEAZ3o2Q@mail.gmail.com>
References: <cover.1405023592.git.rgb@redhat.com> <13645924.XpBzvDVILV@sifl> <1405103466.2357.5.camel@flatline.rdu.redhat.com> <1433620.8yKm3TZIWM@sifl> <CAGXu5jKVuE34Ly3g885270gLQavyA0UdQZaV41HoNunRDPOC4A@mail.gmail.com> <CAGXu5jLnyvbnjadgMaee816zN9XFcB2HQUHWusCH0viEAZ3o2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32 filter
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 11 Jul 2014 15:55:55 -0700
To: Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>
CC: Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <aviro@redhat.com>, Will Drewry <wad@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>, Chris Evans <cevans@google.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Tyler Hicks <tyhicks@canonical.com>, stgraber@ubuntu.com
Message-ID: <4fa3f909-9bf8-447d-99de-ce93ebc6d27e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It includes the X32 bit.

On July 11, 2014 3:52:42 PM PDT, Kees Cook <keescook@chromium.org> wrote:
>On Fri, Jul 11, 2014 at 3:48 PM, Kees Cook <keescook@chromium.org>
>wrote:
>> On Fri, Jul 11, 2014 at 12:36 PM, Paul Moore <pmoore@redhat.com>
>wrote:
>>> Anyway, getting back to the idea I mentioned earlier ... as many of
>you may
>>> know, Kees (added to the CC line) is working on some seccomp filter
>>> improvements which will result in a new seccomp syscall.  Perhaps
>one way
>>> forward is to preserve everything as it is currently with the
>prctl()
>>> interface, but with the new seccomp() based interface we fixup x32
>and use the
>>> new AUDIT_ARCH_X32 token?  It might result in a bit of ugliness in
>some of the
>>> kernel, but I don't think it would be too bad, and I think it would
>address
>>> both our concerns.
>>
>> Adding AUDIT_ARCH_X32: yes please. (On that note, the comment "/*
>Both
>> x32 and x86_64 are considered "64-bit". */" should be changed...)
>>
>> Just so I understand: currently x86_64 and x32 both present as
>> AUDIT_ARCH_X86_64. The x32 syscalls are seen as in a different range
>> (due to the set high bit).
>>
>> The seccomp used in Chrome, Chrome OS, and vsftpd should all only do
>> whitelisting by both arch and syscall, so adding AUDIT_ARCH_X32
>> without setting __X32_SYSCALL_BIT would be totally fine (it would
>> catch the arch instead of the syscall). This sounds similar to how
>> libseccomp is doing things, so these should be fine.
>
>I should clarify: seccomp expects to find whatever is sent as the
>syscall nr... as in the __NR_read used like this:
>
>                BPF_STMT(BPF_LD+BPF_W+BPF_ABS,
>                        offsetof(struct seccomp_data, nr)),
>                BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, __NR_read, 0, 1),
>                BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_KILL),
>                BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
>
>Are there native x32 users yet? What does __NR_read resolve to via the
>uapi on a native x32 userspace?
>
>-Kees
>
>> The only project I know of doing blacklisting is lxc, and Eric's
>> example looks a lot like a discussion I saw with lxc and init_module.
>> :) So it sounds like we can get this right there.
>>
>> I'd like to avoid carrying a delta on filter logic based on the prctl
>> vs syscall entry. Can we find any userspace filters being used that a
>> "correct" fix would break? (If so, then yes, we'll need to do this
>> proposed "via prctl or via syscall?" change.)
>>
>> -Kees
>>
>> --
>> Kees Cook
>> Chrome OS Security

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
