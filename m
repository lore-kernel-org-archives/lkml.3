Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab3CLRyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:54:24 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:48866 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3CLRyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com>
References: <1363058712.4534.12.camel@pasglop> <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 12 Mar 2013 14:54:02 -0300
Message-ID: <CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com>
Subject: Re: Regression with orderly_poweroff()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Hong <hongfeng@marvell.com>, Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 11:46 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Mar 11, 2013 at 8:25 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>>
>> A couple of weeks ago, David sent an email that went unanswered about a
>> regression concerning orderly_poweroff(). I think the original patch
>> causing it should be reverted, here's the actual email with the
>> explanation:
>
> Hmm.. You should really have cc'd the people who acked it and were in
> the sign-off chain too, because all those people are involved with the
> patch as well.
>
> Also, the patch doesn't revert cleanly any more after commit
> 7ff6764061ec ("usermodehelper: cleanup/fix __orderly_poweroff() &&
> argv_free()") which seems to be a real bug-fix for a double free, but
> which really doesn't seem to work together with UMH_NO_WAIT.

Yep, using it in that way with UMH_NO_WAIT will not work.

>
> So before reverting that one too, let's at least get the people who
> were involved with the original patch (and the bugfix that relies on
> it) in the email thread.

I have some pending patches on LKML to remove
call_usermodehelper_fns() and export call_usermodehelper_{setup,exec}.
 Doing this we can separate the allocation part using GFP_ATOMIC in
order to make it work on interrupt context. May I suggest going with
something like below after that patches are applied (sorry, whitespace
damaged)? I can also rework the patch series so this can be applied
regardless of the rest.


Lucas De Marchi

diff --git a/kernel/sys.c b/kernel/sys.c
index bd15276..6df5ec7 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2194,7 +2194,8 @@ static int __orderly_poweroff(void)
  "PATH=/sbin:/bin:/usr/sbin:/usr/bin",
  NULL
  };
- int ret;
+ struct subprocess_info *info;
+ int ret = -ENOMEM;

  argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
  if (argv == NULL) {
@@ -2203,7 +2204,10 @@ static int __orderly_poweroff(void)
  return -ENOMEM;
  }

- ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+ info = call_usermodehelper_setup(argv[0], argv, envp, GFP_ATOMIC,
+ NULL, NULL, NULL);
+ if (info)
+ ret = call_usermodehelper_exec(info, UMH_WAIT_EXEC);
  argv_free(argv);

  return ret;
