Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934732Ab3DHDC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 23:02:59 -0400
Received: from intranet.asianux.com ([58.214.24.6]:40563 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760459Ab3DHDC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 23:02:59 -0400
X-Spam-Score: -100.7
Message-ID: <51623344.4040905@asianux.com>
Date: Mon, 08 Apr 2013 11:02:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org >> linux-kernel@vger.kernel.org" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: module: strncpy issue, using strlcpy instead
 of strncpy
References: <51615AB0.9060502@asianux.com> <CAMuHMdU+K9Kqe1JS+PCcuyf_3V1yMDe_M1r63SyEyp4ppfkpfg@mail.gmail.com> <51622FEF.2070801@asianux.com>
In-Reply-To: <51622FEF.2070801@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月08日 10:48, Chen Gang wrote:
> On 2013年04月07日 22:28, Geert Uytterhoeven wrote:
>> On Sun, Apr 7, 2013 at 1:38 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>   ownername and namebuf are all NUL terminated string.
>>>>
>>>>   need always let them ended by '\0'.
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>> ---
>>>>  kernel/module.c |    4 ++--
>>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/kernel/module.c b/kernel/module.c
>>>> index 3c2c72d..597efd8 100644
>>>> --- a/kernel/module.c
>>>> +++ b/kernel/module.c
>>>> @@ -3464,7 +3464,7 @@ const char *module_address_lookup(unsigned long addr,
>>>>         }
>>>>         /* Make a copy in here where it's safe */
>>>>         if (ret) {
>>>> -               strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
>>>> +               strlcpy(namebuf, ret, KSYM_NAME_LEN);
>>>>                 ret = namebuf;
>>>>         }
>>>>         preempt_enable();
>> Is this buffer ever copied to userspace?
> 
> 

  the key words is:
    if it knows the length of namebuf, it may need initialized namebuf.
    if it can not know the length of namebuf
      it can not initialize namebuf.
      (in our case, it only know, the namebuf length >= KSYM_NAME_LEN)

  so, it need not initialize it.

  :-)

  thanks.

gchen.


> at lease now:
>   I think, it is not, the reason is:
>     it is only a tool function for kallsyms using.
>     it has no duty to let namebuf initialized.
> 
>   please reference the related comments in include/linux/module.h
> 
> 493 /* For kallsyms to ask for address resolution.  namebuf should be at
> 494  * least KSYM_NAME_LEN long: a pointer to namebuf is returned if
> 495  * found, otherwise NULL. */
> 496 const char *module_address_lookup(unsigned long addr,
> 497                             unsigned long *symbolsize,
> 498                             unsigned long *offset,
> 499                             char **modname,
> 500                             char *namebuf);
> 
> 
> originally:
>   it will not cause issue (the upper caller has noticed it).
>   but we really need let it '\0' ended within module_address_lookup.
>     (so, maybe for subject: "strncpy issue" need be deleted)
> 
> 
> in the future:
>   since it is an extern function, it can be used by others.
>   since it is a tool function, it can not be used directly by user mode.
>   according to the api definition:
>     if it is necessary to initialize (such as return to user mode)
>       the caller should perform it.
>     if it is not necessary to initialize (not return to user mode)
>       still prefer the caller to initialize it.
>       but should understand if the caller will not initialize it.
>         (if caller does not initialize it, it should not cause issue)
> 
> 
>   thanks.
> 
>   :-)
> 
> 


-- 
Chen Gang

Asianux Corporation
