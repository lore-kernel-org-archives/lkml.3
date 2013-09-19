Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3ISXCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 19:02:48 -0400
Received: from tartarus.angband.pl ([89.206.35.136]:37921 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3ISXCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 19:02:46 -0400
Date: Fri, 20 Sep 2013 01:02:41 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Roy Franz <roy.franz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 09/17] Move unicode to ASCII conversion to shared
 function.
Message-ID: <20130919230241.GA18666@angband.pl>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
 <1379391093-27948-10-git-send-email-roy.franz@linaro.org>
 <20130919034406.GA26385@angband.pl>
 <CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw@mail.gmail.com>
X-Junkbait: adolf@angband.pl, zareba@angband.pl
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@tartarus.angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 09:48:44PM -0700, Roy Franz wrote:
> On Wed, Sep 18, 2013 at 8:44 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> > [UCS2 truncation]
> 
> I stuck to re-arranging the code that was there, as I don't know enough
> about character encodings to propose changes.

I on the other hand don't know the kernel (lurking because of my first
patch), but I'm on a crusade against mangled Unicode (so far in the
userland).  Can't let such a blatant error slip through on my watch :)

> Also, this code is running as part of the kernel decompressor, rather than
> the kernel itself, so it doesn't have access to any kernel facilities, and
> it also needs to be position independent.

Ok, so it can't reuse common libraries.  No problem, a simplified, sanitized
and optimized copy of utf16s_to_utf8s() can be done in quite less code than
the original.

> It's running in a quite limited environment - the decompressor has
> its own copy of strstr(), and other string functions.

I'd need nothing but a way to alloc the new string.  And I see this is
already done (efi_{low,high_alloc()).

> I checked the UEFI specification, and it states that all 16 bit strings
> are UCS-2, unless otherwise noted.

... which means it will either get upgraded to UTF-16 in a subsequent
version, or some Unicode strings get mangled.  I'd ignore this bit and
implement full UTF-16 from the start: every legal UCS-2 string can be
decoded as UTF-16 so it's a strict superset.

> The load options that the command line is provided through a void pointer
> specified as: [snip]

Either a null pointer or a 16-bit string, that sounds clear enough.

I see not a word about endianness (does anything do EFI on big endian?),
but "same as host" seems to be a reasonable assumption.

> Would it be acceptable to fix the naming/comments, and convert values
> above 126 to '?' in the current patchset, and address a more thorough fix
> in another patch set?  The ARM and ARM64 EFI stub patchsets that are
> mostly complete depend on this one, so getting this merged soon would be
> helpful.

I don't want to hinder your work, so what about putting in your version
as-is and fixing it later?

> > There's just one problem: which encoding to use, but
> > these days, most distributions have either dropped non-UTF8 or hardly pay
> > lip service, so we could get away with hard-coding UTF-8: those few who
> > use ancient charsets can stick to ASCII.

Not being able to use regular kernel facilities makes supporting ancient
charsets a lost cause.  I'm so weeping about them... not.

> I would certainly appreciate your help improving this

Are we on the same page so far?  If so, I can make a patch atop yours.

-- 
ᛊᚨᚾᛁᛏᚣ᛫ᛁᛊ᛫ᚠᛟᚱ᛫ᚦᛖ᛫ᚹᛖᚨᚲ
