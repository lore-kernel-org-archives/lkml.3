Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3CIXye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 18:54:34 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:34486 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3CIXyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 18:54:33 -0500
MIME-Version: 1.0
In-Reply-To: <20130309202329.GC16399@redhat.com>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
 <1362723313-839-4-git-send-email-lucas.demarchi@profusion.mobi> <20130309202329.GC16399@redhat.com>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Sat, 9 Mar 2013 20:54:10 -0300
Message-ID: <CAMOw1v52=MOZkBOrB-AGPd4Z87fu0pb+6hYEdpQFkjJQrUop=w@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] kmod: split call to call_usermodehelper_fns()
To: Oleg Nesterov <oleg@redhat.com>
Cc: lucas.de.marchi@gmail.com, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 9, 2013 at 5:23 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/08, Lucas De Marchi wrote:
>>
>> Use call_usermodehelper_setup() + call_usermodehelper_exec() instead of
>> calling call_usermodehelper_fns(). In case the latter returns -ENOMEM
>> the cleanup function may had not been called - in this case we would
>> not free argv and module_name.
>>
>> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
>
> Thanks!
>
> looks correct, but...
>
>> @@ -98,8 +100,17 @@ static int call_modprobe(char *module_name, int wait)
>>       argv[3] = module_name;  /* check free_modprobe_argv() */
>>       argv[4] = NULL;
>>
>> -     return call_usermodehelper_fns(modprobe_path, argv, envp,
>> -             wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
>> +     gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
>
> Why? it is never called with UMH_NO_WAIT,
>
>> +     info = call_usermodehelper_setup(modprobe_path, argv, envp,
>> +                                      gfp_mask, NULL, free_modprobe_argv,
>
> can't we simply use GFP_KERNEL?

True... I was preserving the previous behavior and didn't check the
callers of this function.
I'm going to send a v3.

Thanks
Lucas De Marchi
