Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422694Ab3BOO44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:56:56 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38921 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161283Ab3BOO4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:56:55 -0500
Date: Fri, 15 Feb 2013 18:56:48 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] x86: make PTRACE_GETREGSET return 32-bit regs if 64-bit
 process entered kernel with int 80
Message-ID: <20130215145648.GE8193@moon>
References: <511CE3D0.8000308@redhat.com>
 <20130214150046.GA30543@redhat.com>
 <511D2779.7040504@zytor.com>
 <20130214191842.GA11620@redhat.com>
 <511D3928.80402@zytor.com>
 <20130214205521.GA20085@moon>
 <511E4B43.7040202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511E4B43.7040202@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 03:50:43PM +0100, Denys Vlasenko wrote:
> On 02/14/2013 09:55 PM, Cyrill Gorcunov wrote:
> > On Thu, Feb 14, 2013 at 11:21:12AM -0800, H. Peter Anvin wrote:
> >> On 02/14/2013 11:18 AM, Oleg Nesterov wrote:
> >>> On 02/14, H. Peter Anvin wrote:
> >>>>
> >>>> On 02/14/2013 07:00 AM, Oleg Nesterov wrote:
> >>>>> On 02/14, Denys Vlasenko wrote:
> >>>>>>
> >>>>>> Determining personality of a ptraced process is a murky area.
> >>>>>> On x86, for years strace was looking at segment selectors,
> >>>>>> which is conceptually wrong: see, for example,
> >>>>>> https://lkml.org/lkml/2012/1/18/320
> >>>>>>
> >>>>
> >>>> One proposal that keeps being on the table is to export a regset with
> >>>> metadatam, including process mode at launch (i386, x86-64, x32).
> >>>
> >>> Yes... but if this metadata includes TS_COMPAT-is-set, then strace should
> >>> do PTRACE_GETREGSET(REGSET_META) + PTRACE_GETREGSET(REGSET_GENERAL) every
> >>> time. Or REGSET_META should include META+GENERAL.
> >>>
> >>> IOW, it is not clear to me what this "meta" should actually report.
> >>
> >> That is one of the things that needs to be nailed down.  In particular,
> >> what are the things people need.
> > 
> > Indeed, having some "official" way for compat bit retrieval would be
> > a great thing for us (c/r camp) since we've just met the same problem.
> > And at moment I sticked for the same trick as gdb does (cs/ds test).
> > 
> > But, guys, if only I'm not missing something completely obvious,
> > can't we simply provide task-compat bit to userspace in say /proc/pid/stat
> > or something? Then the strace/gdb would be able to always know if
> > the tracee is actually in compat mode. Or I miss something fundamental
> > here?
> 
> strace needs to get that data on every syscall entry in the traced process.
> Doing open/read/close on every syscall entry is going to slow it down a lot.

Don't you need to read it only once when strace is attached? Compat flag can't
be arbitrary dropped when program executes, no?
