Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3IXQgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:36:41 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48512 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3IXQgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:36:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130923090100.GE6192@mwanda>
References: <20130923090100.GE6192@mwanda>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 24 Sep 2013 10:36:18 -0600
Message-ID: <CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com>
Subject: Re: checkpatch guide for newbies
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 3:01 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> I've written a checkpatch guide for newbies because it seems like they
> make the same mistakes over and over.  I intend to put it under
> Documentation/.  Could you look it over?

I think this is great.

>                 Introduction
>
> This document is aimed at new kernel contributors using "checkpatch.pl --file".
>
> The first thing to remember is that the aim is not to get rid of every
> checkpatch.pl warning; the aim is to make the code cleaner and more readable.
> The other thing to remember is that checkpatch.pl is not a very smart tool and
> there are mistakes that it misses so keep your eyes open for those as well.
>
> For example, checkpatch.pl could warn about a badly formatted warning message.
> Ask yourself, is the warning message is clear?  Is it needed?  Could a
> non-privileged user trigger the warning and flood the syslog?  Are there
> spelling mistakes?  Since Checkpatch.pl has flagged the line as sloppy code,
> there may be multiple mistakes.
>
> In the Linux kernel, we take an enormous pride in our work and we want clean
> code.  But the one major drawback to cleanup patches is that they break
> "git blame" so it's not a good idea for newbies to send very trivial cleanup
> patches to the kernel/ directory.  It's better to get a little experience in the
> drivers/ directory first.  The drivers/staging/ directory in particular always
> needs cleanup patches.
>
>
>                 General Hints
>
> 1)  Don't put too many things in one patch because it makes it hard to review.
> Break the patch up into a patch series like this made up example:
>
> [PATCH 1/4] subsystem: driver: Use tabs to indent instead of spaces
> [PATCH 2/4] subsystem: driver: Add spaces around math operations
> [PATCH 3/4] subsystem: driver: Remove extra braces
> [PATCH 4/4] subsystem: driver: Delete LINUX_VERSION_CODE related code

This is a good hint and a good example.  One thing that annoys me is
when there's no consistency in subject lines; I wish people would run
"git log --oneline <file>" and follow the existing convention,
including spacing, brackets, capitalization, etc.  I also like Ingo's
suggestion [1] for making them sentences, starting with a verb.

But maybe that's too nitty-gritty to include.  You already have a nice
concise writeup and it would be a shame to let us ruin it by committee
:)

Bjorn

[1] http://lkml.kernel.org/r/20120711080446.GA17713@gmail.com

>                 Long Lines
>
> Historically screens were 80 characters wide and it was annoying when code went
> over the edge.  These days we have larger screens, but we keep the 80 character
> limit because it forces us to write simpler code.
>
> One way to remove indent levels is using functions.  If you find yourself
> writing a loop or a switch statement and you're already indented several tabs
> then probably it should be a new function instead.
>
> Whenever possible return immediately.
> Bad:
> -       foo = kmalloc();
> -       if (foo) {
> -               /* code indent 2 tabs */
> -       }
> -       return foo;
> Good:
> +       foo = kmalloc();
> +       if (!foo)
> +               return NULL;
> +       /* code indented 1 tab */
> +       return foo;
>
> Choose shorter names.
> Bad:
> -       for(uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords;
> -           uiIpv6AddIndex++) {
> Good:
> +       for (i = 0; i < long_words; i++) {
>
> Use temporary variable names:
> Bad:
> -       dev->backdev[count]->bitlistsize =
> -               dev->backdev[count]->devmagic->bitlistsize;
> Good:
> +       back = dev->backdev[count];
> +       back->bitlistsize = back->devmagic->bitlistsize;
>
> Don't do complicated things in the initializer:
> Bad:
> -       struct binder_ref_death *tmp_death = container_of(w,
> -                                               struct binder_ref_death, work);
> Good:
> +       struct binder_ref_death *tmp_death;
> +
> +       tmp_death = container_of(w, struct binder_ref_death, work);
>
> If you must break up a long line then align it nicely.  Use spaces if needed.
> Bad:
> -       if (adapter->flowcontrol == FLOW_RXONLY ||
> -                       adapter->flowcontrol == FLOW_BOTH) {
> Good:
> +       if (adapter->flowcontrol == FLOW_RXONLY ||
> +           adapter->flowcontrol == FLOW_BOTH) {
>
> It's preferred if the operator goes at the end of the first line instead of at
> the start of the second line:
> Bad:
> -       PowerData = (1 << 31) | (0 << 30) | (24 << 24)
> -                   | BitReverse(w89rf242_txvga_data[i][0], 24);
> Good:
> +       PowerData = (1 << 31) | (0 << 30) | (24 << 24) |
> +                   BitReverse(w89rf242_txvga_data[i][0], 24);
>
>
>                 Writing the Changelog
>
> Use the word "cleanup" instead of "fix".  "Fix" implies the runtime changed and
> it fixes a bug.  "Cleanup" implies that runtime stayed exactly the same.
