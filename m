Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbaIQWNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:13:07 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:49249 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbaIQWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:13:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140915082346.GB17875@mwanda>
References: <1410710597-14520-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140915082346.GB17875@mwanda>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Thu, 18 Sep 2014 00:12:42 +0200
Message-ID: <CAFo99gZUiSB2cgSAAj7EBjZJTs7QxvCDZr6Wms3ud5qQvBWQMw@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: libcfs: debug.c: Cleaning up
 unnecessary use of memset in conjunction with strncpy
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-15 10:23 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sun, Sep 14, 2014 at 06:03:16PM +0200, Rickard Strandqvist wrote:
>> Using memset before strncpy just to ensure a trailing null
>> character is an unnecessary double writing of a string
>>
>
> You really should make a function which pads and NUL terminates.
>
> I've said this before, of course, but you haven't even tried.
>
> I can't get excited about these cleanups which open code NUL termination
> every where.  They are risky and have introduced bugs before.
>
> regards,
> dan carpenter



Hi Dan

Ok, I have made two suggestions for strncpy function that also
guarantees a terminating null character.
1) retunerar number of characters to be copied, it can be good to
have, but was not really satisfied.

int strncpyz(char *dest, const char *src, size_t count)
{
  size_t len=0;

  if(0 == count)
    return 0;

  --count;
  while(len < count && src[len])
   *dest++ = src[len++];

  do {
    *dest++ = '\0';
  }
  while(len < count--);

  return len;
}


2) The next version is almost the same code as the regular strncpy,
but with two extra lines.

char *strncpyz(char *dest, const char *src, size_t count)
{
        char *tmp = dest;

        while (count) {
                if ((*tmp = *src) != 0)
                        src++;
                tmp++;
                count--;
        }

        if(tmp != dest)
          *--tmp = '\0';

        return dest;
}


Since I did not got any better solution to variant 1, I prefer variant 2.

Then the next question is of course what it should be called  :-)


Kind regards
Rickard Strandqvist
