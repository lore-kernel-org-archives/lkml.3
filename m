Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3JKDTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 23:19:23 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53672 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab3JKDTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 23:19:21 -0400
Message-ID: <52576E32.1050700@gmail.com>
Date: Fri, 11 Oct 2013 14:19:14 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>, Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
References: <5255D023.2030907@gmail.com> <1381356014.2050.28.camel@joe-AO722>	<5255D2FD.6050705@gmail.com> <1381356861.2050.33.camel@joe-AO722>	<5255D7D4.8050204@gmail.com> <1381358030.2050.36.camel@joe-AO722>	<5255DBD8.30005@gmail.com> <1381360187.2050.44.camel@joe-AO722> <87pprck0q7.fsf@xmission.com>
In-Reply-To: <87pprck0q7.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/13 13:20, Eric W. Biederman wrote:
> Joe Perches <joe@perches.com> writes:
> 
>> Some setuid binaries will allow reading of files which have read
>> permission by the real user id. This is problematic with files which
>> use %pK because the file access permission is checked at open() time,
>> but the kptr_restrict setting is checked at read() time. If a setuid
>> binary opens a %pK file as an unprivileged user, and then elevates
>> permissions before reading the file, then kernel pointer values may be
>> leaked.
>>
>> This happens for example with the setuid pppd application on Ubuntu
>> 12.04:
>>
>>   $ head -1 /proc/kallsyms
>>   00000000 T startup_32
>>
>>   $ pppd file /proc/kallsyms
>>   pppd: In file /proc/kallsyms: unrecognized option 'c1000000'
>>
>> This will only leak the pointer value from the first line, but other
>> setuid binaries may leak more information.
>>
>> Fix this by adding a check that in addition to the current process
>> having CAP_SYSLOG, that effective user and group ids are equal to the
>> real ids. If a setuid binary reads the contents of a file which uses
>> %pK then the pointer values will be printed as NULL if the real user
>> is unprivileged.
>>
>> Update the sysctl documentation to reflect the changes, and also
>> correct the documentation to state the kptr_restrict=0 is the default.
> 
> Sigh.  This is all wrong.  The only correct thing to test is
> file->f_cred.  Aka the capabilities of the program that opened the
> file.
> 
> Which means that the interface to %pK in the case of kptr_restrict is
> broken as it has no way to be passed the information it needs to make
> a sensible decision.

Would it make sense to add a struct file * to struct seq_file and set
that in seq_open? Then the capability check can be done against seq->file.

~Ryan

