Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3CIXz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 18:55:59 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:52307 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab3CIXz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 18:55:58 -0500
MIME-Version: 1.0
In-Reply-To: <20130309202537.GD16399@redhat.com>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
 <1362723313-839-5-git-send-email-lucas.demarchi@profusion.mobi> <20130309202537.GD16399@redhat.com>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Sat, 9 Mar 2013 20:55:37 -0300
Message-ID: <CAMOw1v5OHc9EmS3WENQStu8W=Q2_+K1o=khru8sQmMUNQjU8cA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KEYS: split call to call_usermodehelper_fns()
To: Oleg Nesterov <oleg@redhat.com>
Cc: lucas.de.marchi@gmail.com, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 9, 2013 at 5:25 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/08, Lucas De Marchi wrote:
>>
>>  static int call_usermodehelper_keys(char *path, char **argv, char **envp,
>>                                       struct key *session_keyring, int wait)
>>  {
>> -     return call_usermodehelper_fns(path, argv, envp, wait,
>> -                                    umh_keys_init, umh_keys_cleanup,
>> -                                    key_get(session_keyring));
>> +     struct subprocess_info *info;
>> +
>> +     info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL,
>> +                                       umh_keys_init, umh_keys_cleanup,
>> +                                       key_get(session_keyring));
>> +     if (!info) {
>> +             key_put(session_keyring);
>> +             return -ENOMEM;
>> +     }
>> +
>> +     return call_usermodehelper_exec(info, wait);
>
> Looks correct, but can't we simpluify it a bit?
>
>         info = call_usermodehelper_setup(session_keyring);
>         if (!info)
>                 return ENOMEM;
>
>         key_get(session_keyring));
>         return call_usermodehelper_exec(info);

Yep, looks better this way.

Lucas De Marchi
