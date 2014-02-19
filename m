Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaBSPew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:34:52 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39589 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaBSPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:34:49 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 2/4] of: reimplement the matching method for __of_match_node()
To: Rob Herring <robherring2@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Hao <haokexin@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
In-Reply-To: <CAL_JsqLbjK02Z1qzfP9K+Grp2WwAth8rMctK9myf8ZwJA6PUGQ@mail.gmail.com>
References: <1392819290-1044-1-git-send-email-grant.likely@linaro.org> < 1392819290-1044-3-git-send-email-grant.likely@linaro.org> < CAL_JsqLbjK02Z1qzfP9K+Grp2WwAth8rMctK9myf8ZwJA6PUGQ@mail.gmail.com>
Date: Wed, 19 Feb 2014 15:34:41 +0000
Message-Id: <20140219153441.5A271C4088D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014 08:54:57 -0600, Rob Herring <robherring2@gmail.com> wrote:
> On Wed, Feb 19, 2014 at 8:14 AM, Grant Likely <grant.likely@linaro.org> wrote:
> > From: Kevin Hao <haokexin@gmail.com>
> >
> > In the current implementation of __of_match_node(), it will compare
> > each given match entry against all the node's compatible strings
> > with of_device_is_compatible().
> >
> > To achieve multiple compatible strings per node with ordering from
> > specific to generic, this requires given matches to be ordered from
> > specific to generic. For most of the drivers this is not true and
> > also an alphabetical ordering is more sane there.
> >
> > Therefore, we define a following priority order for the match, and
> > then scan all the entries to find the best match.
> >   1. specific compatible && type && name
> >   2. specific compatible && type
> >   3. specific compatible && name
> >   4. specific compatible
> >   5. general compatible && type && name
> >   6. general compatible && type
> >   7. general compatible && name
> >   8. general compatible
> >   9. type && name
> >   10. type
> >   11. name
> 
> While I agree this should be the right order, I worry that this may be
> changing the matching in some case as all previous attempts have done.

True, but they should be few and far between, and they can be
fixed up with bugfixes in drivers. This time we actually have test cases
that show the behaviour is correct. The previous versions failed the
current test cases (I checked).

> > +       /* Compatible match has highest priority */
> > +       if (compat && compat[0]) {
> > +               cp = __of_get_property(device, "compatible", &cplen);
> > +               if (!cp)
> > +                       return 0;
> > +               for (index = 0; cplen > 0; index++, cp += l, cplen -= l) {
> > +                       l = strlen(cp) + 1;
> 
> This could use of_property_for_each_string.

Good point. Changed.

g.
