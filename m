Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaFXJ2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:28:49 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53620 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXJ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:28:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-watchdog@vger.kernel.org, dbaryshkov@gmail.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        dwmw2@infradead.org
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog driver
Date: Tue, 24 Jun 2014 11:27:45 +0200
Message-ID: <20298828.cYNPnTRxWX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53A8A084.3000005@roeck-us.net>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com> <20140623213046.GR22347@spo001.leaseweb.com> <53A8A084.3000005@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Ei8yeDbaQZor1Xob69BOlPKvoSS7WsGyDVWUcWwXBd/
 a841SmgXR65jP73OU8pXR5E0txNJYyhs8FYUDk+hLT6do7sqQc
 95gF7NHKZkPVcJh9WVx6pvT6DWuVSJdZgiF2t87ovGjaB7Sb/d
 NNen4oOzKY4D79HP/mT85T5C8ygxLMtdumxzQonn99OAslz+x6
 puu/lZoTYsUjb6mXcSXg4rm4hDZaqlwIG8Kquci9lEECWaLX4S
 N3xYMijBMaRIl5YZTCvRS7UCXVK39RAUPtk3jv5DhqLXgjDMGT
 vM60I4QHN/6GAracqknDZ7tI3J7o2W5KFRoOpjMEIwWyJHruFs
 Xu0pk38Ho4ddX1sicqE8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2014 14:47:48 Guenter Roeck wrote:
> > To continue the discussion: I would like to add an excerpt from drivers/watchdog/alim7101_wdt.c
> > /*
> >   *      Notifier for system down
> >   */
> >
> > static int wdt_notify_sys(struct notifier_block *this,
> >                                          unsigned long code, void *unused)
> > {
> >          if (code == SYS_DOWN || code == SYS_HALT)
> >                  wdt_turnoff();
> >
> >          if (code == SYS_RESTART) {
> >                  /*
> >                   * Cobalt devices have no way of rebooting themselves other
> >                   * than getting the watchdog to pull reset, so we restart the
> >                   * watchdog on reboot with no heartbeat
> >                   */
> >                  wdt_change(WDT_ENABLE);
> >                  pr_info("Watchdog timer is now enabled with no heartbeat - should reboot in ~1 second\n");
> >          }
> >          return NOTIFY_DONE;
> > }
> >
> > For some systems the watchdog is the only way to reboot... So where we should put it, is not trivial neither...
> >
> 
> Agreed. The above definitely doesn't look like a good solution to me.
> 

Right, at the very least, it should be a separate notifier: the existing
reboot_notifier is meant for things that need to happen /before/ reboot,
so adding something in there to actually trigger the reboot is by definition
racy against the other notifiers that may or may not get called after
this one.

	Arnd
