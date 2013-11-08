Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab3KHQZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:25:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212Ab3KHQZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:25:04 -0500
Date: Fri, 8 Nov 2013 11:24:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        akpm@linux-foundation.org, davej@fedoraproject.org,
        rmk+kernel@arm.linux.org.uk, chaowang@redhat.com, mwhitehe@redhat.com,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Robin Holt <robinmholt@linux.com>, Robin Holt <robinmholt@gmail.com>
Subject: Re: [PATCH] x86: make reboot task only run on the appropriate
 processor
Message-ID: <20131108162421.GC13068@redhat.com>
References: <1383642967-12595-1-git-send-email-bhe@redhat.com>
 <20131108151416.GA13068@redhat.com>
 <527D0D50.6010607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527D0D50.6010607@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 08:12:00AM -0800, H. Peter Anvin wrote:
> On 11/08/2013 07:14 AM, Vivek Goyal wrote:
> > 
> > Hi Bao,
> > 
> > This patch fixes the issue for me too. I noticed that we have generic
> > function migrate_to_reboot_cpu() to achieve what we want and rest of
> > the reboot paths are using it. So how about using that function. I 
> > wrote the new patch below. It works for me. Can you please give it
> > a try.
> > 
> > Thanks
> > Vivek
> > 
> 
> Is this path exercised for the kdump flow?  migrate_to_reboot_cpu() is
> unsafe in that case.

kdump path should not be affected by this change as it uses crash_kexec()
instead of kerenl_kexec() for its entry. And crash_kexec() path does not
call migrate_to_reboot_cpu().

Thanks
Vivek

> 
> > Index: linux-2.6/kernel/kexec.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/kexec.c	2013-10-16 00:30:50.000000000 -0400
> > +++ linux-2.6/kernel/kexec.c	2013-11-08 21:34:02.492072375 -0500
> > @@ -1676,6 +1676,7 @@ int kernel_kexec(void)
> >  #endif
> >  	{
> >  		kernel_restart_prepare(NULL);
> > +		migrate_to_reboot_cpu();
> >  		printk(KERN_EMERG "Starting new kernel\n");
> >  		machine_shutdown();
> >  	}
> > 
