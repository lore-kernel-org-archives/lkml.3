Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3DLG0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 02:26:08 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:64298 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3DLG0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 02:26:06 -0400
MIME-Version: 1.0
In-Reply-To: <51679FB2.9080309@jp.fujitsu.com>
References: <1365622759-2133-1-git-send-email-yinghai@kernel.org>
	<1365622759-2133-5-git-send-email-yinghai@kernel.org>
	<51679FB2.9080309@jp.fujitsu.com>
Date: Thu, 11 Apr 2013 23:26:05 -0700
X-Google-Sender-Auth: aICaBMUqPEecz6k6QBTts6i-01U
Message-ID: <CAE9FiQW2LP8YDgBAiYj0F_DwVL_grvMgXJxe7GjSob1aZJvvqA@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] x86, kdump: Change crashkernel_high/low= to crashkernel=,high/low
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

On Thu, Apr 11, 2013 at 10:46 PM, HATAYAMA Daisuke
<d.hatayama@jp.fujitsu.com> wrote:
> (2013/04/11 4:39), Yinghai Lu wrote:
> <cut>
>> Index: linux-2.6/kernel/kexec.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/kexec.c
>> +++ linux-2.6/kernel/kexec.c
>> @@ -1368,35 +1368,108 @@ static int __init parse_crashkernel_simp
>>       return 0;
>>   }
>>
>> +#define SUFFIX_HIGH 0
>> +#define SUFFIX_LOW  1
>> +#define SUFFIX_NULL 2
>> +static __initdata char *suffix_tbl[] = {
>> +     [SUFFIX_HIGH] = ",high",
>> +     [SUFFIX_LOW]  = ",low",
>> +     [SUFFIX_NULL] = NULL,
>> +};
>> +
>>   /*
>> - * That function is the entry point for command line parsing and should be
>> - * called from the arch-specific code.
>> + * That function parses "suffix"  crashkernel command lines like
>> + *
>> + *   crashkernel=size,[high|low]
>> + *
>> + * It returns 0 on success and -EINVAL on failure.
>>    */
>> +static int __init parse_crashkernel_suffix(char *cmdline,
>> +                                        unsigned long long   *crash_size,
>> +                                        unsigned long long   *crash_base,
>> +                                        const char *suffix)
>> +{
>> +     char *cur = cmdline;
>> +
>> +     *crash_size = memparse(cmdline, &cur);
>> +     if (cmdline == cur) {
>> +             pr_warn("crashkernel: memory value expected\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* check with suffix */
>> +     if (!strncmp(cur, suffix, strlen(suffix)))
>> +             return 0;
>
> What kind of strings do you intend to be passed here? The syntax that
> matches this check would be
>
>   [0-9]+[kmgKMG]?(,low|,high){.*(,low|,high)}*

should be
[0-9]+[kmgKMG](,low|,high)

will tight the checking.

>
> though memparse() part might be less precise. For example, the following
> one passes the check since it ends with ",low" and  ",high" follows
> "12345K" to be parsed by memparse(). Is this within your intension for
> ease of implementation?
>
>   crashkernel=12345K,highfoobar,highabcd,low

it will be rejected.

crashkernel=12345K,highfoobar,highabcd,high
should be rejected too.

>
>> +
>> +     pr_warn("crashkernel: unrecognized char\n");
>> +     return -EINVAL;
>> +}
>
> I like functions checking errornous cases in the middle and ends with
> successful case. How about:
>
> /* check with suffix */
> if (strncmp(cur, suffix, strlen(suffix)) {
>     pr_warn("crashkernel: unrecognized char\n");
>     return -EINVAL;
> }
>
> return 0;

ok.
