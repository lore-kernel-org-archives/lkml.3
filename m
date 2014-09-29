Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaI2MpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:45:16 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:53767 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509AbaI2MpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:45:14 -0400
Message-ID: <1411994711.6334.57.camel@x220>
Subject: Re: [PATCH v7] checkkconfigsymbols.sh: reimplementation in python
From: Paul Bolle <pebolle@tiscali.nl>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: akpm@linux-foundation.org, Stefan Hengelein <stefan.hengelein@fau.de>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Sep 2014 14:45:11 +0200
In-Reply-To: <CAD3Xx4+REZ4gy=q6ywDy=b6NXOvfSrBWHG9NCnQdQanMvB6pKw@mail.gmail.com>
References: <1411222524-7850-1-git-send-email-valentinrothberg@gmail.com>
	 <1411919729-5800-1-git-send-email-valentinrothberg@gmail.com>
	 <1411986525.6334.32.camel@x220>
	 <CAD3Xx4+REZ4gy=q6ywDy=b6NXOvfSrBWHG9NCnQdQanMvB6pKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2014 12:45:11.0943 (UTC) FILETIME=[358B8970:01CFDBE3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 14:08 +0200, Valentin Rothberg wrote:
> On Mon, Sep 29, 2014 at 12:28 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > On Sun, 2014-09-28 at 17:55 +0200, Valentin Rothberg wrote:
> >>     (d) only checks files under version control ('git ls-files')
> >
> > (The shell script is .git unaware. If you happen to have one or more
> > branches with "Kconfig" in their name, as I do, it generates a lot of
> > noise on stderr.)
> 
> Do you prefer to use os.walk() then?

It seems I was unclear: this described a problem with the shell script
and not a problem with your python rewrite.

> I just don't want to assume that
> the script is called in a clean tree. 'git ls-files' avoids to filter
> files. How do you solve this issue in your script?

This is getting off topic, but I choose to not care about the state of
the tree on disk. My script basically does "git ls-tree -r $SOME_TAG",
filters out symlinks, and generates a long list of (blob, path) pairs to
work with.

(You may remember from https://lkml.org/lkml/2014/9/26/485 that my
script uses git notes for each blob it parses. Different approach,
different pros and cons.)

> >> +STMT = r"^\s*(?:if|select|depends\s+on)\s+" + EXPR
> >
> > Could please make that "depends on"? Yes, it seems the yacc grammar
> > accepts any amount of whitespace, but that doesn't make it right to use
> > anything other than a single space. (Can the yacc grammar be tweaked to
> > see "depends on" as one, well, token?)
> 
> I don't know if yacc can do that. Usually the lexer trims whitespaces.
> If I change the regex to "depends on", we will miss potential
> statements as Kconfig accepts multiple spaces between the "depends"
> and the "on".

Your choice. (The expectation behind my request is that bogus results
from this script might help catch uses of this misfeature. But every use
of "depends on" is currently sane, anyway.)

> >> +REGEX_SOURCE_FEATURE = re.compile(r"(?:D|\W|\b)+CONFIG_(" + FEATURE + r")")
> >
> > That should be "-D", because now you get a hit on
> >     TPS6507X_ADCONFIG_CONVERT_TS
> >
> > and friends. What does \W do, by the way?
> 
> (?:\W|\b)+[D]{,1}CONFIG_... will do the trick. "-D" would fail in
> getting DCONFIG_ in the build files. "\W" matches not "\w", which is
> [A-Za-z0-9_].

The joy of regular expressions! You now know what wrong, and you'll
surely come up with something better than my idea to fix it.

Thanks,


Paul Bolle

