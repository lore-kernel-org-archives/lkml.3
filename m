Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968142AbaLLPDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:03:53 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58157 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S967963AbaLLPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:03:52 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [GIT PULL] fbdev fixes for 3.19
Date: Fri, 12 Dec 2014 16:25:30 +0100
Message-ID: <5087676.8ZtUhzdjMG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqKrKxSdmp5UKcGeNFzDxOxirycT0YQKsPbY3dTaJWY+ag@mail.gmail.com>
References: <54899F0E.4090309@ti.com> <3272093.0A5V5UZ3cA@vostro.rjw.lan> <CAL_JsqKrKxSdmp5UKcGeNFzDxOxirycT0YQKsPbY3dTaJWY+ag@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 11, 2014 06:59:34 PM Rob Herring wrote:
> On Thu, Dec 11, 2014 at 4:58 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Thursday, December 11, 2014 12:55:28 PM Linus Torvalds wrote:
> >> On Thu, Dec 11, 2014 at 5:41 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> >> >
> >> > Please pull fbdev changes for 3.19.
> >>
> >> Ugh. I've pulled it, but I'm not a huge fan of commit 6d09dc6b74ca
> >> ("of.h: Keep extern declaration of of_* variables when !CONFIG_OF").
> >>
> >> I guess it works, but it ends up delaying any failures from compile
> >> time to link time, and the linker error messages likely won't be
> >> great.
> >>
> >> So I'm cc'ing the OF people and Rafael (who worked on OF/ACPI
> >> unification) to see if they have comments, preferences, or other ways
> >> to solve this.
> >>
> >> Quite frankly, to me it smells like non-OF builds should just have an
> >> empty "for_each_child_of_node ()" define instead of playing games with
> >> externs that then end up not existing, and depending on the compiler
> >> DTRT.
> >>
> >> Comments?
> >
> > "for_each_child_of_node ()" is not a problem here AFAICS, because in the
> > example from the commit changelog the compiler would complain on the
> > of_chosen instance in the "if ()" statement already anyway if I'm not mistaken.
> 
> Really, the "if" should be completely removed here.
> for_each_child_of_node should do the right thing for !OF or if
> of_chosen is NULL already.

This still is an example of a common pattern:

<statement optimized away for CONFIG_BLAH unset> {
	<some code>
}

Now, if you use variables defined only for CONFIG_BLAH set in the above (block
or statement), you'll get compile errors for !CONFIG_BLAH.

There is a limited choice of what can be done to avoid those errors:
 (a) Put the whole code in question under #ifdef CONFIG_BLAH (defeats the
     purpose of the entire exercise).
 (b) Define the variables unconditionally (wasted memory for !CONFIG_BLAH).
 (c) Wrap the variables in static inline functions that will be empty for
     !CONFIG_BLAH ("one more level of indirection" approach).
 (d) Do dirty tricks like in commit 6d09dc6b74ca.

Are there any more options that I'm overlooking?  If not, (a) and (b) are
unattractive, so the real choice seems to be between (c) and (d) to me.

Rafael

