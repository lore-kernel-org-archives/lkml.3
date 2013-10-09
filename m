Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3JICBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 22:01:04 -0400
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:36052 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753958Ab3JICBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 22:01:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:69:196:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1622:1711:1730:1747:1777:1792:1963:2393:2525:2553:2561:2564:2682:2685:2693:2828:2859:2894:2895:2901:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3622:3657:3865:3866:3867:3868:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956
X-HE-Tag: rod59_870227d9755b
X-Filterd-Recvd-Size: 4086
Message-ID: <1381284056.23937.49.camel@joe-AO722>
Subject: Re: [PATCH v2] vsprintf: Check real user/group id for %pK
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 19:00:56 -0700
In-Reply-To: <5254B787.6080700@gmail.com>
References: <5254A034.5020700@gmail.com>
	 <1381279758.23937.42.camel@joe-AO722> <1381282200.23937.45.camel@joe-AO722>
	 <5254B787.6080700@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 12:55 +1100, Ryan Mallon wrote:
> On 09/10/13 12:30, Joe Perches wrote:
> > On Tue, 2013-10-08 at 17:49 -0700, Joe Perches wrote:
> >> On Wed, 2013-10-09 at 11:15 +1100, Ryan Mallon wrote:
> >>> Some setuid binaries will allow reading of files which have read
> >>> permission by the real user id. This is problematic with files which
> >>> use %pK because the file access permission is checked at open() time,
> >>> but the kptr_restrict setting is checked at read() time. If a setuid
> >>> binary opens a %pK file as an unprivileged user, and then elevates
> >>> permissions before reading the file, then kernel pointer values may be
> >>> leaked.
> >>
> >> I think it should explicitly test 0.
> > 
> > Also, Documentation/sysctl/kernel.txt should be updated too.
> > 
> > Here's a suggested patch:
> > 
> > ---
> >  Documentation/sysctl/kernel.txt | 14 ++++++++------
> >  lib/vsprintf.c                  | 38 ++++++++++++++++++++++++++------------
> >  2 files changed, 34 insertions(+), 18 deletions(-)
> > 
> > diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> > index 9d4c1d1..eac53d5 100644
> > --- a/Documentation/sysctl/kernel.txt
> > +++ b/Documentation/sysctl/kernel.txt
> > @@ -290,13 +290,15 @@ Default value is "/sbin/hotplug".
> >  kptr_restrict:
> >  
> >  This toggle indicates whether restrictions are placed on
> > -exposing kernel addresses via /proc and other interfaces.  When
> > -kptr_restrict is set to (0), there are no restrictions.  When
> > -kptr_restrict is set to (1), the default, kernel pointers
> > +exposing kernel addresses via /proc and other interfaces.
> > +
> > +When kptr_restrict is set to (0), there are no restrictions.
> > +When kptr_restrict is set to (1), the default, kernel pointers
> >  printed using the %pK format specifier will be replaced with 0's
> > -unless the user has CAP_SYSLOG.  When kptr_restrict is set to
> > -(2), kernel pointers printed using %pK will be replaced with 0's
> > -regardless of privileges.
> > +unless the user has CAP_SYSLOG and effective user and group ids
> > +are equal to the real ids.
> > +When kptr_restrict is set to (2), kernel pointers printed using
> > +%pK will be replaced with 0's regardless of privileges.
> 
> I'll add this, thanks.
> 
> I'm less fussed about the suggestions for the logic. The current test is
> small and concise.

The logic ends up the same to the compiler, but it's
human readers that want simple and clear.

> The original also does the in_irq tests regardless of
> the kptr_restrict setting since they are mostly intended to catch
> internal kernel bugs.

Not so.

http://marc.info/?l=linux-security-module&m=129303800912245&w=4
https://lkml.org/lkml/2012/7/13/428


