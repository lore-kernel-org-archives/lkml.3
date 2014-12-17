Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaLQKpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:45:24 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:45807 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaLQKpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:45:23 -0500
Date: Wed, 17 Dec 2014 11:45:16 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: "Marcel J.E. Mol" <marcel@mesa.nl>
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, ebiederm@xmission.com,
        oleg@redhat.com, luto@amacapital.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make /proc/<pid>/io world readable
Message-ID: <20141217104516.GA3202@dztty>
References: <20141211162228.GA10717@rim.emol.mesa.nl>
 <20141211192911.GA3080@dztty>
 <20141211230453.GB30907@joshua.mesa.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211230453.GB30907@joshua.mesa.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel (sorry for my late response),

On Fri, Dec 12, 2014 at 12:04:53AM +0100, Marcel J.E. Mol wrote:
> On Thu, Dec 11, 2014 at 08:29:11PM +0100, Djalal Harouni wrote:
> > Hi,
> > 
> > On Thu, Dec 11, 2014 at 05:22:28PM +0100, Marcel Mol wrote:
> > > /proc/<pid>/io is only readable by the pid owner, while files
> > > like stat, statm and status are world readable.
> > > I see no reason why io statistics should be hidden.
> > > This patch makes io also world readable so process io counts
> > > can be analysed without root permissions.
> > As Andy noted this should be the other way around! so unless you have
> > a real usecase, this will revert previous patch by Vasiliy that closed
> > some info leaks...
> > https://lkml.org/lkml/2011/7/27/459
> > 
> > Thanks!
> 
> Hi Djalal, thanks for pointing this out. I did look for info like this,
> but did not look that far back. I can see the issues Vasiliy points out.
>
> I do not have a real important usecase, but it is just convenience.
> On my home (personal) workstation I trust noone is looking for my
> password length in ssh or ftp, but I sometimes do like to see what
> process is keeping my disk busy. And I want to limit switching to
> root...
Even if capabilities are not the best model, but they are useful here,
just use a small helper (aliased to whatever you want) that have a
hardcoded path to /proc/%u/io ,later give it CAP_DAC_OVERRIDE and
CAP_SYS_PTRACE

> So I guess I'm more interested in the read_byte, write_bytes and
> cancelled_write_bytes fields (Per physical disk or filesystem
> preferably.)
> Would that give away any sensitive information? 
I'm not sure here, perhaps a matter of time before someone else
interested pops up with a reaserch on this?!

> If not maybe a separate /proc/PID/dio can be created to show only
> these fields.
Hmm, you could try if you think that it can be accepted! but do know
that these days new procfs features are rare unless they are justified
I don't know what others think about this.


> Thanks.
> -Marcel
> 
> > 
> > > Signed-off-by: Marcel Mol <marcel@mesa.nl>
> > > ---
> > >  fs/proc/base.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > > index 772efa4..7bd8dbe 100644
> > > --- a/fs/proc/base.c
> > > +++ b/fs/proc/base.c
> > > @@ -2563,7 +2563,7 @@ static const struct pid_entry tgid_base_stuff[] = {
> > >  	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
> > >  #endif
> > >  #ifdef CONFIG_TASK_IO_ACCOUNTING
> > > -	ONE("io",	S_IRUSR, proc_tgid_io_accounting),
> > > +	ONE("io",	S_IRUGO, proc_tgid_io_accounting),
> > >  #endif
> > >  #ifdef CONFIG_HARDWALL
> > >  	ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
> > > @@ -2904,7 +2904,7 @@ static const struct pid_entry tid_base_stuff[] = {
> > >  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> > >  #endif
> > >  #ifdef CONFIG_TASK_IO_ACCOUNTING
> > > -	ONE("io",	S_IRUSR, proc_tid_io_accounting),
> > > +	ONE("io",	S_IRUGO, proc_tid_io_accounting),
> > >  #endif
> > >  #ifdef CONFIG_HARDWALL
> > >  	ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
> > > -- 
> > > 1.9.3
> > > 
> > > 
> > 
> > -- 
> > Djalal Harouni
> > http://opendz.org
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
>      ======--------         Marcel J.E. Mol                MESA Consulting B.V.
>     =======---------        ph. +31-(0)6-54724868          P.O. Box 112
>     =======---------        marcel@mesa.nl                 2630 AC  Nootdorp
> __==== www.mesa.nl ---____U_n_i_x______I_n_t_e_r_n_e_t____ The Netherlands ____
>  They couldn't think of a number,           Linux user 1148  --  counter.li.org
>     so they gave me a name!  -- Rupert Hine  --  www.ruperthine.com

-- 
Djalal Harouni
http://opendz.org
