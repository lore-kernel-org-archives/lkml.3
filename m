Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbaFIVXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:23:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46495 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaFIVXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:23:35 -0400
Message-ID: <539625D1.2090905@infradead.org>
Date: Mon, 09 Jun 2014 14:23:29 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>,
        Richard Weinberger <richard.weinberger@gmail.com>
CC: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 3/5] kbuild: Use relative path for $(objtree)
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz> <1399639944-20551-4-git-send-email-mmarek@suse.cz> <CAFLxGvyz-aX8rTveo9W3mqsQxPeg8cb7Oq59UiC1kMz4qTiYwg@mail.gmail.com> <538EEA3D.1080105@suse.cz> <538F1B41.3060904@suse.cz> <20140605155614.GA18376@sepie.suse.cz>
In-Reply-To: <20140605155614.GA18376@sepie.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/14 08:56, Michal Marek wrote:
> On Wed, Jun 04, 2014 at 03:12:33PM +0200, Michal Marek wrote:
>> On 2014-06-04 11:43, Michal Marek wrote:
>>> On 2014-06-04 11:03, Richard Weinberger wrote:
>>>> To reproduce run:
>>>> make defconfig ARCH=um O=/mnt/o && make linux ARCH=um O=/mnt/
>>>>
>>>> If there is anything in UML which needs fixing, please tell. :-)
>>>
>>> I'll have a look, thanks for the report.
>>
>> Findings so far: For some reason, syscalls_32.h is generated in the
>> source tree (which is wrong) and syscalls_64.h is not generated at all.
>> Looking further.
> 
> Can you try the below patch? The same pattern is used in the rules for
> tools/ and tools/% in the main Makefile, need to look into that as well.
> But UML should work now.
> 
> Michal
> 
> From d4bc590f8716f7dde6b7bca319097ac30a8cb0b4 Mon Sep 17 00:00:00 2001
> From: Michal Marek <mmarek@suse.cz>
> Date: Thu, 5 Jun 2014 17:44:44 +0200
> Subject: [PATCH] um: Fix for relative objtree when generating x86 headers
> 
> In an O= build, rely on the generated Makefile to call the main Makefile
> properly. When building in the source tree, we do not need to specify
> the -C and O= either. This fixes the problem when $(objtree) is a
> relative path and the -C changes the directory.
> 
> Reported-by: Richard Weinberger <richard.weinberger@gmail.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  arch/um/Makefile | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/um/Makefile b/arch/um/Makefile
> index 36e658a..e4b1a96 100644
> --- a/arch/um/Makefile
> +++ b/arch/um/Makefile
> @@ -111,8 +111,7 @@ endef
>  KBUILD_KCONFIG := $(HOST_DIR)/um/Kconfig
>  
>  archheaders:
> -	$(Q)$(MAKE) -C '$(srctree)' KBUILD_SRC= \
> -		ARCH=$(HEADER_ARCH) O='$(objtree)' archheaders
> +	$(Q)$(MAKE) KBUILD_SRC= ARCH=$(HEADER_ARCH) archheaders
>  
>  archprepare: include/generated/user_constants.h
>  
> 

I still get this build error when building uml for i386:

  CC      arch/x86/um/user-offsets.s
../arch/x86/um/user-offsets.c:14:29: fatal error: asm/syscalls_32.h: No such file or directory
compilation terminated.
make[2]: *** [arch/x86/um/user-offsets.s] Error 1


-- 
~Randy
