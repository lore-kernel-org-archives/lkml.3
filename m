Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaFEWSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:18:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:35109 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbaFEWSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:18:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,984,1392192000"; 
   d="scan'208";a="543149859"
Message-ID: <5390EC55.2030608@linux.intel.com>
Date: Thu, 05 Jun 2014 15:16:53 -0700
From: eric ernst <eric.ernst@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        jwboyer@fedoraproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] Add kernel parameter for kernel version
References: <538CC567.2060305@linux.intel.com> <1402006157-126864-1-git-send-email-eric.ernst@linux.intel.com> <5390EC78.9000805@infradead.org>
In-Reply-To: <5390EC78.9000805@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 14-06-05 03:17 PM, Randy Dunlap wrote:
> On 06/05/2014 03:09 PM, eric.ernst@linux.intel.com wrote:
>> From: Eric Ernst <eric.ernst@linux.intel.com>
>>
>> Create a kernel cmdline parameter, "version_addendum", which can be
>> used to add text to the kernel version that is reported from
>> /proc/version.
> and you still didn't update Documentation/kernel-parameters.txt.
>
Correct - I was waiting for the initial feedback of whether this would 
be useful to community before doing this, sorry for the thrash, Randy.
>> Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>
>> ---
>>   fs/proc/version.c |   14 +++++++++++++-
>>   init/version.c    |    2 +-
>>   2 files changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/proc/version.c b/fs/proc/version.c
>> index d2154eb6d78f..442e69e3eecb 100644
>> --- a/fs/proc/version.c
>> +++ b/fs/proc/version.c
>> @@ -5,12 +5,17 @@
>>   #include <linux/seq_file.h>
>>   #include <linux/utsname.h>
>>   
>> +#define ADDENDUM_LENGTH 20
>> +static char version_addendum[ADDENDUM_LENGTH];
>> +
>>   static int version_proc_show(struct seq_file *m, void *v)
>>   {
>>   	seq_printf(m, linux_proc_banner,
>>   		utsname()->sysname,
>>   		utsname()->release,
>> -		utsname()->version);
>> +		utsname()->version,
>> +		version_addendum);
>> +
>>   	return 0;
>>   }
>>   
>> @@ -26,6 +31,13 @@ static const struct file_operations version_proc_fops = {
>>   	.release	= single_release,
>>   };
>>   
>> +static int __init set_version_addendum(char *str)
>> +{
>> +	strncpy(version_addendum, str, ADDENDUM_LENGTH-1);
>> +	return 0;
>> +}
>> +early_param("version_addendum", set_version_addendum);
>> +
>>   static int __init proc_version_init(void)
>>   {
>>   	proc_create("version", 0, NULL, &version_proc_fops);
>> diff --git a/init/version.c b/init/version.c
>> index 1a4718e500fe..180059b69b7a 100644
>> --- a/init/version.c
>> +++ b/init/version.c
>> @@ -47,4 +47,4 @@ const char linux_banner[] =
>>   const char linux_proc_banner[] =
>>   	"%s version %s"
>>   	" (" LINUX_COMPILE_BY "@" LINUX_COMPILE_HOST ")"
>> -	" (" LINUX_COMPILER ") %s\n";
>> +	" (" LINUX_COMPILER ") %s " "%s\n";
>>
>

