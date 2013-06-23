Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3FWXJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 19:09:56 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:61132 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3FWXJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 19:09:55 -0400
MIME-Version: 1.0
In-Reply-To: <51C75CD6.5010206@zytor.com>
References: <51C3DDFA.7050204@zytor.com> <51C69732.1010906@gmail.com>
 <b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com> <20130623192936.GA28655@khazad-dum.debian.net>
 <51C75465.9060007@zytor.com> <CAPM=9tzkJTf4d=HfBUs3VwmNG1+Zo5J-JURYd4mYcJ82yXZOKg@mail.gmail.com>
 <51C75CD6.5010206@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 23 Jun 2013 16:09:33 -0700
Message-ID: <CALCETrV_XmuybtkBMZt-syNrMKLLJk0RrqTURE6SNaZ--W8O4w@mail.gmail.com>
Subject: Re: MTRR use in drivers
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Brice Goglin <brice.goglin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 1:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/23/2013 01:30 PM, Dave Airlie wrote:
>>>>> Why do you care about performance when PAT is disabled?
>>
>> breaking old boxes just because, is just going to get reverted when I
>> get the first regression report that you broke old boxes.
>>
>
> Not "just because", but *if* the choice is between breaking old boxes
> and breaking new boxes I'll take the latter.
>
>> Andy Lutomirski just submitted a bunch of patches to clean up the DRM
>> usage of mtrrs, they are in drm-next, afaik we no longer add them on
>> PAT systems.
>
> Fantastic news.  No issue, then, and no need to break anything.
>
> The only problem I see with having ioremap_wc() installing an MTRR on
> non-PAT, rather than pushing that into the drivers which is clearly not
> the right thing, is that we will need a hook to uninstall it when the
> mapping is destroyed.

I have trouble believing that this will ever work well -- MTRRs have
crazy alignment requirements and interactions with other MTRRs, and a
few drivers have to jump through hoops to set up the right MTRRs.
There aren't really enough to break down every mapping.

My patches (in dri-next) add functions arch_wc_phys_add and
arch_wc_phys_del that do nothing except on x86 with MTRRs on and PAT
off, in which case they try to add a WC MTRR.  That way the handful of
drivers that need WC for performance on old hardware can try (and
possibly fail, depending on the usual vagaries of MTRRs).  With my
patches applied, DRM and agpgart no longer touch MTRRs at all with PAT
on.

I didn't get around to excising MTRRs from the non-DRM video drivers
or from the few odd cases like myri10ge.

This stuff is painful to test.  The only drivers I can really test are
i915 and radeon.  I have a myri10ge device, but it's on a production
server.  I also have several mgag200 devices, but they're in a
super-secret-locked-down datacenter a few thousand miles away, and
trying to gauge framebuffer performance over Dell and/or HP's crappy
remoting interface is a lost cause.  I'm not sure that my oldest
computer (locked in a basement in another state) is old enough to have
an AGP port.

--Andy
