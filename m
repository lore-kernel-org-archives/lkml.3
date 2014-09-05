Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaIESMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:12:41 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:41530 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaIESMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:12:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140905174925.GA12991@mtj.dyndns.org>
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
 <CAB=NE6Wti1RpAFk5q_YeZn2F9Rd=wsiwhyPszu74nG9fXwH5vQ@mail.gmail.com>
 <20140905141241.GC10455@mtj.dyndns.org> <20140905164405.GA28964@core.coreip.homeip.net>
 <20140905174925.GA12991@mtj.dyndns.org>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 5 Sep 2014 11:12:17 -0700
X-Google-Sender-Auth: mG7l6i04sV3omuPrUIJBq0IG1Qs
Message-ID: <CAB=NE6VPTV39pNujOgO422wbUvU44HZ7s=aaxPVraNECqA6e4Q@mail.gmail.com>
Subject: Re: [RFC v2 3/6] kthread: warn on kill signal if not OOM
To: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 10:49 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Sep 05, 2014 at 09:44:05AM -0700, Dmitry Torokhov wrote:
>> Which problem are we talking about here though? It does solve the slow device
>> stalling the rest if the kernel booting (non-module case) for me.
>
> The other one.  The one with timeout.  Neither cxgb4 or pata_marvell
> has slow probing stalling boot problem.
>
>> I also reject the notion that anyone should be relying on drivers to be fully
>> bound on module loading. It is not nineties anymore. We have hot pluggable
>> buses, deferred probing, and even for not hot-pluggable ones the module
>> providing the device itself might not be yet loaded. Any scripts that expect to
>> find device 100% ready after module loading are simply broken.
>
> We've been treating loading + probing as a single operation when
> loading drivers and the assumption has always been that the existing
> devices at the time of loading finished probing by the time insmod
> finishes.  We now need to split loading and probing and wait for each
> of them differently.  The *only* thing we can do is somehow making the
> issuer specify that it's gonna wait for probing separately.  I'm not
> sure this can even be up for discussion.  We're talking about a major
> userland visible behavior change.  We simply can't change it
> underneath the existing users.

Meanwhile we are allowing a major design consideration such as a 30
second timeout for both init + probe all of a sudden become a hard
requirement for device drivers. I see your point but can't also be
introducing major design changes willy nilly either. We *need* a
solution for the affected drivers.

Also what stops drivers from going ahead and just implementing their
own async probe? Would that now be frowned upon as it strives away
from the original design? The bool would let those drivers do this
easily, and we would still need to identify these drivers, although
this particular change can be NAK'd Oleg's suggestion on
WARN_ON(fatal_signal_pending() at the end of load_module() seems to me
at least needed. And if its not async probe... what do those with
failed drivers do?

  Luis
