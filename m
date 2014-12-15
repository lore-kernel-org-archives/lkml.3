Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbaLOWXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 17:23:48 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:34031 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaLOWXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 17:23:47 -0500
MIME-Version: 1.0
In-Reply-To: <1418608297.2674.4.camel@perches.com>
References: <1418597547-25086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1418608297.2674.4.camel@perches.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 15 Dec 2014 23:23:25 +0100
Message-ID: <CAFo99gaVUbsvwY7RKZ9D=c0jnVeFiBLAeNVb53UX=Ba4XytoKg@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c: Fix
 for possible null pointer dereference
To: Joe Perches <joe@perches.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe

No, it does not look like end can be NULL then.
Then remove the end != NULL instead?
...
    if (end != NULL && *end == '.') {


However, I am hesitant to the tolower()  I think double case is faster...?


Kind regards
Rickard Strandqvist


2014-12-15 2:51 GMT+01:00 Joe Perches <joe@perches.com>:
> On Sun, 2014-12-14 at 23:52 +0100, Rickard Strandqvist wrote:
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
>
> Perhaps the tool could use a little work.
> It's not possible for end to be NULL no?
>
> unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
> {
>         unsigned long long result;
>         unsigned int rv;
>
>         cp = _parse_integer_fixup_radix(cp, &base);
>         rv = _parse_integer(cp, base, &result);
>         /* FIXME */
>         cp += (rv & ~KSTRTOX_OVERFLOW);
>
>         if (endp)
>                 *endp = (char *)cp;
>
>         return result;
> }
> EXPORT_SYMBOL(simple_strtoull);
>
>
>> diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
> []
>
> Above this:
>
>         whole = simple_strtoull(pbuf, &end, 10);
>
>> +++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
>> @@ -1897,17 +1897,19 @@ int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
>>       }
>>
>>       units = 1;
>> -     switch (*end) {
>> -     case 'p': case 'P':
>> -             units <<= 10;
>> -     case 't': case 'T':
>> -             units <<= 10;
>> -     case 'g': case 'G':
>> -             units <<= 10;
>> -     case 'm': case 'M':
>> -             units <<= 10;
>> -     case 'k': case 'K':
>> -             units <<= 10;
>> +     if (end) {
>> +             switch (*end) {
>> +             case 'p': case 'P':
>> +                     units <<= 10;
>> +             case 't': case 'T':
>> +                     units <<= 10;
>> +             case 'g': case 'G':
>> +                     units <<= 10;
>> +             case 'm': case 'M':
>> +                     units <<= 10;
>> +             case 'k': case 'K':
>> +                     units <<= 10;
>> +             }
>
> The only thing I might do is
>
>         switch (tolower(*end)) {
>
> and remove the second case entry for each line
>
