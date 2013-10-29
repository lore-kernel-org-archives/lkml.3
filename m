Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab3J2Vt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:49:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab3J2Vty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:49:54 -0400
Date: Tue, 29 Oct 2013 14:49:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v3 1/3] msi: free msi_desc entry only after we've
 released the kobject
Message-ID: <20131029214953.GB19354@kroah.com>
References: <1383042632-7102-1-git-send-email-vfalico@redhat.com>
 <1383042632-7102-2-git-send-email-vfalico@redhat.com>
 <CA+55aFxt9KnmZnK5QdkPcpHNR+Ath5WTzhRibu5Y=xOhiz3fzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxt9KnmZnK5QdkPcpHNR+Ath5WTzhRibu5Y=xOhiz3fzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 09:34:28AM -0700, Linus Torvalds wrote:
> On Tue, Oct 29, 2013 at 3:30 AM, Veaceslav Falico <vfalico@redhat.com> wrote:
> >                 /*
> >                  * Its possible that we get into this path
> >                  * When populate_msi_sysfs fails, which means the entries
> >                  * were not registered with sysfs.  In that case don't
> > -                * unregister them.
> > +                * unregister them, and just free. Otherwise the
> > +                * kobject->release will take care of freeing the entry via
> > +                * msi_kobj_release().
> >                  */
> >                 if (entry->kobj.parent) {
> >                         kobject_del(&entry->kobj);
> >                         kobject_put(&entry->kobj);
> > +               } else {
> > +                       kfree(entry);
> >                 }
> > -
> > -               list_del(&entry->list);
> > -               kfree(entry);
> 
> So this code sequence still makes me very unhappy.
> 
> Why does not just a simple unconditional
> 
>         kobject_del(&entry->kobj);
>         kobject_put(&entry->kobj);
> 
> work for the "not registered with sysfs" case? And if the sysfs code
> really gets confused, why not
> 
>         if (entry->kobj.parent)
>                 kobject_del(&entry->kobj);
>         kobject_put(&entry->kobj);
> 
> (btw, looking at the sysfs code, this looks *very* suspicious in
> sysfs_remove_dir():
> 
>         struct sysfs_dirent *sd = kobj->sd;
> 
>         spin_lock(&sysfs_assoc_lock);
>         kobj->sd = NULL;
>         spin_unlock(&sysfs_assoc_lock);
> 
> and I would suggest that "sd = kobj->sd" should be done under the
> lock, because otherwise the lock is kind of pointless..)
> 
> Greg?

That is really odd, but I guess it works as-is because no one ever calls
that function on the same kobject at the same time.  I don't know what
that is trying to do.  There has been some work by Tejun in this area
for linux-next, but that lock and logic is still there, I'll look into
fixing that up...

thanks,

greg k-h
