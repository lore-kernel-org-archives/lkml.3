Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaGKWsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:48:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56664 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaGKWsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <1433620.8yKm3TZIWM@sifl>
References: <cover.1405023592.git.rgb@redhat.com>
	<13645924.XpBzvDVILV@sifl>
	<1405103466.2357.5.camel@flatline.rdu.redhat.com>
	<1433620.8yKm3TZIWM@sifl>
Date: Fri, 11 Jul 2014 15:48:22 -0700
X-Google-Sender-Auth: LQkUwdycx-657fCZcm6_QZGHQRw
Message-ID: <CAGXu5jKVuE34Ly3g885270gLQavyA0UdQZaV41HoNunRDPOC4A@mail.gmail.com>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32 filter
From: Kees Cook <keescook@chromium.org>
To: Paul Moore <pmoore@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <aviro@redhat.com>,
        Will Drewry <wad@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Chris Evans <cevans@google.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Tyler Hicks <tyhicks@canonical.com>, stgraber@ubuntu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:36 PM, Paul Moore <pmoore@redhat.com> wrote:
> Anyway, getting back to the idea I mentioned earlier ... as many of you may
> know, Kees (added to the CC line) is working on some seccomp filter
> improvements which will result in a new seccomp syscall.  Perhaps one way
> forward is to preserve everything as it is currently with the prctl()
> interface, but with the new seccomp() based interface we fixup x32 and use the
> new AUDIT_ARCH_X32 token?  It might result in a bit of ugliness in some of the
> kernel, but I don't think it would be too bad, and I think it would address
> both our concerns.

Adding AUDIT_ARCH_X32: yes please. (On that note, the comment "/* Both
x32 and x86_64 are considered "64-bit". */" should be changed...)

Just so I understand: currently x86_64 and x32 both present as
AUDIT_ARCH_X86_64. The x32 syscalls are seen as in a different range
(due to the set high bit).

The seccomp used in Chrome, Chrome OS, and vsftpd should all only do
whitelisting by both arch and syscall, so adding AUDIT_ARCH_X32
without setting __X32_SYSCALL_BIT would be totally fine (it would
catch the arch instead of the syscall). This sounds similar to how
libseccomp is doing things, so these should be fine.

The only project I know of doing blacklisting is lxc, and Eric's
example looks a lot like a discussion I saw with lxc and init_module.
:) So it sounds like we can get this right there.

I'd like to avoid carrying a delta on filter logic based on the prctl
vs syscall entry. Can we find any userspace filters being used that a
"correct" fix would break? (If so, then yes, we'll need to do this
proposed "via prctl or via syscall?" change.)

-Kees

-- 
Kees Cook
Chrome OS Security
