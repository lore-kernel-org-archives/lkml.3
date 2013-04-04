Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764048Ab3DDRdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:33:23 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61811 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763907Ab3DDRdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:33:22 -0400
MIME-Version: 1.0
In-Reply-To: <515D23D5.70805@jp.fujitsu.com>
References: <1365035906-3208-1-git-send-email-yinghai@kernel.org>
	<1365035906-3208-5-git-send-email-yinghai@kernel.org>
	<515D23D5.70805@jp.fujitsu.com>
Date: Thu, 4 Apr 2013 10:33:21 -0700
X-Google-Sender-Auth: SBdGpoPoHx1_GajWqP-SVz3r3Ag
Message-ID: <CAE9FiQXBd6+Np0ejuFa-hyBsNFnqNVoDXg+XyPU3ZZuuMPkqXw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] x86, kdump: Change crashkernel_high/low= to crashkernel=;high/low
From: Yinghai Lu <yinghai@kernel.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 11:55 PM, HATAYAMA Daisuke
<d.hatayama@jp.fujitsu.com> wrote:
> (2013/04/04 9:38), Yinghai Lu wrote:
>
>> Index: linux-2.6/kernel/kexec.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/kexec.c
>> +++ linux-2.6/kernel/kexec.c
>> @@ -1360,7 +1360,7 @@ static int __init parse_crashkernel_simp
>>
>>       if (*cur == '@')
>>               *crash_base = memparse(cur+1, &cur);
>> -     else if (*cur != ' ' && *cur != '\0') {
>> +     else if (*cur != ' ' && *cur != ';' && *cur != '\0') {
>>               pr_warning("crashkernel: unrecognized char\n");
>>               return -EINVAL;
>>       }
>
> As I said below, ";high" or ";low" check should be here. It would be
> enough to replace the condition *cur != ';' by strncmp(cur, ";high", 5)
> || strncmp(cur, ";low", 4).

Good catch, will use that strict checking.

>
>> @@ -1368,58 +1368,108 @@ static int __init parse_crashkernel_simp
>>       return 0;
>>   }
>>
>> -/*
>> - * That function is the entry point for command line parsing and should be
>> - * called from the arch-specific code.
>> - */
>> +#define SUFFIX_HIGH 0
>> +#define SUFFIX_LOW  1
>> +#define SUFFIX_NULL 2
>> +static __initdata char *suffix_tbl[] = {
>> +     [SUFFIX_HIGH] = ";high",
>> +     [SUFFIX_LOW]  = ";low",
>> +     [SUFFIX_NULL] = NULL,
>> +};
>> +
>> +static __init char *get_last_crashkernel(char *cmdline,
>> +                          const char *name,
>> +                          const char *suffix)
>> +{
>> +     char *p = cmdline, *ck_cmdline = NULL;
>> +
>> +     /* find crashkernel and use the last one if there are more */
>
> Why did you choose the last one? Is there any reason you didn't choose
> the first one?

I split the function out, and keep the old comments.

Also that is default behavior of early_param and __setup() handling,
last one will be take effective.

>
> Also, it's better to describe this bahaviour in
> Documentations/kernel-parameter.txt.
>
>> +     p = strstr(p, name);
>> +     while (p) {
>> +             char *end_p = strchr(p, ' ');
>> +             char *q;
>> +
>> +             if (!end_p)
>> +                     end_p = p + strlen(p);
>> +
>> +             if (!suffix) {
>> +                     int i;
>> +
>> +                     /* skip the one with any known suffix */
>> +                     for (i = 0; suffix_tbl[i]; i++) {
>> +                             q = end_p - strlen(suffix_tbl[i]);
>> +                             if (!strncmp(q, suffix_tbl[i],
>> +                                          strlen(suffix_tbl[i])))
>> +                                     goto next;
>> +                     }
>> +                     ck_cmdline = p;
>> +             } else {
>> +                     q = end_p - strlen(suffix);
>> +                     if (!strncmp(q, suffix, strlen(suffix)))
>> +                             ck_cmdline = p;
>> +             }
>
> It looks to me that this function does more than its name suggests. It
> seems to me enough to get the last occurence of "crashkernel=<some
> value>" and to leave the "<some value>" unknown for now.

ok will move
     ck_cmdline += strlen(name);

down.

>
> The current code of yours checks if each "crashkernel=<some value>"
> detected by strstr() ends with each of ";high" or ";low", but doesn't
> check the formeter letters at all; e.g, "crashkernel=foobar;high" is passed.

that should be ok, later parse...simple will report error.

>
> Also, this function can be called in different contexts: from a variant
> of parse_crashkernel_*(). Is it better to move this function in
> reserve_crashkernel() and then pass the obtained "crashkernel=<some
> value>" to a variant of parse_crashkernel_*() functions?

Do you mean calling get_last_crashkernel directly from reserve_crashkernel
directly?

I think we could keep parse_crashkernel_*() call it directly, so could have less
change in arch/x86/kernel/setup.c.

Thanks

Yinghai
