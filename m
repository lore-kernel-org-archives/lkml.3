Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab3BFTlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:41:37 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:44319 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3BFTlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:41:36 -0500
MIME-Version: 1.0
In-Reply-To: <51123236.3060001@asianux.com>
References: <511217F3.6050800@asianux.com>
	<20130206085653.GQ1712@moon>
	<51123236.3060001@asianux.com>
Date: Wed, 6 Feb 2013 11:41:35 -0800
X-Google-Sender-Auth: iiDBROb6tzvUmCLC0G72yffUyrs
Message-ID: <CAGXu5jJ7AY93Qn0BuECBJprxV2MH1-DV7qMfwEQ9J0UP-cHMqw@mail.gmail.com>
Subject: Re: [PATCH] kernel: arg2 is unsigned long which is never < 0
From: Kees Cook <keescook@chromium.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 2:36 AM, Chen Gang <gang.chen@asianux.com> wrote:
> 于 2013年02月06日 16:56, Cyrill Gorcunov 写道:
>> On Wed, Feb 06, 2013 at 04:44:35PM +0800, Chen Gang wrote:
>>> >
>>> > diff --git a/kernel/sys.c b/kernel/sys.c
>>> > index 24d1ef5..568b9ca 100644
>>> > --- a/kernel/sys.c
>>> > +++ b/kernel/sys.c
>>> > @@ -2027,7 +2027,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>>> >                    error = get_dumpable(me->mm);
>>> >                    break;
>>> >            case PR_SET_DUMPABLE:
>>> > -                  if (arg2 < 0 || arg2 > 1) {
>>> > +                  if (arg2 > 1) {
>>> >                            error = -EINVAL;
>>> >                            break;
>>> >                    }
>> I guess
>>
>>       if (arg2 != SUID_DUMPABLE_DISABLED &&
>>           arg2 != SUID_DUMPABLE_ENABLED) {
>>               error = -EINVAL;
>>               break;
>>       }
>>
>> would be better. Still, current patch looks good to me.
>
> thank you for your suggestion, firstly.
>
> and after read more, it seems a little more complex:
> for me, I think it would be better:
>
>         if (arg2 != SUID_DUMP_DISABLE && arg2 != SUID_DUMP_USER) {
>                 error = -EINVAL;
>                 break;
>         }
>
>
> the reason is below:
>
> it has 2 branches:
>
>   branch 1:
>
>     #define SUID_DUMP_DISABLE      0       /* No setuid dumping */
>     #define SUID_DUMP_USER         1       /* Dump as user of process */
>     #define SUID_DUMP_ROOT         2       /* Dump as root */
>
>     in patch d6e711448137ca3301512cec41a2c2ce852b3d0a
>       Signed-of-by Alan Cox in 2005.
>       define these constant for using.
>       change 2 choices to 3 choices (add a new choice).

Ah, good find. These weren't used anywhere in the kernel, so I didn't see them.

>     in patch abf75a5033d4da7b8a7e92321d74021d1fcfb502
>       Signed-of-by Marcel Holtmann in 2006.
>       find and fix a security issue for it.
>
>
>   branch 2:
>
>     #define SUID_DUMPABLE_DISABLED  0
>     #define SUID_DUMPABLE_ENABLED   1
>     #define SUID_DUMPABLE_SAFE      2
>
>     in patch 54b501992dd2a839e94e76aa392c392b55080ce8
>       Signed-of-by Kees Cook in Jul 30 2012
>       define the constants for using
>       print warning when detect unsafe core_pattern settings
>
>     in patch 0f4cfb2e4e7a7e4e97a3e90e2ba1062f07fb2cb1
>       Signed-of-by Oleg Nesterov in Oct 4 2012
>       use SUID_DUMPABLE_ENABLED rather than hardcoded 1
>
> analysing:
>   branch 1 and branch 2 have the same values with different macro names.
>   branch 1 is much older than branch 2.
>   for features:
>     branch 1 is for functional feature and bug fix,
>     branch 2 is for printing warning and beautifying code.
>
>   it seems:
>     branch 2 did not notice the branch 1, before it performs.
>     if it noticed, it is meanless to define the new macros.

Well, it seems we'd need to add an include to gain access to binfmts.h
in once place, but that doesn't seem bad. I'll send to patch to clean
this up.

>
> result:
>   still use the macros of branch 1
>   and use branch 1 macros instead of branch 2 macros (need an additional patch).
>
>   :-)
>
>   Regards.
>
> --
> Chen Gang
>
> Asianux Corporation

-Kees

--
Kees Cook
Chrome OS Security
