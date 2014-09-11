Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaIKOdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:33:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51330 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752376AbaIKOdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:33:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Thu, 11 Sep 2014 16:52:50 +0200
Message-ID: <23520581.7q253rZGaa@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140911142822.GL22042@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <1973496.9q6IzlQu6V@vostro.rjw.lan> <20140911142822.GL22042@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 11, 2014 04:28:22 PM Michal Hocko wrote:
> On Thu 11-09-14 16:32:50, Rafael J. Wysocki wrote:
> > On Thursday, September 11, 2014 04:10:51 PM Michal Hocko wrote:
> > > On Thu 11-09-14 16:26:56, Rafael J. Wysocki wrote:
> > > > On Thursday, September 11, 2014 04:04:48 PM Michal Hocko wrote:
> > > > > On Thu 11-09-14 16:17:56, Rafael J. Wysocki wrote:
> > > > > [...]
> > > > > > And I'm still wondering if the OOM killer may be made avoid killing frozen
> > > > > > tasks.
> > > > > 
> > > > > This is really tricky. OOM killer aims at the biggest memory hog. We
> > > > > shouldn't ignore it just because it hides into the fridge... So even
> > > > > if we "fix" oom killer to ignore frozen tasks (which is inherently
> > > > > racy btw.) then we have a potential problem of freezer abuse (e.g. in
> > > > > container environments). So I strongly believe that the OOM killer has
> > > > > to be able to kill a frozen tasks.
> > > > 
> > > > OK
> > > > 
> > > > Is the OOM killer the only place where TIF_MEMDIE is set?
> > > 
> > > Yes. To be precise, lowmemorykiller (staging android thingy), global OOM
> > > killer and memcg OOM killer. Any other users would be an abuse.
> > 
> > OK
> > 
> > So can we ensure that those things don't trigger during system suspend (or
> > equivalent) and then simply use the TIF_MEMDIE check in __refrigerator()?
> 
> That would require that no memory allocation triggers OOM killer during
> suspend. I don't think this will work out. OOM killer is the last resort
> action. We cannot simply give access to memory reserves just because the
> current context is in the middle of suspend.

But we can fail the allocation, can't we?

> What is the worst thing that might happen when a task is killed in the
> middle of suspend? I thought that suspend would fail after several
> attempts to suspend all existing tasks.

The problem is what to do when we need to kill a frozen task.

In that case we need to thaw it and then it will die eventually.  Unfortunately,
it generally can do something undesirable before dying.  That may be accessing
a suspended device, for example.

Rafael

