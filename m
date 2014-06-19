Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbaFSMBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:01:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34416 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbaFSMBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:01:04 -0400
Message-ID: <53A2D0FC.7040309@plexistor.com>
Date: Thu, 19 Jun 2014 15:01:00 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: kbuild: support of new KBUILD_FULL_PATH
References: <53A1D3A1.70202@gmail.com> <53A2B7A9.7080605@gmail.com> <53A2BE65.2070501@suse.cz>
In-Reply-To: <53A2BE65.2070501@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 01:41 PM, Michal Marek wrote:
<>
>> Is there a document I need to edit for this new parameter?
> 
> That would be Documentation/kbuild/kbuild.txt
> 

Will send a VER2 thanks

> 
>> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
>> ---
>>  Makefile | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 97b2861..778732a 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -149,11 +149,17 @@ else
>>  _all: modules
>>  endif
>>  
>> +# put KBUILD_FULL_PATH=1 if relative path to sources breaks your system
>> +ifneq ($(KBUILD_FULL_PATH), 1)
>> +	KBUILD_FULL_PATH=""
>> +endif
>> +
>>  ifeq ($(KBUILD_SRC),)
>>          # building in the source tree
>>          srctree := .
>>  else
>> -        ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
>> +        # if KBUILD_FULL_PATH is not empty then condition will fail
>> +        ifeq ($(KBUILD_FULL_PATH)$(KBUILD_SRC)/,$(dir $(CURDIR)))
> 
> This is an ugly way to express the logic.
> 

I kind of agree. My Makefile foo is not very strong any other way I
know would duplicate code. What would you suggest?

[ Best I can think of is:

        srctree := $(KBUILD_SRC)

        # if KBUILD_FULL_PATH=1 then do not use relative path
	ifneq ($(KBUILD_FULL_PATH), 1)
                ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
                        # building in a subdirectory of the source tree
                        srctree := ..
                endif
        endif


Is this better?
]

> 
>>                  # building in a subdirectory of the source tree
>>                  srctree := ..
>>          else
> 
> How about generated sources like asm-offsets.s or the lexer and parser
> in scripts/kconfig, does kdevelop figure out where the files live? If
> not, you might need to add
> 
> -objtree                := .
> +ifeq ($(KBUILD_FULL_PATH),1)
> +       objtree := $(CURDIR)
> +else
> +        objtree        := .
> +endif
> 
> to use the full path also for the O= directory.
> 

I would not care for those at all. The important is those files that
you need to point and edit to fix stuff. The generated files I better
not edit usually. The edit is in some other place, right?

> Michal
> 

I saw that this patch caused other breakage as well. Will you be
fixing those? Do you want to own this or you still need a ver2
of this patch?

Thanks
Boaz

