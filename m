Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaEHW1C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:27:02 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49774 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755895AbaEHW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:26:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [RFC][PATCH 0/3] (was: Re: PM / sleep: Flag to speed up suspend-resume of runtime-suspended devices)
Date: Fri, 09 May 2014 00:28:37 +0200
Message-ID: <4232134.uNVe9bptuo@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2356017.WpDFDYKWcr@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1405081718200.995-100000@iolanthe.rowland.org> <1516837.oN5cf7KDad@vostro.rjw.lan> <2356017.WpDFDYKWcr@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 11:50:23 PM Rafael J. Wysocki wrote:
> On Thursday, May 08, 2014 11:42:01 PM Rafael J. Wysocki wrote:
> > On Thursday, May 08, 2014 05:20:43 PM Alan Stern wrote:
> > > On Thu, 8 May 2014, Rafael J. Wysocki wrote:
> > > 
> > > > > > Wait a minute.  Following ->runtime_suspend(), you are going to call 
> > > > > > ->suspend() and then ->runtime_resume()?  That doesn't seem like what 
> > > > > > you really want; a ->suspend() call should always have a matching 
> > > > > > ->resume().
> > > > > 
> > > > > Yes, it should, but I didn't see any other way to do that.
> > > > 
> > > > Actually, that's kind of easy to resolve. :-)
> > > > 
> > > > When ->suspend() leaves power.leave_runtime_suspended set, the PM core can
> > > > simply skip the early/late and noirq callbacks and then call ->resume()
> > > > that will be responsible for using whatever is necessary to resume the
> > > > device.
> > > > 
> > > > And perhaps the flag should be called something different then, like
> > > > direct_resume (meaning go directly for ->resume() without executing
> > > > the intermediate callbacks)?
> > > 
> > > In light of what I wrote earlier, it should be okay for the ->prepare() 
> > > callback to be responsible for setting leave_runtime_suspended.  Then 
> > > there will be no need to call either ->suspend() or ->resume().
> > 
> > Hmm.  OK, let's try that.
> 
> Well, no.
> 
> The reason why that doesn't work is because ->prepare() callbacks are
> executed in the reverse order, so the perent's ones will be run before
> the ->prepare() of the children.  Thus if ->prepare() sets the flag
> with the expectation that ->suspend() (and the subsequent callbacks)
> won't be executed, that expectation may not be met actually.
> 
> So I'm going to do what I said above.  I prefer it anyway. :-)

Reworked patches follow (again).

I followed the Ulf's suggestion to make the helpers depend on PM_RUNTIME
instead of adding the new CONFIG_ symbol.

Rafael

