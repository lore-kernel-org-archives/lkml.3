Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3GSV2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:28:10 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57317 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751638Ab3GSV2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:28:07 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tim Chen <tim.c.chen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
Date: Fri, 19 Jul 2013 23:38:04 +0200
Message-ID: <4295105.1txhDL4OOg@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1374257329.22432.382.camel@schen9-DESK>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp> <2493652.fjZLqTL8IF@vostro.rjw.lan> <1374257329.22432.382.camel@schen9-DESK>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 19, 2013 11:08:49 AM Tim Chen wrote:
> On Fri, 2013-07-19 at 16:49 +0200, Rafael J. Wysocki wrote:
> > > > > > This should cause udev to load the crct10dif_pclml module when cpu
> > > > > > support the PCLMULQDQ (feature code 0081).  I did my testing during
> > > > > > development on 3.10 and the module was indeed loaded.
> > > > > >
> > > > > > However, I found that the following commit under 3.11-rc1 broke
> > > > > > the mechanism after some bisection.
> > > > > >
> > > > > > commit ac212b6980d8d5eda705864fc5a8ecddc6d6eacc
> > > > > > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > Date:   Fri May 3 00:26:22 2013 +0200
> > > > > >
> > > > > >      ACPI / processor: Use common hotplug infrastructure
> > > > > >      
> > > > > >      Split the ACPI processor driver into two parts, one that is
> > > > > >      non-modular, resides in the ACPI core and handles the enumeration
> > > > > >      and hotplug of processors and one that implements the rest of the
> > > > > >      existing processor driver functionality.
> > > > > >      
> > > > > > Rafael, can you check and see if this can be fixed so those optimized
> > > > > > crypto modules for Intel cpu that support them can be loaded?
> > > > > 
> > > > > I think this is an ordering issue between udev startup and the time when 
> > > > > devices are registered.
> > > > 
> > > > Something that can be fixed?
> > > 
> > > I'm sure it can be fixes, but I'm not sure whether it's a udev bug or real
> > > breakage in the kernel yet.  I need to figure out that part.
> > 
> > OK
> > 
> > I wonder if the appended patch makes the issue go away for you?
> > 
> 
> Rafael, the patch did fix the cpu feature based module loading issue.
> Thanks for your quick response.

Alas, this is not the one I'd like to apply.

With that patch applied, new device objects are created to avoid binding the
processor driver directly to the cpu system device objects, because that
apparently confuses udev and it starts to ignore the cpu modalias once the
driver has been bound to any of those objects.

I've verified in the meantime that this indeed is the case.

A link to the patch in question: https://patchwork.kernel.org/patch/2830561/

Greg, I asked you some time ago whether or not it was possible for udev to stop
autoloading modules that matched the cpu modalias after a driver had been bound
to the cpu system device objects and you said "no".  However, this time I can
say with certainty that that really is the case.  So, the question now is
whether or not we can do anything in the kernel to avoid that confusion in udev
instead of applying the patch linked above (which is beyond ugly in my not so
humble opinion)?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
