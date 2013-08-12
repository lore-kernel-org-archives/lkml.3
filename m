Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3HLEUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 00:20:38 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:35476 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3HLEU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 00:20:27 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Should unprivileged linkat(..., AT_EMPTY_PATH) work on O_TMPFILE files?
In-Reply-To: <CALCETrXKzMBwkEFCsGeLB1sqFFPjivpFR2P8ZMeuZX5SAuZZjA@mail.gmail.com>
References: <CALCETrUTyLO4BKX0SrmRd=nb2jvvZEhD9iTyFpSM23OUdQLhsA@mail.gmail.com> <877gfsrxar.fsf@linux.vnet.ibm.com> <CALCETrXKzMBwkEFCsGeLB1sqFFPjivpFR2P8ZMeuZX5SAuZZjA@mail.gmail.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 12 Aug 2013 09:50:19 +0530
Message-ID: <87haevbkvw.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081204-4790-0000-0000-000009C062E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Sun, Aug 11, 2013 at 9:45 AM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> The change:
>>>
>>> commit f4e0c30c191f87851c4a53454abb55ee276f4a7e
>>> Author: Al Viro <viro@zeniv.linux.org.uk>
>>> Date:   Tue Jun 11 08:34:36 2013 +0400
>>>
>>>     allow the temp files created by open() to be linked to
>>>
>>>     O_TMPFILE | O_CREAT => linkat() with AT_SYMLINK_FOLLOW and /proc/self/fd/<n>
>>>     as oldpath (i.e. flink()) will create a link
>>>     O_TMPFILE | O_CREAT | O_EXCL => ENOENT on attempt to link those guys
>>>
>>>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>>>
>>> makes it possible to hardlink an O_TMPFILE file using procfs.  Should
>>> linkat(fd, "", newdirfd, newpath, AT_EMPTY_PATH) also work?
>>>
>>> AFAICS it currently requires CAP_DAC_READ_SEARCH, but I'm a bit
>>> confused as to why linkat(..., AT_EMPTY_PATH) should have a stricter
>>> check than linkat(AT_FDCWD, "/proc/self/fd/n", ...,
>>> AT_SYMLINK_FOLLOW),  (The relevant change is
>>> 11a7b371b64ef39fc5fb1b6f2218eef7c4d035e3.)
>>>
>>> FWIW, this program works on Linux 3.9, which makes me doubt that the
>>> security restriction on linkat is doing any good:
>>>
>>> #include <stdio.h>
>>> #include <err.h>
>>> #include <fcntl.h>
>>> #include <unistd.h>
>>>
>>> int main(int argc, char **argv)
>>> {
>>>   char buf[128];
>>>
>>>   if (argc != 3)
>>>     errx(1, "Usage: flink FD PATH");
>>>
>>>   sprintf(buf, "/proc/self/fd/%d", atoi(argv[1]));
>>>   if (linkat(AT_FDCWD, buf, AT_FDCWD, argv[2], AT_SYMLINK_FOLLOW) != 0)
>>>     err(1, "linkat");
>>>   return 0;
>>> }
>>>
>>>
>>> Removing the check from the AT_EMPTY_PATH case would simplify code
>>> that wants to write a file, fsync it, and then flink it in.
>>
>> I understand that this got merged upstream. But in case of the above
>> test we would walk the path pointed by /proc/self/fd/<x> right ?
>>
>> ie,
>>
>> 20 -> /home/no-access/k
>>
>> will the above test work ? Now if i pass the '20' to another application
>> I can affectively create a hardlink to that outside no-access and if k
>> happens to have 'r' for others, then everybody will be able to read
>> right ?. I understand that limitting the read access based on directory
>> permission is not a good idea. But aren't we expected to keep that ?
>
> The symlinks in /proc/self/fd are rather magical and don't actually
> walk the path.  Give it a try :)
>

How about fd passed from one application to another(say from a1 to
a2). a2 won't have read permission on /proc/a1/fd/ and also don't know
the value of file descriptor he should use right ? Will the /proc/self/fd
method work in such case ? IIUC with AT_EMPTY_PATH a2 can create the
link in the above case right ? So if /proc/self/fd doesn't work should
we allow that ?

-aneesh

