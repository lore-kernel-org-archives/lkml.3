Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaDPCdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:33:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaDPCdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:33:09 -0400
Date: Tue, 15 Apr 2014 22:33:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Satoru MORIYA <satoru.moriya.br@hitachi.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/panic: Add "late_kdump" option for kdump in
 unstable condition
Message-ID: <20140416023302.GC5035@redhat.com>
References: <20140414045158.10846.35462.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140414193153.GC4281@redhat.com>
 <534C8D64.2070108@hitachi.com>
 <20140415140853.GA17018@redhat.com>
 <534DDCC7.2070003@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534DDCC7.2070003@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:28:39AM +0900, Masami Hiramatsu wrote:
> (2014/04/15 23:08), Vivek Goyal wrote:
> > On Tue, Apr 15, 2014 at 10:37:40AM +0900, Masami Hiramatsu wrote:
> > 
> > [..]
> >>> Masami,
> >>>
> >>> So what's the alternative to kdump which is more reliable? IOW, what
> >>> action you are planning to take through kmsg_dump() or through
> >>> panic_notifiers?
> >>>
> >>> I have seen that many a times developers have tried to make the case 
> >>> to save kernel buffers to NVRAM. Does it work well? Has it been proven
> >>> to be more reliable than kdump?
> >>
> >> Yeah, one possible option is the NVRAM, but even with the serial,
> >> there are other reasons to kick the notifiers, e.g.
> >>  - dump to ipmi which has a very small amount of non-volatile memory
> >>  - ftrace_dump() to dump "flight recorder" log to serial
> > 
> > So why do we need to run them in crashed kernel? Only argument I seem
> > to receive that there is no guarantee that kdump kernel will successfully
> > boot hence we want to run these notifiers.
> > 
> > But what's the guarantee that these will run successfully without creating
> > futher issues? Is there data to prove it.
> 
> I think there is no guarantee, but that's same as kdump is.
> However, if we can try both, there is higher possibility (more cases)
> to save some information.

This is only valid if the entity which is running before kdump has 
higher probability of saving some useful information. So do kmsg_dump()
and backend drivers provide more reliable way to save kernel logs as
compared to kdump? 

[..]
> > I think big debate here is that we should be able to do most of it
> > in second kernel. 
> 
> No, that's another topic what we talk about.
> 
> What I (and others who had argued) consider that in some rare cases,
> kdump might fail to boot up the second kernel, and only for who worries
> in those cases, we can give a chance.

And *rare failure cases* don't exist in other mechanisms which are
planning to take control before kdump? You are assuming that any entity
which runs before kdump is more reliable than kdump. And I don't think
anybody has any data to prove that. People are just looking for a hook
to execute things before kdump hoping that it will provide them better
results.

> 
> > If you provide a knob to run these in first kernel, this functionality
> > will never migrate to second kernel.
> 
> No, there are many use-cases which doesn't (and can't) use kdump
> because of the limitation of resources etc. For those cases, that
> functionality never migrate (means move) to the second one.

What are those use cases? What resources you are referring too. Are you
planning to do a whole lot after kernel has crashed. That will not make
much sense.

> 
> > And trying to make them safe in
> > crashed kernel is a losing battle, I think.
> 
> Why? the best goal what users expect is both panic-notifiers and kdump
> runs safely. If one of them fails, that's a bug (except for some rare
> hardware-related corruption.)

So you think that running panic-notifiers can be made safe? How would
we do that?

What's the special action panicn notifiers are taking which can't be
done in second kernel. 

> 
> > So providing this knob does not help with making these notifiers better.
> > These notifiers can become better only if migrate the functionality
> > to second kernel (preferrably in user space). There we can extract all
> > the data from /proc/vmcore and send it whereever you want.
> 
> I see, that is also an important work, but that is done in userspace.
> In kernel space, we can do something to give them a chance.

If the goal is to send kernel buffers at some location, then it does
not matter whether a kernel driver does it or a user space application
extracts buffers and then takes help of driver to send it.

> 
> > But for that you will have to trust kdump and keep on improving it
> > constantly so that it works reasonably well.
> 
> I trust you and kdump :) but I also know that in some rare cases that
> kdump can't finish booting up, at least currently. So, if you sure
> kdump is improved to boot up the second in any situation, I'm happy
> to withdraw from this patch.

Kdump is best effort solution. I don't think anybody can guarantee that
it will work in all situations.

And same will be true for different notifiers you are trying to run
before kdump. By running those notifiers you can't be sure that they
will always work and there are no corner cases.

So to me, late_kdump will make sense only if you have an alternate
mechanism which can more reliably save kernel buffers as compared to
kdump. My feeling is that nobody knows how reliable these kmsg_dump(),
NVRAM saving hooks are. Proponets of these hooks seem to be believe
that it will provide them a safety net in case kdump fails.

Given the fact that people have been asking for this for years, I 
think creating a command line parameter to switch to that behavior
is probably not a bad idea. Distributions can probably continue to
run without specifying "late_kdump" and those specific users who wish
to run kmsg_dump() hooks before kdump, can configure their system with
"late_kdump" parameter.

Thanks
Vivek
