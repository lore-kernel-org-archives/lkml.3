Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbaHFPCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:02:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbaHFPCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:02:01 -0400
Message-ID: <53E24365.6020405@suse.cz>
Date: Wed, 06 Aug 2014 17:01:57 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kbuild: escape single backslashes in macro make-cmd
References: <20140726163551.19857.17737.stgit@zurg>	<53E2156E.9060700@suse.cz> <CALYGNiO=oiiLgJRrpycO=CWyMMf8-AiDyW=Ch3ajV5W=9dtZfA@mail.gmail.com>
In-Reply-To: <CALYGNiO=oiiLgJRrpycO=CWyMMf8-AiDyW=Ch3ajV5W=9dtZfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-06 14:19, Konstantin Khlebnikov wrote:
> On Wed, Aug 6, 2014 at 3:45 PM, Michal Marek <mmarek@suse.cz> wrote:
>> On 2014-07-26 18:35, Konstantin Khlebnikov wrote:
>>> This already has been fixed in commit c353acba28fb3fa1fd05fd
>>> ("kbuild: make: fix if_changed when command contains backslashes")
>>> but escaping still isn't perfect and triggers false-positive rebuilds.
>>>
>>> For x86 problem happens every time, because rules in arch/x86/realmode/rm/
>>> and arch/x86/boot/ contains commands like sed -n -e 's/foo\(.*\)/\1/p'.
>>> Backslash in \1 isn't escaped and turns into ascii symbol with code 1.
>>> Macro if_changed detects command change and rebuilds target again and again.
>>>
>>> Backslash escaping conflicts with other passes because it's used for escaping
>>> other symbols. To avoid that current macro handles only double backslashes.
>>> Obviously this doesn't work for \1 like above.
>>>
>>> This patch reorders passes. It doubles all backslashes before escaping # and '
>>>
>>> Visible effect in rebuilding x86/defconfig without changes, before patch:
>>>
>>> blind@zurg:~/src/linux$ make V=2
>>>   CHK     include/config/kernel.release
>>>   CHK     include/generated/uapi/linux/version.h
>>>   CHK     include/generated/utsrelease.h
>>>   CALL    scripts/checksyscalls.sh - due to target missing
>>>   CHK     include/generated/compile.h
>>>   PASYMS  arch/x86/realmode/rm/pasyms.h - due to command line change
>>
>> With which make and shell version are you seeing this? While the patch
>> looks correct, I can't reproduce the error here:
> 
> /bin/sh points to dash (debian default setup).
> 
> I cannot reproduce this using bash. That explains why this bug is still here.

So the difference between the shells is that their 'echo' builtin treats
\<number> differently:
$ ./dash -c "echo '\2'"

$ ./dash -c "echo '\2'" | xxd
0000000: 020a                                     ..
$ /bin/bash -c "echo '\2'"
\2

For some reason we fail to escape the \ and dash treats \2 as \02. POSIX
says that this is implementation-defined, so none of the shells is wrong.

I need to look into this a bit further. I'll most likely end up applying
your patch, but I'd like to understand the fix in detail first.

Thanks,
Michal
