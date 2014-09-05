Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaIES3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:29:33 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61331 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIES3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:29:31 -0400
Date: Fri, 5 Sep 2014 11:29:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Zhangjin <falcon@meizu.com>, Takashi Iwai <tiwai@suse.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, hare@suse.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Santosh Rastapur <santosh@chelsio.com>, Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Casey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC v2 3/6] kthread: warn on kill signal if not OOM
Message-ID: <20140905182928.GB29003@core.coreip.homeip.net>
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
 <CAB=NE6Wti1RpAFk5q_YeZn2F9Rd=wsiwhyPszu74nG9fXwH5vQ@mail.gmail.com>
 <20140905141241.GC10455@mtj.dyndns.org>
 <20140905164405.GA28964@core.coreip.homeip.net>
 <20140905174925.GA12991@mtj.dyndns.org>
 <CAB=NE6VPTV39pNujOgO422wbUvU44HZ7s=aaxPVraNECqA6e4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6VPTV39pNujOgO422wbUvU44HZ7s=aaxPVraNECqA6e4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 11:12:17AM -0700, Luis R. Rodriguez wrote:
> On Fri, Sep 5, 2014 at 10:49 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello,
> >
> > On Fri, Sep 05, 2014 at 09:44:05AM -0700, Dmitry Torokhov wrote:
> >> Which problem are we talking about here though? It does solve the slow device
> >> stalling the rest if the kernel booting (non-module case) for me.
> >
> > The other one.  The one with timeout.  Neither cxgb4 or pata_marvell
> > has slow probing stalling boot problem.
> >
> >> I also reject the notion that anyone should be relying on drivers to be fully
> >> bound on module loading. It is not nineties anymore. We have hot pluggable
> >> buses, deferred probing, and even for not hot-pluggable ones the module
> >> providing the device itself might not be yet loaded. Any scripts that expect to
> >> find device 100% ready after module loading are simply broken.
> >
> > We've been treating loading + probing as a single operation when
> > loading drivers and the assumption has always been that the existing
> > devices at the time of loading finished probing by the time insmod
> > finishes.  We now need to split loading and probing and wait for each
> > of them differently.  The *only* thing we can do is somehow making the
> > issuer specify that it's gonna wait for probing separately.  I'm not
> > sure this can even be up for discussion.  We're talking about a major
> > userland visible behavior change.  We simply can't change it
> > underneath the existing users.
> 
> Meanwhile we are allowing a major design consideration such as a 30
> second timeout for both init + probe all of a sudden become a hard
> requirement for device drivers. I see your point but can't also be
> introducing major design changes willy nilly either. We *need* a
> solution for the affected drivers.
> 
> Also what stops drivers from going ahead and just implementing their
> own async probe? 

They already do and the problem is that they do that poorly. One of the issues
is that the device is considered bound and so may attempt to suspend/resume
them, or unbind them, and the driver is not ready for such operations to take
place.

And even though driver is bound "synchronously" it does not help the user in
the slightest and the object that is the result of driver initialization is
still created asynchronously and is not ready (well, it might if drivers use
async_schedule as we are doing asych_sycnhronize_full() in module load.unload).

Thanks.

-- 
Dmitry
