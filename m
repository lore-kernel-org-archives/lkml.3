Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab3BNQue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:50:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57418 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3BNQuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:50:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: Re: [PATCH] driver core: add wait event for deferred probe
Date: Thu, 14 Feb 2013 16:50:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
        hpa@linux.intel.com, Jim Cromie <jim.cromie@gmail.com>,
        linux-kernel@vger.kernel.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        broonie@opensource.wolfsonmicro.com,
        Patch Tracking <patches@linaro.org>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org> <201302141557.18308.arnd@arndb.de> <CAD6h2NS_eR7zJjwAuBJPRrCb9=-4r=y-QJt7Lvg5U+yBf-e=kw@mail.gmail.com>
In-Reply-To: <CAD6h2NS_eR7zJjwAuBJPRrCb9=-4r=y-QJt7Lvg5U+yBf-e=kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302141650.21144.arnd@arndb.de>
X-Provags-ID: V02:K0:cbrq2SLR4IMwgM2PqffhIokY+GzLZysn6R79YwCGdbX
 uZ8exGXUCuaGIegFKRzAciKkxWokuXEDqsd7VxL4xgryF97NNz
 D07HMoQN9xmePzRndBctLxPAQ3HITk9O0X/yexP6bfOfnCmVrH
 ln0MS14x2pNJtgWbDVK7LQs8pAIiZRgg2+AVNwmt1PpLn5bKmX
 S014+DaW/RFj8VXumHwJAx5vRQPuQ46rD94+knrpnG/Nak9T9b
 ekD40WIXu1HZRpGOifFRk7t1AGolARu4gdCgl18J4FGNz2sIZT
 iG9VDt3FeoJrux5b8OLfd5KIzTz4bJv4lKePLEQmcdS42dLS/2
 etViJftZ45Gw42xT9ADU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013, Haojian Zhuang wrote:
> On 14 February 2013 23:57, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 14 February 2013, Haojian Zhuang wrote:
> >> If you can change it into code in below, it could work. Otherwise, it
> >> always fails.
> >>         driver_deferred_probe_enable = true;
> >>         driver_deferred_probe_trigger();
> >> +      deferred_probe_work_func(NULL);
> >>         return 0;
> >>
> >> Because deferred_probe_work_func() depends on that deferred_probe is added
> >> into deferred_probe_active_list. If driver_deferred_probe_trigger() isn't called
> >> first, the deferred uart probe can't be added into active list. So even you call
> >> work_func at here, it doesn't help.
> >>
> >
> > Would that not cause two instances of the work function to run at the same time?
> > That sounds like a source for a lot of problems.
> >
> >         Arnd
> 
> Two instances of the work function? I'm sorry that I don't
> understanding your meaning.
> Could you help explain your question?

I mean you end up calling the work function directly, while it gets run as part
of the work queue on a different CPU at the same time. I just noticed that
there is actually locking in place in deferred_probe_work_func that prevents
any actual bugs, but you are still adding extra overhead here.

Maybe just add

	flush_workqueue(deferred_wq);

here?

	Arnd
