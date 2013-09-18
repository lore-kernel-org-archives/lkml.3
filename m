Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3IRWnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 18:43:11 -0400
Received: from nm9-vm9.access.bullet.mail.gq1.yahoo.com ([216.39.63.247]:37869
	"EHLO nm9-vm9.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661Ab3IRWnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 18:43:09 -0400
X-Yahoo-Newman-Id: 748489.52269.bm@smtp113.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 79m0kgwVM1kAA0xDHsuh3zXeJPHhT2w2mF1wg.K6IrO6bQl
 2tJ9lIVGpcx3U_4ZOG4pcOluzAoKfnpZbjYaqhvNXK6TBnX11whUZGvIs0CJ
 rRpakY_0eiFvJm0IUzKyKFgtgUNePTjVjVEJICuC.GreJ7g2YNdS4XxVMRwh
 EZoDxqSFeI8gkpqhBj233rx_m7NSdb_w5oQAhAnqed.Wbx3lnS3HWjvmupo8
 D8jULFtH4M8.Kwc6bcU9iBEM_5e5FWd2TTdwD5t7w8.zp7dZsCsPBUNOfHjF
 NlnkI6KLzevYjjcuQbN3wQcq2Kq4aKaT9OstGCdmlXF.0qx9XBpwJdXiGuzv
 elKPFJxpwW9P6AWvPFbItYAcQfBlMjbcR7io1oRWY.UJfVfUezrKo8qyJYnk
 D5n3ay1EfW2R8n4OX0FrmPGrSxumOFY9yJXiBF_ByDybkSxXQ7rzPHqiQl8V
 WeNjuaTC79r1DSXt33NoPd5fDMJSnxvmaeKrotx.QQ9XIxcVCt14W9GmuCkF
 QIe9iNLuqp71o6ZFdxXABhjES.tfxTFw4lgvig9G2dP1AWanuIqYH_MAaSXF
 IX2zbOLuvvX.x8jv2Es6ZMC1wMVXJHR1KsGdyiMLdslAWNptvKZVEoARLEE6
 xwMRwKU_Wfgg-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with )
        by smtp113.sbc.mail.gq1.yahoo.com with SMTP; 18 Sep 2013 15:43:08 -0700 PDT
Message-ID: <523A2C97.6090403@att.net>
Date: Wed, 18 Sep 2013 17:43:35 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Daniel Santos <daniel.santos@pobox.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 1/5] scripts: Add mkstrerror.sh
References: <1379459317-13046-2-git-send-email-daniel.santos@pobox.com> <1379459317-13046-1-git-send-email-daniel.santos@pobox.com> <29168.1379504300@warthog.procyon.org.uk>
In-Reply-To: <29168.1379504300@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 06:38 AM, David Howells wrote:
> danielfsantos@att.net wrote:
>
>> This is a simple bash script that parses our errno*.h files and formats
>> them into the error_strings.h header that our strerror and strerror_name
>> functions will use later.
> I presume you haven't tried building with a "make O=foo" build directory?  I
> see:
>
>        /bin/sh: /data/fs/linux-2.6-fscache/include/generated/error_strings.h: No such file or directory
>
> when I try it.

No, indeed I haven't, thanks. I'm going to need help figuring out the 
correct way to put this in the build because the current definitely 
isn't correct.  From what I could tell from digging into the build last 
night (which I've never carefully analyzed), this should be added 
somewhere in one of the scripts/Makefile*s and not in the root makefile 
(as I have done), or maybe even in lib/Makefile.

>
>   (2) Storing the leading 'E' for each symbol is redundant as you can add that
>       later so you might want to discard it.

This is a good thought, that's 150-ish bytes, but it will introduce some 
new challenges.  Currently, strerror() functions exactly like "man 3p 
strerror", except that it returns a pointer to a const string like the 
POSIX specification should have done. :)  So I directly return a pointer 
to the string within the .rodata section of the object file (same for 
strerror_name).  Omitting the 'E' would require I work up another 
solution requiring a return buffer or some such, thus increasing 
complexity and possibly loosing that savings to code.

However, if we wanted to squeze that much more out of it, then we could 
7-th bit terminate the strings and save another 150-ish bytes on null 
terminators or go even further and use some encoding scheme (maybe 32 
bits per character)?  At 2k for both the error names and the code, I 
figured it was already pretty low, but if there are some existing 
libraries in the kernel we could use to do this and not further bloat 
the text size for decompression then I wouldn't be opposed, so long as 
it makes sense.  And since we're dealing with error conditions which 
don't happen often, speed shouldn't be a concern.

Thanks!
Daniel

