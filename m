Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaBZP40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:56:26 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40423 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaBZP4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:56:25 -0500
MIME-Version: 1.0
In-Reply-To: <1393426760.26583.43.camel@deneb.redhat.com>
References: <1392238575-10000-1-git-send-email-msalter@redhat.com>
	<1392238575-10000-5-git-send-email-msalter@redhat.com>
	<CAL_JsqLi=GhGy7dNf2BiAGd4EtzfqqYfbo0YhRhyhuwEp0w8HQ@mail.gmail.com>
	<1393426760.26583.43.camel@deneb.redhat.com>
Date: Wed, 26 Feb 2014 09:56:24 -0600
Message-ID: <CAL_JsqKy3ZFpS_vXGv+wxX60c3=heURamH+gN=zLW9oR2VOkBg@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] arm: add early_ioremap support
From: Rob Herring <robherring2@gmail.com>
To: Mark Salter <msalter@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Linaro Patches <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 8:59 AM, Mark Salter <msalter@redhat.com> wrote:
> On Tue, 2014-02-25 at 23:48 -0600, Rob Herring wrote:
>> > +#define NR_FIX_BTMAPS          32
>> > +#define FIX_BTMAPS_SLOTS       7
>> > +#define TOTAL_FIX_BTMAPS       (NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
>> > +#define FIX_BTMAP_END          FIX_KMAP_BEGIN
>> > +#define FIX_BTMAP_BEGIN                (FIX_BTMAP_END +
>> TOTAL_FIX_BTMAPS - 1)
>>
>> Why the different logic from arm64? Specifically, it doesn't make
>> adding a permanent mapping simple.
>
> I looked at adding support for permanent mappings but it was going to
> take more time than I had. Also on ARM, we have to deal with kmap's
> needs as well. Working that out was going to take more time than I
> had. I think getting the patch in now to support early_ioremap is
> the way to go. Adding support for permanent mappings can be done
> later with the early console support for which it is needed.

I'm not saying that you should add permanent mappings, but just align
the definitions across arches more. So make arm look something like
this:

enum fixed_addresses {
       __end_of_permanent_fixed_addresses,

       /*
        * Temporary boot-time mappings, used by early_ioremap(),
        * before ioremap() is functional.
        */
#define NR_FIX_BTMAPS          32
#define FIX_BTMAPS_SLOTS       7
#define TOTAL_FIX_BTMAPS       (NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)

      FIX_BTMAP_END = __end_of_permanent_fixed_addresses,
       FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
       __end_of_fixed_addresses
       FIX_KMAP_BEGIN = FIX_BTMAP_END,
       FIX_KMAP_END = FIX_BTMAP_BEGIN,
};

These could then go into the generic header:

#define FIXADDR_SIZE   (__end_of_permanent_fixed_addresses << PAGE_SHIFT)
#define FIXADDR_START  (FIXADDR_TOP - FIXADDR_SIZE)

Rob
