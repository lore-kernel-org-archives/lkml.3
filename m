Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964903Ab3DIPB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:01:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49015 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933250Ab3DIPB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:01:26 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130409134544.GA6320@redhat.com>
References: <1365113821-22749-1-git-send-email-yinghai@kernel.org> <1365113821-22749-5-git-send-email-yinghai@kernel.org> <20130409134544.GA6320@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 3/4] x86, kdump: Change crashkernel_high/low= to crashkernel=;high/low
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 09 Apr 2013 08:00:57 -0700
To: Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Message-ID: <b591d6e4-5468-48f1-8b7e-c6a3943214cd@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, no semicolons. We already have established syntax for suboptions (option=suboption,suboption,...) and suboptions with parameters (option=suboption:value,...)

Vivek Goyal <vgoyal@redhat.com> wrote:

>On Thu, Apr 04, 2013 at 03:17:01PM -0700, Yinghai Lu wrote:
>
>[..]
>> @@ -1360,37 +1369,80 @@ static int __init parse_crashkernel_simp
>>  
>>  	if (*cur == '@')
>>  		*crash_base = memparse(cur+1, &cur);
>> -	else if (*cur != ' ' && *cur != '\0') {
>> -		pr_warning("crashkernel: unrecognized char\n");
>> -		return -EINVAL;
>> +	else {
>> +		int i;
>> +
>> +		/* check with known suffix */
>> +		for (i = 0; suffix_tbl[i]; i++)
>> +			if (!strncmp(cur, suffix_tbl[i], strlen(suffix_tbl[i])))
>> +				return 0;
>> +
>
>So crashkernel=X@Y;high is a valid syntax? Looks like we will reserve
>X amount of RAM at base Y and ignore "high" or "low".
>
>[..]
>>  static int __init __parse_crashkernel(char *cmdline,
>>  			     unsigned long long system_ram,
>>  			     unsigned long long *crash_size,
>>  			     unsigned long long *crash_base,
>> -				const char *name)
>> +			     const char *name,
>> +			     const char *suffix,
>> +			     bool simple_only)
>>  {
>> -	char 	*p = cmdline, *ck_cmdline = NULL;
>>  	char	*first_colon, *first_space;
>> +	char	*ck_cmdline;
>>  
>>  	BUG_ON(!crash_size || !crash_base);
>>  	*crash_size = 0;
>>  	*crash_base = 0;
>>  
>> -	/* find crashkernel and use the last one if there are more */
>> -	p = strstr(p, name);
>> -	while (p) {
>> -		ck_cmdline = p;
>> -		p = strstr(p+1, name);
>> -	}
>> +	ck_cmdline = get_last_crashkernel(cmdline, name, suffix);
>>  
>>  	if (!ck_cmdline)
>>  		return -EINVAL;
>> @@ -1403,23 +1455,30 @@ static int __init __parse_crashkernel(ch
>>  	 */
>>  	first_colon = strchr(ck_cmdline, ':');
>>  	first_space = strchr(ck_cmdline, ' ');
>> -	if (first_colon && (!first_space || first_colon < first_space))
>> -		return parse_crashkernel_mem(ck_cmdline, system_ram,
>> -				crash_size, crash_base);
>> -	else
>> +	if (first_colon && (!first_space || first_colon < first_space)) {
>> +		if (simple_only)
>> +			return -EINVAL;
>> +		else
>> +			return parse_crashkernel_mem(ck_cmdline, system_ram,
>> +					crash_size, crash_base);
>> +	} else
>>  		return parse_crashkernel_simple(ck_cmdline, crash_size,
>>  				crash_base);
>
>Why don't we structure it little differently. Now we seem to have 3 
>categories of crashkernel= parameters.
>
>- crashkernel_simple (crashkernel=X or crashkernel=X@Y)
>- crashkernel_mem (crashkernel=range:size,.....)
>- crashkerenl_high_low_suffix (crashkernel=X;high or crashkernel=Y;low)
>
>if (suffix) {
>	parse_crashkernel_high_low_suffix()
>} else {
>	if (first_colon.....)
>		parse_crashkernel_mem()
>	else
>		parse_crashkernel_simple();
>}
>
>And now you should not require "simple_only" function parameter and you
>can also do strict syntax checking for each type of crashkernel=
>parameter.
>
>Thanks
>Vivek

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
