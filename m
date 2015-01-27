Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbbA0WBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:01:34 -0500
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:48346 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752609AbbA0WBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:01:33 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:973:981:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3354:3622:3653:3865:3866:3867:3868:3871:3872:3874:4321:4362:4605:5007:6117:6119:6120:6261:7875:7901:7903:9040:9108:10004:10400:10848:10967:11232:11658:11914:12043:12296:12517:12519:12555:12663:12740:14130:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crime39_d400d2c5183b
X-Filterd-Recvd-Size: 3214
Date: Tue, 27 Jan 2015 17:01:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktest: restore tty settings after closing console
Message-ID: <20150127170129.7db53047@gandalf.local.home>
In-Reply-To: <1bb89abc0025cf1d6da657c7ba58bbeb4381a515.1422382008.git.jpoimboe@redhat.com>
References: <1bb89abc0025cf1d6da657c7ba58bbeb4381a515.1422382008.git.jpoimboe@redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 12:10:04 -0600
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> When ktest runs the console program as a child process, the parent and
> child share the same tty for stdin and stderr.  This is problematic when
> using a libvirt target.  The "virsh console" program makes a lot of
> changes to the tty settings, making ktest's output hard to read
> (carriage returns don't work).  After ktest exits, the terminal is
> unusable (CRs broken, stdin isn't echoed).
> 
> I think the best way to fix this issue would be to create a
> pseudoterminal (pty pair) so the child process would have a dedicated
> tty, and then use pipes to connect the two ttys.  I'm not sure if that's
> overkill, but it's far beyond my current Perl abilities.

And beyond mine too. I tried to get that right a few times, and it
never worked out. Maybe someone with more oyster skilz can fix this.

> 
> This patch is a much easier way to (partially) fix this issue.  It saves
> the tty settings before opening the console and restores them after
> closing it.  There are still a few places where ktest prints mangled
> output while the console is open, but the output is much more legible
> overall, and the terminal works just fine after ktest exits.

Thanks, I'll add this, and make sure that it doesn't break anything, as
I use ktest daily.

-- Steve

> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  tools/testing/ktest/ktest.pl | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> index b9cd036..ba20f89 100755
> --- a/tools/testing/ktest/ktest.pl
> +++ b/tools/testing/ktest/ktest.pl
> @@ -178,6 +178,7 @@ my $checkout;
>  my $localversion;
>  my $iteration = 0;
>  my $successes = 0;
> +my $stty;
>  
>  my $bisect_good;
>  my $bisect_bad;
> @@ -1349,6 +1350,9 @@ sub open_console {
>  
>      my $flags;
>  
> +    # save terminal settings
> +    $stty = `stty -g`;
> +
>      my $pid = open($fp, "$console|") or
>  	dodie "Can't open console $console";
>  
> @@ -1368,6 +1372,9 @@ sub close_console {
>  
>      print "closing!\n";
>      close($fp);
> +
> +    # restore terminal settings
> +    system("stty $stty");
>  }
>  
>  sub start_monitor {

