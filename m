Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3BCL0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 06:26:14 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:41940 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753070Ab3BCL0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 06:26:12 -0500
Date: Sun, 3 Feb 2013 09:56:09 +0100
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PM: make VT switching to the suspend console optional
 v2
Message-ID: <20130203095609.31867279@jbarnes-t420>
In-Reply-To: <2424360.s1UolC1PMO@vostro.rjw.lan>
References: <1359819248-3714-1-git-send-email-jbarnes@virtuousgeek.org>
	<1359819248-3714-2-git-send-email-jbarnes@virtuousgeek.org>
	<1933562.n2GhljaZKo@vostro.rjw.lan>
	<2424360.s1UolC1PMO@vostro.rjw.lan>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 151.216.70.212 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Feb 2013 21:50:35 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > + * Drivers can indicate support for switchless suspend/resume, which can
> > > + * save time and flicker, by using this routine and passing 'false' as
> > > + * the argument.  If any loaded driver needs VT switching, or the
> > > + * no_console_suspend argument has been passed on the command line, VT
> > > + * switches will occur.
> > > + */
> > 
> > It seems to me that we'll need a separate counter for the number of registered
> > drivers and do the switch if that number is equal to the number of drivers that
> > have passed false to this thing.
> > 
> > In which case we can simplify this slightly and introduce
> > pm_vt_swtich_not_required(void)
> 
> Sorry, that won't be sufficient.  Rather something like pm_vt_switch_get()
> (indicating "I'll do the switch, thanks") and pm_vt_switch_put() (indicating
> "now you need to do the switch yourself").

I thought of both of your approaches before posting this one, but each
have other problems.  And I found a bug in mine last night.

So I think I need a separate count of drivers that need the switch, and
ones that don't.  Then if either no driver has registered or if the
need_switch count is nonzero, we'll do the switch.  Otherwise, if the
dont_need_switch is nonzero, we can avoid the switch.  I think that'll
handle all the cases I outlined.

My code as posted will fail if one driver needs a switch but then two
switch free drivers register.

Jesse
