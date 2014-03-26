Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbaCZV5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:57:31 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:54896 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbaCZV53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:57:29 -0400
Message-ID: <53334CB7.9020107@ahsoftware.de>
Date: Wed, 26 Mar 2014 22:55:03 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Levente Kurusa <levex@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] initramfs: print error and shell out for unsupported
 content
References: <CAAsK9AEeobOG1j6NHUoqkZaZ5h8GGK_fL+gyh9MhSvguQjyU_w@mail.gmail.com>	<1395352845-7435-1-git-send-email-holler@ahsoftware.de>	<20140321140305.a3679620aa25132a3b75a404@linux-foundation.org>	<532CC215.1000107@ahsoftware.de>	<20140321155517.51af1b28fe32656fb7506f97@linux-foundation.org>	<532CC625.7020509@ahsoftware.de>	<53334393.5050008@ahsoftware.de> <CAAsK9AG85HmHYgVL=19hYtTF+AiaZHX0hhg8V3Q-+WfVi_jzCw@mail.gmail.com>
In-Reply-To: <CAAsK9AG85HmHYgVL=19hYtTF+AiaZHX0hhg8V3Q-+WfVi_jzCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.03.2014 22:38, schrieb Levente Kurusa:
> Hi,
>
> 2014-03-26 22:16 GMT+01:00 Alexander Holler <holler@ahsoftware.de>:
>> Am 22.03.2014 00:07, schrieb Alexander Holler:
>>>
>>> Am 21.03.2014 23:55, schrieb Andrew Morton:
>>>
>>>> On Fri, 21 Mar 2014 23:49:57 +0100 Alexander Holler
>>>> <holler@ahsoftware.de> wrote:
>>>>
>>>>> Am 21.03.2014 22:03, schrieb Andrew Morton:
>>>>>>
>>>>>> On Thu, 20 Mar 2014 23:00:45 +0100 Alexander Holler
>>>>>> <holler@ahsoftware.de> wrote:
>>>>>>
>>>>>>> The initramfs generation is broken for file and directory names which
>>>>>>> contain
>>>>>>> colons or spaces. Print an error and don't try to continue.
>>>>>
>>>>>
>>>>>> It would be better to fix the it-doesnt-work-with-all-filenames bug.
>>>>>> Any details on that?
>>>>>
>>>>>
>>>>> IMHO not worth the time. The whole process which is curently used is
>>>>> extremly fragile.
>>>>>
>>>>> E.g it's almost guaranteed to fail trying to include arbitrary filenames
>>>>> as dependencies in a Makefile. Besides the one problem I've discoverd
>>>>> with colons, there could be much more things happen, e.g. with filenames
>>>>> which do include other special Makefile characters you all would have to
>>>>> escape correctly.
>>
>>
>> To be a bit more verbose, (gnu)make doesn't support quoted filenames. That
>> means one has to escape all kind of characters which might have a special
>> meaning for make. Not really doable. Furthermore escaped characters are not
>> very well supported by make and are usable only by a few rules.
>>
>>
>>>>> And the problem with spaces isn't as easy to fix as it first does look
>>>>> like. I think it might be easier to write the whole stuff new instead of
>>>>> trying to escape the spaces in various ways needed to end up correctly
>>>>> in the cpio (it first goes through shell code and is then feeded as some
>>>>> list to a C program).
>>
>>
>> To be a bit more verbose here, the shell script
>> (scripts/gen_initramfs_list.sh) identifes filenames based on the position in
>> a string which is delimited by the usual (shell) whitespace. E.g. $1 =
>> filename, $2 = mode, ...
>> And this stuff is then feeded to usr/gen_init_cpio.c,which uses a similiar
>> approach like
>>
>> sscanf(line, "%" str(PATH_MAX) "s %" str(PATH_MAX) "s %o %d %d", name,
>> target, ...
>>
>> which obviously fails for filenames with whitspace too.
>>
>> What I think might be reasonable is:
>>
>> - get rid of the dependency list in form of a include into the Makefile and
>> just generate the cpio-archive every time make is called. Common initramfs
>> sizes are about a few megabytes and with today machines such a cpio-archive
>> is build in about a second,
>>
>
> I don't understand what kind of include would you want.
>
>> - get rid of gen_initramfs_list.sh and rewrite gen_init_cpio.c such that it
>> reads the filenames, modes and similiar itself (e.g. by using stat(2)).
>
> This is walkable but probably not worth the effort. Besides, why would
> anyone want to put spaces, colons and arbitrary characters to filenames
> in the initramfs?
>
>>
>>
>> But I don't have any motivation to do so. Sorry.
>>
>> Maybe Levente Kurusa is interested in doing so, he seems to have an interest
>> in the topic as he was quiet fast to send an answer to my patch.
>
> All I wonder now is why are you being so arrogant. You are not a 'remote
> keyboard' as you had called yourself, since when you send a patch
> you not only have to send it but communicate WHY maintainers
> should take that patch, and if somebody has a comment

The patch clearly explained what's broken.

> spotting an obvious mistake you shouldn't become angry.
> It was only a simple typo and a suggestion. Nobody told you
> to blindly accept my suggestion. Everybody can have opinions.
> It's open-source, the community suggests you new changes,
> it's normal, get used to it. Writing up this nonsense sentence
> (I feel the irony) probably took more time than actually resending
> the patch did.

So please accept my opinion that I'm not interested in fixing silly 
typos until I had at least some feedback with reasonable content. E.g. a 
Tested-By would have been nice.

And please forgive me that I'm unable to differentiate between feedback 
from "someone" or by a maintainer. Maybe I was fooled by that linux.com 
in your email, I had forgotten that this is a public available mail address.

So, Thanks for supporting the Linux Foundation.

Regards,

Alexander Holler
