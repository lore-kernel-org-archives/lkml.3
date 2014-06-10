Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaFJQYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:24:13 -0400
Received: from smtprelay0091.hostedemail.com ([216.40.44.91]:52219 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750735AbaFJQYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:24:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2689:2828:2890:3138:3139:3140:3141:3142:3355:3622:3865:3867:3868:3870:3872:3873:3874:4042:4321:4605:5007:7514:7652:7903:7974:10004:10400:10848:11026:11232:11658:11914:12043:12257:12295:12517:12519:12555:12740:13019,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cave28_4123086e89b57
X-Filterd-Recvd-Size: 4030
Message-ID: <1402417441.30479.0.camel@joe-AO725>
Subject: Re: [PATCH] [checkpatch.pl] ctx_statement_block #if/#else/#endif fix
From: Joe Perches <joe@perches.com>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>
Date: Tue, 10 Jun 2014 09:24:01 -0700
In-Reply-To: <CAMSQXEE9ZgE8wuXz_qu5ndbfFne7zjhN24R44trPE11e02hmWQ@mail.gmail.com>
References: <1400164995-8652-1-git-send-email-meltedpianoman@gmail.com>
	 <CAMSQXEE9ZgE8wuXz_qu5ndbfFne7zjhN24R44trPE11e02hmWQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 08:19 +0200, Ivo Sieben wrote:
> Andy, Joe,
> 
> What do you think about my patchset below?

Andy wrote that originally and I think he should respond.

> Regards,
> Ivo Sieben
> 
> 2014-05-15 16:43 GMT+02:00 Ivo Sieben <meltedpianoman@gmail.com>:
> > When picking up a complete statement block #if/#else/#endif prepocesor
> > boundaries are taken into account by pushing current level & type on a stack.
> > But on an #else the level was read from stack again (without actually popping it
> > from stack) causing the statement block to end too early on the next ';'.
> > Fixed this.
> >
> > For example the following code:
> >
> >         if (!test()) {
> >  #ifdef NEVER
> >                 foo();
> >                 bar();
> >  #else
> >                 bar();
> >                 foo();
> >  #endif
> >         }
> >
> > Results in statement block:
> >
> >  STATEMENT<+    if (!test()) {
> >  +#ifdef NEVER
> >  +              foo();
> >  +              bar();
> >  +#else
> >  +              bar();>
> >  CONDITION<+    if (!test())>
> >
> > While you would expect:
> >
> >  STATEMENT<+    if (!test()) {
> >  +#ifdef NEVER
> >  +              foo();
> >  +              bar();
> >  +#else
> >  +              bar();
> >  +              foo();
> >  +#endif
> >  +       }>
> >  CONDITION<+     if (!test())>
> >
> > Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
> > ---
> >
> > Request for comments:
> > I think I fixed a problem here that I encountered while I was working on another
> > changeset in which I check the statement block after a condition.
> > Somehow the statement block did not contain everything I expected.
> >
> >  scripts/checkpatch.pl |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 34eb216..e7bca89 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -878,7 +878,7 @@ sub ctx_statement_block {
> >                 if ($remainder =~ /^#\s*(?:ifndef|ifdef|if)\s/) {
> >                         push(@stack, [ $type, $level ]);
> >                 } elsif ($remainder =~ /^#\s*(?:else|elif)\b/) {
> > -                       ($type, $level) = @{$stack[$#stack - 1]};
> > +                       # no changes to stack: type & level remain the same
> >                 } elsif ($remainder =~ /^#\s*endif\b/) {
> >                         ($type, $level) = @{pop(@stack)};
> >                 }
> > @@ -1050,7 +1050,7 @@ sub ctx_block_get {
> >                 if ($lines[$line] =~ /^.\s*#\s*(?:ifndef|ifdef|if)\s/) {
> >                         push(@stack, $level);
> >                 } elsif ($lines[$line] =~ /^.\s*#\s*(?:else|elif)\b/) {
> > -                       $level = $stack[$#stack - 1];
> > +                       # no changes to stack: type & level remain the same
> >                 } elsif ($lines[$line] =~ /^.\s*#\s*endif\b/) {
> >                         $level = pop(@stack);
> >                 }
> > --
> > 1.7.9.5
> >



