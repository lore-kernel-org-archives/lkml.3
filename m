Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3JCGXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:23:05 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45122 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab3JCGXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:23:00 -0400
Date: Thu, 3 Oct 2013 08:22:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com, Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH v2 0/9] procfs: protect /proc/<pid>/* files with
 file->f_cred
Message-ID: <20131003062256.GD25345@gmail.com>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
 <524B7999.60806@amacapital.net>
 <20131002143759.GA2966@dztty>
 <CALCETrUcg4o5QeGMP1rRAzJSfjwS=qD3DsDWV3=fPJQOA3xkKw@mail.gmail.com>
 <20131002181257.GA2485@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002181257.GA2485@dztty>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Djalal Harouni <tixxdz@opendz.org> wrote:

>  * You can't do it for /proc/*/stat otherwise you will break userspace
>   "ps"..., ps must access /proc/1/stat etc... so the proposed solution
>   will work without any side effect.

The thing is, returning -EINVAL is not the only way to reject access to 
privileged information!

In the /proc/1/stat case a compatibility quirk can solve the problem: 
create a special 'dummy' process inode for invalid accesses and give it to 
ps, with all fields present but zero.

>   And for /proc/*/maps you will perhaps break glibc under certain
>   situations... so just hold it for the moment and test it
>   later. There have been reports in the past about it.

Same deal: just create a dummy compat-quirk maps inode with constant, zero 
information contents to placate old user-space:

 00000000-00000000 ---p 00000000 00:00 0

[ Or whatever line is needed to minimally not break old userspace. ]

But don't leak privileged information!

( Maybe add a CONFIG_PROC_FS_COMPAT_QUIRKS Kconfig option, default-y for 
  now, that new/sane userspace can turn off. )

Thanks,

	Ingo
