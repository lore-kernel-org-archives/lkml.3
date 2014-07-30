Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaG3Xxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:53:55 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63280 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaG3Xxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:53:52 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: ARC fails to boot on linux-next of 20140711
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Rob Herring <robherring2@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        lkml <linux-kernel@vger.kernel.org>,
        greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230753C4B8155@IN01WEMBXA.internal.synopsys.com>
References: <C2D7FE5348E1B147BCA15975FBA230753C4B67CF@IN01WEMBXA.internal.synopsys.com>
	<CAL_JsqJ2q0RSvXQW03RqwwBi_TKQ7Zt6DsUbsUruzh5oqYi5Cg@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA230753C4B7DD5@IN01WEMBXA.internal.synopsys.com>
	<20140726165055.D3E64C43E0B@trevor.secretlab.ca>
	<C2D7FE5348E1B147BCA15975FBA230753C4B8155@IN01WEMBXA.internal.synopsys.com>
Date: Wed, 30 Jul 2014 17:53:45 -0600
Message-Id: <20140730235345.41FD3C40712@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014 04:38:38 +0000, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> On Saturday 26 July 2014 10:21 PM, Grant Likely wrote:
> > On Sat, 26 Jul 2014 06:52:36 +0000, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> >> Hi Rob,
> >>
> >> On Friday 25 July 2014 07:45 PM, Rob Herring wrote:
> >>> On Fri, Jul 25, 2014 at 6:02 AM, Vineet Gupta
> >>> <Vineet.Gupta1@synopsys.com> wrote:
> >>>>> Hi Grant,
> >>>>>
> >>>>> linux-next has a series for arc_uart (via tty tree) which converts it to generic
> >>>>> earlycon and specifies console via /chosen/stdout-path vs.  an explicit param in
> >>>>> /chose/bootargs
> >>>>>
> >>>>> 2014-06-24 9da433c0a0b5 ARC: [arcfpga] stdout-path now suffices for earlycon/console
> >>>>>
> >>>>> This relied on prev commit of yours (from linux next of 20140711), which seem to
> >>>>> have disappeared now.
> >>>>>
> >>>>> 2014-03-27 a9296cf2d0b6 of: Create of_console_check() for selecting a console
> >>>>> specified in /chosen
> >>>>> 2014-03-27 cfa9cacc5dd3 of: Enable console on serial ports specified by
> >>>>> /chosen/stdout-path
> >>>>>
> >>>>> Is there a specific reason for dropping these patches (or perhaps a merge to be
> >>>>> merged). I cherry-picked both but still doesn't work.
> >>>>>
> >>>>> Can you please advise next step forward, before I go off debugging with those
> >>>>> patches in.
> >>> There's an issue that if you have stdout-path and "earlycon" on the
> >>> command line, the kernel will switch to tty0 and disable the earlycon.
> >>>
> >>> This is the "fix", but I don't like adding the DT dependency into generic code:
> >>>
> >>> @@ -2382,7 +2386,7 @@ void register_console(struct console *newcon)
> >>>                 if (newcon->setup == NULL ||
> >>>                     newcon->setup(newcon, NULL) == 0) {
> >>>                         newcon->flags |= CON_ENABLED;
> >>> -                       if (newcon->device) {
> >>> +                       if (newcon->device  && !of_stdout) {
> >>>                                 newcon->flags |= CON_CONSDEV;
> >>>                                 preferred_console = 0;
> >>>                         }
> >> The DT settings relevant for ARC, which enable generic-earlycon and
> >> console-with-stdout-path are as follows
> >>
> >>         chosen {
> >>                 bootargs = "earlycon";
> >>                 stdout-path = &arcuart0;
> >>         };
> >>
> >> ....
> >>                 arcuart0: serial@c0fc1000 {
> >>                         compatible = "snps,arc-uart";
> >>
> >> And it works w/o above hunk, provided the 2 patches from Grant exist in linux-next
> >> which they don't at the moment. I'm pretty confused how the hunk above comes into
> >> picture.
> >>
> >> And if not then I will have to get the ARC std-out patch reverted in tty-next as
> >> it is broken.
> > You need to revert it anyway, the dependency chain is broken. Just
> > because something is in linux-next doesn't mean it will be merged.
> > Dependencies must always be in the branch to which you commit.
> >
> > If that doesn't happen (like here) then bisecting is broken and the
> > dependencies may not actually get merged.
> >
> > When this happens, what you're supposed to do is tell the maintainers
> > what commits the patch depends on so that it can be applied to the
> > correct tree. In this case I could take it through my devicetree branch
> > that contains the console patches.
> 
> I understand all of that. Actually 9 out of 10 of my changes were for switching to
> earlycon for which corresponding core changes from Rob were already in mainline.
> When reviewing my code, Rob pointed me to your on going work on use of stdout-path
> so my mistake was to pile that up in the same series vs. asking you to add that
> patch in ur tree for precisely the multi dependency reason.
> 
> > If a patch depends on commits in several branches then it is a bit more
> > complex. What we usually do is create a new branch that merges in each
> > branch that is depended on, and then apply the commit on top of that.
> >
> > As for the console patches, I'm only going to be putting them back if I
> > can devise a good fix for the earlycon duplication issue.
> 
> If you have an internal branch for this work, can you please add the patch below
> to it so that we don't forget abt it.
> 
> https://lkml.org/lkml/2014/6/24/127
> 
> I'll ask Greg to revert it from tty tree !

Isn't that also broken for bisect? Doesn't that patch depend on the
patches in Greg's tree? If so, then same problem. At this point you'll
need to wait until both are mainlined before this patch gets applied
since I don't want to deal with cross merging trees.

However, this patch is trivial, so I don't see any problem with not
having it in linux-next before the merge window.

g.

