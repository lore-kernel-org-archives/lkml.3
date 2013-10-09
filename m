Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab3JIWEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:04:53 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59078 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3JIWEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:04:52 -0400
Message-ID: <5255D2FD.6050705@gmail.com>
Date: Thu, 10 Oct 2013 09:04:45 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] vsprintf: Check real user/group id for %pK
References: <5255D023.2030907@gmail.com> <1381356014.2050.28.camel@joe-AO722>
In-Reply-To: <1381356014.2050.28.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/13 09:00, Joe Perches wrote:
> On Thu, 2013-10-10 at 08:52 +1100, Ryan Mallon wrote:
>> Some setuid binaries will allow reading of files which have read
>> permission by the real user id. This is problematic with files which
>> use %pK because the file access permission is checked at open() time,
>> but the kptr_restrict setting is checked at read() time. If a setuid
>> binary opens a %pK file as an unprivileged user, and then elevates
>> permissions before reading the file, then kernel pointer values may be
>> leaked.
> 
> Please review the patch I sent you a little more.
> 
>> Fix this by adding a check that in addition to the current process
>> having CAP_SYSLOG, that effective user and group ids are equal to the
>> real ids. If a setuid binary reads the contents of a file which uses
>> %pK then the pointer values will be printed as NULL if the real user
>> is unprivileged.
> 
> []
> 
>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
>> @@ -1312,11 +1313,37 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>>  				spec.field_width = default_width;
>>  			return string(buf, end, "pK-error", spec);
>>  		}
> 
> Move the interrupt tests and pK-error printk
> into case 1:
> 
> It's the only case where CAP_SYSLOG needs to be
> tested so it doesn't need to be above the switch.

Like I said, I think it is useful to do the pK-error check anyway. It is
checking for internal kernel bugs, since if 'pK-error' ever gets
printed, then some kernel code is doing the wrong thing. Therefore, I
think it is useful to print it always (I would argue it even makes sense
when kptr_restrict=0). I decided to just leave that part of the code alone.

~Ryan

