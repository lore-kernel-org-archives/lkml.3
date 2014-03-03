Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaCCNuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:50:24 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:44671 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaCCNuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:50:21 -0500
MIME-Version: 1.0
In-Reply-To: <1393621571.10280.49.camel@joe-AO722>
References: <1393604742-14317-1-git-send-email-florian.vaussard@epfl.ch>
	<1393604742-14317-3-git-send-email-florian.vaussard@epfl.ch>
	<1393621571.10280.49.camel@joe-AO722>
Date: Mon, 3 Mar 2014 07:50:20 -0600
X-Google-Sender-Auth: s8puAai-lLhUVQ6YSXP-xoD6Rqg
Message-ID: <CAL_JsqJfSpanHTCsshQKvbSziQyONC=zzSSunxFoaJytciozCw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] checkpatch: fix spurious vendor compatible warnings
From: Rob Herring <robh@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Florian Vaussard <florian.vaussard@epfl.ch>,
        Andy Whitcroft <apw@canonical.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 3:06 PM, Joe Perches <joe@perches.com> wrote:
> Hi.
>
> A couple of suggestions and a couple of questions.
>
> I made the patch below against your patches to.
>
> o Look for ".compatible = "foo" strings in .c and .h files too
> o Improve the vendor name match in vendor-prefix.txt by only
>   matching the exact vendor name at the beginning of lines.
>
> I then produced a file of all the compatible uses in dts
> and used checkpatch on it.  It's a long list and a longer
> checkpatch warning list.
>
> $ git ls-files | grep -E "\.dtsi?$" | \
>   xargs grep -hE "^\s*compatible\s*="| \
>   sed -r -e 's/^\s*//' -e 's/\s*=\s*/ = /'| sort | uniq > tmp.dts
> $ .scripts/checkpatch.pl -f tmp.dts
>
> A couple of questions:
>
> How does the $compat2 variable actually work?
> What is it supposed to do?
>
>                                 my $compat2 = $compat;
>                                 $compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
>
> For instance:
> WARNING: DT compatible string "marvell,tauros2-cache" appears un-documented -- check ./Documentation/devicetree/bindings/
>
> The prefix "tauros2-" doesn't match '=~ s/[a-z]*-/
>
> Should it?  Should the '[a-z]*' be '[a-zA-Z0-9-]+'
> like the other test?

What Florian said is exactly right.

> Also the grep used when $compat2 is different than $compat
> has <.*>
>
> There aren't any descriptions I see in binding/ that have
> any <foo> like uses with the angle brackets.
>
> Are the angle brackets "<" and ">" necessary?
>
> I think the code block should look more like:
>
>                                 my $compat2 = $compat;
>                                 $compat2 =~ s/\,[a-zA-Z0-9]*\-/\,\.\*\-/g;
>                                 my $grepfor = "\Q$compat\E";
>                                 $grepfor .= "|\Q$compat2\E" if ($compat2 ne $compat);
>                                 `grep -Erq "$grepfor" $dt_path`;
>
> so that there's only 1 grep pattern when
> $compat2 is the same as $compat and the
> strings are escape quoted.
>
> There are a _lot_ of missing entries:
>
> o 164 vendor names
> o 2408 device names (maybe due to bad compat2 greps?)
>
> What, if anything, should be done about them?

Documenting DT bindings is somewhat new, so there are lots of older
sparc and powerpc bindings that don't have documentation and are
basically grandfathered in. I had thought about adding documentation
in an undocumented binding list, but that would only help making
checks on files pass. For any new bindings, documentation is required,
but we are only hitting like 50-60% in each kernel version. Those are
the ones I hope to catch.

I've written a script that finds the commit adding the undocumented
property and can email the authors, but I've been reluctant to start
spamming people with this. I want to see if checkpatch helps improve
the rate.

Rob
