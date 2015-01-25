Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbbAYM6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 07:58:13 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:47042 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbbAYM6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 07:58:11 -0500
Message-ID: <54C4E84E.7090901@ahsoftware.de>
Date: Sun, 25 Jan 2015 13:57:50 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigbrady.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] modsign: use shred to overwrite the private key before
 deleting it
References: <54C2F4F8.20809@draigBrady.com>	<1422096327-4483-1-git-send-email-holler@ahsoftware.de>	<54C383E0.9060408@ahsoftware.de>	<54C38B6D.1060806@ahsoftware.de>	<54C3901D.8040406@ahsoftware.de>	<54C45153.2050703@draigBrady.com>	<54C4583A.5040505@ahsoftware.de>	<54C4C65A.2020403@ahsoftware.de>	<54C4CC05.9090602@ahsoftware.de>	<54C4D6BA.4080308@ahsoftware.de> <CAFLxGvzZOfhwW5hp1GDhTHLU5Z=9ozkOQgvatqhwDT982hfYcA@mail.gmail.com> <54C4E080.4020507@ahsoftware.de> <54C4E181.4080004@nod.at>
In-Reply-To: <54C4E181.4080004@nod.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.01.2015 um 13:28 schrieb Richard Weinberger:
> Am 25.01.2015 um 13:24 schrieb Alexander Holler:
>> Am 25.01.2015 um 13:08 schrieb Richard Weinberger:
>>> On Sun, Jan 25, 2015 at 12:42 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>>>> Now, after I ended up into flaming a lot (sorry again, but this topic made
>>>> me angry for so long and I had to spent too much time to get rid of unwanted
>>>> content and answering other peoples question in regard to that topic), I
>>>> should offer something more useful.
>>>>
>>>> So I've written down in some short words, how I think it could be done:
>>>>
>>>> First offer a syscall named sunlink() (or whatever name) which fails if it
>>>> can't overwrite or securely trim the contents of a file before deleting it.
>>>>
>>>> That could be done like this:
>>>>
>>>> (1) If it's a SSD or MMC without offering "Secure Trim" fail.
>>>> (2) If it's a plain FLASH or conventional harddisk where writing a block
>>>> means that block will be overwritten or if it's a SSD or MMC with "Secure
>>>> Trim) go on with
>>>> (3) Identify the blocks which contain the file contents (should be doable by
>>>> using the same mechanisms used to read and write a file)
>>>> (4) Mark the file as deleted
>>>> (5) Overwrite or securely trim blocks which can be deleted completely
>>>> (6) Build new blocks for blocks which can only partly deleted because they
>>>> contain information still used by the FS or other files
>>>> (7) Instruct the FS to us the new blocks instead of the old ones
>>>> (8) Overwrite or securely trim the old blocks which previously contained
>>>> partly information of other stuff.
>>>>
>>>> Afterwards use that new syscall in shred.
>>>>
>>>> Of course, this is just a totally simplified instruction in regard to how
>>>> complicated filesystems have become, but I think there isn't any black magic
>>>> involved in offering the user a simple way to really delete files.
>>>
>>> Or add support for the "s" chattr to major filesystems.
>>>
>> And change the manpage for the 's' attribute to change the "overwriting with zero" with some other wording.
>>
>> But thanks for the hint. I wasn't aware of that bit (maybe because it's still useless on most filesystems).
>>
>> But the above silly instruction might still help in implementing support for the 's' attribute.
>>
>> Also I wonder what happens if you delete a file with such an attribute on e.g. an SSD. I assume the user just gets a false positive that the file is deleted, which isn't much
>> different to what nowadays happens and doesn't therefor really help.
>
> The implementation will be challenging. Especially for modern filesytems like btrfs or f2fs which are copy-on-write based.

Sure. I didn't thought it's easy. A quick workaround for modern SSDs and 
similiar would be to call secure trim on all free blocks whenever shred 
is called. Would be a rather ugly workaround, but a least something 
which might be achieved in a short time frame instead of some bigger 
project like it's necessary to implement that erase as it should work 
from the beginning. Especially because that fundamental design goal of 
safelydeleting file wasn't a design goal from the beginning, which is 
the real failure.

Regards,

Alexander Holler
