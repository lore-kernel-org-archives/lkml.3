Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3ISEsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 00:48:46 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:35072 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3ISEsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 00:48:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130919034406.GA26385@angband.pl>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
	<1379391093-27948-10-git-send-email-roy.franz@linaro.org>
	<20130919034406.GA26385@angband.pl>
Date: Wed, 18 Sep 2013 21:48:44 -0700
Message-ID: <CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw@mail.gmail.com>
Subject: Re: [PATCH 09/17] Move unicode to ASCII conversion to shared function.
From: Roy Franz <roy.franz@linaro.org>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 8:44 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Mon, Sep 16, 2013 at 09:11:25PM -0700, Roy Franz wrote:
>> +/* Convert the unicode UEFI command line to ASCII to pass to kernel.
>> + * Size of memory allocated return in *cmd_line_len.
>> + * Returns NULL on error.
>> + */
>> +static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
>
>> +       int load_options_size = image->load_options_size / 2; /* ASCII */
>
>> +     for (i = 0; i < options_size - 1; i++)
>> +             *s1++ = *s2++;
>
> I'm afraid both this commit and comments inside are misnamed.  What you're
> changing here is the encoding rather than character set.
>
> In fact, these days it's 8-bit encodings that are more likely to be Unicode
> than 16-bit ones: UTF-8 is ubiquitous, while you usually get UCS2 at most.
> In either case, though, we have here is a 7-bit charset encoded as either
> 8-bit or 16-bit units.  What this function does is blindly truncating upper
> byte.  The supported payload is in both cases ASCII.
>
> I'd thus rename the function to what it already does: truncating u16 to u8,
> and adjust comments accordingly.
>
> Replacing values above 126 with a token character like '?' would be good
> too: that'd avoid producing corrupted characters and/or random ASCII chars.

I stuck to re-arranging the code that was there, as I don't know
enough about character encodings
to propose changes.  Also, this code is running as part of the kernel
decompressor, rather
than the kernel itself, so it doesn't have access to any kernel
facilities, and it also needs to
be position independent.  It's running in a quite limited environment
-  the decompressor has
its own copy of strstr(), and other string functions.

I checked the UEFI specification, and it states that all 16 bit
strings are UCS-2, unless
otherwise noted.  The load options that the command line is provided
through a void pointer
specified as:

    "LoadOptions A pointer to the image's binary load options."

I couldn't quickly find any other mentions of LoadOptions in the
spec., so I don't know what
other types of values could be, or are typically provided.  The spec
isn't helpful regarding the type
of this data, and I don't know what common practice is here among the
various EFI/UEFI firmwares
out there.

Would it be acceptable to fix the naming/comments, and convert values
above 126 to '?'
in the current patchset, and address a more thorough fix in another patch set?
The ARM and ARM64 EFI stub patchsets that are mostly complete depend
on this one,
so getting this merged soon would be helpful.

Something like:
>> +/* Convert the UEFI command line from 16 bit to 8 bit encoding to pass to kernel.
>> + * by truncating to 7 bits.  Values above 126 are converted to 63 (ASCII '?')
>> + * Size of memory allocated return in *cmd_line_len.
>> + * Returns NULL on error.
>> + */
+static char *efi_truncate_cmdline_to_8bit_encoding(efi_system_table_t
*sys_table_arg,
(update code to truncate and convert to '?')

>
> Your commit only moves things around, so it might be out of scope for now,
> but I wonder: what if the kernel actually supported Unicode here?  Few
> cmdline arguments take values where non-ASCII makes sense, but at least some
> do: for example, a Russian guy is not unlikely to name subvolumes using
> cyrillic.  Supporting that would be easy (estimating the length then
> tf16us_to_utf8s()).  There's just one problem: which encoding to use, but
> these days, most distributions have either dropped non-UTF8 or hardly pay
> lip service, so we could get away with hard-coding UTF-8: those few who
> use ancient charsets can stick to ASCII.  Would this be ok?  If so, shout,
> I can code this if you don't care enough.

I would certainly appreciate your help improving this, although I think we'll
need to have a better understanding of what the UEFI firmware is providing
before we can implement something better.


>
> --
> ᛊᚨᚾᛁᛏᚣ᛫ᛁᛊ᛫ᚠᛟᚱ᛫ᚦᛖ᛫ᚹᛖᚨᚲ
