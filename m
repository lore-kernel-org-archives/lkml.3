Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947063Ab3BHUgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:36:37 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38923 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946949Ab3BHUgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:36:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
	<20130207141502.04625ea0.akpm@linux-foundation.org>
	<20130208003501.GC31684@hansolo.jdub.homelinux.org>
	<20130208181949.GD31684@hansolo.jdub.homelinux.org>
	<20130208201826.GE31684@hansolo.jdub.homelinux.org>
Date: Fri, 08 Feb 2013 12:36:08 -0800
In-Reply-To: <20130208201826.GE31684@hansolo.jdub.homelinux.org> (Josh Boyer's
	message of "Fri, 8 Feb 2013 15:18:27 -0500")
Message-ID: <87fw16v8zr.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+DvribkbypsteCfIMpqvg6Ccv4zdVj3wc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Josh Boyer <jwboyer@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:

> On Fri, Feb 08, 2013 at 01:19:49PM -0500, Josh Boyer wrote:
>> On Thu, Feb 07, 2013 at 07:35:01PM -0500, Josh Boyer wrote:
>> > On Thu, Feb 07, 2013 at 02:15:02PM -0800, Andrew Morton wrote:
>> > > On Thu, 7 Feb 2013 16:57:42 -0500
>> > > Josh Boyer <jwboyer@redhat.com> wrote:
>> > > 
>> > > > Hi All,
>> > > > 
>> > > > We've hit a weird error in Fedora using the 3.8-rcX kernels.  It seems
>> > > > the mock tool is getting back ENOMEM when doing very simple things that
>> > > > normally just work.  The 3.7 kernels on the same userspace work just
>> > > > fine.  It seems just running 'mock init -v' is enough to cause the
>> > > > failure.
>> > > 
>> > > I assume you're not seeing the "page allocation failure" message and
>> > > backtrace.  This means that either
>> > 
>> > Right.  If I disable our debug options, I see no backtraces at all and
>> > the python app still gets ENOMEM returned.  (See below for those
>> > interested).
>> > 
>> > > a) it's a __GFP_NOWARN callsite.  This is rare.  Or
>> > > 
>> > > b) it's actually a different error but someone went and overwrote a
>> > >    callee's return value with -ENOMEM.  We do this a lot and it sucks.
>> > 
>> > We do it in copy_io :\.
>> > 
>> > > > At first glance it seems copy_io is failing (possibly because
>> > > > get_task_io_context fails), and then the above fallout is printed.  The
>> > > > warning seems fairly valid, but I don't think that is the root of the
>> > > > problem.
>> > > 
>> > > yes, get_task_io_context() might be the place.  Tried adding a few
>> > > error-path printks in there to see what's happening?
>> > 
>> > Yeah, that's my next step.  I guess I know what I'll be doing tomorrow.
>> > 
>> > > I can't see anything around there which leaves interrupts disabled
>> > > though.  It's quite likely that there's some code with is forgetting to
>> > > reenable interrupts on a rarely-tested error path, and that ENOMEM is
>> > > tickling the bug.
>> > 
>> > Right, agreed.  As I said, I think that is mostly a secondary issue.
>> > Hopefully it will be easy to fix once we figure out why we're getting
>> > the ENOMEM error.
>> > 
>> > Python backtrace below.  Seems to be failing on forking a umount command
>> > after init'ing the chroot.  I can put the full output somewhere if
>> > people are interested.
>> 
>> OK.  I've bisected this down to:
>> 
>> 50804fe3737ca6a5942fdc2057a18a8141d00141 is the first bad commit
>> commit 50804fe3737ca6a5942fdc2057a18a8141d00141
>> Author: Eric W. Biederman <ebiederm@xmission.com>
>> Date:   Tue Mar 2 15:41:50 2010 -0800
>> 
>>     pidns: Support unsharing the pid namespace.
>>     
>> 
>> I haven't really gotten much farther than that yet, but the bisect was
>> pretty straight forward.  Eric, is there anything specific I can gather
>> or do to help figure out why that is causing mock to get such a weird
>> error?  I can provide the bisect log if you'd like.
>
> I took a look at what mock was doing and it was mostly very simple
> stuff.  The two exceptions were that it was calling unshare, then doing
> some file checks and I/O, and then calling fork to exec off some helper
> things.  Up until the point it fails, the forks work and the children go
> do whatever it is they were supposed to do.  I've CC'd Clark Williams
> just in case people have questions on mock itself, but I'm not sure that
> will be needed.

Our emails crossed paths.  You have just confirmed my suspicion about
what was going wrong.

The practical question is why mock is calling unshare(CLONE_NEWPID)
because it clearly seems not to understand how to unshare the pid
namespace and use it that way.

Except for forgeting to reenable irqs in the failure path of alloc_pid
the behavior is exactly correct and is how the pid namespace is designed
to behave in the case of unshare.


> which is consistent with what mock is seeing.  If I comment out the call
> to unshare, it seems to always work.  It seems to consistently fail with
> ENOMEM after the first 3-5 forked children, but it varies within that
> range.

If you add a waitpid or space out your forks you will see that it always
fails after your first child in the pid namespace has exited.

We don't allow children in a pid namespace after fork has exited.

Eric
