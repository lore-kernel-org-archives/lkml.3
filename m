Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3IIRNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:13:44 -0400
Received: from tartarus.angband.pl ([89.206.35.136]:39518 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3IIRNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:13:43 -0400
X-Greylist: delayed 1635 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2013 13:13:43 EDT
Date: Mon, 9 Sep 2013 18:46:23 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vt: properly ignore xterm-256 colour codes
Message-ID: <20130909164623.GA12525@angband.pl>
References: <E1VImxG-0002w1-UA@tartarus.angband.pl>
 <CANq1E4Tv0Vb9KzWK0oa3P+-V66LqF312HZrwq_JLmHhH-v2k=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4Tv0Vb9KzWK0oa3P+-V66LqF312HZrwq_JLmHhH-v2k=Q@mail.gmail.com>
X-Junkbait: adolf@angband.pl, zareba@angband.pl
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@tartarus.angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 05:53:19PM +0200, David Herrmann wrote:
> On Fri, Jul 12, 2013 at 10:23 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> >  drivers/tty/vt/vt.c | 26 ++++++++++++++++++++------
> >  1 file changed, 20 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> > index c677829..f7aaa28 100644
> > --- a/drivers/tty/vt/vt.c
> > +++ b/drivers/tty/vt/vt.c
> > @@ -1300,13 +1300,27 @@ static void csi_m(struct vc_data *vc)
[...]
> > -                       case 38: /* ANSI X3.64-1979 (SCO-ish?)
> > -                                 * Enables underscore, white foreground
> > -                                 * with white underscore (Linux - use
> > -                                 * default foreground).
> > -                               vc->vc_color = (vc->vc_def_color & 0x0f) | (vc->vc_color & 0xf0);
> > -                               vc->vc_underline = 1;
> 
> You break the old behavior here. _Iff_ this is what you want, then
> please do that in another commit. Explicitly state that "38" is used
> for 256color and shouldn't turn on underline+default-col. The SCO-ish
> behavior is weird, indeed, but breaking it silently is not ok.

This is implied by the description; none among modern terminal emulators
support this.  Would an additional comment in the commit message be
enough, or do I need to change the replacement into a pair of commits?
 
> > +                               i++;
> > +                               if (i > vc->vc_npar)
> 
> This should be ">=", but the for()-loop does allow your ">". So unless
> someone fixes the for-loop to use "<" (do a ++vc->vc_npar before it,
> if it's correct. But blindly doing "<=" is really irritating) I think
> this is ok.

The loop this switch is in does:
	for (i = 0; i <= vc->vc_npar; i++)
which is obviously contrary to what we're used to, but I did not want to
rewrite nearby code to match my preferences.

The change you suggest would deoptimize the code by a single unnecessary
dereference and increment, which is negligible, but since the whole cost
of speedier version is having <= instead of < in the loop, I'm not so
certain this is a good idea.

[...]
> Btw., you should put Greg Kroah-Hartman and Andrew Morton on CC. Both
> are the most likely to pick this up.

Thanks for the suggestion.  I've sent the patch two days ago to Jiri Slaby
(listed as a maintainer besides Greg) together with a newbie question, but
he's apparently busy.

I've got more changes for the vt, but there's no hurry, I wanted to test
the waters with a single minor one in 3.12 first.

-- 
ᛊᚨᚾᛁᛏᚣ᛫ᛁᛊ᛫ᚠᛟᚱ᛫ᚦᛖ᛫ᚹᛖᚨᚲ
