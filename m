Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3LJQa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:30:57 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49561 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3LJQa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:30:56 -0500
Date: Tue, 10 Dec 2013 17:30:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: suravee.suthikulpanit@amd.com, mingo@kernel.org, mingo@redhat.com,
        jacob.w.shin@gmail.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hpa@zytor.com, tgl@domain.invalid,
        linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20131210163051.GI10633@localhost.localdomain>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20131210152342.GE10633@localhost.localdomain>
 <20131210161945.GA23086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210161945.GA23086@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 05:19:45PM +0100, Oleg Nesterov wrote:
> On 12/10, Frederic Weisbecker wrote:
> >
> > On Wed, Oct 02, 2013 at 11:11:06AM -0500, suravee.suthikulpanit@amd.com wrote:
> > > @@ -279,7 +260,16 @@ static int arch_build_bp_info(struct perf_event *bp)
> > >  	}
> > >
> > >  	/* Len */
> > > +	info->mask = 0;
> > > +
> > >  	switch (bp->attr.bp_len) {
> > > +	default:
> > > +		if (!is_power_of_2(bp->attr.bp_len))
> > > +			return -EINVAL;
> > > +		if (!cpu_has_bpext)
> > > +			return -EOPNOTSUPP;
> > > +		info->mask = bp->attr.bp_len - 1;
> > > +		/* fall through */
> >
> > So, that's perhaps just personal preference but having the default on
> > top of the switch makes things very confusing. Can't we put the above
> > in the end of the switch instead?
> 
> Then "fall through" won't work ;)

Indeed, now may be that's just me but it's very hard to parse :)

There are other ways to perform the above, it's no big deal if
we duplicate one line of code.

> 
> > > @@ -314,11 +303,11 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
> > >  	if (ret)
> > >  		return ret;
> > >
> > > -	ret = -EINVAL;
> > > -
> > >  	switch (info->len) {
> > >  	case X86_BREAKPOINT_LEN_1:
> > >  		align = 0;
> > > +		if (info->mask)
> > > +			align = info->mask;
> >
> > Confused, I thought mask is set only when length is above 8?
> 
> Yes. But we need the info->len for hw anyway. if mask != 0 then
> len == X86_BREAKPOINT_LEN_1 and it is still used by encode_dr7().
> Note that it is not the length in bytes, it is the magic x86 code.

Good point, and that matches the above fallthrough.

Thanks.

> 
> ->bp_len is the length.
> 
> Oleg.
> 
