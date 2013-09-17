Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3IQNRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:17:04 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61604 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3IQNRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:17:03 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5238564D.6010307@roeck-us.net>
Date: Tue, 17 Sep 2013 06:17:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] modpost: Fix secondary errors seen if a single module
 build fails
References: <1379219942-31545-1-git-send-email-linux@roeck-us.net> <52384C72.4040403@suse.cz>
In-Reply-To: <52384C72.4040403@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 05:34 AM, Michal Marek wrote:
> Dne 15.9.2013 06:39, Guenter Roeck napsal(a):
>> Commit ea4054a23 (modpost: handle huge numbers of modules) added
>> support for building a large number of modules.
>>
>> Unfortunately, the commit changed the semantics of the makefile: Instead of
>> passing only existing object files to modpost, make now passes all expected
>> object files. If make was started with option -i, this results in a modpost
>> error if a single file failed to build.
>>
>> Example with the current btrfs build falure on m68k:
>>
>> fs/btrfs/btrfs.o: No such file or directory
>> make[1]: [__modpost] Error 1 (ignored)
>>
>> This error is followed by lots of errors such as:
>>
>> m68k-linux-gcc: error: arch/m68k/emu/nfcon.mod.c: No such file or directory
>> m68k-linux-gcc: fatal error: no input files
>> compilation terminated.
>> make[1]: [arch/m68k/emu/nfcon.mod.o] Error 1 (ignored)
>>
>> This doesn't matter much for normal builds, but it is annoying for builds
>> started with "make -i" due to the large number of secondary errors.
>> Those errors unnececessarily clog any error log and make it difficult
>> to find the real errors in the build.
>>
>> Fix the problem by only passing existing object files to modpost.
>>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   scripts/Makefile.modpost |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
>> index 8dcdca2..387c806 100644
>> --- a/scripts/Makefile.modpost
>> +++ b/scripts/Makefile.modpost
>> @@ -81,7 +81,8 @@ modpost = scripts/mod/modpost                    \
>>
>>   # We can go over command line length here, so be careful.
>>   quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
>> -      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$$/.o/' | $(modpost) -s -T -
>> +      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$$/.o/' | \
>> +	while read a; do [ -f $$a ] && echo $$a; done | $(modpost) -s -T -
>
> Can you do this filtering only if make -i is used ('i' is present in
> $(MAKEFLAGS)), to not hide potential buildsystem bugs? Regarding shell
> loop vs. ls, maybe the cleanest way would be to add an option to modpost
> to ignore missing files.
>

Possibly, but I don't really see the point, as the rest of the makefile
does and always did the same filtering already (using $(wildcard ...)
and it doesn't make sense to even try to run modpost on a file that
does not exist.

Sure, it might be a possibility to drop all the wildcard and other filtering
conditionally and only keep it if -i was specified, but I think that should
be a separate patch as it would add its own risks and complexities.

Guenter

