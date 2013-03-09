Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab3CIX5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 18:57:24 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:46275 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3CIX5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 18:57:23 -0500
MIME-Version: 1.0
In-Reply-To: <20130309204242.GA17303@redhat.com>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
 <1362723313-839-7-git-send-email-lucas.demarchi@profusion.mobi> <20130309204242.GA17303@redhat.com>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Sat, 9 Mar 2013 20:57:02 -0300
Message-ID: <CAMOw1v5vOsx0mzuYSJc39E3XFY+U3RC4eezeE7MoPWzssz6jew@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] Split remaining calls to call_usermodehelper_fns()
To: Oleg Nesterov <oleg@redhat.com>
Cc: lucas.de.marchi@gmail.com, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 9, 2013 at 5:42 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/08, Lucas De Marchi wrote:
>>
>> @@ -571,9 +572,17 @@ void do_coredump(siginfo_t *siginfo)
>>                       goto fail_dropcount;
>>               }
>>
>> -             retval = call_usermodehelper_fns(helper_argv[0], helper_argv,
>> -                                     NULL, UMH_WAIT_EXEC, umh_pipe_setup,
>> -                                     NULL, &cprm);
>> +             sub_info = call_usermodehelper_setup(helper_argv[0],
>> +                                             helper_argv, NULL, GFP_KERNEL,
>> +                                             umh_pipe_setup, NULL, &cprm);
>> +             if (!sub_info) {
>> +                     printk(KERN_WARNING "%s failed to allocate memory\n",
>> +                            __func__);
>
> Why?
>
>> +                     argv_free(helper_argv);
>> +                     goto fail_dropcount;
>> +             }
>> +
>> +             retval = call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
>
> I do not really like another argv_free() here... How about
>
>                 retval = -ENOMEM;
>                 info = call_usermodehelper_setup(...);
>                 if (info)
>                         retval = call_usermodehelper_fns(...);
>                 argv_free();
>
> ?

Looks good. I'll prepare a v3

Thanks
Lucas De Marchi
