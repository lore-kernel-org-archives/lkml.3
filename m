Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3ISDoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 23:44:16 -0400
Received: from tartarus.angband.pl ([89.206.35.136]:59632 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3ISDoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 23:44:14 -0400
Date: Thu, 19 Sep 2013 05:44:06 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, leif.lindholm@linaro.org, msalter@redhat.com
Subject: Re: [PATCH 09/17] Move unicode to ASCII conversion to shared
 function.
Message-ID: <20130919034406.GA26385@angband.pl>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
 <1379391093-27948-10-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379391093-27948-10-git-send-email-roy.franz@linaro.org>
X-Junkbait: adolf@angband.pl, zareba@angband.pl
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@tartarus.angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 09:11:25PM -0700, Roy Franz wrote:
> +/* Convert the unicode UEFI command line to ASCII to pass to kernel.
> + * Size of memory allocated return in *cmd_line_len.
> + * Returns NULL on error.
> + */
> +static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,

> +       int load_options_size = image->load_options_size / 2; /* ASCII */

> +	for (i = 0; i < options_size - 1; i++)
> +		*s1++ = *s2++;

I'm afraid both this commit and comments inside are misnamed.  What you're
changing here is the encoding rather than character set.

In fact, these days it's 8-bit encodings that are more likely to be Unicode
than 16-bit ones: UTF-8 is ubiquitous, while you usually get UCS2 at most.
In either case, though, we have here is a 7-bit charset encoded as either
8-bit or 16-bit units.  What this function does is blindly truncating upper
byte.  The supported payload is in both cases ASCII.

I'd thus rename the function to what it already does: truncating u16 to u8,
and adjust comments accordingly.

Replacing values above 126 with a token character like '?' would be good
too: that'd avoid producing corrupted characters and/or random ASCII chars.

Your commit only moves things around, so it might be out of scope for now,
but I wonder: what if the kernel actually supported Unicode here?  Few
cmdline arguments take values where non-ASCII makes sense, but at least some
do: for example, a Russian guy is not unlikely to name subvolumes using
cyrillic.  Supporting that would be easy (estimating the length then
utf16s_to_utf8s()).  There's just one problem: which encoding to use, but
these days, most distributions have either dropped non-UTF8 or hardly pay
lip service, so we could get away with hard-coding UTF-8: those few who
use ancient charsets can stick to ASCII.  Would this be ok?  If so, shout,
I can code this if you don't care enough.

-- 
ᛊᚨᚾᛁᛏᚣ᛫ᛁᛊ᛫ᚠᛟᚱ᛫ᚦᛖ᛫ᚹᛖᚨᚲ
