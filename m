Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaKFSWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:22:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36201 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaKFSWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:22:10 -0500
Date: Thu, 6 Nov 2014 19:22:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Chen Yucong <slaoub@gmail.com>, "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
Message-ID: <20141106182206.GG4318@pd.tnic>
References: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
 <1415162873-1874-2-git-send-email-slaoub@gmail.com>
 <20141106153539.GC4318@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329240AE@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F329240AE@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:27:14PM +0000, Luck, Tony wrote:
> >> +int mce_severity(struct mce *m, int tolerant, char **msg, bool is_excp)
> >
> > You're adding a function argument which is carrying redundant info which
> > is already present in *m...
> >
> >>  {
> >> +	enum exception excp = (is_excp ? EXCP_CONTEXT : NO_EXCP);
> >
> > ... and so this should be:
> >
> >	excp = ((m->mcg_status & MCG_STATUS_MCIP) ? EXCP_CONTEXT : NO_EXCP);
> 
> That only works if you trust that MCG_STATUS.MCIP is correctly set to indicate whether
> we are in MCE or CMCI context. The current code doesn't do that - we check for, and flag
> it as a fatal error if we find ourselves in the MCE handler with MCIP==0. If you add the
> code you suggest, then it completely neuters the severity check:
> 
>         MCESEV(
>                 PANIC, "MCIP not set in MCA handler",
>                 MCGMASK(MCG_STATUS_MCIP, 0)
>                 ),

I was looking at the version Chen did:

        MCESEV(
                PANIC, "MCIP not set in MCA handler",
                EXCP, MCGMASK(MCG_STATUS_MCIP, 0)
                ),

and then

                if (s->excp && excp != s->excp)
                        continue;

Basically, this check is being done only for machine check exceptions
only.

> I'm also a bit worried about the check for DEFERRED errors in
> the severity table.  That isn't conditional on an:
>   if (intel) do_onething(); else /*amd/ do_anotherthing();
> So if we can misinterpret some bits on an Intel cpu as if
> we had a deferred error.
> 
> Overall, this might have seemed like a good idea to begin with,
> but we are piling more complexity into mce_severity() [a routine
> which everyone agrees is already tough to understand].
> 
> It doesn't even buy us some simple code in the polling path.
> We still have to do more checks on MCi_STATUS.MCACOD above
> and beyond what we get back from mce_severity()
> 
> Boris: Do you still want to keep pushing this way? Or should
> we look back fondly at version 1 of this patch?

You mean the one which doesn't touch mce_severity() at all and decides
on deferred errors in a separate, completely unrelated function? Yeah,
that might be cleaner after all.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
