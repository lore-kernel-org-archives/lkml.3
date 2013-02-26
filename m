Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597Ab3BZRyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:54:41 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:40212 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3BZRyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:54:39 -0500
MIME-Version: 1.0
In-Reply-To: <20130225202735.GA1928@the-dreams.de>
References: <20130225202735.GA1928@the-dreams.de>
Date: Tue, 26 Feb 2013 09:54:37 -0800
X-Google-Sender-Auth: iT5sM4ooablWgm_eo57XoR-9gZQ
Message-ID: <CA+55aFyxtjiaA=BqHmHbGJqm3cE-cqboCuLXnKxiu4LfHRXnmg@mail.gmail.com>
Subject: Re: [PULL REQUEST] i2c for 3.9
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 12:27 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
> here are the changes for the i2c subsystem for 3.9. Highlights:
>    ....
> In addition, there is the usual bunch of fixes, cleanups, devm_*
> conversions, etc. Please pull.

Pulled, but when doing the conflict resolution, I noted that at least
one devm_* conversion had been done incorrectly. It's an older one,
but then there were changes to the area that made it conflict, and
Inotied.

These three lines have two separate bugs in them:

        i2c->regs = devm_request_and_ioremap(&pdev->dev, res);
        if (i2c->regs == NULL) {
                dev_err(&pdev->dev, "cannot request and map IO\n");

The bugs are:
 (a) the error case for devm_request_and_ioremap() doesn't return NULL
 (b) dev_err() is very wrong, since one of the whole points of devm_*
is that it already prints out errors for the error case.

There have been other complaints about the mindless devm_* conversion
lately (it changes the order of deallocations which can be deadly), so
please please *please* be more careful about these kinds of "trivial"
patches.

                  Linus
