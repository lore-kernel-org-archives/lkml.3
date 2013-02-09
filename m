Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab3BIUYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 15:24:51 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36449 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932527Ab3BIUYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 15:24:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
        Miklos Szeredi <miklos@szeredi.hu>, Li Fei <fei.li@intel.com>,
        len.brown@intel.com, mingo@redhat.com, peterz@infradead.org,
        biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: [fuse-devel] [PATCH] fuse: make fuse daemon frozen along with kernel threads
Date: Sat, 09 Feb 2013 21:31:10 +0100
Message-ID: <1595169.zvx3Wi6SMv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130209174910.GA28370@amd.pavel.ucw.cz>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <20130208141123.GA29460@frosties> <20130209174910.GA28370@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, February 09, 2013 06:49:10 PM Pavel Machek wrote:
> Hi!
> 
> > > The only way to *reliably* freeze fuse filesystems is to let it freeze
> > > even if there are outstanding requests.  But that's the hardest to
> > > implement, because then it needs to allow freezing of tasks waiting on
> > > i_mutex, for example, which is currently not possible.  But this is
> > > the only way I see that would not have unsolvable corner cases that
> > > prop up at the worst moment.
> > > 
> > > And yes, it would be prudent to  wait some time for pending requests
> > > to finish before freezing.  But it's not a requirement, things
> > > *should* work without that: suspending a machine is just like a very
> > > long pause by the CPU, as long as no hardware is involved.  And with
> > > fuse filesystems there is no hardware involved directly by definition.
> > > 
> > > But I'm open to ideas and at this stage I think even patches that
> > > improve the situation for the majority of the cases would be
> > > acceptable, since this is turning out to be a major problem for a lot
> > > of people.
> > 
> > For shutdown in userspace there is the sendsigs.omit.d/ to avoid the
> > problem of halting/killing processes of the fuse filesystems (or other
> > services) prematurely. I guess something similar needs to be done for
> > freeze. The fuse filesystem has to tell the kernel what is up.
> 
> Would it be feasible to create some kind of fuse-stop-script.sh, and
> run it before suspend (from userspace)? It should be pretty similar to
> sendsigs.omit.d/ mechanism AFAICT.
> 
> I'm sorry, freezer is not too suitable for fuse.
> 
> (BTW: for suspend, we may be able to improve it so that it is possible
> to remove freezer from it. For hibernation, it would be very hard.)

Well, this is so incorrect that it's not even funny. :-(

The whole memory shrinking we do for hibernation is now done by allocating
memory, so the freezer is not necessary for *that* and there's *zero*
difference between suspend and hibernation with respect to why the freezer is
used.

And *the* reason why it's used is that intercepting all of the possible ways
user space could interfere with the suspend process without the freezer is
simply totally impractical.  System calls (including ioctls and fctls),
sysfs accesses, /proc accesses, debugfs, to name a few, and mmap (I wonder how
you would handle *that* alone).  And I'm sure there's more I didn't even
think about.  Moreover, all of the drivers we have assume that user space will
be frozen before their suspend callbacks are run by now and changing that is
totally unrealistic.

So please don't tell people that something is doable while it practically
realisticly isn't.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
