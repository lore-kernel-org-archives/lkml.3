Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaEMP1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:27:25 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57951 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753286AbaEMP1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:27:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily
Date: Tue, 13 May 2014 17:43:55 +0200
Message-ID: <1652919.R3bbdKUH5p@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1405131110480.1098-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1405131110480.1098-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 13, 2014 11:12:28 AM Alan Stern wrote:
> On Tue, 13 May 2014, Rafael J. Wysocki wrote:
> 
> > > > +	dev->power.direct_complete = ret > 0 && state.event == PM_EVENT_SUSPEND
> > > > +					&& pm_runtime_suspended(dev);
> > > 
> > > Shouldn't the flag be set under the spinlock?
> > 
> > I guess you're worried about runtime PM flags being modified in parallel to
> > this?  But we've just done the barrier a while ago, so is that still a concern
> > here?
> 
> A wakeup request from the hardware could cause a runtime resume to 
> occur at this time.  The barrier wouldn't prevent that.
> 
> It's unlikely, I agree, but not impossible.

Yeah, I didn't think about that.

But that also can occur in __device_suspend(), after we've checked the flag
and decided not to invoke the ->suspend() callback, right?  So moving the
check in there doesn't help much I'd say.  It closes the race window, but
that's it.

That means that the whole approach based on ->prepare() is problematic
unless we somehow mix it with disabling runtime PM.

Rafael

