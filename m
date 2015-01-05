Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbbAESHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:07:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbbAESHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:07:49 -0500
Date: Mon, 5 Jan 2015 13:07:43 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com
Subject: Re: [PATCH] TaskTracker : Simplified thread information tracker.
Message-ID: <20150105180743.GI29998@madcap2.tricolour.ca>
References: <20140927091440.6fe54f43@ivy-bridge>
 <201409280012.FGE05239.VtFOSMOJFOFQLH@I-love.SAKURA.ne.jp>
 <20141007213054.GJ26201@madcap2.tricolour.ca>
 <201410102140.HHB30768.tFVJSFQOMLOOFH@I-love.SAKURA.ne.jp>
 <20141010124923.GD2966@madcap2.tricolour.ca>
 <201501042050.EEH30201.FJVtFHMQOLSFOO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501042050.EEH30201.FJVtFHMQOLSFOO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/04, Tetsuo Handa wrote:
> Hello.
> 
> Richard Guy Briggs wrote:
> > > Richard Guy Briggs wrote:
> > > > On 14/09/28, Tetsuo Handa wrote:
> > > > > (Q2) Does auxiliary record work with only type=SYSCALL case?
> > > > 
> > > > Auxiliary records don't work with AUDIT_LOGIN because that record has a
> > > > NULL context.  Similarly for core dumps (AUDIT_ANOM_ABEND), AUDIT_SECCOMP,
> > > > configuration changes (AUDIT_CONFIG_CHANGE, AUDIT_FEATURE_CHANGE), most
> > > > (all?) AUDIT_USER_* messages.
> > > > 
> > > I see, thank you.
> > > 
> > > Although I feel that, from the point of view of troubleshooting, emitting
> > > history of thread's comm name into NULL-context records would help sysadmin
> > > to map login session and operations a user did from that login session,
> > > I'm OK with starting history of thread's comm name as auxiliary records
> > > (i.e. not emitted into NULL-context records).
> > > 
> > > Adding LKML for reviewers. What else can I do for merging this patch?
> > 
> > I'm willing to take it with some reflection and no significant
> > objections, in particular from userspace audit.  I'll have a closer look
> > at it.
> 
> Any comments on this patch?

Steve already mentioned any user-influenced fields need to be escaped,
so I'd recommend audit_log_untrustedstring() as being much simpler from
your perspective and much better tested and understood from audit
maintainer's perspective.  At least use the existing 'o' printf format
specifier instead of inventing your own.  I do acknowledge that the
resulting output from your function is easier to read in its raw format
passed from the kernel, however, it makes your code harder to maintain.

As for the date-stamping bits, they seem to be the majority of the code
in audit_update_history().  I'd just emit a number and punt that to
userspace for decoding.  Alternatively, I'd use an existing service in
the kernel to do that date formatting, or at least call a new function
to format that date string should a suitable one not already exist, so
you can remove that complexity from audit_update_history().

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
